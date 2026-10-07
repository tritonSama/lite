# UPGRADE-02: Universal 3D Viewport Replacement
**Agent Role:** Agent Gamma (UI & Engine Integration Specialist)  
**Target Scope:** Android & Web  
**Objective:** Replace all static 2D painters, canvas placeholders, and empty mock tabs with the universal `FluoderpodView` backed by the native graphics engine.

---

## 1. Technical Specification

### 1.1 Viewport Insertion Points
1. **`lib/features/board/presentation/board_page.dart` (`_LocalTab`):**
   * Replace the `_PlaceholderTab` with an interactive 3D local radar viewport using `FluoderpodView`.
   * Display local tasks, nearby providers, and radius sphere boundaries dynamically rendered in 3D.
2. **`lib/features/mission_control/presentation/game_map_overlay.dart`:**
   * Upgrade `GameMapOverlay` to layer `FluoderpodView` directly beneath the tactical HUD controls, providing live camera rotation, zoom, and tilt.
3. **`lib/features/teams/presentation/constellation/constellation_map_page.dart`:**
   * Ensure full parity with Pillar 2's Fluorescent constellation system.
   * Connect node selection callbacks between 3D raycasting and Flutter state dialogs.

---

## 2. Step-by-Step Implementation Instructions

### Step 1: Update `_LocalTab` in `board_page.dart`
Locate `_LocalTab` and embed the `FluoderpodView`:
```dart
class _LocalTabState extends State<_LocalTab> {
  double _radius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 3D Fluoderpod Viewport
        const Positioned.fill(
          child: FluoderpodView(),
        ),
        
        // Floating HUD Overlay
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: GlassmorphicCard(
            child: Slider(
              value: _radius,
              min: 1.0,
              max: 100.0,
              onChanged: (val) => setState(() => _radius = val),
            ),
          ),
        ),
      ],
    );
  }
}
```

### Step 2: Validate Raycasting & Gestures
Ensure pinch-to-zoom, two-finger rotate, and tap events on `FluoderpodView` pass spatial coordinates down to `FluoderpodBridge`.

---

## 3. Build & Verification Commands

```powershell
# 1. Run static analysis across board and mission control
flutter analyze lib/features/board lib/features/mission_control lib/features/teams/presentation/constellation

# 2. Verify Android debug build
flutter build apk --debug
```
