"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.releaseEscrow = exports.acceptOffer = void 0;
const https_1 = require("firebase-functions/v2/https");
const firestore_1 = require("firebase-admin/firestore");
const params_1 = require("firebase-functions/params");
const stripe_1 = __importDefault(require("stripe"));
const db = (0, firestore_1.getFirestore)();
const stripeSecretKey = (0, params_1.defineSecret)('STRIPE_SECRET_KEY');
// ── acceptOffer: Callable — task creator selects a winning bid ────────────────
//
// Called by the task creator. Transitions task → providerSelected,
// sets selectedProviderId, and rejects all other pending bids.
exports.acceptOffer = (0, https_1.onCall)({ region: 'us-central1' }, async (req) => {
    const { taskId, offerId } = req.data;
    const uid = req.auth?.uid;
    if (!uid)
        throw new https_1.HttpsError('unauthenticated', 'Must be signed in');
    if (!taskId || !offerId) {
        throw new https_1.HttpsError('invalid-argument', 'taskId and offerId are required');
    }
    await db.runTransaction(async (t) => {
        const taskRef = db.collection('tasks').doc(taskId);
        const offerRef = db.collection('bids').doc(offerId);
        const [taskSnap, offerSnap] = await Promise.all([
            t.get(taskRef), t.get(offerRef),
        ]);
        if (!taskSnap.exists)
            throw new https_1.HttpsError('not-found', 'Task not found');
        if (!offerSnap.exists)
            throw new https_1.HttpsError('not-found', 'Offer not found');
        const task = taskSnap.data();
        const offer = offerSnap.data();
        if (task.creatorId !== uid) {
            throw new https_1.HttpsError('permission-denied', 'Only the task creator can accept bids');
        }
        if (!['published', 'fundingOpen', 'bidding'].includes(task.status)) {
            throw new https_1.HttpsError('failed-precondition', `Task is not accepting bids (status: ${task.status})`);
        }
        if (offer.taskId !== taskId) {
            throw new https_1.HttpsError('invalid-argument', 'Offer does not belong to this task');
        }
        if (offer.status !== 'pending') {
            throw new https_1.HttpsError('failed-precondition', `Offer is not pending (status: ${offer.status})`);
        }
        // Accept the winning offer
        t.update(offerRef, { status: 'accepted' });
        // Transition task to providerSelected
        t.update(taskRef, {
            status: 'providerSelected',
            selectedProviderId: offer.bidderId,
            updatedAt: firestore_1.FieldValue.serverTimestamp(),
        });
    });
    // Reject all other pending bids for this task (outside transaction for scale)
    const otherBids = await db.collection('bids')
        .where('taskId', '==', taskId)
        .where('status', '==', 'pending')
        .get();
    const batch = db.batch();
    for (const doc of otherBids.docs) {
        if (doc.id !== offerId) {
            batch.update(doc.ref, { status: 'rejected' });
        }
    }
    if (!otherBids.empty)
        await batch.commit();
    return { success: true };
});
// ── releaseEscrow: Callable — task creator approves work & releases payment ───
//
// Full Stripe integration wired here in Sprint 5.
// For now, transitions task through approved → paymentReleased → completed.
exports.releaseEscrow = (0, https_1.onCall)({ region: 'us-central1', secrets: [stripeSecretKey] }, async (req) => {
    const { taskId } = req.data;
    const uid = req.auth?.uid;
    if (!uid)
        throw new https_1.HttpsError('unauthenticated', 'Must be signed in');
    const taskRef = db.collection('tasks').doc(taskId);
    let taskSnap = await taskRef.get();
    if (!taskSnap.exists)
        throw new https_1.HttpsError('not-found', 'Task not found');
    let task = taskSnap.data();
    if (task.creatorId !== uid) {
        throw new https_1.HttpsError('permission-denied', 'Only the task creator can release payment');
    }
    if (task.status !== 'submittedForVerification') {
        throw new https_1.HttpsError('failed-precondition', `Task must be in submittedForVerification state (current: ${task.status})`);
    }
    if (!task.selectedProviderId) {
        throw new https_1.HttpsError('failed-precondition', 'Task has no selected provider');
    }
    // Get provider's stripe account id
    const providerRef = db.collection('users').doc(task.selectedProviderId);
    const providerSnap = await providerRef.get();
    if (!providerSnap.exists) {
        throw new https_1.HttpsError('not-found', 'Provider user not found');
    }
    const provider = providerSnap.data();
    const providerStripeId = provider.stripeAccountId;
    if (!providerStripeId) {
        throw new https_1.HttpsError('failed-precondition', 'Provider does not have a Stripe account connected');
    }
    // Calculate transfer amount
    const budgetAmount = task.budgetAmount || 0;
    const platformFee = task.platformFee || 0;
    const currency = task.currencyCode ? task.currencyCode.toLowerCase() : 'usd';
    const transferAmount = budgetAmount * (1 - platformFee / 100);
    const transferAmountCents = Math.round(transferAmount * 100);
    if (transferAmountCents > 0) {
        const stripe = new stripe_1.default(stripeSecretKey.value(), {
            apiVersion: '2023-10-16', // Typical recent api version
        });
        try {
            await stripe.transfers.create({
                amount: transferAmountCents,
                currency: currency,
                destination: providerStripeId,
                transfer_group: taskId,
            }, {
                idempotencyKey: `transfer_${taskId}`,
            });
        }
        catch (error) {
            console.error('Stripe transfer failed:', error);
            throw new https_1.HttpsError('internal', 'Failed to release funds to the provider');
        }
    }
    // Update task status in a transaction to ensure atomic history append
    await db.runTransaction(async (t) => {
        taskSnap = await t.get(taskRef);
        if (!taskSnap.exists)
            throw new https_1.HttpsError('not-found', 'Task not found');
        task = taskSnap.data();
        if (task.status !== 'submittedForVerification') {
            throw new https_1.HttpsError('failed-precondition', `Task must be in submittedForVerification state (current: ${task.status})`);
        }
        t.update(taskRef, {
            status: 'approved',
            updatedAt: firestore_1.FieldValue.serverTimestamp(),
        });
        // Append status history
        t.set(taskRef.collection('statusHistory').doc(), {
            fromStatus: 'submittedForVerification',
            toStatus: 'approved',
            changedBy: uid,
            changedAt: firestore_1.FieldValue.serverTimestamp(),
            reason: 'creator_approved_work',
        });
    });
    return { success: true };
});
//# sourceMappingURL=escrow.js.map