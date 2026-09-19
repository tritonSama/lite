# Fluorescent Engine Architecture

> **Repository:** [github.com/tritonSama/Fluorescent](https://github.com/tritonSama/Fluorescent)

> **Flutter for the application/editor experience. Rust for the core runtime. Fluorite/Filament-inspired rendering for the visual layer. O3DE/Unreal-class systems architecture underneath.**

Fluorescent is **not** a modified Fluorite engine. It is a **new, layered game/runtime platform** built from Fluorite's ideas and technology — a coherent engine that extracts architectural lessons from the best and unifies them under a single vision.

---

## Philosophy

| Source | Lesson Extracted |
|:---|:---|
| **Fluorite / Filament** | The seed — physically-based mobile rendering, material model, Vulkan abstraction |
| **Flutter** | The interface — production-grade cross-platform UI for editor and in-game HUD |
| **Rust** | The heart — memory safety, fearless concurrency, zero-cost abstractions for the runtime core |
| **Vulkan** | The hardware abstraction — explicit GPU control across Android, Desktop, and Linux |
| **Godot** | Developer experience — server architecture pattern (`RenderingServer`, `PhysicsServer`, `NavigationServer`) |
| **O3DE** | Modular AAA architecture — Gem system, prefab overrides, multi-team scalability |
| **Unreal** | The benchmark — AAA capability target (Nanite, Lumen, World Partition, networking) |

The goal is not to make a Frankenstein. It is to **extract the architectural ideas needed and build a coherent engine around them**.

---

## Repository Structure

```text
Fluorescent/
│
├── fluorescent/                     # Dart/Flutter monorepo (core engine packages)
│   ├── packages/
│   │   ├── fluorescent_core/        # Servers, resources, render graph, scene graph
│   │   ├── fluorescent_ecs/         # Sparse-Set TypedData ECS
│   │   ├── fluorescent_flame/       # Flame 2D/3D viewport bridge
│   │   ├── fluorescent_vulkan/      # Vulkan C-ABI FFI bindings
│   │   ├── fluorescent_webgpu/      # WebGPU JS-interop bindings
│   │   ├── fluorescent_metal/       # Metal backend scaffold
│   │   └── fluorescent_fluorite/    # Fluorite engine plugin scaffold
│   ├── tools/
│   │   ├── asset_pipeline/          # CLI: .gltf + .wgsl → .fworld binaries
│   │   ├── blender_sync/            # Python Blender add-on
│   │   └── generate_shaders.py      # SPIR-V bytecode generator
│   ├── examples/
│   │   ├── functional_test_app/     # Google Maps geofencing demo
│   │   ├── hybrid_2d_3d/           # Flame 2D + 3D viewport demo
│   │   ├── open_world_demo/         # Open world scaffold
│   │   └── ...
│   ├── docs/
│   │   └── ENGINE_SPECIFICATION.md  # 24KB formal engine spec
│   └── test/e2e/                    # Pillar & acceptance tests
│
├── fluorite_core/                   # Rust native engine crate (cdylib + rlib)
│   └── src/
│       ├── allocator/               # ArenaAllocator, DoubleBufferedFrameAllocator
│       ├── api/engine.rs            # FFI API surface (start_engine, buffers, telemetry)
│       └── rendering/renderer.rs    # QualityTier (Tier 1–4)
│
├── fluorite_editor/                 # Flutter Desktop editor (consumes FRB bindings)
│   └── lib/src/rust/                # Generated Dart ↔ Rust bridge code
│
├── flutter_rust_bridge.yaml         # FRB v2 code generation config
└── tests/                           # 4-Tier E2E suite (51 tests)
```

---

## Core Concept: Two Engines in One

The engine is composed of a **Creation Runtime** and a **Game Runtime** that share the same project, the same data, and the same core systems.

**The editor is not an afterthought.** It is a first-class runtime.

```text
                  FLUORESCENT
                       │
          ┌────────────┴────────────┐
          │                         │
     CREATION RUNTIME          GAME RUNTIME
          │                         │
       Flutter                     Rust
     (fluorite_editor)         (fluorite_core)
          │                         │
       Editor                  ECS / Systems
       Inspector                  Renderer
       Scene tools                Physics
       Material tools             Animation
       VFX tools                  Audio
       Profiler                   AI
          │                    Networking
          │                         │
          └────────────┬────────────┘
                       │
                 SAME PROJECT
```

### What's Built Today

| Runtime | Package | Status |
|:---|:---|:---|
| **Creation** | `fluorite_editor` | ✅ FRB bindings, telemetry viewer, hex inspector, engine lifecycle |
| **Game** | `fluorite_core` (Rust) | ✅ Custom allocators, zero-copy FFI, frame budgeting, quality tiers |
| **Game** | `fluorescent_core` (Dart) | ✅ Server architecture, resource management, render graph, scene graph |

---

## Rust as the Authoritative Runtime

Rust is the engine's heart. Flutter is a high-level interface. All authoritative state lives in Rust.

### What `fluorite_core` Implements Today

```text
fluorite_core/src/
│
├── allocator/
│   ├── arena.rs          # ArenaAllocator — 64-byte cache-line aligned,
│   │                     #   atomic bump pointer, O(1) bulk reset, telemetry
│   └── frame.rs          # DoubleBufferedFrameAllocator — ping-pong frame
│                         #   allocation, automatic arena reset on swap
├── api/
│   └── engine.rs         # FFI surface:
│                         #   start_engine() → EngineStatus
│                         #   allocate_engine_buffer(size) → Vec<u8> (sentinels 0xAA/0x55)
│                         #   get_engine_status() → EngineStatus
│                         #   verify_buffer_sentinels() → bool
│                         #   SharedFrameBuffer (ptr_address, asTypedList)
│                         #   EngineStatusC (#[repr(C)] for standard C-ABI)
└── rendering/
    └── renderer.rs       # QualityTier (Tier1 mobile → Tier4 high-end)
```

### Flutter ↔ Rust FFI Boundary

Configured by `flutter_rust_bridge.yaml`:
```yaml
rust_root: "fluorite_core"
rust_input: "src/api"
dart_output: "fluorite_editor/lib/src/rust"
```

The bridge provides:
- **Zero-copy buffer transfer** via `Dart_NewExternalTypedDataWithFinalizer`
- **SharedFrameBuffer** — persistent native pointer exposed as `Uint8List` via `asTypedList()` (no intermediate serialization)
- **Dual-mode runtime** — native DLL dynamic linking + managed C-runtime fallback (`_SystemAlloc` via msvcrt `malloc`/`free`) with GC finalizers for headless/test environments
- **Sentinel-based integrity verification** — `0xAA` header / `0x55` footer on all allocated buffers

```text
Flutter (fluorite_editor)
   │
   │ flutter_rust_bridge v2
   │ (zero-copy, native finalizers)
   ▼
Rust API (fluorite_core/src/api/)
   │
   ▼
Allocators + Renderer + Engine State
```

---

## Godot-Inspired Server Architecture

Borrowed from Godot's server pattern and implemented in `fluorescent_core`. Each server runs in its own Dart Isolate with non-blocking message passing:

### `ServerManager` (Built ✅)
- Spawns background worker isolates via `_serverWorkerEntryPoint`
- Bidirectional `SendPort`/`ReceivePort` communication
- Fire-and-forget commands (`_ServerCommandMessage`)
- Request-response queries with unique IDs and `Completer`s (`_ServerQueryMessage` / `_ServerResponseMessage`)
- Periodic tick updates (`ServerTickUpdate`) synchronizing transforms at 60 Hz

### `PhysicsServer` (Built ✅)
- Newtonian integration (position, velocity, acceleration)
- Spatial queries and raycasts
- Opaque handle-based API (no direct object references cross-isolate)

### `NavigationServer` (Built ✅)
- A* pathfinding with Funnel smoothing
- Agent crowd steering
- Opaque handle-based API

### `RenderingServer` (Built ✅)
- Data-driven DAG-based render graph with cycle detection and topological sort
- JSON/YAML configurable render passes
- Extensible pass architecture

```text
Main Isolate (Flutter UI / Game Loop)
   │
   ├──SendPort──→ Physics Isolate (PhysicsServer)
   │              └── Newtonian sim, raycasts, spatial queries
   │
   ├──SendPort──→ Navigation Isolate (NavigationServer)
   │              └── A* pathfinding, funnel smooth, crowd steering
   │
   └──SendPort──→ Rendering Isolate (RenderingServer)
                  └── Render graph DAG, pass scheduling
```

---

## ECS: Everything is an Entity

Implemented in `fluorescent_ecs` using a **Sparse-Set contiguous `Float32List`** memory layout — cache-friendly and GC-pressure-free.

### `TransformStorage` Layout (Built ✅)

16-float stride per entity, 64-byte cache-line aligned:

```text
[0..2]   translation (x, y, z)
[3]      dirty flag
[4..7]   quaternion (x, y, z, w)
[8..10]  scale (x, y, z)
[11]     reserved
[12..14] bounds min (x, y, z)
[15]     bounds max radius
```

### `EcsWorld` (Built ✅)
- Sparse-set archetype storage
- O(1) entity recycling
- 10,000 entity benchmark verified with zero GC pressure

### Target: Full Component Composition

```text
Player                          NPC
├── Transform                   ├── Transform
├── Mesh                        ├── Mesh
├── Material                    ├── Animation
├── PhysicsBody                 ├── NavAgent
├── CharacterController         ├── Behavior
├── AnimationController         ├── Dialogue
├── Health                      └── NetworkIdentity
├── Inventory
├── NetworkIdentity
└── AIController
```

---

## Resource Management (Built ✅)

`ResourceManager` in `fluorescent_core` provides GPU resource lifecycle management:

- **Intrusive reference counting** — resources track their own ref count
- **GPU VRAM budget tracking** — configurable memory ceiling with enforcement
- **Cascading disposal** — materials release their textures when disposed
- **Resource types**: `TextureResource`, `MeshResource`, `MaterialResource`

```text
ResourceManager
   │
   ├── TextureResource (ref count, GPU handle, VRAM bytes)
   ├── MeshResource    (ref count, GPU handle, VRAM bytes)
   └── MaterialResource
        ├── refs → TextureResource (albedo)
        ├── refs → TextureResource (normal)
        └── refs → TextureResource (roughness)
        
   Dispose material → cascading texture release if refcount hits 0
```

---

## Data-Driven Render Graph (Built ✅)

The render graph is defined in JSON/YAML rather than hard-coded. The runtime parses it, validates the DAG (cycle detection), and executes passes in topological order.

```text
RenderGraph (JSON/YAML definition)
   │
   ├── Parse → Validate (cycle detection)
   │
   └── Execute (topological sort)
        │
        ├── Depth Pre-Pass
        ├── GBuffer Pass
        ├── Lighting Pass
        ├── Post-Process Pass
        └── UI Composite Pass
```

---

## Rendering Engine

The renderer is a self-contained subsystem with pluggable backends and a scalable quality tier system:

### Backends

| Package | API | Status |
|:---|:---|:---|
| `fluorescent_vulkan` | Vulkan (C-ABI FFI: `init_vulkan`, `render_frame`, `cleanup_vulkan`, `load_gltf_model`, `update_camera`) | ✅ Bindings built |
| `fluorescent_webgpu` | WebGPU (`dart:js_interop` → `window.fluorescentBridge.initCanvas`) | ✅ Bindings built |
| `fluorescent_metal` | Metal | 🔲 Scaffold |
| `fluorescent_fluorite` | Filament/Fluorite bridge | 🔲 Scaffold |

### Quality Tiers (Built ✅)

Defined in `fluorite_core/src/rendering/renderer.rs`:

```text
                    FLUORESCENT
                        │
                 Hardware Detection
                        │
        ┌───────────────┼───────────────┐
        │               │               │
    Tier 1 (Mobile)  Tier 2 (Desktop)  Tier 3–4 (High-End)
        │               │               │
      Vulkan          Vulkan           Vulkan
        │               │               │
    Reduced GI      Dynamic GI       Full GI
    Simple VFX      GPU VFX          Advanced VFX
    Lower LOD       Adaptive LOD     Virtual Geometry
```

### Evolutionary Rendering Strategy

Start from Filament/Fluorite technology, progressively replace with Rust-native systems:

| Phase | Approach | Status |
|:---|:---|:---|
| **Phase 1** | Filament/Fluorite PBR via FFI; Vulkan/WebGPU bindings | ✅ Bindings built |
| **Phase 2** | Rust-native material system and shader pipeline | 🔲 Planned |
| **Phase 3** | Custom GI, virtual geometry, advanced VFX in Rust | 🔲 Planned |
| **Phase 4** | Full Rust-native renderer with Vulkan backend | 🔲 Planned |

---

## Asset Pipeline & Shader Toolchain (Built ✅)

`fluorescent/tools/asset_pipeline/` — a standalone Dart CLI that compiles content into engine-native formats:

```text
Source Assets                    Compiled Output
│                                │
├── model.gltf  ──GltfCompiler──→│
│                                ├── scene.fworld (gzip/zlib/none)
├── shader.wgsl ──NagaFfi─────→ │    ├── mesh data
│               ──DemoShader───→ │    ├── SPIR-V bytecode (0x07230203)
│                                │    └── MSL text
└── textures/                    │
                                 └── Bundled binary package
```

### Shader Toolchain

- `NagaFfiTranspiler` — native FFI to Naga (`naga_compile_spirv`, `naga_compile_msl`, `naga_free_buffer`)
- `DemoShaderTranspiler` — fallback producing valid SPIR-V magic bytes and Metal Shading Language
- Automatic fallback when native binaries are absent

---

## The 10 Major Engine Subsystems

```text
┌───────────────────────────────────────────┐
│              FLUORESCENT ENGINE            │
├───────────────────────────────────────────┤
│ 1.  Core / ECS          ✅ Built           │
│ 2.  Rendering           ✅ Bindings + DAG  │
│ 3.  Physics             ✅ Server built    │
│ 4.  Animation           🔲 Planned         │
│ 5.  Audio               🔲 Planned         │
│ 6.  VFX                 🔲 Planned         │
│ 7.  World / Terrain     ✅ Scene graph     │
│ 8.  AI / Navigation     ✅ Server built    │
│ 9.  Networking          🔲 Planned         │
│ 10. Asset Pipeline      ✅ Built           │
└───────────────────────────────────────────┘
```

Each subsystem will have a corresponding **editor tool** in the Creation Runtime:

```text
┌───────────────────────────────────────────┐
│             CREATOR PLATFORM              │
├───────────────────────────────────────────┤
│ Scene Editor              🔲 Planned       │
│ World Editor              🔲 Planned       │
│ Material Editor           🔲 Planned       │
│ Animation Editor          🔲 Planned       │
│ VFX Editor                🔲 Planned       │
│ Audio Editor              🔲 Planned       │
│ AI / Behavior Editor      🔲 Planned       │
│ Visual Scripting          🔲 Planned       │
│ Profiler                  🔲 Planned       │
│ Debugger                  🔲 Planned       │
└───────────────────────────────────────────┘
```

---

## Flutter as a First-Class UI Runtime

Flutter is not bolted on. It is a **native UI runtime** for both the editor and in-game interfaces.

### In-Game UI Architecture

```text
Game
 ├── 3D World (Rust/Vulkan)
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

### Flame Integration (Built ✅)

`fluorescent_flame` provides `FluorescentViewport` — compositing native 3D texture IDs into Flame's 2D component tree. This enables mixed 2D/3D games:

```text
Flame 2D Layer (sprites, particles, UI)
       │
       └── FluorescentViewport (textureId from Rust/Vulkan)
              │
              └── 3D scene rendered by native GPU backend
```

Demonstrated in `examples/hybrid_2d_3d/`.

---

## Platform Capability Tiers

The same game project runs across all tiers. Hardware detection selects the tier automatically:

| Tier | Target | Rendering | Status |
|:---|:---|:---|:---|
| **Tier 1 — Mobile** | Android phones, ARM GPUs | Baked GI, simple shadows, reduced draw distance | ✅ Defined |
| **Tier 2 — Desktop** | Mid-range GPUs, integrated | Dynamic GI (probes), GPU VFX, adaptive LOD | ✅ Defined |
| **Tier 3 — High-End** | Discrete GPUs (RTX-class) | Full GI, virtual geometry, advanced VFX | ✅ Defined |
| **Tier 4 — Ultra** | Workstation GPUs | Maximum fidelity, no budget limits | ✅ Defined |

---

## Data-Driven Engine

Content is defined in declarative files. The engine interprets them at runtime:

```text
Game Project
│
├── project.yaml           # Project metadata, engine version, plugins
├── scenes/                # Scene graphs, entity hierarchies
├── entities/              # Entity prefabs / archetypes
├── materials/             # PBR material definitions
├── shaders/               # Custom shader source (.wgsl)
├── textures/              # Source textures (auto-cooked per tier)
├── meshes/                # 3D models (.gltf → compiled .fworld)
├── animations/            # Animation clips, blend trees, state machines
├── audio/                 # Sound banks, spatial audio configs
├── VFX/                   # Particle definitions, GPU effect graphs
├── scripts/               # Gameplay scripts (visual or text)
└── plugins/               # Engine extensions (Gem-equivalent modules)
```

The `.fworld` binary format (built by the asset pipeline) supports gzip, zlib, and uncompressed modes. It bundles meshes, compiled shaders (SPIR-V + MSL), and metadata into a single deployable package.

---

## The Full Layered Architecture

```text
                  ┌─────────────────────┐
                  │     GAME / APP      │
                  └──────────┬──────────┘
                             │
                  ┌──────────▼──────────┐
                  │     FLUTTER UI      │
                  │  (fluorite_editor   │
                  │   + in-game HUD)    │
                  └──────────┬──────────┘
                             │
                  ┌──────────▼──────────┐
                  │     ENGINE API      │
                  │  (flutter_rust_     │
                  │   bridge v2 FFI)    │
                  └──────────┬──────────┘
                             │
                  ┌──────────▼──────────┐
                  │    RUST RUNTIME     │
                  │    (fluorite_core)  │
                  │                     │
                  │ ECS • Allocators    │
                  │ Frame Budget • Jobs │
                  └──────────┬──────────┘
                             │
          ┌──────────────────┼───────────────────┐
          │                  │                   │
     ┌────▼────┐       ┌─────▼─────┐       ┌─────▼─────┐
     │ RENDER  │       │ SIMULATION│       │ SERVICES  │
     │         │       │           │       │           │
     │ Vulkan  │       │ Physics   │       │ AI/Nav    │
     │ WebGPU  │       │ Server    │       │ Server    │
     │ Metal   │       │ Animation │       │ Audio     │
     │ Fluorite│       │ Vehicles  │       │ Network   │
     │ RenderGr│       │ Destruct. │       │ Streaming │
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
          Android          Desktop          Web/Server
             │               │                │
          Vulkan           Vulkan           WebGPU/Headless
```

---

## Test Infrastructure (Built ✅ — 51 Tests Passing)

### 4-Tier Systematic Test Suite (`tests/`)

| Tier | Focus | Test Count |
|:---|:---|:---|
| **Tier 1** | Feature coverage (allocators, zero-copy buffers, FFI lifecycle, editor integration) | 20 |
| **Tier 2** | Boundary & corner cases (0-byte, 1-byte, overflow, alignment ladders, sentinel corruption) | 21 |
| **Tier 3** | Cross-feature combinations (allocator reset + frame swap, Rust→FFI→Dart roundtrip, hex inspector) | 5 |
| **Tier 4** | Real-world scenarios (60 FPS loop, 1000-frame stress, 1MB streaming, dynamic pressure, editor lifecycle) | 5 |

### Pillar E2E Suite (`fluorescent/test/e2e/`)

| Test | Validates |
|:---|:---|
| `ac1_server_isolate` | Isolate spawn & communication without main thread blocking |
| `ac2_asset_pipeline` | `.gltf` + `.wgsl` → `.fworld` compilation |
| `ac3_ecs_benchmark` | 10K entity spawn/iterate, zero GC pressure |
| `ac4_resource_manager` | Texture lifecycle, ref counting, VRAM budget enforcement |
| `pillar2_render_graph` | DAG parse, topological sort, cycle detection |
| `pillar6_shader_toolchain` | SPIR-V + MSL transpilation |

### Running Tests

```bash
# Rust native tests
cargo test --manifest-path tests/Cargo.toml

# Dart E2E runner
dart run tests/e2e_runner.dart

# Platform scripts
.\tests\run_e2e_tests.ps1     # Windows PowerShell
bash ./tests/run_e2e_tests.sh  # Linux/macOS
```

---

## Implementation Roadmap

### ✅ Phase 1: Foundation (Complete)

- Rust custom allocators (Arena, DoubleBuffered Frame)
- Zero-copy Flutter↔Rust FFI via FRB v2
- Godot-pattern server architecture (Physics, Navigation, Rendering)
- Sparse-set TypedData ECS with 10K entity benchmark
- Data-driven render graph (DAG, cycle detection, topological sort)
- GPU resource management (ref counting, VRAM budgets, cascading disposal)
- Asset pipeline CLI (`.gltf` + `.wgsl` → `.fworld`)
- Shader toolchain (WGSL → SPIR-V + MSL)
- Vulkan & WebGPU FFI bindings
- Flame 2D/3D bridge
- 51-test E2E verification suite

### 🔲 Phase 2: Engine Core Subsystems (Next)

- Complete native Vulkan/Metal rendering backend implementations
- Full physics engine integration (Rapier/PhysX)
- Animation blending trees and state machines
- Spatial audio system
- Scene graph persistence and hot-reload

### 🔲 Phase 3: AAA Visuals

- GPU-driven rendering pipeline
- Virtual geometry (Nanite equivalent)
- Dynamic global illumination (Lumen equivalent)
- Virtual shadow maps
- GPU VFX compute pipelines
- Procedural content generation (PCG)

### 🔲 Phase 4: Online Multiplayer

- State replication with client-side prediction
- Rollback netcode
- Dedicated headless server runtime
- Matchmaking and spatial voice

### 🔲 Phase 5: Creator Ecosystem

- Full Flutter desktop editor suite (Scene, World, Material, Shader Graph, Animation, VFX, Audio, Behavior editors)
- Visual scripting system
- Profiler and debugger tools
- Asset marketplace integration

### 🔲 Phase 6: Android Desktop Specialization

- Automatic hardware detection and tier selection
- Multi-monitor desktop windowing
- High refresh rate and HDR support
- Dynamic resolution scaling
