# CLAUDE.md - Exchanges App

## Project Overview
iOS cryptocurrency exchanges app using CoinMarketCap API. Displays exchange listings with pagination and detail views. Built with UIKit, Swift 6, targeting iOS 15+.

## Build System
- **Tuist** for project generation and modular architecture
- `make local-setup` - Install Brew and Ruby dependencies
- `make generate-project` - Generate Xcode workspace via Tuist
- Requires `.env` file with `TUIST_CM_API_BASE_URL` and `TUIST_CM_API_KEY`

## Project Structure (TMA - Two-Module Architecture)
```
Projects/
├── App/              # Main app target (AppDelegate, SceneDelegate, AppCoordinator, DI assemblies)
├── Home/             # Feature: exchange list with pagination
├── Detail/           # Feature: exchange detail view
├── DependencyInjection/  # Shared DI container (Swinject wrapper)
├── DesignSystem/     # Reusable UI components, styles, design tokens
└── Navigation/       # Coordinator protocols and navigation interfaces
```

Each module follows:
```
Module/
├── Sources/          # Implementation
├── Tests/            # Unit tests
├── Interfaces/       # Public protocols/contracts
├── Testing/          # Shared test doubles (optional)
├── Resources/        # Assets, localization
└── Project.swift     # Tuist module definition
```

## Architecture: MVVM-C
- **Coordinators** manage navigation flow and VC instantiation (AppCoordinator → HomeCoordinator → DetailCoordinator)
- **ViewModels** are `@MainActor`, protocol-based, use delegates for state updates, async/await for network
- **ViewControllers** are thin - only layout and user interaction, programmatic UI (no storyboards)
- **Services** are protocol-based with endpoint abstraction
- **DI** via Swinject with Assembly pattern and `SharedContainer` singleton

### Source Organization per Module
```
Sources/
├── Coordinator/      # Navigation flow
├── ViewModel/        # Business logic
├── View/             # UI controllers
├── Service/          # API/data layer
├── Endpoints/        # API endpoint definitions
├── Model/            # Data models and state enums
└── Protocols/        # Public interfaces
```

## Dependencies
- **Swinject** (2.9.1+) - Dependency injection
- **SnapshotTesting** (1.18.9+) - UI snapshot tests
- **networking-package** (1.1.0+) - Custom networking abstraction
- **SwiftLint** - Linting (via Homebrew)
- **Fastlane** - Test automation and coverage
- **Slather** - Code coverage reports
- **Danger** - PR review automation

## Testing
- **Swift Testing framework** (not XCTest) - uses `@Suite`, `@Test`, `#expect()` macros
- **Spy/Mock pattern** in `Module/Tests/Doubles/` - tracks called methods via `calledMethods`
- **Shared test doubles** in `Module/Testing/` exported as separate framework
- **Snapshot tests** for DesignSystem components using `assertSnapshot(of:as:)`
- **`makeSut()` factory pattern** for test setup
- **Coverage target: 80%** - Danger warns on PRs below this threshold

### Running Tests
```bash
fastlane tests target:App
fastlane tests_coverage target:App
```

## Coding Conventions
- Swift 6 with async/await concurrency
- `@MainActor` on UI-related types (ViewModels, Coordinators)
- `final class` where inheritance not needed
- Protocol-driven design with explicit access control
- Weak delegates to prevent retain cycles

### Naming
- Feature-prefixed types: `HomeViewModel`, `HomeCoordinator`, `HomeViewController`
- Protocol suffix: `HomeViewModelProtocol`, `HomeServiceProtocol`
- Coordinating protocols: `HomeCoordinating`
- Delegate suffix: `HomeViewModelDelegate`, `HomeViewModelCoordinatorDelegate`
- Assembly suffix: `NetworkAssembly`, `CoordinatorAssembly`
- State enums: lowercase cases (`.loading`, `.empty`, `.error`)
- Bundle IDs: `com.vrc.{modulename}`

### File Headers
```swift
//
//  FileName.swift
//  ModuleName
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
```

## CI/CD
- **GitHub Actions** on PRs: path-filtered test matrix per module, coverage reporting via Danger
- **Dangerfile** parses Cobertura XML, posts coverage tables to PRs
- SwiftLint runs as build phase on each target
