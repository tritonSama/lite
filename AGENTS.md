# Fluorescent / Game Maps IRL - Agent Assignments

This document assigns AI agents to specific phases outlined in the `docs/BUILD_PLAN.md` to build out the Game Maps IRL platform.

## General Instructions for Agents
*   Read `docs/DOCUMENTATION.md` to understand the project architecture, the "Living World" concept, and the Flutter/Rust integration strategy.
*   Read `docs/BUILD_PLAN.md` to understand the overall roadmap and current phase goals.
*   Ensure that any new feature implemented aligns with the long-term vision of building a General-Purpose Engine.
*   Update this `AGENTS.md` file when a phase is completed.

## Agent Assignments

### Phase 0 Agent: Foundation
**Goal:** Establish the base architecture and resolve technical debt.
**Tasks:** Fix compilation bugs, stabilize Flutter/Rust bridge, create core domain models, abstract the Map layer, and solidify Firebase/Auth setup.

### Phase 1 Agent: Living Map
**Goal:** Establish the visual and realtime map foundation.
**Tasks:** Implement Google Maps integration via the abstraction layer, add live location/GPS tracking, render nearby driver entities, and build the Vehicle Garage and User Profile UI.

### Phase 2 Agent: Social Driving
**Goal:** Build the social networks and event structures.
**Tasks:** Implement Clubs, Feeds, Friends list, Chat (WebSockets), Car Meets, Convoys, and Geofenced check-ins.

### Phase 3 Agent: Driving Game Systems
**Goal:** Add gamification.
**Tasks:** Implement Drive Sessions, XP, Achievements, Rally systems, Checkpoints, Time attack logic, Ghost replays, and Leaderboards.

### Phase 4 Agent: Rust Realtime Core
**Goal:** Move performance-critical functionality to Rust.
**Tasks:** Re-write GPS processing, geospatial math, entity state interpolation, and realtime networking in the Rust core.

### Phase 5 Agent: Fluorescent 3D World
**Goal:** Replace Map API visualization with native Fluorescent rendering.
**Tasks:** Implement 3D vehicles, terrain generation, custom world objects, and dynamic lighting using the Fluorescent renderer.

### Phase 6 Agent: Engine Expansion
**Goal:** Broaden the engine capabilities.
**Tasks:** Add physics simulation, animation graphs, VFX, world streaming, procedural generation (PCG), and editor tools.
