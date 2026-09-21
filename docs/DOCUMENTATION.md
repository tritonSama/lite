# HeavenlyBond Lite Documentation

## Overview

HeavenlyBond Lite is a general-purpose community task and service marketplace.

The core premise is:
**Anyone can create a legitimate task. The community can fund it. Providers can compete to fulfill it. The task creator chooses who performs it. Teams can form around complex tasks.**

It restores the ability for ordinary people to turn useful work into an opportunity to earn, while allowing the community to decide what work deserves funding.

## Core Workflow

1.  **Create a Task:** A person posts a task (e.g., "Clean up this vacant lot — approximately 2 hours of work. Bounty: $150.").
    *   **Task Details Include:** Title, Description, Photos/video, Location, Desired completion date, Budget/bounty, Required skills, Required equipment, Number of workers, Special requirements, Required licenses/certifications.
2.  **Initial Offer:** The creator establishes an initial bounty (e.g., $150).
3.  **Bidding Mechanism:** Providers respond with offers. They can accept the bounty, make a counteroffer (higher or lower), propose a different date, or propose a team.
    *   *Evaluation:* The task creator evaluates offers based on a combination of Price + Rating + Experience + Verified Credentials + Proposed Completion Time + Team (not necessarily lowest price wins).
4.  **Task Fulfillment:** A provider/team is selected, the task is performed, submitted for verification, approved, and payment is released.

## Architecture

The application is built using Flutter for the frontend, communicating with Firebase (Firestore, Authentication, Storage, Functions).
*   **State Management:** Riverpod (`flutter_riverpod`, `riverpod_annotation`)
*   **Navigation:** GoRouter (`go_router`)
*   **Data Models:** Freezed (`freezed`, `json_serializable`) for immutable data structures.
*   **Backend:** Firebase Firestore (with custom security rules), Firebase Authentication.

### Key Models

*   **Task (`Task`):** Represents a job request. Includes budget, location, required credentials, status, and creator/provider IDs.
*   **UserProfile (`UserProfile`):** Represents a user on the platform. Includes skills, ratings, job counts, and basic info.
*   **Offer (`Offer`):** Represents a bid on a task. Includes amount, proposed dates, status, and attached credentials.
*   **Team (`Team`):** Represents a group of workers.
*   **Membership (`Membership`):** Junction between a user and a team, including roles.
*   **Credential (`Credential`):** Represents an uploaded license/certification, its verification status, and type.

### Task State Machine

A task progresses through defined states (enforced by `TaskStatus` enum):

`DRAFT` → `PUBLISHED` → `FUNDING_OPEN` → `BIDDING` → `PROVIDER_SELECTED` → `TEAM_FORMING` → `SCHEDULED` → `IN_PROGRESS` → `SUBMITTED_FOR_VERIFICATION` → `APPROVED` → `PAYMENT_RELEASED` → `COMPLETED`

Other possible states: `CANCELLED`, `DISPUTED`, `EXPIRED`.

This robust state machine allows the foundation to support many different types of services.

### License & Credential System

Tasks can specify required credentials (e.g., Driver's License, Electrical License, Insurance).
*   Providers upload documents to their profiles.
*   The system distinguishes between `Uploaded` and `Verified` credentials.
*   Verification requires platform admin approval.
*   Regulated services can require *verified* credentials before accepting tasks.

### "Official" Project Concept (Evolution of a Task)

For complex tasks (e.g., "Community Event — 300 People"), a task evolves into a project.
`TASK` → `PROJECT` → `ADMIN_SELECTED` → `REQUIREMENTS_MET` → `OFFICIAL_PROJECT`

An official project unlocks coordination tools: sub-teams (Security, Food, Cleanup), specific roles, budget tracking, and communications.

## Firebase Firestore Rules

Security is enforced via robust Firestore rules (`firestore.rules`):
*   **Users:** Read for signed-in users, update restricted to owner for specific fields.
*   **Tasks:** Public read for published tasks. Creation by owner. Updates restricted by fields and owner, or Admin.
*   **Bids:** Read for bidder and Admin (Creator read handled via Cloud Functions).
*   **Credentials:** Verification requires Admin role (`isAdmin()`).
*   **Teams/Memberships:** Public read, owner update. Admin capabilities.

## App Structure (Flutter)

The application features 5 major sections, managed by persistent bottom navigation:
1.  **Board (`/board`):** Feed of open tasks, nearby tasks, categories, and projects.
2.  **Create (`/create`):** Wizard to create tasks/service requests.
3.  **Bids (`/bids`):** Manage offers received, own offers made, and active contracts.
4.  **Teams (`/teams`):** Create/join teams, manage team credentials and jobs.
5.  **Profile (`/profile`):** User skills, ratings, credentials, history, and earnings.

## Future: Nexus Protocol Ecosystem

HeavenlyBond Lite will eventually integrate with the **Nexus Protocol** and the **Nexus Coin**. The Nexus Protocol is an edge-native compute substrate and decentralized marketplace for idle hardware, powered by a Proof of Health (PoH) consensus engine.

As the app ecosystem evolves into "Game Maps IRL", the native application will leverage the Nexus Protocol for:
*   **Mobile Sovereign Vaults & Identity Rails:** Utilizing hardware Secure Enclaves for managing local user context, credentials, and Decentralized Identifiers (DIDs).
*   **Distributed AI Compute:** Providing telemetry and participating in the decentralized marketplace for AI workload execution.
*   **Proof of Health Telemetry:** A future telemetry daemon will coordinate with the cluster to validate hardware state for consensus.

*Note: Initial foundation code includes waitlist capabilities and placeholder state for compute node telemetry, preparing the architecture for Phase 1 of the Nexus Protocol implementation.*

### Implementation Notes
The deep native and lower-level networking components for the Nexus Ecosystem phases (e.g., PoH Telemetry Daemon, WebSocket Execution Rail, TEE Container Runtime, and LoRa Subnetworks) are currently slated for the Fluorescent core engine team to handle and integrate. This repository will primarily serve as the mobile user interface and high-level coordinator.

### Implementation Notes
The deep native and lower-level networking components for the Nexus Ecosystem phases (e.g., PoH Telemetry Daemon, WebSocket Execution Rail, TEE Container Runtime, and LoRa Subnetworks) are currently slated for the Fluorescent core engine team to handle and integrate. This repository will primarily serve as the mobile user interface and high-level coordinator.
