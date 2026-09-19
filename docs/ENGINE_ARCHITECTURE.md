# Engine Architecture Specification

> **Flutter for the application/editor experience. Rust for the core runtime. Fluorite/Filament-inspired rendering for the visual layer. O3DE/Unreal-class systems architecture underneath.**

This is **not** a modified Fluorite engine. It is a **new, layered game/runtime platform** built from Fluorite's ideas and technology — a coherent engine that extracts architectural lessons from the best and unifies them under a single vision.

---

## Philosophy

| Source Engine | Lesson Extracted |
|:---|:---|
| **Fluorite / Filament** | The seed — physically-based mobile rendering, material model, Vulkan abstraction |
| **Flutter** | The interface — production-grade cross-platform UI toolkit for editor and in-game HUD |
| **Rust** | The heart — memory safety, fearless concurrency, zero-cost abstractions for the runtime core |
| **Vulkan** | The hardware abstraction — explicit GPU control across Android, Desktop, and Linux |
| **Godot** | Developer experience — approachable workflows, data-driven project structure, open ecosystem |
| **O3DE** | Modular AAA architecture — Gem system, prefab overrides, multi-team scalability |
| **Unreal** | The benchmark — AAA capability target for rendering, world, physics, animation, networking |

The goal is not to make a Frankenstein of those engines. It is to **extract the architectural ideas needed and build a coherent engine around them**.

---

## High-Level Architecture

```text
                         ┌───────────────────────────────┐
                         │        YOUR GAME ENGINE       │
                         │                               │
                         │   AAA • OPEN • CROSS-PLATFORM │
                         └───────────────┬───────────────┘
                                         │
                 ┌───────────────────────┴───────────────────────┐
                 │                                               │
        ┌────────▼────────┐                             ┌────────▼────────┐
        │  FLUTTER LAYER  │                             │   RUST RUNTIME  │
        │                 │                             │                 │
        │ Editor          │                             │ ECS             │
        │ UI              │                             │ Gameplay        │
        │ HUD             │                             │ Networking      │
        │ Menus           │                             │ Physics         │
        │ Tools           │                             │ Animation       │
        │ Launcher        │                             │ Audio           │
        │ Social          │                             │ AI              │
        └────────┬────────┘                             │ Assets          │
                 │                                      │ Scripting       │
                 │                                      └────────┬────────┘
                 │                                               │
                 └──────────────────────┬────────────────────────┘
                                        │
                              ┌─────────▼─────────┐
                              │ ENGINE SERVICES   │
                              │                   │
                              │ Rendering         │
                              │ Physics           │
                              │ Animation         │
                              │ VFX               │
                              │ Audio             │
                              │ World             │
                              │ AI                │
                              │ Networking        │
                              └─────────┬─────────┘
                                        │
                         ┌──────────────▼──────────────┐
                         │       PLATFORM ABSTRACTION │
                         │                            │
                         │ Android │ Desktop │ Linux  │
                         │ Vulkan  │ Vulkan  │ Vulkan │
                         └──────────────┬─────────────┘
                                        │
                                ┌───────▼───────┐
                                │    HARDWARE   │
                                │ GPU / CPU /   │
                                │ Memory / I/O  │
                                └───────────────┘
```

---

## Core Concept: Two Engines in One

The engine is not a monolithic runtime. It is composed of a **Creation Runtime** and a **Game Runtime** that share the same project, the same data, and the same core systems — but serve fundamentally different purposes.

**The editor is not an afterthought.** It is a first-class runtime.

```text
                  YOUR ENGINE
                       │
          ┌────────────┴────────────┐
          │                         │
     CREATION RUNTIME          GAME RUNTIME
          │                         │
       Flutter                     Rust
          │                         │
       Editor                  ECS / Systems
       Inspector                  Renderer
       Scene tools                Physics
       Material tools             Animation
       VFX tools                  Audio
       World tools                AI
       Profiler                   Networking
          │                         │
          └────────────┬────────────┘
                       │
                 SAME PROJECT
```

### Why This Matters

| Concern | Creation Runtime (Flutter) | Game Runtime (Rust) |
|:---|:---|:---|
| **Primary user** | Developer, artist, designer | Player |
| **Performance priority** | Responsiveness, usability | Throughput, frame budget |
| **UI complexity** | Very high (panels, inspectors, graphs, trees) | Moderate (HUD, menus, inventory) |
| **Lifecycle** | Development time | Shipping product |
| **Hot reload** | Yes (Flutter) | Scene/asset hot reload |

Both runtimes talk to the same underlying Rust engine core through the same API. The difference is what sits on top.

---

## Rust as the Authoritative Runtime

Dart/Flutter is **not** the engine's core. Rust is. Flutter is a high-level interface to the engine.

```text
                       RUST
                         │
       ┌─────────────────┼─────────────────┐
       │                 │                 │
      ECS              Systems          Runtime
       │                 │                 │
       ├── Entity        ├── Physics       ├── Threads
       ├── Component     ├── Animation     ├── Jobs
       ├── Archetype     ├── Audio         ├── Memory
       └── World         ├── AI            └── Scheduling
                         ├── Networking
                         ├── Gameplay
                         └── Rendering
```

### Flutter ↔ Rust Boundary

Flutter communicates with the Rust runtime through a clean FFI layer. The API boundary is explicit and well-defined:

```text
Flutter
   │
   │ FFI
   ▼
Rust API
   │
   ▼
Game World
   │
   ├── Entity
   ├── Component
   ├── System
   └── Resource
```

This gives a very clean separation:

- **Flutter** never owns game state. It reads and writes through the API.
- **Rust** never renders UI widgets. It provides data for Flutter to display.
- **The FFI boundary** is the contract. Both sides can evolve independently as long as the contract holds.

---

## Rendering Engine as Its Own Subsystem

Rather than having rendering scattered throughout the codebase, the renderer is a self-contained engine within the engine:

```text
                 RENDERING ENGINE
                       │
          ┌────────────┼────────────┐
          │            │            │
       Geometry     Lighting      Materials
          │            │            │
       Virtual       GI           Shaders
       Geometry      Shadows      Textures
          │            │            │
          └────────────┼────────────┘
                       │
                    Vulkan
```

### Evolutionary Rendering Strategy

The renderer starts by leveraging **Filament / Fluorite technology** for physically-based rendering, then progressively replaces pieces with Rust-native implementations. This provides an evolutionary path rather than requiring a giant rewrite:

| Phase | Rendering Approach |
|:---|:---|
| **Phase 1** | Use Filament/Fluorite PBR pipeline directly via FFI |
| **Phase 2** | Replace material system with Rust-native shader pipeline |
| **Phase 3** | Implement custom GI, virtual geometry, advanced VFX in Rust |
| **Phase 4** | Full Rust-native renderer with Vulkan backend |

Each phase ships a working product. No phase requires the next to be useful.

---

## The 10 Major Engine Subsystems

```text
┌───────────────────────────────────────────┐
│                 GAME ENGINE                │
├───────────────────────────────────────────┤
│ 1.  Core / ECS                             │
│ 2.  Rendering                              │
│ 3.  Physics                                │
│ 4.  Animation                              │
│ 5.  Audio                                  │
│ 6.  VFX                                    │
│ 7.  World / Terrain                        │
│ 8.  AI                                     │
│ 9.  Networking                             │
│ 10. Asset / Build Pipeline                 │
└───────────────────────────────────────────┘
```

Each subsystem has a corresponding **editor tool** in the Creation Runtime:

```text
┌───────────────────────────────────────────┐
│             CREATOR PLATFORM              │
├───────────────────────────────────────────┤
│ Scene Editor                              │
│ World Editor                              │
│ Material Editor                           │
│ Animation Editor                          │
│ VFX Editor                                │
│ Audio Editor                              │
│ AI / Behavior Editor                      │
│ Visual Scripting                          │
│ Profiler                                  │
│ Debugger                                  │
└───────────────────────────────────────────┘
```

### Subsystem ↔ Editor Mapping

| # | Engine Subsystem | Editor Tool | Description |
|---|:---|:---|:---|
| 1 | Core / ECS | Scene Editor, Inspector | Entity/component creation, hierarchy, properties |
| 2 | Rendering | Material Editor, Viewport | PBR materials, lighting, camera, render settings |
| 3 | Physics | Scene Editor (physics overlay) | Colliders, rigidbodies, joints, ragdolls |
| 4 | Animation | Animation Editor | Skeletal/blend tree/state machine editing |
| 5 | Audio | Audio Editor | Spatial audio, mixing, event triggers |
| 6 | VFX | VFX Editor | Particle systems, GPU effects, post-process |
| 7 | World / Terrain | World Editor | Terrain sculpting, foliage, streaming, LOD |
| 8 | AI | Behavior Editor | Behavior trees, navigation, utility AI |
| 9 | Networking | Debugger (network overlay) | Replication inspector, latency simulation |
| 10 | Asset Pipeline | Asset Browser, Build Settings | Import, cook, bundle, platform targeting |

---

## ECS: Everything is an Entity

The engine uses a pure Entity-Component-System architecture. There are no deep inheritance hierarchies. Every game object is an entity with a bag of components.

### Example: Player Entity

```text
Player
├── Transform
├── Mesh
├── Material
├── PhysicsBody
├── CharacterController
├── AnimationController
├── Health
├── Inventory
├── NetworkIdentity
└── AIController
```

### Example: NPC Entity

```text
NPC
├── Transform
├── Mesh
├── Animation
├── NavAgent
├── Behavior
├── Dialogue
└── NetworkIdentity
```

### Why ECS

| Benefit | Detail |
|:---|:---|
| **Performance** | Cache-friendly memory layout; archetype storage enables SIMD |
| **Composability** | Mix and match components without class explosion |
| **Parallelism** | Systems with non-overlapping component access run in parallel |
| **Serialization** | Entities are just IDs + data blobs — trivial to save/load/network |
| **Editor integration** | Inspector can enumerate all components generically |

---

## Flutter as a First-Class UI Runtime

This is where the engine diverges from Unreal, Unity, and Godot. Flutter is not bolted on — it is a **first-class UI runtime** for both the editor and in-game interfaces.

### In-Game UI Architecture

A game developer writes:

```text
Game
 ├── 3D World
 │    ├── Player
 │    ├── NPCs
 │    ├── Vehicles
 │    └── Environment
 │
 └── Flutter UI
      ├── Inventory
      ├── Map
      ├── Quest Log
      ├── Chat
      ├── Shop
      └── Settings
```

The 3D world is rendered by the Rust/native GPU systems.
Flutter handles the complex UI — overlaid, composited, and interactive.

### Why Flutter for Game UI

| Advantage | vs. Immediate-Mode (Dear ImGui) | vs. Web-Based (Electron/CEF) |
|:---|:---|:---|
| **Rich widgets** | ✅ Full widget library, animations, theming | ✅ Comparable richness, much less overhead |
| **Performance** | ✅ Similar draw-call efficiency | ✅ No JavaScript runtime, no DOM |
| **Hot reload** | ✅ Sub-second iteration on UI | ✅ Same |
| **Cross-platform** | ✅ Same Flutter code on Android, Desktop, Linux | ✅ No Chromium dependency |
| **Developer pool** | ✅ Large Flutter ecosystem | ✅ Much lighter than web stack |

---

## Platform Capability Tiers

Platform support is fundamental, not an export option. The engine defines hardware **capability tiers** and automatically adapts rendering and simulation quality:

```text
                    ENGINE
                       │
                Hardware Detection
                       │
        ┌──────────────┼──────────────┐
        │              │              │
      MOBILE        DESKTOP         HIGH-END
        │              │              │
     Tier 1         Tier 2           Tier 3
        │              │              │
      Vulkan         Vulkan          Vulkan
        │              │              │
   Reduced GI      Dynamic GI      Full GI
   Simple VFX      GPU VFX         Advanced VFX
   Lower LOD       Adaptive LOD    Virtual Geometry
```

### Tier Definitions

| Tier | Target Hardware | Rendering Budget | Key Tradeoffs |
|:---|:---|:---|:---|
| **Tier 1 — Mobile** | Android phones/tablets, ARM GPUs | 16ms (60fps) | Baked GI, simplified shadows, reduced draw distance, lower-res textures |
| **Tier 2 — Desktop** | Mid-range desktop GPUs, integrated graphics | 16ms (60fps) | Dynamic GI (probe-based), GPU-driven VFX, adaptive LOD |
| **Tier 3 — High-End** | Discrete desktop GPUs (RTX-class) | 8ms (120fps) or 16ms with max fidelity | Full GI (ray-traced or screen-space), virtual geometry, advanced VFX, maximum draw distance |

The **same game project** runs across all three tiers. Asset pipeline automatically generates tier-appropriate assets (LODs, texture mips, shader variants).

---

## Data-Driven Engine

Instead of baking everything into compiled Rust/C++ code, the engine is **data-driven**. The runtime interprets declarative resource files:

```text
Game Project
│
├── project.yaml           # Project metadata, engine version, plugins
├── scenes/                # Scene graphs, entity hierarchies
├── entities/              # Entity prefabs / archetypes
├── materials/             # PBR material definitions
├── shaders/               # Custom shader source
├── textures/              # Source textures (auto-cooked per tier)
├── meshes/                # 3D model source files
├── animations/            # Animation clips, blend trees, state machines
├── audio/                 # Sound banks, spatial audio configs
├── VFX/                   # Particle definitions, GPU effect graphs
├── scripts/               # Gameplay scripts (visual or text)
└── plugins/               # Engine extensions (Gem-equivalent modules)
```

### Why Data-Driven

| Benefit | Detail |
|:---|:---|
| **Modding** | Community can create and share content without recompiling the engine |
| **Asset ecosystem** | Marketplace for materials, VFX, prefabs, plugins |
| **Hot reload** | Change a material file → see it update in the viewport instantly |
| **Version control** | Text-based formats (YAML, TOML, JSON) diff cleanly in Git |
| **Multi-team** | Artists, designers, and programmers work on different files without conflicts |

---

## The Ultimate Layered Architecture

```text
                  ┌─────────────────────┐
                  │     GAME / APP      │
                  └──────────┬──────────┘
                             │
                  ┌──────────▼──────────┐
                  │     FLUTTER UI      │
                  └──────────┬──────────┘
                             │
                  ┌──────────▼──────────┐
                  │     ENGINE API      │
                  └──────────┬──────────┘
                             │
                  ┌──────────▼──────────┐
                  │    RUST RUNTIME     │
                  │                     │
                  │ ECS • Jobs • Memory │
                  │ Gameplay • Network  │
                  └──────────┬──────────┘
                             │
          ┌──────────────────┼───────────────────┐
          │                  │                   │
     ┌────▼────┐       ┌─────▼─────┐       ┌─────▼─────┐
     │ RENDER  │       │ SIMULATION│       │ SERVICES  │
     │         │       │           │       │           │
     │ Vulkan  │       │ Physics   │       │ AI        │
     │ Filament│       │ Animation │       │ Audio     │
     │ GI      │       │ Vehicles  │       │ Network   │
     │ VFX     │       │ Destruct. │       │ Streaming │
     └────┬────┘       └─────┬─────┘       └─────┬─────┘
          │                  │                   │
          └──────────────────┼───────────────────┘
                             │
                  ┌──────────▼──────────┐
                  │ PLATFORM ABSTRACTION│
                  └──────────┬──────────┘
                             │
             ┌───────────────┼────────────────┐
             │               │                │
          Android          Desktop          Server
             │               │                │
          Vulkan           Vulkan           Headless
```

### Layer Responsibilities

| Layer | Owns | Does Not Own |
|:---|:---|:---|
| **Game / App** | Game logic, content, scripted behaviors | Engine internals |
| **Flutter UI** | All 2D interface rendering, editor panels, HUD | 3D rendering, physics |
| **Engine API** | Public contract between Flutter and Rust | Implementation details |
| **Rust Runtime** | ECS world, job scheduler, memory allocator, system orchestration | Presentation |
| **Render** | GPU pipeline, draw calls, materials, lighting, VFX | Game logic |
| **Simulation** | Physics integration, animation evaluation, vehicle dynamics | Rendering |
| **Services** | AI evaluation, audio mixing, network replication, asset streaming | Everything else |
| **Platform Abstraction** | OS windowing, input, file I/O, Vulkan instance creation | High-level logic |

---

## What Must Be Specified Before Writing Code

Before writing thousands of lines of Rust, the following must be formally specified to prevent the project from turning into an increasingly difficult fork of Fluorite:

- [ ] **Core architecture** — ECS storage model (archetype vs. sparse set), world structure
- [ ] **Module boundaries** — Crate/package graph, dependency rules between subsystems
- [ ] **ECS model** — Component registration, system scheduling, query API
- [ ] **Rendering architecture** — Render graph, material system, shader pipeline, GPU resource management
- [ ] **Flutter ↔ Rust FFI** — Message protocol, data marshalling, threading model
- [ ] **Asset format** — Source vs. cooked formats, import pipeline, versioning
- [ ] **Plugin / Gem equivalent** — How extensions register components, systems, and editor panels
- [ ] **Platform abstraction** — Windowing, input, file I/O, GPU device selection
- [ ] **Android desktop strategy** — How the same project targets mobile/desktop/server tiers
- [ ] **Phased roadmap** — What ships at each milestone, what can be deferred

That specification is what separates an engine from a collection of interesting code.
