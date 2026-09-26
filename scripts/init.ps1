# ==============================================================================
# HeavenlyBond Lite / Game Maps IRL - Initiation & Dependency Sync Script
# Target Platforms: Android and Web
# ==============================================================================

Write-Host ""
Write-Host "[1/4] Synchronizing Git Submodules recursively (--remote)..." -ForegroundColor Cyan
git submodule sync --recursive
git submodule update --init --recursive --remote

Write-Host ""
Write-Host "[2/4] Resolving Flutter dependencies..." -ForegroundColor Cyan
flutter pub get

Write-Host ""
Write-Host "[3/4] Running code generation (Freezed and Riverpod)..." -ForegroundColor Cyan
dart run build_runner build --delete-conflicting-outputs

Write-Host ""
Write-Host "[4/4] Running static analysis sanity check..." -ForegroundColor Cyan
flutter analyze lib/core lib/features/tasks lib/features/game

Write-Host ""
Write-Host "Initiation complete! All 3 pillars are aligned for Android and Web." -ForegroundColor Green
Write-Host ""
