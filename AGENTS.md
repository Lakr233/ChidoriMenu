# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ChidoriMenu is a Swift package providing a drop-in replacement for UIMenu & UIAction with enhanced features including nested menu support, dark mode compatibility, and iOS version backward compatibility.

## Build and Development

### Swift Package Manager
```bash
# Build the package
swift build

# Test the package
swift test

# Generate Xcode project
swift package generate-xcodeproj
```

### Xcode Development
- Open `Example/ChidoriMenuExample.xcworkspace` for example app development
- The main package is located in `Sources/ChidoriMenu/`
- Platform support: iOS 13.0+, macCatalyst 13.0+

### IMPORTANT MUST USE: Xcode Build Commands for Verify Code Changes

You should not use `swift build` or `swift test` to verify code changes. Instead, always use `xcodebuild` commands to ensure compatibility with Xcode's build system and the example app. 

**ALWAYS pipe the output to `xcbeautify` for readable logs.**

```bash
# Build with xcodebuild for xcworkspace (preferred)
xcodebuild -workspace Example/ChidoriMenuExample.xcworkspace -scheme ChidoriMenuExample -destination 'platform=iOS Simulator,name=iPhone Air' build | xcbeautify

# Build with xcodebuild for xcodeproj
xcodebuild -project Example/ChidoriMenuExample.xcodeproj -scheme ChidoriMenuExample -destination 'platform=iOS Simulator,name=iPhone Air' build | xcbeautify

# Clean build
xcodebuild -workspace Example/ChidoriMenuExample.xcworkspace -scheme ChidoriMenuExample clean | xcbeautify
```

## Architecture

### Core Components
- **ChidoriMenu**: Main view controller presenting custom menus
- **ChidoriAnimationController**: Handles custom presentation/dismissal animations
- **ChidoriPresentationController**: Manages presentation context
- **TableView**: Custom table view for menu display

### Extension System
- **Present+UIView.swift**: `UIView.present(menu:anchorPoint:)` extension
- **Present+UIButton.swift**: `UIButton.presentMenu()` convenience method
- **UIView.swift**: `parentViewController` helper extension

### Backward Compatibility
- **DeferredMenu**: Backport of `UIDeferredMenuElement` for iOS 14+
- **ChidoriMenuMagic**: Objective-C runtime hooks for iOS 26+ compatibility

### Data Structure
- **DataSourceContents**: Typealias for menu section data `[(section: MenuSection, contents: [MenuContent])]`
- **MenuContent**: Enum representing `.action(UIAction)` or `.submenu(UIMenu)`
- **MenuSection**: Section container with title

## Key Implementation Patterns

### Menu Presentation
- Uses custom modal presentation with `UIViewControllerTransitioningDelegate`
- Supports both programmatic presentation and button integration
- Handles nested menus with stack scaling animation

### UIMenuElement Attributes Support
- **`.destructive`**: Red text color for destructive actions
- **`.disabled`**: Dimmed appearance and prevents selection/execution
- **`.keepsMenuPresented`**: Action executes without dismissing menu (iOS 16+)
- Uses helper properties (`chidoriIsDisabled`, `chidoriKeepsMenuPresented`) for safe attribute access
- Proper iOS version checking for newer attributes

### Layout and Styling
- **Icon Alignment**: Icons are vertically centered within menu items
- **Multi-line Labels**: Supports multi-line text with proper vertical centering
- **Dynamic Width**: Uses `min(max(menu item width) + 32, available width - 64)` formula for optimal sizing
- **Responsive Design**: Adapts to screen size with appropriate padding

### Runtime Compatibility
- Uses Objective-C runtime to handle iOS 26+ API changes in `UIDeferredMenuElement`
- Dynamically adds missing `elementProvider` property when needed
- Maintains transparent backward compatibility

### Configuration
- `ChidoriMenuConfiguration` provides global styling options:
  - `accentColor`: Menu highlight color
  - `backgroundColor`: Menu background color
  - `hapticFeedback`: Optional haptic feedback style
  - `suggestedWidth`: Optional custom width override

## Testing

### Example App
- Located in `Example/ChidoriMenuExample/`
- Demonstrates various menu configurations:
  - Basic menu sets
  - Nested menus
  - Long menu lists
  - UIDeferredMenuElement usage
  - Production-style menu examples

### Test Patterns
- Menu presentation from table view cells
- Button integration with context menus
- Programmatic menu presentation
- Nested menu navigation
- UIMenuElement attributes testing (disabled, destructive, keepsMenuPresented)

## File Organization

```
Sources/
├── ChidoriMenu/
│   ├── ChidoriMenu.swift                 # Main menu controller
│   ├── ChidoriMenu+*.swift              # Extensions (DataSource, Cell, etc.)
│   ├── Extension/                       # UIView/UIButton extensions
│   ├── Supplement/                      # Animation and presentation controllers
│   └── Backport/                        # Backward compatibility utilities
└── ChidoriMenuMagic/                    # Runtime compatibility hooks
```

## Important Notes

- Supports both iOS and macCatalyst platforms
- Maintains MIT license from original ChidoriMenu project
- Uses 4-space indentation and modern Swift conventions
- Implements custom table view for menu rendering with proper accessibility support
- Full UIMenuElement attributes support including `.disabled` and `.keepsMenuPresented`
- Backward compatible attribute handling with iOS version checks

# Swift Code Style Guidelines

## Core Style
- **Indentation**: 4 spaces
- **Braces**: Opening brace on same line
- **Spacing**: Single space around operators and commas
- **Naming**: PascalCase for types, camelCase for properties/methods

## File Organization
- Logical directory grouping
- PascalCase files for types, `+` for extensions
- Modular design with extensions

## Modern Swift Features
- **@Observable macro**: Replace `ObservableObject`/`@Published`
- **Swift concurrency**: `async/await`, `Task`, `actor`, `@MainActor`
- **Result builders**: Declarative APIs
- **Property wrappers**: Use line breaks for long declarations
- **Opaque types**: `some` for protocol returns

## Code Structure
- Early returns to reduce nesting
- Guard statements for optional unwrapping
- Single responsibility per type/extension
- Value types over reference types

## Error Handling
- `Result` enum for typed errors
- `throws`/`try` for propagation
- Optional chaining with `guard let`/`if let`
- Typed error definitions

## Architecture
- Avoid using protocol-oriented design unless necessary
- Dependency injection over singletons
- Composition over inheritance
- Factory/Repository patterns

## Debug Assertions
- Use `assert()` for development-time invariant checking
- Use `assertionFailure()` for unreachable code paths
- Assertions removed in release builds for performance
- Precondition checking with `precondition()` for fatal errors

## Memory Management
- `weak` references for cycles
- `unowned` when guaranteed non-nil
- Capture lists in closures
- `deinit` for cleanup
