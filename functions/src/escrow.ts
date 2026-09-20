import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { defineSecret } from 'firebase-functions/params';
import Stripe from 'stripe';

const db = getFirestore();
const stripeSecretKey = defineSecret('STRIPE_SECRET_KEY');

// ── acceptOffer: Callable — task creator selects a winning bid ────────────────
//
// Called by the task creator. Transitions task → providerSelected,
// sets selectedProviderId, and rejects all other pending bids.
export const acceptOffer = onCall({ region: 'us-central1' }, async (req) => {
  const { taskId, offerId } = req.data as { taskId: string; offerId: string };
  const uid = req.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', 'Must be signed in');
  if (!taskId || !offerId) {
    throw new HttpsError('invalid-argument', 'taskId and offerId are required');
  }

  await db.runTransaction(async (t) => {
    const taskRef = db.collection('tasks').doc(taskId);
    const offerRef = db.collection('bids').doc(offerId);

    const [taskSnap, offerSnap] = await Promise.all([
      t.get(taskRef), t.get(offerRef),
    ]);

    if (!taskSnap.exists) throw new HttpsError('not-found', 'Task not found');
    if (!offerSnap.exists) throw new HttpsError('not-found', 'Offer not found');

    const task = taskSnap.data()!;
    const offer = offerSnap.data()!;

    if (task.creatorId !== uid) {
      throw new HttpsError('permission-denied', 'Only the task creator can accept bids');
    }
    if (!['published', 'fundingOpen', 'bidding'].includes(task.status)) {
      throw new HttpsError('failed-precondition', `Task is not accepting bids (status: ${task.status})`);
    }
    if (offer.taskId !== taskId) {
      throw new HttpsError('invalid-argument', 'Offer does not belong to this task');
    }
    if (offer.status !== 'pending') {
      throw new HttpsError('failed-precondition', `Offer is not pending (status: ${offer.status})`);
    }

    // Accept the winning offer
    t.update(offerRef, { status: 'accepted' });

    // Transition task to providerSelected
    t.update(taskRef, {
      status: 'providerSelected',
      selectedProviderId: offer.bidderId,
      updatedAt: FieldValue.serverTimestamp(),
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
  if (!otherBids.empty) await batch.commit();

  return { success: true };
});

// ── releaseEscrow: Callable — task creator approves work & releases payment ───
//
// Full Stripe integration wired here in Sprint 5.
// For now, transitions task through approved → paymentReleased → completed.
export const releaseEscrow = onCall({ region: 'us-central1', secrets: [stripeSecretKey] }, async (req) => {
  const { taskId } = req.data as { taskId: string };
  const uid = req.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', 'Must be signed in');

  const taskRef = db.collection('tasks').doc(taskId);
  let taskSnap = await taskRef.get();

  if (!taskSnap.exists) throw new HttpsError('not-found', 'Task not found');
  let task = taskSnap.data()!;

  if (task.creatorId !== uid) {
    throw new HttpsError('permission-denied', 'Only the task creator can release payment');
  }
  if (task.status !== 'submittedForVerification') {
    throw new HttpsError(
      'failed-precondition',
      `Task must be in submittedForVerification state (current: ${task.status})`,
    );
  }

  if (!task.selectedProviderId) {
    throw new HttpsError('failed-precondition', 'Task has no selected provider');
  }

  // Get provider's stripe account id
  const providerRef = db.collection('users').doc(task.selectedProviderId);
  const providerSnap = await providerRef.get();
  if (!providerSnap.exists) {
    throw new HttpsError('not-found', 'Provider user not found');
  }

  const provider = providerSnap.data()!;
  const providerStripeId = provider.stripeAccountId;
  if (!providerStripeId) {
    throw new HttpsError('failed-precondition', 'Provider does not have a Stripe account connected');
  }

  // Calculate transfer amount
  const budgetAmount = task.budgetAmount || 0;
  const platformFee = task.platformFee || 0;
  const currency = task.currencyCode ? task.currencyCode.toLowerCase() : 'usd';

  const transferAmount = budgetAmount * (1 - platformFee / 100);
  const transferAmountCents = Math.round(transferAmount * 100);

  if (transferAmountCents > 0) {
    const stripe = new Stripe(stripeSecretKey.value(), {
      apiVersion: '2023-10-16', // Typical recent api version
    });

    try {
      await stripe.transfers.create(
        {
          amount: transferAmountCents,
          currency: currency,
          destination: providerStripeId,
          transfer_group: taskId,
        },
        {
          idempotencyKey: `transfer_${taskId}`,
        }
      );
    } catch (error) {
      console.error('Stripe transfer failed:', error);
      throw new HttpsError('internal', 'Failed to release funds to the provider');
    }
  }

  // Update task status in a transaction to ensure atomic history append
  await db.runTransaction(async (t) => {
    taskSnap = await t.get(taskRef);
    if (!taskSnap.exists) throw new HttpsError('not-found', 'Task not found');
    task = taskSnap.data()!;

    if (task.status !== 'submittedForVerification') {
      throw new HttpsError(
        'failed-precondition',
        `Task must be in submittedForVerification state (current: ${task.status})`,
      );
    }

    t.update(taskRef, {
      status: 'approved',
      updatedAt: FieldValue.serverTimestamp(),
    });

    // Append status history
    t.set(taskRef.collection('statusHistory').doc(), {
      fromStatus: 'submittedForVerification',
      toStatus: 'approved',
      changedBy: uid,
      changedAt: FieldValue.serverTimestamp(),
      reason: 'creator_approved_work',
    });
  });

  return { success: true };
});
