# Fluorescent: Game Maps IRL

Fluorescent is a next-generation automotive navigation and social platform that transforms real-world driving into a persistent, interactive "living world."

It combines real-world navigation, game-inspired map visualization, live driver mapping, car clubs, and gamification (XP, rallies, time attacks) into a single unified experience.

The project is built on top of the Fluorescent platform, which combines a Flutter application layer with a high-performance Rust core engine. The strategic objective is to use this automotive application to progressively build a general-purpose Rust/Flutter simulation and game engine.

## Documentation & Roadmap

Please refer to the following documents for comprehensive information about the project:

*   [Documentation](docs/DOCUMENTATION.md): Details the application's concept, architecture, the Map abstraction layer, the Rust engine evolution, and the strategic vision for the "Game Maps IRL" platform.
*   [Build Plan](docs/BUILD_PLAN.md): A 7-phase roadmap detailing the transition from the base repository to the final General-Purpose Engine.
*   [Agent Assignments](AGENTS.md): Breakdown of the AI agent roles for each phase of the build plan.

## Getting Started

This project is a Flutter application utilizing a Rust core via Flutter/Rust Bridge, with Firebase for backend services.

### Prerequisites

*   Flutter SDK (^3.8.0)
*   Rust Toolchain
*   Firebase project setup with Firestore, Authentication, and Storage configured.

### Running the App

1.  Clone the repository.
2.  Run `flutter pub get` to install dependencies.
3.  Ensure your Firebase configuration files (`firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`) and API keys are set up.
4.  Run `flutter run` to launch the app on your desired device or emulator.
