# Nexus Coin (Nexus Protocol) Integration Plan for Game Maps IRL

## Overview
This document outlines the technical strategy for integrating the **Nexus Coin (Nexus Protocol)** natively into the "Game Maps IRL" application (formerly hblite).

The Nexus Protocol operates as a decentralized compute substrate and marketplace for idle hardware, driven by a **Proof of Health (PoH)** consensus engine. By integrating Nexus Coin, the Game Maps IRL application will evolve into a node within this distributed grid, participating in secure, edge-native compute workloads, mobile identity verification, and mesh networking.

---

## 1. Core Integration Objectives

### A. Mobile Sovereign Vaults & Identity Rails
The Game Maps IRL Flutter app will act as a Sovereign Mobile Vault, interacting with the secure hardware enclaves of the user's smartphone.
* **Secure Enclave Integration:** Implement native iOS (Secure Enclave) and Android (ARM TrustZone) bridges via Flutter/Rust Bridge to store biometric data, identity credentials, and signing keys securely.
* **Web2-to-Web3 Onboarding:** Utilize Google OAuth 2.0 / OpenID Connect integrated with ERC-4337 Account Abstraction to generate Decentralized Identifiers (DIDs) seamlessly without requiring users to manage seed phrases.
* **Client-Side ZKP Generation:** Offload context validation to the device using local Zero-Knowledge Proof (ZKP) generation. The Flutter client will generate proofs locally (e.g. verifying physical location for a map task) so remote nodes can verify validity without exposing raw GPS/user data.

### B. Proof of Health (PoH) Telemetry Daemon
Game Maps IRL devices will run lightweight telemetry daemons to act as edges nodes on the Nexus grid.
* **Rust Core Integration:** Incorporate the PoH Telemetry Daemon into the high-performance Rust core engine runtime (already integrated via Flutter/Rust Bridge).
* **Metrics Gathering:** The Rust daemon will silently gather hardware telemetry (CPU/GPU temperatures, RAM/VRAM availability, network latency) and generate zero-knowledge FLOPs scores.
* **Thermal Throttling & Battery Management:** Strict governor protocols will be integrated into the mobile daemon to prevent battery drain or thermal degradation on user smartphones. Workloads will automatically pause when the device is not plugged in or exceeds safe thermal thresholds.

### C. Layer 0 & Layer 1 Communication Rails
The Game Maps IRL mapping and tracking features will leverage the Nexus multi-tier communication rails.
* **Mesh Networking (Layer 0):** Integrate LoRa / Meshtastic capabilities (where hardware is available or connected via Bluetooth) to provide long-range, off-grid fallback communication for micro-transactions, map tracking, and state proofs.
* **Execution Rail (Layer 1):** Migrate existing real-time app interactions (e.g., live tracking, bidding) to utilize the Nexus high-speed WebSocket execution rails for sub-50ms finality.

### D. Decentralized Commerce (AI Agents & Tasks)
The existing "Task & Bidding" architecture (currently running on Firebase/Stripe) will be incrementally upgraded to utilize the Nexus Commerce layer.
* Autonomous AI agents running on the Nexus grid can bid on Game Maps IRL tasks.
* Escrow payments and settlements will be bridged from fiat (Stripe) to programmable Nexus Coin logic, allowing agents and human providers to settle computationally complex spatial tasks on-chain.

---

## 2. Technical Roadmap & Phases

### Phase 1: Genesis (Target: Q4 2026)
**Focus:** Identity & Baseline Telemetry
* **Identity Vault:** Develop the Mobile Vault SDK for iOS and Android within the Flutter project. Connect Google OAuth to ERC-4337 Smart Accounts to establish the base user DIDs.
* **Rust Daemon:** Deploy the initial PoH Telemetry Daemon via the Flutter/Rust Bridge. Begin passive, background health metric sampling on user devices (opt-in).
* **Layer 1 Connection:** Establish basic WebSocket connectivity between the mobile clients and the Nexus Layer 1 rail.

### Phase 2: Mesh & ZKPs (Target: Q2 2027)
**Focus:** Privacy & Off-grid capabilities
* **Zero-Knowledge Proofs:** Implement client-side ZKP generation for task verification (e.g., proving location or completion without leaking raw user data).
* **Layer 0 Mesh:** Integrate offline tracking and state sync using LoRa/Bluetooth mesh fallback layers.
* **TEE Support:** Enable the backend services (Firebase Cloud Functions / Custom Rust Nodes) to interface with Confidential Computing Container Runtimes (AMD SEV-SNP/Intel SGX) for secure task evaluation.

### Phase 3: Scale & Autonomous Commerce (Target: Q4 2027)
**Focus:** Full Decentralization & AI Agents
* **Token Integration:** Fully integrate Nexus Coin as a native payment method alongside/replacing Stripe for task escrows and settlements.
* **Agent Marketplace:** Open the in-app bidding marketplace to Autonomous AI agents powered by the Nexus distributed compute grid.
* **Model Distribution:** Enable peer-to-peer chunked distribution caching on mobile devices to share lightweight inference models across the network.

---

## 3. Architecture Changes Required
* **`lib/features/auth/`**: Extensive updates to replace/augment Firebase Auth with Web3 Identity Rails and the Mobile Sovereign Vault SDK.
* **`rust/` (Fluorescent Core)**: Heavy expansion to compile and run the PoH Daemon, ZKP generators, and WebSocket Execution rails natively.
* **`lib/features/tasks/` & `functions/src/escrow.ts`**: Refactoring to support smart-contract based escrow and settlements via Nexus Coin.
* **`lib/features/map/`**: Integration of Layer 0 (LoRa) offline mesh routing for map state updates.