#!/usr/bin/env bash
# ==============================================================================
# HeavenlyBond Lite / Game Maps IRL - Initiation & Dependency Sync Script
# Target Platforms: Android and Web
# ==============================================================================
# Recursively updates all 3 architectural pillars and nested submodules:
#   1. fluorescent (3D Graphics Engine)
#   2. fluoderpod (fluoderpod_render GPU-driven renderer)
#   3. fluoridian / tithX (Nexus Protocol & Blockchain Consensus)
# ==============================================================================

set -e

echo -e "\n🚀 [1/4] Synchronizing Git Submodules recursively (--remote)..."
git submodule sync --recursive
git submodule update --init --recursive --remote

echo -e "\n📦 [2/4] Resolving Flutter dependencies..."
flutter pub get

echo -e "\n⚙️ [3/4] Running code generation (Freezed & Riverpod)..."
dart run build_runner build --delete-conflicting-outputs

echo -e "\n🔍 [4/4] Running static analysis sanity check..."
flutter analyze lib/core lib/features/tasks lib/features/game

echo -e "\n✅ Initiation complete! Pillars are aligned for Android & Web.\n"
