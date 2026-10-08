# UPGRADE-04: WebGPU & Jaspr CanvasKit Interop
**Agent Role:** Agent Zeta (Web, WebGPU & Jaspr Specialist)  
**Target Scope:** Web (WebAssembly / WebGPU / Jaspr)  
**Objective:** Deliver 60+ FPS hardware 3D graphics on Web browsers using WebGPU and Jaspr without using JavaScript or TypeScript.

---

## 1. Technical Specification

### 1.1 Architecture & Jaspr Integration
* **Pure Dart Web:** UI rendered using Flutter Web with Wasm support, and the accompanying standalone portal using `jaspr.js` / `jaspr` pure Dart components.
* **WebGPU Native Context:** `fluoderpod_render` compiled to `--target wasm32-unknown-unknown` utilizing `wgpu` with the WebGPU backend.
* **Zero JS/TS Mandate:** All interaction scripts, models, and UI bindings are authored strictly in Dart.

### 1.2 Target Source Files
* `third_party/fluoderpod/cyan_sdk_jaspr/`
* `third_party/fluorescent/fluoderpod_render/Cargo.toml`
* `web/index.html` (mount `<canvas id="fluoderpod-canvas">`)
* `lib/core/fluoderpod/fluoderpod_bridge.dart` (Web branch)

---

## 2. Step-by-Step Implementation Instructions

### Step 1: Compile Rust Engine to WebAssembly (WebGPU)
Inside `third_party/fluorescent/fluoderpod_render`:
```bash
cargo build --target wasm32-unknown-unknown --release
```
> The crate currently defines no `webgpu` feature; wgpu targets WebGPU on wasm32 by default. A canvas-bound `wasm-bindgen` entry point still has to be added (see `DEPENDENCY_TEAM_BREAKDOWN.md`, F5).

### Step 2: Build Jaspr Web Client
Inside `third_party/fluoderpod/cyan_sdk_jaspr`:
```powershell
jaspr clean
jaspr build --release
```

### Step 3: Build Flutter Web with Wasm
In the root `lite` repository:
```powershell
flutter build web --wasm
```

---

## 3. Build & Verification Commands

```powershell
# 1. Test compilation of pure Dart Jaspr client
cd third_party/fluoderpod/cyan_sdk_jaspr
jaspr build
cd ../../..

# 2. Test Flutter Web Wasm compilation
flutter build web --wasm
```
