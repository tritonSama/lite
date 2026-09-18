# HeavenlyBond Lite - Agent Assignments

This document assigns AI agents to specific sprints outlined in the `docs/BUILD_PLAN.md` to implement the remaining features of HeavenlyBond Lite.

## General Instructions for Agents
*   Read `docs/DOCUMENTATION.md` to understand the project architecture, data models, and Firebase rules.
*   Read `docs/BUILD_PLAN.md` to understand the overall roadmap and current sprint goals.
*   Ensure that any new feature implemented follows the existing architecture (Flutter, Riverpod, GoRouter, Freezed, Firebase).
*   For each new feature, write appropriate widget and unit tests.
*   Update this `AGENTS.md` file when a sprint is completed.

## Agent Assignments

### Sprint 2 Agent: Task Creation Wizard
**Goal:** Allow users to create comprehensive tasks.
**Focus Area:** `lib/features/tasks/presentation/create_task_page.dart`
**Tasks:** Implement the multi-step wizard (Basic Info, Logistics, Requirements, Funding, Review & Publish) and connect it to Firestore.

### Sprint 3 Agent: Bidding & Offers Mechanism
**Goal:** Enable providers to place bids and task creators to manage them.
**Focus Area:** `lib/features/bids/presentation/` and Firebase Cloud Functions.
**Tasks:** Implement "Make an Offer" modal, build `BidsPage` (My Offers vs Offers Received), build `OfferDetailPage`, and write Cloud Functions for bid visibility and status transitions.

### Sprint 4 Agent: Task Execution & Verification
**Goal:** Track task progress and verify completion for payment release.
**Focus Area:** `lib/features/tasks/presentation/task_detail_page.dart` (UI updates) and Firebase Storage/Functions.
**Tasks:** Add UI for Providers to upload completion photos, add UI for Creators to approve/dispute, and stub Stripe Connect integration for escrow.

### Sprint 5 Agent: Credentials & Licensing System
**Goal:** Allow providers to prove qualifications for regulated tasks.
**Focus Area:** `lib/features/credentials/presentation/` and Firebase Storage.
**Tasks:** Build `CredentialsPage`, implement document upload, and enforce credential checks before bidding.

### Sprint 6 Agent: Teams Foundation
**Goal:** Allow users to form teams to tackle larger tasks.
**Focus Area:** `lib/features/teams/presentation/` and `lib/features/teams/domain/`.
**Tasks:** Build `TeamsPage`, implement team creation, invite functionality, and allow offers to be made on behalf of a team.

### Sprint 7 Agent: Official Projects & Event Coordination
**Goal:** Transform complex tasks into managed projects.
**Focus Area:** `lib/features/projects/` (New feature module).
**Tasks:** Implement Project state transitions, Project management UI, sub-task creation, and role assignments.
