# Fluorescent / Game Maps IRL Build Plan

This document outlines the step-by-step roadmap to build the "Game Maps IRL" living world platform on top of the Fluorescent engine.

## Phase 0 — Foundation (Current State)
**Goal:** Establish the base architecture.
*   Repository audit
*   Architecture cleanup
*   Flutter/Rust Bridge stabilization
*   Core domain models
*   Map abstraction
*   Firebase integration (Auth, initial config)
*   Authentication (Basic setup)
*   Basic GPS

## Phase 1 — Living Map
**Goal:** Establish the visual and realtime map foundation.
*   Google Maps integration (behind an abstraction layer)
*   Live location tracking
*   Nearby drivers queries
*   Driver entities on the map
*   Basic events
*   User profiles
*   Vehicle garage
*   Basic theme system
*   God's Eye camera experience

## Phase 2 — Social Driving
**Goal:** Build the social networks and event structures.
*   Clubs
*   Feed
*   Friends
*   Chat (Stream Chat / WebSockets)
*   Meets
*   Convoys
*   Event routes
*   Geofenced check-in
*   Live participant map

## Phase 3 — Driving Game Systems
**Goal:** Add gamification.
*   Drive Sessions
*   XP
*   Achievements
*   Challenges
*   Rally system
*   Checkpoints
*   Time attack
*   Ghost replay
*   Leaderboards

## Phase 4 — Rust Realtime Core
**Goal:** Move performance-critical functionality toward Rust.
*   GPS processing
*   Geospatial calculations
*   Entity state
*   Interpolation
*   Rally simulation
*   Vehicle state
*   Realtime networking

## Phase 5 — Fluorescent 3D World
**Goal:** Replace Map API visualization with native Fluorescent rendering.
*   3D vehicles
*   Terrain
*   Custom world objects
*   Advanced VFX
*   Dynamic lighting
*   Streamed environments

## Phase 6 — Engine Expansion
**Goal:** Broaden the engine capabilities.
*   Physics
*   Animation
*   VFX
*   World streaming
*   PCG
*   Networking (Dedicated servers)
*   Editor tools
*   Profiling

## Phase 7 — General-Purpose Engine
**Goal:** Extract the engine for independent use.
*   Games, simulations, visualization, multiplayer worlds.
