# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### To Be Implemented
- Hive local storage integration
- Add user functionality
- Chat screen with messages
- API integration for receiver messages
- Error handling and loading states

---

## [0.2.1] - 2024-12-25

### Added
- Navigation system using `go_router` with ShellRoute pattern
- Chat screen route with bottom navigation persistence
- Navigate to chat screen from Users List by tapping on user
- Route parameter handling for user ID
- Error page with "Go Home" button for 404 routes

### Changed
- MainScreen now wraps child routes for bottom nav integration
- Bottom nav remains visible when navigating to chat screen

### Technical
- Implemented ShellRoute to preserve bottom navigation across screens
- Added nested route structure: `/home/chat/:userId`
- Route configuration supports offers and settings placeholder screens

## [v0.2.0] - 2024-12-25

### Added
- **Responsive Design System**
  - sizer (^2.0.15) for percentage-based sizing
  - Custom AppConfig with theme-aware dimensions
  - Device width/height helpers (w%, h%)
  - Consistent spacing, padding, and component sizes
  
- **Network Layer**
  - dio (^5.9.0) for HTTP client
  - package_info_plus (^9.0.0) for app metadata
  - ApiClient singleton with app info headers
  - DioErrorHandler for centralized error handling
  - MessageApiService for API calls
  - Support for dummyjson.com/quotes/random API

- **Home Screen UI**
  - Custom tab switcher in AppBar (Users/Chat History)
  - Scroll-based AppBar hide/show (Users tab only)
  - Theme-based colors using Material Design 3 colorScheme
  - Gradient avatars (dark blue → purple → pink)
  
- **Users List Tab**
  - Scrollable list with 20 mock users
  - Gradient circular avatars with user initials
  - "Online" status subtitle
  - Chevron navigation indicator
  - Floating Action Button (Users tab only)
  - Scroll position preservation via PageStorageKey
  
- **Chat History Tab**
  - Scrollable list with 15 mock chat sessions
  - Avatar, name, last message, and timestamp
  - Unread message count badges (every 3rd item)
  - Time-ago format (hours, yesterday)
  - AppBar always visible (no scroll hiding)
  - Scroll position preservation

### Changed
- All hardcoded colors replaced with Theme.of(context).colorScheme
- All hardcoded sizes replaced with AppConfig responsive values
- AppBar background made non-translucent (surfaceTintColor: transparent)
- Tab button styling to match reference UI (white pill with shadow)

### Technical Details
- Using NestedScrollView approach initially, switched to Column + AnimatedContainer for better control
- ScrollController listener for scroll direction detection
- Conditional AppBar rendering based on selected tab
- ValueListenable for tab switching without full rebuilds

## [v0.1.0]

### Added
- go_router (^17.0.1) for declarative navigation with deep linking support
- Bottom navigation with 3 tabs (Home, Offers, Settings)
- Main screen with ValueListenable for efficient state management
- Home screen basic structure with Material Design 3
- Placeholder screens for Offers and Settings tabs
- Centralized routing configuration in app_router.dart
- Error handling page for unknown routes
- VS Code launch.json with debug, profile, and release configurations
- Simple folder structure: lib/core/routes/ and lib/screens/

### Changed
- Updated main.dart to use MaterialApp.router with GoRouter
- Modified pubspec.yaml with go_router dependency
- Updated README.md with detailed go_router explanation and tech stack

---
## [0.0.1] - 2024-12-25

### Added
- Initial commit with base Flutter project
- Default Flutter project structure and configuration files
- Git repository initialization
- README.md with project overview and tech stack
- CHECKLIST.md for tracking development progress
- CHANGELOG.md for documenting changes

### Changed
- Updated README from default Flutter template to project-specific documentation, project overview and tech stack.

---

**Format**: This changelog follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format.

**Categories**:
- **Added** - New features
- **Changed** - Changes in existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Security fixes