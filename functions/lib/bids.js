"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.onBidStatusChanged = exports.onNewBid = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const firestore_2 = require("firebase-admin/firestore");
const sendPush_1 = require("./sendPush");
const db = (0, firestore_2.getFirestore)();
// ── Helper: idempotency dedup ─────────────────────────────────────────────────
async function alreadyProcessed(eventId, taskId) {
    const dedupRef = db.collection('processedEvents').doc(eventId);
    let seen = false;
    await db.runTransaction(async (t) => {
        const snap = await t.get(dedupRef);
        if (snap.exists) {
            seen = true;
            return;
        }
        const ttl = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24h TTL
        t.set(dedupRef, { processedAt: firestore_2.FieldValue.serverTimestamp(), taskId, ttl });
    });
    return seen;
}
// ── onNewBid: notify task creator when a new bid arrives ─────────────────────
exports.onNewBid = (0, firestore_1.onDocumentCreated)('bids/{bidId}', async (event) => {
    const bid = event.data?.data();
    if (!bid)
        return;
    const taskSnap = await db.collection('tasks').doc(bid.taskId).get();
    const task = taskSnap.data();
    if (!task)
        return;
    await (0, sendPush_1.sendPushAndSaveNotification)(task.creatorId, 'New Bid Received', `Someone placed a bid of $${bid.amount} on "${task.title}"`, { type: 'new_bid', taskId: bid.taskId, bidId: event.params.bidId }, `/board/task/${bid.taskId}`);
});
// ── onBidStatusChanged: notify bidder when their bid status changes ───────────
exports.onBidStatusChanged = (0, firestore_1.onDocumentUpdated)('bids/{bidId}', async (event) => {
    if (await alreadyProcessed(event.id, event.params.bidId))
        return;
    const before = event.data?.before.data();
    const after = event.data?.after.data();
    if (!before || !after || before.status === after.status)
        return;
    const messages = {
        accepted: '🎉 Your bid was accepted! Get to work.',
        rejected: 'Your bid was not selected for this task.',
        withdrawn: 'Your bid has been withdrawn.',
        countered: '↩ The task creator sent a counteroffer.',
        expired: 'Your bid has expired.',
    };
    const body = messages[after.status] ?? 'Your bid status changed.';
    await (0, sendPush_1.sendPushAndSaveNotification)(after.bidderId, 'Bid Update', body, { type: 'bid_status', bidId: event.params.bidId, taskId: after.taskId, newStatus: after.status }, `/bids/${event.params.bidId}`);
});
//# sourceMappingURL=bids.js.map