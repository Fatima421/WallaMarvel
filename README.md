# WallaMarvel - Technical Challenge

A Disney character browsing app showing different architectural approaches and my refactoring process.

## Project Overview

This project showcases two separate approaches to building the same app:

1. **`main` branch** - Refactoring and fixing existing UIKit codebase while keeping the architecture clean.
2. **`new-version` branch** - A modern SwiftUI implementation using async/await with MVVM + Clean Architecture.

### API Change: Marvel → Disney

**Important Note**: The original codebase was designed to use the Marvel API. During development, I was informed that the Marvel API was not working properly, so I had to look for an alternative.

After evaluating options, I switched to the **[Disney API](https://disneyapi.dev/)** for the following reasons:

- **Similar structure**: Provides characters with detailed info like name, image, films, etc.
- **Pagination support**: Built-in pagination
- **Free and reliable**: No authentication issues, stable endpoints
- **Character-focused**: Same concept of browsing and viewing character details
- **Limited detail info**: While Disney characters have fewer details than Marvel heroes the API structure is similar enough to demonstrate the same architectural patterns

**Why Disney API was the right choice**:

It was the closest alternative for character-based content and allowed me to demonstrate technical concepts like search, detail views, and pagination while handling an API change scenario.

---

## Why Two Branches?

### Strategic Approach

I intentionally developed two separate branches to demonstrate different technical capabilities:

#### `main` Branch - Refactoring Existing Code
**Goal**: Demonstrate ability to identify and fix architectural issues in legacy codebases without rewriting everything.

**Why this matters**:
- In real projects, full rewrites are rarely an option
- Shows capability to work with and improve existing codebases
- Demonstrates understanding of architectural patterns (MVP in this case)
- Proves I can identify issues like memory leaks, constraint conflicts, and security problems
- **If I had modernized everything immediately, the fixes and improvements wouldn't be visible**

**Key Focus**:
- Fix architectural violations (MVP pattern)
- Resolve memory leaks
- Fix Auto Layout conflicts
- Secure API key management
- Integrate SwiftUI detail view into UIKit context

#### `new-version` Branch - Modern Implementation
**Goal**: Demonstrate ability to build modern iOS applications from an existing base using current best practices.

**Why this matters**:
- Demonstrates proficiency with SwiftUI and Swift Concurrency
- Shows understanding of modern architecture (MVVM + Clean Architecture)
- Proves ability to build scalable, testable applications
- Allows direct comparison of architectural approaches

**Key Focus**:
- Complete SwiftUI implementation
- Swift Concurrency (async/await)
- SOLID principles
- Clean code organization and readability
- Search functionality
- Pagination support
- Accessibility features
- Unit testing
- Code quality enforced with SwiftLint and SwiftFormat

---

## Architecture Comparison

### `main` Branch - MVP + Clean Architecture (UIKit)

```
┌─────────────────────────────────────────────────┐
│                  Presentation                   │
│  ┌──────────────┐  ┌───────────┐  ┌──────────┐ │
│  │ViewController│◄─┤ Presenter ├─►│  Adapter │ │
│  │   (UIKit)    │  │   (MVP)   │  │(TableView)│
│  └──────────────┘  └─────┬─────┘  └──────────┘ │
└─────────────────────────┼──────────────────────┘
                          │
┌─────────────────────────┼──────────────────────┐
│                      Domain                     │
│                  ┌───────▼─────┐                │
│                  │  Use Cases  │                │
│                  │ (Business)  │                │
│                  └───────┬─────┘                │
└─────────────────────────┼──────────────────────┘
                          │
┌─────────────────────────┼──────────────────────┐
│                       Data                      │
│  ┌──────────┐    ┌─────▼──────┐   ┌─────────┐ │
│  │APIClient │◄───┤ Repository │◄──┤DataSource│ │
│  │(Network) │    │ (Protocol) │   │ (Impl)   │ │
│  └──────────┘    └────────────┘   └─────────┘ │
└─────────────────────────────────────────────────┘
```

**Flow**: View → Presenter → UseCase → Repository → DataSource → APIClient

### `new-version` Branch - MVVM + Clean Architecture (SwiftUI)

```
┌─────────────────────────────────────────────────┐
│                  Presentation                   │
│  ┌──────────────┐         ┌───────────────┐    │
│  │     View     │◄────────┤  ViewModel    │    │
│  │  (SwiftUI)   │ @Published │   (MVVM)      │    │
│  └──────────────┘         └───────┬───────┘    │
└─────────────────────────────────┼──────────────┘
                                  │
┌─────────────────────────────────┼──────────────┐
│                      Domain                     │
│            ┌─────────────────────▼────────┐    │
│            │      Use Cases (async)       │    │
│            │  - GetCharacters             │    │
│            │  - SearchCharacters          │    │
│            └─────────────┬────────────────┘    │
└─────────────────────────┼──────────────────────┘
                          │
┌─────────────────────────┼──────────────────────┐
│                       Data                      │
│  ┌──────────┐    ┌─────▼──────┐   ┌─────────┐ │
│  │APIClient │◄───┤ Repository │◄──┤DataSource│ │
│  │(async/   │    │(async throw)│   │  (async) │ │
│  │ await)   │    └────────────┘   └─────────┘ │
│  └──────────┘                                  │
└─────────────────────────────────────────────────┘
```

**Flow**: View → ViewModel → UseCase → Repository → DataSource → APIClient

---

## Key Technical Decisions

### Architecture Choices

**`main` - MVP**:
This architecture was chosen because it fits UIKit well, separating the UI (ViewController) from the presentation logic in the Presenter. This separation allows the legacy codebase to stay organized without a full rewrite. The Presenter acts as a mediator between the View and the UseCases, ensuring that the UI does not directly depend on the data layer, which keeps responsibilities clear and maintainable.

**`new-version` - MVVM**:
This architecture was used as it aligns naturally with SwiftUI’s declarative and reactive approach. The ViewModel handles both state and business logic, keeping the views simple and purely declarative. This approach reduces boilerplate compared to MVP, facilitates testing, and makes the data flow more predictable and easier to scale as the application grows.

### Why SwiftUI Detail in `main` Branch?

I specifically chose to implement the detail view in SwiftUI within the UIKit-based `main` branch to demonstrate:

1. **Practical Migration Skills**: Gradual migration from UIKit to SwiftUI is common in real projects.
2. **Hybrid Integration**: Shows understanding of `UIHostingController` and bridging between frameworks.
3. **Wallapop Relevance**: Given Wallapop's established codebase, demonstrates ability to integrate modern UI patterns into an existing codebase.
