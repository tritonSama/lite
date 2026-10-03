# Game Maps IRL — HeavenlyBond Lite

A tactical community task & service marketplace, guild constellation command center, and decentralized operations platform rewritten as a React + TypeScript + Vite application.

## Overview

HeavenlyBond Lite restores the ability for ordinary people to turn useful work into an opportunity to earn, while allowing the community to decide what work deserves funding.

### Core Ecosystem & Features

1. **Board (`/board`)**:
   - **Main Feed**: Categorized community tasks (Field Cleanup, Logistics & Delivery, Automotive & OBD, Home Improvement, Tech & Hardware) with bounties, required skills, and worker requirements.
   - **My Club**: Filter tasks posted by your active guild or faction.
   - **Local Radar**: Interactive proximity radius slider (1–100 mi) with live coordinate radar blips and distance calculations.
   - **Interacting**: Active bids, negotiations, and escrow milestone management.

2. **Terminal Tactics 9x9 Grid Game (`/game`)**:
   - Turn-based tactical grid combat between Player 1 (Cyan) and Player 2 (Gold).
   - Placement phase for 7 pieces, flags, and hidden trap cards (values 1–12).
   - D12 movement rolling, orthogonal traversal, combat dice rolls, trap disarm rolls, and flag capture victory conditions.

3. **Mission Control (`/mission-control`)**:
   - Live meteorological satellite telemetry powered by Open-Meteo API.
   - High-performance interactive 3D holographic radar / globe view with 3 rendering modes: `CYBERPUNK RADAR`, `TACTICAL GRID`, and `SATELLITE`, with pan/zoom controls and squad tracking.
   - Quick access to GPS tracking, Tactical Comms, War Theater, and OBD2 Diagnostics.

4. **Tactical Comms & Radio**:
   - Direct Message, Guild / Team, Global, and VHF/UHF Mesh Radio channels.
   - Radio Walkie-Talkie simulator with Push-to-Talk (PTT), frequency tuner (462.5625 MHz), channel presets, and audio/visual transmission bursts.

5. **Guilds & Factions (`/teams`)**:
   - Elemental Guilds: Water Clan, Fire Tribe, Earth Guild, and Wind Order.
   - Guild Marketplace with Buy, Sell, and Rent listings (hourly, daily, weekly, monthly).
   - Active Territorial Wars with live scoreboards, casus belli declarations, and victory logs.
   - **Constellation Map 3D**: Interactive orbital solar-system visualization of guild hierarchies, genesis hubs, sibling links, and treaty tethers.

6. **TitheX Escrow & Task Verification**:
   - Multi-step Task Creation Wizard with automatic TitheX breakdown (90% Worker Bounty, 10% Community Tithe treasury).
   - Photographic Proof-of-Work upload and creator review/dispute workflow.

7. **OBD2 CAN Bus Telemetry**:
   - ELM327 Bluetooth adapter pairing and CAN bus streaming.
   - Real-time gauge cluster: RPM tachometer, Speedometer (km/h), Coolant temperature, Fuel level, and Throttle position.

8. **Nexus Protocol Early Access (`/nexus`)**:
   - Edge-native compute substrate for distributed AI workloads, Mobile Sovereign Vaults, and Proof of Health (PoH) consensus waitlist registration.

## Tech Stack

- **Framework**: React 19 + TypeScript + Vite
- **Styling**: Tailwind CSS v4 + Custom Cyberpunk Glows & Space Grotesk / JetBrains Mono typography
- **State & Storage**: React Context with LocalStorage persistence
- **Icons**: Lucide React
- **Graphics**: HTML5 Canvas 2D/3D orbital simulations & tactical radar rendering
- **APIs**: Open-Meteo REST API for live weather data

## Development

```bash
# Start local dev server (port 3000)
npm run dev

# Build for production
npm run build
```
