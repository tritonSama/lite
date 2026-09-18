# Game Maps IRL — "Living World"

## Fluorescent-Based Automotive Social, Navigation & Simulation Platform

**Prepared for:** Retry Apps\
**Date:** September 18, 2026\
**Status:** Concept / Pre-Development\
**Base Repository:** `tritonSama/Fluorescent`

---

## 1\. Executive Summary

Game Maps IRL is envisioned as a next-generation automotive navigation and social platform that transforms real-world driving into a persistent, interactive "living world."

The project will be **built on top of the existing Fluorescent repository**, rather than creating an unrelated application from scratch.

Fluorescent provides the foundational Flutter/Rust architecture, including the existing `fluorescent`, `fluorite_core`, and `fluorite_editor` components and Flutter/Rust Bridge integration. The new product will progressively extend this foundation into a geospatial, realtime, gamified automotive platform.

Fluorescent GitHub Repository

The resulting platform will combine:

- Real-world navigation
- Game-inspired map visualization
- God's Eye / tactical map modes
- Live driver mapping
- Car clubs and social feeds
- Vehicle garages
- Car meets and cruises
- Rally and convoy systems
- Real-road time attack
- GPS telemetry
- Ghost replays
- XP, achievements and challenges
- Developer broadcasts
- 3D visualization
- Realtime multiplayer infrastructure
- Eventually, a general-purpose Rust/Flutter simulation and game engine

The strategic objective is therefore larger than building another navigation application.

**Game Maps IRL becomes the first major application built on the Fluorescent platform.**

---

# 2\. Core Strategic Concept

The platform has two layers that evolve together.

## Product Layer

The immediate product is the automotive social network:

```
                 GAME MAPS IRL
                       │
       ┌───────────────┼────────────────┐
       │               │                │
    Navigation       Social          Driving
       │               │                │
    Live GPS        Clubs            Rallies
    Routing         Feed             Convoys
    Themes          Garage           Time Attack
    God's Eye       Chat             Challenges
       │               │                │
       └───────────────┼────────────────┘
                       │
                 Gamification
                       │
                XP / Badges / Events
```

## Platform Layer

Underneath the product is the evolving Fluorescent engine:

```
                 FLUORESCENT PLATFORM
                         │
             ┌───────────┴───────────┐
             │                       │
          Flutter                   Rust
             │                       │
       Application UI          Engine Runtime
             │                       │
             └───────────┬───────────┘
                         │
                       ECS
                         │
        ┌────────────────┼────────────────┐
        │                │                │
    Rendering         Physics          Networking
        │                │                │
      World           Vehicles        Replication
      Terrain         Simulation      Prediction
      VFX             Collision       Realtime
      Animation       Audio           Servers
```

The automotive application is the first demanding use case for this architecture.

---

# 3\. Existing Fluorescent Repository as the Foundation

The project should begin by **forking/branching the existing Fluorescent repository and evolving it in place**.

The repository currently contains:

```
Fluorescent
│
├── fluorescent
├── fluorite_core
├── fluorite_editor
├── packages
├── examples
├── tests
├── flutter_rust_bridge.yaml
└── project/task documentation
```

The architecture should preserve the existing foundation wherever practical while adding the systems required by the automotive product.

The target evolution is:

```
EXISTING FLUORESCENT
        │
        ├── Flutter application layer
        ├── Rust core
        ├── Editor
        └── Existing rendering/3D infrastructure
                │
                ▼
        AUTOMOTIVE PLATFORM
                │
        ├── Geospatial
        ├── GPS
        ├── Realtime
        ├── Vehicles
        ├── Rally systems
        ├── Social systems
        └── Gamification
                │
                ▼
        GENERAL-PURPOSE ENGINE
```

The project should avoid a rewrite unless a subsystem has a clear architectural reason to be replaced.

---

# 4\. Product Vision

The central concept is:

> **The map is the social network.**

Instead of treating the map as a passive navigation surface, the application makes the real world interactive.

A user can see:

- Nearby drivers
- Friends
- Car clubs
- Meets
- Rallies
- Convoys
- Checkpoints
- Time-attack circuits
- Scenic routes
- Community-created events
- Challenges
- Achievements

A drive becomes a persistent activity rather than merely a trip from A to B.

---

# 5\. Map Experience

The first major product layer will use a conventional geospatial renderer while Fluorescent evolves underneath it.

## Initial renderer

```
Flutter
   │
   ▼
Google Maps SDK
   │
   ├── Roads
   ├── Satellite imagery
   ├── Camera
   ├── Markers
   ├── Polylines
   └── User location
```

The application should introduce an internal abstraction:

```
MapRenderer
│
├── GoogleMapRenderer
├── FutureOpenMapRenderer
└── FutureFluorescent3DRenderer
```

The rest of the application should never depend directly on Google Maps APIs.

This allows the future Fluorescent renderer to replace the initial renderer without rewriting the social, rally, navigation or gameplay systems.

---

# 6\. God's Eye View

God's Eye View becomes the application's strategic map mode.

Features include:

- Top-down camera
- Tactical overview
- Smooth 3D-to-2D transitions
- Speed-linked zoom
- Route visualization
- Nearby driver visualization
- Event visualization
- Rally participant visualization
- Theme-specific HUD

Conceptually:

```
Street View
     │
     ▼
Angled 3D
     │
     ▼
Overhead
     │
     ▼
God's Eye
     │
     ▼
Metro / regional overview
```

At higher zoom levels:

```
CITY
 │
 ├── Events
 ├── Clubs
 ├── Drivers
 ├── Rallies
 └── Traffic
```

---

# 7\. Theme System

Themes become a modular presentation layer rather than hard-coded maps.

Initial/future themes include:

- Default
- Deep Space / Celestial
- Celestial Punk
- Retro Pixel
- Medieval / Parchment
- Blueprint / Industrial
- Watercolor / Painterly

The renderer should separate:

```
WORLD DATA
    +
THEME
    ↓
VISUAL REPRESENTATION
```

A road remains a road.

A checkpoint remains a checkpoint.

A vehicle remains a vehicle.

The theme determines how each is displayed.

This makes quarterly theme releases possible without changing the underlying navigation architecture.

---

# 8\. Live Driver Mapping

Every active driver can become a realtime entity.

```
GPS
 │
 ▼
Drive Session
 │
 ▼
Realtime Transport
 │
 ▼
Geospatial Interest Query
 │
 ▼
Nearby Drivers
 │
 ▼
Interpolation
 │
 ▼
Map / 3D Renderer
```

The server should never require every client to receive every driver.

Use:

- H3
- PostGIS
- Redis
- geographic radius queries
- interest management

to limit replication to relevant areas.

---

# 9\. Drive Session

The **Drive Session** becomes a foundational domain object.

```
Drive Session
│
├── Start
├── End
├── GPS trace
├── Distance
├── Duration
├── Speed
├── Heading
├── Route
├── Vehicle
├── Participants
├── Checkpoints
├── XP
├── Challenges
└── Achievements
```

One system can therefore power:

- Live driver mapping
- Navigation
- Rally participation
- Time attack
- Ghost replay
- Driving statistics
- XP
- Achievements
- Club activity

---

# 10\. Street Time Attack

Users can create real-world circuits.

```
START
  │
  ▼
Checkpoint
  │
  ▼
Sector
  │
  ▼
Checkpoint
  │
  ▼
Finish
```

The system provides:

- Circuit creation
- GPS lap timing
- Sector timing
- Personal bests
- Ghost replay
- Leaderboards
- Vehicle classes
- Friends' times
- Weekly competitions
- Clean-lap validation

Safety requirements must remain fundamental.

The system should be designed around:

- mounted-device use
- glanceable information
- no manual interaction while driving
- session-based tracking
- explicit participation
- exclusion/flagging of unreliable GPS data

The feature should be positioned as a controlled timing/gameplay system rather than encouraging unsafe public-road racing.

---

# 11\. Car Clubs and Meets

The social world consists of:

```
User
 │
 ├── Vehicles
 ├── Friends
 ├── Clubs
 ├── Events
 ├── Drives
 └── Achievements
```

A meet can contain:

```
MEET
│
├── Location
├── Host
├── Attendees
├── Start time
├── Showcase vehicles
├── Route
├── Parade
├── Checkpoints
├── Photos
└── Recap
```

The live map shows attendees as they arrive.

Geofencing can automatically trigger check-in.

---

# 12\. Virtual Garage

Each user maintains one or more vehicle profiles.

```
Garage
│
├── Vehicle
│   ├── Make
│   ├── Model
│   ├── Year
│   ├── Photos
│   ├── Modifications
│   ├── Performance
│   └── History
│
└── Vehicle
```

The garage integrates directly with:

- Time attack
- Meets
- Clubs
- Leaderboards
- Profiles
- Achievements

---

# 13\. Social Platform

Initial architecture:

```
Firestore
│
├── Users
├── Vehicles
├── Posts
├── Clubs
├── Events
├── Rallies
├── Drives
└── Achievements
```

Realtime communication:

```
Stream Chat / WebSockets
│
├── Direct messages
├── Group channels
├── Club chat
└── Rally communication
```

Live location:

```
Firebase RTDB
        ↓
Future WebSocket/Rust service
```

The architecture should allow the realtime layer to migrate away from Firebase as scale and requirements increase.

---

# 14\. Routing

The initial navigation stack:

```
OSM / Geographic Data
        │
        ▼
OSRM / OpenRouteService
        │
        ▼
Route
        │
        ▼
Google Maps / Future Renderer
```

Routing should support:

- A → B
- multiple waypoints
- scenic routes
- rally routes
- checkpoints
- circuits
- convoy routes
- saved drives

---

# 15\. Geospatial Infrastructure

The long-term stack:

```
                    GEOSPATIAL PLATFORM

                         PostGIS
                            │
              ┌─────────────┴─────────────┐
              │                           │
             H3                         OSM
              │                           │
       spatial indexing             road network
              │                           │
              └─────────────┬─────────────┘
                            │
                       Routing Engine
                       OSRM / ORS
```

Redis provides fast ephemeral state.

WebSockets provide realtime delivery.

Rust eventually becomes the authoritative realtime layer.

---

# 16\. Fluorescent / Flame Role

Flame should not be forced to become the map renderer.

Its primary role should become:

- Rally HUD
- XP effects
- achievement animations
- checkpoint effects
- VFX
- driving challenges
- countdowns
- game-like overlays
- vehicle effects
- interactive 3D elements

Example:

```
Google/Future Map
       │
       ▼
┌─────────────────────────────┐
│       WORLD / MAP           │
│                             │
│       🚗───────●            │
│              checkpoint     │
│                             │
├─────────────────────────────┤
│       FLAME HUD             │
│                             │
│       CHECKPOINT 3/7        │
│       +250 XP               │
│       18.4 miles            │
└─────────────────────────────┘
```

---

# 17\. Rust Engine Evolution

The existing Flutter/Rust architecture should gradually evolve into:

```
Rust Engine
│
├── Core
├── ECS
├── Math
├── Assets
├── Scene
├── Rendering
├── Physics
├── Animation
├── Audio
├── Networking
├── World
├── Terrain
├── VFX
└── Scripting
```

Flutter becomes the application/editor interface.

Rust becomes the high-performance runtime.

---

# 18\. Long-Term Engine Vision

The automotive application is the first major workload.

The engine can eventually support:

- Automotive simulations
- Racing games
- Driving games
- Multiplayer worlds
- Training simulations
- Visualization
- Virtual environments
- Other games

The long-term architecture:

```
                 FLUORESCENT ENGINE
                         │
       ┌─────────────────┼─────────────────┐
       │                 │                 │
    Car App          Racing Game       Simulation
       │                 │                 │
       └─────────────────┼─────────────────┘
                         │
                      Rust
                         │
              ECS / Rendering / Physics
                         │
                    Vulkan/GPU
```

---

# 19\. AAA Engine Roadmap

The goal is not to immediately clone Unreal Engine or Unity.

Instead, build capabilities progressively.

## Renderer

```
PBR
HDR
Forward+
Deferred
GPU-driven rendering
Virtual textures
Advanced shadows
Dynamic GI
Ray tracing
Temporal reconstruction
Upscaling
Volumetrics
GPU particles
```

## World

```
World coordinates
Streaming cells
LOD
Terrain streaming
Asset streaming
Physics streaming
AI streaming
Network relevance
```

## Animation

```
Animation graphs
State machines
Blend trees
IK
Full-body IK
Retargeting
Motion matching
Procedural animation
Facial animation
Ragdolls
Compression
```

## VFX

```
GPU particles
Fire
Smoke
Rain
Snow
Dust
Sparks
Explosions
Weather
Destruction effects
```

## Physics

```
Vehicles
Collision
Rigid bodies
Soft bodies
Destruction
Fracturing
Ragdolls
Terrain interaction
```

## Networking

```
Replication
Prediction
Interpolation
Rollback
Lag compensation
Interest management
Entity ownership
Authentication
Dedicated servers
Matchmaking
```

---

# 20\. World Streaming

The engine should eventually provide massive-world streaming.

```
WORLD
│
├── Cell A
├── Cell B
├── Cell C
├── Cell D
└── ...
```

Each cell can independently stream:

- terrain
- buildings
- vehicles
- NPCs
- physics
- vegetation
- audio
- VFX
- network entities

This architecture directly benefits the automotive application because a future worldwide driving map is itself a massive streamed world.

---

# 21\. Procedural World Generation

Eventually introduce a PCG system:

```
Terrain
   │
   ├── Height
   ├── Slope
   ├── Biome
   ├── Density
   └── Noise
          │
          ▼
     PCG Graph
          │
    ┌─────┼─────┐
    ▼     ▼     ▼
 Trees   Rocks  Buildings
```

This can later generate fictional environments for games while the automotive product can use real-world geographic data.

---

# 22\. Engine Editor

`fluorite_editor` should evolve into the developer environment.

Target capabilities:

- Scene editor
- World editor
- Entity inspector
- Asset browser
- Material editor
- Shader editor
- Animation editor
- VFX editor
- Terrain tools
- PCG editor
- Timeline
- Profiler
- Network debugger
- Physics debugger
- Entity debugger

Eventually:

```
┌──────────────────────────────────────────┐
│ File  Edit  World  Entity  Build        │
├──────────┬─────────────────────┬─────────┤
│ Assets   │                     │Inspector│
│ Models   │      3D VIEW        │         │
│ Audio    │                     │Transform│
│ Scripts  │                     │Physics  │
│ VFX      │                     │Network  │
├──────────┴─────────────────────┴─────────┤
│ Console │ Profiler │ Animation │ Network │
└──────────────────────────────────────────┘
```

---

# 23\. Platform Strategy

The engine should be hardware-scalable.

```
                  SAME WORLD
                      │
             Hardware Detection
                      │
        ┌─────────────┼─────────────┐
        ▼             ▼             ▼
     Android       Midrange       Desktop
      Tier 1        Tier 2          Tier 4
        │             │             │
   simplified      advanced         AAA
   renderer        renderer       renderer
```

Gameplay and world data remain consistent.

Rendering quality changes according to available hardware.

---

# 24\. Developer Broadcast

The application can provide an official Retry Apps channel.

Possible content:

- Developer drives
- Theme previews
- Circuit demonstrations
- Community Q&A
- Event announcements
- Live map sessions
- Map replays
- Telemetry demonstrations

The MVP can simply use:

```
Recorded Drive
      +
Map Replay
      +
Commentary
      +
Chat
```

before introducing full live video broadcasting.

---

# 25\. Monetization

Potential tiers:

| Tier | Core Features |
| --- | --- |
| Free | Basic navigation, selected themes, public events |
| Premium | Full theme library, advanced circuits, hosting, advanced customization |
| Lifetime | Long-term premium access |
| Sponsored | Branded circuits, meets and community events |

Additional revenue can come from:

- Custom themes
- Sponsored meets
- Featured circuits
- Automotive partnerships
- Creator content
- Optional hardware integrations
- Premium customization

Pricing should be validated through actual market testing rather than treated as fixed at this stage.

---

# 26\. Privacy & Safety

Privacy is a core architectural requirement.

Live location must be:

- explicitly opt-in
- session-based
- revocable
- automatically expired
- configurable by visibility
- protected against unnecessary historical retention

Modes:

```
VISIBLE
   ↓
Friends Only
   ↓
Club Only
   ↓
Ghost Mode
   ↓
Hidden
```

Additional protections:

- coarse-location fallback
- location expiration
- background-location controls
- no unnecessary historical storage
- account blocking
- reporting
- moderation
- event safety controls

Time-attack functionality should avoid encouraging unsafe public-road driving. The product should support controlled/closed-course timing where appropriate and design the UI so that driving does not require manual interaction.

---

# 27\. Development Roadmap

## Phase 0 — Foundation

**Base:** existing Fluorescent repository

Deliver:

- Repository audit
- Architecture cleanup
- Flutter/Rust Bridge stabilization
- Core domain models
- Map abstraction
- Firebase integration
- Authentication
- Basic GPS

---

## Phase 1 — Living Map

Deliver:

- Google Maps integration
- Live location
- Nearby drivers
- Driver entities
- Basic events
- User profiles
- Vehicle garage
- Basic theme system
- God's Eye camera experience

---

## Phase 2 — Social Driving

Deliver:

- Clubs
- Feed
- Friends
- Chat
- Meets
- Convoys
- Event routes
- Geofenced check-in
- Live participant map

---

## Phase 3 — Driving Game Systems

Deliver:

- Drive Sessions
- XP
- Achievements
- Challenges
- Rally system
- Checkpoints
- Time attack
- Ghost replay
- Leaderboards

---

## Phase 4 — Rust Realtime Core

Move performance-critical functionality toward Rust:

```
GPS processing
Geospatial calculations
Entity state
Interpolation
Rally simulation
Vehicle state
Realtime networking
```

---

## Phase 5 — Fluorescent 3D World

Begin replacing portions of the map visualization with native Fluorescent rendering.

Introduce:

- 3D vehicles
- terrain
- custom world objects
- advanced VFX
- dynamic lighting
- streamed environments

---

## Phase 6 — Engine Expansion

Add:

- Physics
- Animation
- VFX
- World streaming
- PCG
- Networking
- Dedicated servers
- Editor tools
- Profiling

---

## Phase 7 — General-Purpose Engine

Fluorescent becomes independently usable for:

- games
- simulations
- automotive applications
- visualization
- multiplayer worlds

The car application remains the flagship reference application.

---

# 28\. Target Architecture

The eventual architecture is:

```
                         GAME MAPS IRL
                               │
                         Flutter App
                               │
          ┌────────────────────┼────────────────────┐
          │                    │                    │
       Social              Navigation           Gameplay
          │                    │                    │
     Firestore             Map API             Flame/HUD
     Chat                  OSRM/ORS             XP/Rally
          │                    │                    │
          └────────────────────┼────────────────────┘
                               │
                         FLUORESCENT API
                               │
                         Flutter/Rust Bridge
                               │
                        ┌──────┴──────┐
                        │ Rust Engine │
                        └──────┬──────┘
                               │
        ┌────────────┬─────────┼──────────┬────────────┐
        │            │         │          │            │
       ECS        Physics   Network    World       Rendering
        │            │         │          │            │
        └────────────┴─────────┼──────────┴────────────┘
                               │
                           Vulkan/GPU
                               │
                  ┌────────────┴────────────┐
                  │                         │
               Android                   Desktop
```

---

# 29\. Final Product Vision

The ultimate experience is not simply:

> "A navigation app with social features."

It is:

> **A persistent, game-like representation of the real automotive world.**

Users can:

```
NAVIGATE
   ↓
DRIVE
   ↓
DISCOVER
   ↓
MEET
   ↓
RALLY
   ↓
COMPETE
   ↓
EARN
   ↓
SOCIALIZE
   ↓
RETURN
```

The map becomes the common interface between all of those activities.

The existing Fluorescent repository provides the starting point.

The automotive application provides the first real-world workload.

The geospatial/realtime stack provides the infrastructure.

The Rust engine provides the long-term performance foundation.

And the eventual Fluorescent renderer/editor provides the path toward a broader game and simulation platform.

**The strategic sequence is therefore:**

```
EXISTING FLUORESCENT
        ↓
AUTOMOTIVE LIVING-WORLD APP
        ↓
REALTIME GEOSPATIAL ENGINE
        ↓
3D WORLD ENGINE
        ↓
GENERAL-PURPOSE FLUORESCENT ENGINE
```

The objective is not to build a AAA engine before building the product.

**The objective is to use the product to progressively build the engine.**
