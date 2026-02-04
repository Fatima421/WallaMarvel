# Decision Log

This document explains key architectural and implementation decisions made during development, including the evolution of the project over time.

## Architecture Decisions

### Clean Architecture + MVVM
**Why**: Chosen to separate UI, business logic, and data concerns, making the code easier to test and maintain. MVVM works naturally with SwiftUI’s reactive approach and keeps ViewModels focused on presentation logic while UseCases handle business rules.

### Feature-Based Organization
**Why**: Each feature (Characters, Splash) is self-contained with its own UI/Domain/Data layers. This makes the project easier to navigate and scale. I also personally find it clearer to read and reason about compared to layer-based folders.

### Repository Pattern with Protocols
**Why**: Repositories act as a boundary between the domain and data layers, keeping UseCases unaware of how data is fetched (network, cache, etc.). It also makes it easier to swap implementations (mock for testing, real API for production) without changing UseCases.

### API Client and Rest Manager
**Why**: Initially, APIClient handled everything (URL building, networking, decoding, errors). I split responsibilities into APIClient that defines domain-specific requests (characters, search, etc.) and RestManager that handles generic networking (building requests, executing HTTP calls, validating responses, decoding). This keeps networking reusable, simplifies APIClient, and makes the code easier to read and maintain.

### App container
**Why**: Created to centralize dependency injection and avoid constructing dependencies inside ViewModels or UseCases.

## Implementation Decisions

### BaseView for State Management
**Why**: Most screens share the same states: `none`, `loading`, `success`, `empty`, and `failure`.
Instead of duplicating this logic per feature, I centralized it in BaseView/BaseViewModel so all views behave consistently during loading and error scenarios. This reduces boilerplate and keeps state handling predictable across the app.

### Styles and View Components
**Why**: Spacing, ImageSize and CornerRadius values are centralized in different enum so layout changes don’t require editing multiple files.
I also created small reusable components (like empty placeholders and image views) to avoid repeating UI logic.
SwiftUI was chosen to modernize the previous UIKit based implementation.

### Models and Entities
**Why**: I decided to have a data model and then a separated model (entity) for our app. Even though it's a small app I wanted to separate the two layers, this also made it easier for me to then read the pagination info directly from Characters.

### Search
**Why**: Search is integrated directly into the character list instead of having a separate screen. Both share the same layout, pagination, and ViewModel logic, so merging them avoided duplication and simplified the flow.

### Accessibility Labels Throughout
**Why**: Added accessibility labels and hints throughout to support VoiceOver, important for usability and accessibility compliance.

## Testing Decisions

### Mock Dependencies via Protocols
**Why**: UseCases and repositories depend on protocols, making it easy to inject mocks for unit tests.

### Unit Tests
**Why**: I focused on testing the ViewModel as it contains most of the presentation and business logic, ensuring core user flows work correctly. In addition, I added unit tests for Repositories and DataSources to verify data mapping, error propagation, and integration between layers. This helps catch issues early in the data flow and gives confidence that each layer behaves correctly in isolation.

## Code Quality Decisions

### SwiftLint/SwiftFormat
**Why**: Ensures consistent code style across the project with automated formatting.

## Refactoring Journey

- **Created data layer foundation** → Built DataSource, Repository, and UseCases with proper separation
- **Fixed API models and separated layers** → Refined data models and split API logic properly
- **Migrated UI from UIKit to SwiftUI** → Deleted old UI and created new SwiftUI views with ViewModels
- **Added comprehensive testing** → Implemented unit tests for repositories, data sources, and ViewModels
- **Built character list and detail views** → Created main features with proper ViewModel integration
- **Created separate search feature** → Initially built as standalone view with its own logic
- **Merged search into character list** → Consolidated to avoid code duplication since both shared same layout/pagination
- **Implemented state management** → Added handling for loading, empty, and error cases with BaseView/BaseViewModel
- **Enhanced error handling** → Added retry actions on failures
- **Improved UI/UX** → Refined character detail view, created launch screen, added accent color and dark mode support
- **Added accessibility support** → Implemented VoiceOver labels and hints throughout the app
- **Applied code quality tools** → Integrated SwiftLint and SwiftFormat for consistent style
- **Fixed console warnings** → Resolved URL handling issues to clean up logs
- **Switched to Kingfisher** → Replaced manual image loading with Kingfisher library for better caching and reliability
- **Added UI tests** → Implemented automated UI testing for key flows
- **Code cleanup** → Removed redundant code and added clarifying comments where needed
