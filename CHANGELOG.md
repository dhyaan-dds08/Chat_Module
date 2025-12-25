# Changelog

All notable changes to this project will be documented in this file.
## [Unreleased]

### To Be Implemented
- Word dictionary on long-press (bonus feature)
- Unit tests

## [0.4.0] - 2024-12-26

### Added
- **Chat Screen with Bloc State Management**
  - flutter_bloc (^8.1.6) for state management
  - equatable (^2.0.5) for value equality in states
  - ChatBloc with events (LoadChatMessages, SendMessage, ReceiveMessage, DeleteMessage)
  - ChatState (ChatInitial, ChatLoading, ChatLoaded, ChatEmpty, ChatError, MessageSending)
  
- **Message Features**
  - Sender messages (right-aligned, blue bubbles)
  - Receiver messages (left-aligned, grey bubbles)
  - Message timestamps with auto-update timer (30 seconds)
  - 12-hour time format with AM/PM
  - Multi-line text input with auto-expanding (max 30% screen height)
  - Send button with consistent sizing (AppConfig.buttonHeight)
  
- **API Integration**
  - Automatic API replies after sending message
  - ApiService.fetchRandomMessage() using Quotable API
  - 500ms delay for natural conversation feel
  - Fallback messages on API failure
  - DioException error handling with custom messages
  
- **User Activity Tracking**
  - lastOnline timestamp updates when chat opens
  - RouteAware mixin for refreshing home screen on return
  - Timer.periodic for auto-refreshing online status (30 seconds)
  - didPopNext() lifecycle method for state refresh

- **Empty States & Error Handling**
  - "No messages yet" empty state with icon
  - Error state with icon and message
  - Loading state with CircularProgressIndicator
  - User validation (redirects if user not found)

### Changed
- MessageService.sendMessage() now triggers API fetch automatically
- Chat screen receives BlocProvider from router (not internal)
- Scroll behavior improved with WidgetsBinding.addPostFrameCallback
- TextField expands vertically instead of scrolling horizontally

### Technical
- Bloc provided at route level in app_router.dart
- Automatic scroll to bottom on new messages
- developer.log for production-safe error logging
- Type-safe error handling (no dynamic types)

---

## [0.3.0] - 2024-12-26

### Added
- **Hive Local Storage**
  - hive_ce (^2.16.0) and hive_ce_flutter (^2.1.0)
  - path_provider (^2.1.4) for app documents directory
  - Two boxes: 'users' and 'chats'
  - JSON-serializable models (no HiveObject/HiveField needed)
  
- **User Management**
  - UserModel with UUID (uuid ^4.5.1), name, initial, lastOnline, createdAt
  - Computed property: isOnline (active within last 5 minutes)
  - lastSeenText: "Online", "Last seen 5m ago", "Last seen 2h ago"
  - UserService with CRUD operations (add, get, update, delete)
  - updateLastOnline() method for activity tracking
  - Add user dialog with TextField and validation
  - Users sorted by creation date (newest first)
  
- **Message System**
  - MessageModel with id (UUID), message, timestamp, isSender
  - MessageModel.createSentMessage() and createReceivedMessage() helpers
  - MessageService storing messages by userId (Map structure)
  - getMessagesForUser(), sendMessage(), receiveMessage()
  - fetchApiReply() for fetching random quotes
  - getAllChatUserIds() for chat history
  
- **Chat History**
  - ChatHistoryItem model combining UserModel + MessageModel
  - Real chat history showing only users with messages
  - Last message preview and timestamp
  - Random unread count (0-5) per chat
  - Sorted by most recent message
  - Empty state: "No chats yet"
  - Navigate to chat on tap with state refresh on return
  
- **API Integration Setup**
  - ApiClient singleton with Dio configuration
  - ApiClient.getApiClient() static method
  - Initialized in main.dart before runApp()
  - ApiUrl constants class for endpoints
  - QuoteModel for parsing API responses
  - DioErrorHandler for Dio 5.x (DioException, DioExceptionType)
  
- **Theme System**
  - ColorScheme.fromSeed() with seed color and primary color - 0xff005acf
  - Automatic light/dark theme generation
  - All hardcoded colors replaced with Theme.of(context).colorScheme
  - Bottom nav uses colorScheme.primary for selected items
  - Filled icons (activeIcon) when nav item selected

### Changed
- Users List now shows real data from Hive (not mock data)
- Chat History shows real users with actual last messages
- Online status is dynamic based on lastOnline timestamp
- FAB actually adds users to Hive with snackbar confirmation
- Empty states for both Users List and Chat History
- Timer.periodic (30s) auto-refreshes timestamps and online status
- HomeScreen uses RouteAware mixin for state refresh on navigation return

### Fixed
- AppBar scroll behavior: keeps space reserved (SizedBox) instead of AnimatedContainer height 0
- Scroll sensitivity improved (offset > 50px threshold)
- Online status updates when returning from chat screen

### Technical Details
- Hive boxes initialized in main.dart
- JSON serialization with build_runner
- No dynamic types anywhere (fully type-safe)
- RouteObserver added to MaterialApp for RouteAware mixin
- Proper disposal of timers and listeners

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