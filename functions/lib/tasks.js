"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.expireStaleTasksCron = exports.onTaskStatusChanged = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const scheduler_1 = require("firebase-functions/v2/scheduler");
const firestore_2 = require("firebase-admin/firestore");
const db = (0, firestore_2.getFirestore)();
// ── Valid task state transitions ──────────────────────────────────────────────
const VALID_TRANSITIONS = {
    draft: ['published', 'cancelled'],
    published: ['fundingOpen', 'bidding', 'cancelled', 'expired'],
    fundingOpen: ['bidding', 'cancelled', 'expired'],
    bidding: ['providerSelected', 'cancelled', 'expired'],
    providerSelected: ['teamForming', 'scheduled', 'cancelled'],
    teamForming: ['scheduled', 'cancelled'],
    scheduled: ['inProgress', 'cancelled'],
    inProgress: ['submittedForVerification', 'disputed'],
    submittedForVerification: ['approved', 'disputed'],
    approved: ['paymentReleased'],
    paymentReleased: ['completed'],
    // Terminal states
    completed: [],
    cancelled: [],
    disputed: ['completed', 'cancelled'], // admin only
    expired: [],
};
// ── onTaskStatusChanged: validate + audit transitions ─────────────────────────
exports.onTaskStatusChanged = (0, firestore_1.onDocumentUpdated)('tasks/{taskId}', async (event) => {
    const before = event.data?.before.data();
    const after = event.data?.after.data();
    if (!before || !after || before.status === after.status)
        return;
    const taskId = event.params.taskId;
    const fromStatus = before.status;
    const toStatus = after.status;
    // Validate transition
    const allowed = VALID_TRANSITIONS[fromStatus] ?? [];
    if (!allowed.includes(toStatus)) {
        console.error(`INVALID TRANSITION: ${fromStatus} → ${toStatus} on task ${taskId}`);
        // Revert — write back previous status
        await db.collection('tasks').doc(taskId).update({
            status: fromStatus,
            updatedAt: firestore_2.FieldValue.serverTimestamp(),
        });
        return;
    }
    // Append to status history audit trail
    await db
        .collection('tasks')
        .doc(taskId)
        .collection('statusHistory')
        .add({
        fromStatus,
        toStatus,
        changedAt: firestore_2.FieldValue.serverTimestamp(),
        // changedBy is set by the callable function that triggered the write
    });
    console.log(`Task ${taskId}: ${fromStatus} → ${toStatus}`);
});
// ── acceptOffer: Callable — task creator selects a provider ──────────────────
// (Implemented in escrow.ts as a callable; status transition handled here)
// ── expireStaleTasksCron: daily job to mark stale tasks as expired ─────────────
exports.expireStaleTasksCron = (0, scheduler_1.onSchedule)('every 24 hours', async () => {
    const now = firestore_2.Timestamp.now();
    const staleStatuses = ['published', 'fundingOpen', 'bidding'];
    for (const status of staleStatuses) {
        const snap = await db.collection('tasks')
            .where('status', '==', status)
            .where('desiredCompletionDate', '<', now)
            .limit(100)
            .get();
        const batch = db.batch();
        for (const doc of snap.docs) {
            batch.update(doc.ref, {
                status: 'expired',
                updatedAt: firestore_2.FieldValue.serverTimestamp(),
            });
        }
        if (!snap.empty)
            await batch.commit();
        console.log(`Expired ${snap.size} tasks with status '${status}'`);
    }
});
//# sourceMappingURL=tasks.js.map