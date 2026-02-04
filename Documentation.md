# Refactoring Log

This document describes the architectural improvements and bug fixes implemented after analyzing the codebase.

---

## Issues Identified

After analyzing the codebase, several architectural and implementation issues were identified:

### 1. Broken MVP Architecture

**Original Problems:**
- `ListHeroesAdapter` existed but wasn't properly integrated
- ViewController implemented `UITableViewDelegate` directly instead of delegating to the adapter
- Direct instantiation of presenter in `didSelectRowAt` creating disconnected instances
- Poor separation of concerns: Presenter had `screenTitle()` method returning UI strings

**Changes Made:**
- Moved `UITableViewDelegate` implementation to `ListHeroesAdapter`
- Implemented closure-based communication (`onHeroSelected`) from adapter to ViewController
- Presenter now manages navigation through protocol methods (`didSelectHero`)
- Removed `screenTitle()` from presenter; title now set directly in ViewController

### 2. Protocol Naming and Responsibility Issues

**Original Problems:**
- Generic protocol name `ListHeroesUI` didn't follow Swift conventions
- Protocol had minimal responsibilities (only `update(heroes:)`)
- No loading states or error handling in the view protocol

**Changes Made:**
- Renamed `ListHeroesUI` to `ListHeroesViewProtocol` (follows Swift naming conventions)
- Expanded protocol responsibilities:
  - `showLoading()` / `hideLoading()` for loading states
  - `showError(message:)` for error handling
  - `navigateToDetail(character:)` for navigation
  - `showHeroes(_:)` instead of generic `update(heroes:)`

### 3. Property Naming and Encapsulation
**Original Problems:**
- Public `listHeroesProvider` property exposed implementation details
- Generic name didn't reflect actual purpose
- Property was mutable from outside the class

**Changes Made:**
- Renamed `listHeroesProvider` to `adapter` (clearer purpose)
- Made property `private` to encapsulate implementation
- Adapter now only exposed through protocol methods

### 4. Unsafe Type Casting
**Original Problems:**
- Force unwrapping in computed property: `view as! ListHeroesView`
- No safety checks or error handling

**Changes Made:**
- Added `guard let` with `fatalError` for debugging
- Provides clearer error message if casting fails
- Makes potential issues visible during development


### 5. Auto Layout Conflicts

**Problem:**
- Table view cells had over-constrained layouts causing runtime warnings
- Hero image view height constraints conflicting with cell's automatic dimension calculations
- Cell view heroe image view height constraints conflicting with automatic dimension calculations
- No constants for reusable values (magic numbers in code)

**Changes Made:**
- Created `Constants` enum for values
- Implemented `heightForRowAt` delegate method to provide explicit row height
- Removed bottom anchor constraint from hero image view
- Added `centerYAnchor` constraint to hero image view for proper vertical positioning

### 6. Memory Leak Fixes
**Problem**:
- Strong reference cycle between presenter and view (bidirectional dependency)
- Closure in `getHeroes()` captured `self` strongly, potentially retaining presenter
- No `weak self` in use case completion handler

**Changes Made:**
- Added `weak` reference for view in presenter to prevent retain cycles
- Added `[weak self]` capture list in `loadHeroes()` completion handler

### 7. API Security and Architecture

**Problem:**
- API credentials (Marvel public/private keys) hardcoded directly in source code
- Sensitive keys exposed in version control history
- Security risk: anyone with repository access could see and misuse API keys
- No separation between configuration and business logic
- Authentication logic mixed with network request implementation
- No reusable pattern for making different API calls

**Changes Made:**
- Created `Config.xcconfig` file to store `MARVEL_PUBLIC_KEY` and `MARVEL_PRIVATE_KEY`
- Added `Config.xcconfig` to `.gitignore` to prevent credential exposure in Git
- `Info.plist` references `$(MARVEL_PUBLIC_KEY)` which gets replaced at build time
- Created `Config.swift` struct to access keys at runtime via `Bundle.main.object(forInfoDictionaryKey:)`
- Created generic `performRequest<T: Decodable>()` method to centralize network logic
- Separated endpoint logic: `getMarvelHeroes()` and `getHeroes()` as distinct methods

### 8. New Feature: Character Detail View

**Implementation:**
- Created `CharacterDetailViewController` to display detailed information about a selected character
- Implemented proper navigation flow from hero list to detail screen
- Integrated detail view into existing MVP architecture maintaining separation of concerns

