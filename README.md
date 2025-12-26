# Mini Chat Application

A Flutter-based mini chat application built as part of the MySivi AI Flutter Developer assignment.

## Project Overview

This is a chat application with the following features:
- **Users List**: Add and manage users with avatar initials
- **Chat History**: View previous chat sessions
- **Chat Screen**: Send messages and receive responses from API
- **Custom UI**: Smart AppBar (auto-hide/show), floating action buttons, and message bubbles
- **Auto-Refresh**: Timestamps, online status, and unread counts update every 30 seconds
- **Accessibility**: Full light/dark theme and text scaling support

## Development Progress

- **Current Phase**: Complete - Ready for Submission (v1.0.0)
- Track the implementation progress in [CHECKLIST.md](CHECKLIST.md)
- View detailed change history in [CHANGELOG.md](CHANGELOG.md)

## Architecture

## Architecture

This project follows a clean, feature-based architecture optimized for scalability:

- **`lib/core/`** - Core functionality and infrastructure
  - `config/` - App configuration (AppConfig for responsive sizing)
  - `constants/` - API URLs and app-wide constants
  - `dio/` - HTTP client setup and error handling
  - `routes/` - Navigation configuration with go_router
  - `services/` - Business logic services (User, Message, Dictionary)
  - `utils/` - Utility classes (Result, SnackBarUtil)

- **`lib/data/`** - Data layer
  - `models/` - JSON-serializable data models

- **`lib/features/`** - Feature modules
  - `chat/bloc/` - Chat feature with Bloc state management

- **`lib/screens/`** - Application screens (HomeScreen, ChatScreen, etc.)

- **`lib/widgets/`** - Reusable UI components (WordDefinitionSheet)

## Project Structure
```
assets/
├── home_icon.svg
lib/
├── core/                          # Core functionality and configuration
│   ├── config/
│   │   └── app_config.dart       # Responsive sizing and theme-aware config
│   ├── constants/
│   │   └── api_url.dart          # API endpoint constants
│   ├── dio/
│   │   ├── api_client.dart       # Dio singleton with headers
│   │   └── dio_error.dart        # DioException error handling
│   └── routes/
│       └── app_router.dart       # GoRouter configuration with ShellRoute + BlocProvider
│   ├── services/
│   │   ├── message_service.dart  # Message CRUD + API integration
│   │   └── user_service.dart     # User CRUD + chat history
│   │   └── dictionary_service.dart     # Word look up api integration
│   └── utils/
│       ├── result.dart                  # Result<T> wrapper for API responses
│       └── snackbar_util.dart           # Reusable snackbar utilities
│
├── data/
│   └── model/
│       ├── quote_model.dart      # Quote data model
│       ├── chat_history_item.dart    # ChatHistory view model
│       ├── dictionary_model.dart        # Dictionary API response model
│       ├── dictionary_model.g.dart      # Generated JSON
│       ├── message_model.dart        # Message with UUID
│       ├── message_model.g.dart      # Generated JSON
│       ├── quote_model.g.dart        # Generated JSON
│       ├── user_model.dart           # User with lastOnline
│       └── user_model.g.dart         # Generated JSON
│
├── features/
│   └── chat/
│       └── bloc/
│           ├── chat_bloc.dart        # Chat business logic
│           ├── chat_event.dart       # Chat events
│           └── chat_state.dart       # Chat states
│
├── screens/
│   ├── chat_screen.dart          # Chat UI with messages
│   ├── home_screen.dart          # Users List + Chat History
│   ├── main_screen.dart          # Bottom navigation
│   └── placeholder_screen.dart   # Offers/Settings
│
├── widgets/
│   └── word_definition_sheet.dart       # Dictionary lookup bottom sheet
│
└── main.dart  
test/
├── models/              # Unit tests for data models (5 files, ~25 tests)
├── services/            # Unit tests for business logic (3 files, ~22 tests)
├── bloc/                # BLoC state management tests (1 file, ~15 tests)
├── integration/         # API integration tests (1 file, ~10 tests)
└── widget_test.dart     # Widget/UI tests (~5 tests)                    # App entry point + Hive init
```

### Key Files

| File | Purpose |
|------|---------|
| `app_config.dart` | Centralized responsive sizing (AppConfig.avatarSize, config.w(), config.h()) |
| `app_router.dart` | GoRouter with ShellRoute, nested routes, and BlocProvider at route level |
| `api_client.dart` | Dio singleton with interceptors, headers, and initialization |
| `dio_error.dart` | DioException handling for Dio 5.x (all exception types) |
| `api_url.dart` | API endpoint constants (DummyJSON, Dictionary API) |
| `result.dart` | Generic Result<T> wrapper for type-safe API responses (success/error) |
| `snackbar_util.dart` | Reusable success snackbar utility with icons and styling |
| `user_service.dart` | User CRUD operations + chat history generation |
| `message_service.dart` | Message CRUD operations + API integration (fetchApiReply) |
| `dictionary_service.dart` | Word lookup API integration with Result wrapper and error handling |
| `user_model.dart` | User with UUID, lastOnline, computed isOnline property |
| `message_model.dart` | Message with UUID, timestamp, isSender flag |
| `quote_model.dart` | API response model for Quotable API |
| `dictionary_model.dart` | Full dictionary API response with phonetics, meanings, definitions |
| `chat_history_item.dart` | View model combining UserModel + MessageModel for chat list |
| `chat_bloc.dart` | Bloc managing chat state (send/receive messages) |
| `home_screen.dart` | Users List + Chat History tabs with RouteAware |
| `chat_screen.dart` | Chat UI with Bloc, message bubbles, auto-scroll |
| `word_definition_sheet.dart` | Dictionary bottom sheet with ValueNotifier state management |
| `main_screen.dart` | Bottom navigation wrapper (ShellRoute child) |
| `placeholder_screen.dart` | Simple placeholder for Offers and Settings tabs (shows tab name) |

## Tech Stack

### Framework
- **Flutter 3.38.5**: Cross-platform UI framework
- **Dart ^3.10.4**: Programming language

### Currently Implemented

#### Navigation
**go_router (^17.0.1)** ✅

Why go_router over traditional Navigator?

- **Declarative Routing**: URL-based routing built on Navigation 2.0 API - define all routes centrally instead of imperative Navigator.push() calls
- **Path Parameters**: Built-in template syntax for parsing path and query parameters (e.g., "user/:id")
- **Deep Linking**: Native deep linking support across Android, iOS, and web platforms with URL handling
- **Error Handling**: Centralized error routing for unknown or malformed URLs

Implementation:
- ShellRoute pattern for bottom navigation persistence
- Nested routes: `/home/chat/:userId` 
- Bottom nav visible across all screens
- Type-safe navigation with path parameters

Alternative Considered: Traditional Navigator 2.0 was rejected due to verbose API and lack of declarative structure.

#### State Management
**ValueListenable**
- Efficient state updates with minimal rebuilds
- Perfect for simple state like tab switching
- Will integrate with Bloc for complex features

**flutter_bloc (^8.1.6) + equatable (^2.0.7)** ✅

Why Bloc over other solutions?
- **Separation of concerns**: Business logic separated from UI
- **Testability**: Easy to test blocs independently
- **Predictable state**: Clear state transitions
- **BlocProvider**: Dependency injection at route level
- **BlocConsumer**: Combined builder + listener for side effects

Implementation:
- ChatBloc manages message sending/receiving
- Events: LoadChatMessages, SendMessage, ReceiveMessage
- States: ChatInitial, ChatLoading, ChatLoaded, ChatEmpty, ChatError
- Provided at route level in app_router.dart

#### Networking
**dio (^5.9.0)** ✅

Why dio over http package?

- **Interceptors**: Add request/response interceptors for logging, authentication, error handling
- **Timeout Configuration**: Granular control over connection, send, and receive timeouts
- **Better Error Handling**: Type-safe error handling with DioException
- **Form Data & File Upload**: Built-in support for multipart requests (future-ready)
- **Request Cancellation**: Cancel ongoing requests when needed
- **Debug Logging**: LogInterceptor for development debugging

Alternative Considered: http package was rejected due to lack of interceptor support and verbose error handling.

#### App Metadata
**package_info_plus (^9.0.0)** ✅

- Retrieves app name, version, build number, and package name at runtime
- Used to populate API request headers for better tracking and debugging
- Platform-specific information (Android/iOS/Web) for analytics
- Essential for version-specific API behavior and monitoring


#### Responsive Design
**sizer (^2.0.15) + Custom AppConfig** ✅

Why this approach?
- **Percentage-based sizing**: 1.h = 1% of screen height, 1.w = 1% of screen width
- **Theme-aware**: AppConfig provides access to TextTheme styles (bodySmall, titleMedium, etc.)
- **Device dimensions**: Helper methods for custom calculations (config.w(5), config.h(10))
- **Consistent spacing**: Predefined spacing values that scale across devices
- **Maintainable**: Change one value, updates everywhere

Features:
- All spacing, padding, and sizes defined in AppConfig
- Text styles use Theme.of(context).textTheme for accessibility
- Automatic text scaling based on user preferences
- Easy maintenance and consistent UI across screens

#### Local Storage
**hive_ce (^2.16.0) + JSON serialization** ✅

Why Hive over SharedPreferences or SQLite?
- **Fast**: NoSQL key-value store, faster than SQLite
- **Lightweight**: No native dependencies
- **Type-safe**: Works with json_serializable models
- **Simple API**: No complex queries needed
- **Cross-platform**: Works on all Flutter platforms

Implementation:
- Two boxes: 'users' (user data) and 'chats' (messages by userId)
- JSON serialization (no HiveObject/HiveField annotations)
- Initialized in main.dart before app starts
- Services layer (UserService, MessageService) for abstraction

#### Code Generation
**build_runner (^2.10.4) + json_serializable (^6.11.3)** ✅

- Generates JSON serialization code (*.g.dart files)
- Run: `flutter pub run build_runner build --delete-conflicting-outputs`
- Models: UserModel, MessageModel, QuoteModel

#### Development Tools (dev_dependencies)
**flutter_native_splash (^2.4.7)** ✅

Why flutter_native_splash?
- **Native Implementation**: Generates platform-native splash screens (not Flutter widgets)
- **Zero Delay**: Displays immediately on app launch before Flutter loads
- **Multi-Platform**: Automatic generation for Android, iOS, and Web
- **Android 12+ Support**: Handles new Splash Screen API automatically
- **Easy Configuration**: Single YAML configuration for all platforms

Features:
- Brand color background (#005acf)
- Custom logo with proper scaling
- Full-screen mode (hides status bar)
- Android 12+ adaptive icon background
- Platform-specific content modes (scaleAspectFit for iOS, center for Android)
- No distortion across different screen sizes

**flutter_launcher_icons (^0.14.1)** ✅

Why automated icon generation?
- **All Sizes**: Generates all required platform icon sizes automatically
- **Adaptive Icons**: Android 8.0+ adaptive icon support
- **Consistent**: Single source image for all platforms
- **Time-Saving**: Manual generation of 20+ icon sizes avoided

Features:
- 1024×1024 source icon
- Android adaptive icons with brand background
- iOS AppIcon set complete
- Web favicon and manifest icons
- All densities (mdpi to xxxhdpi)

#### Unique IDs
**uuid (^4.5.2)** ✅

- Generates RFC4122 UUIDs for users and messages
- v4 (random) UUIDs for global uniqueness
- Better than timestamps for distributed systems

#### Date Formatting
**intl (^0.19.0)** ✅

- Format timestamps: "2:30 PM", "Mon 2:30 PM", "Dec 25, 2:30 PM"
- 12-hour format with AM/PM
- Relative time: "Just now", "5 mins ago", "2 hours ago"

#### UI Components
**flutter_svg (^2.2.3)** ✅

Why flutter_svg?
- **Vector Graphics**: Scalable icons without quality loss
- **Small File Size**: SVG files are smaller than PNGs
- **Theme Integration**: Easy color customization with ColorFilter
- **Performance**: Efficient rendering on all screen sizes
- **Flexibility**: Can be styled dynamically based on state

Implementation:
- Custom home icon in bottom navigation
- Selected/unselected state colors
- ColorFilter.mode with BlendMode.srcIn for proper color application
- 24×24 logical pixel sizing

Alternative Considered: PNG icons were rejected due to scaling issues and larger file sizes.

## Current Features

### Completed (v0.6.0 - Branding & Visual Identity)

#### Native Splash Screen
- Professional native splash screen implementation
- Brand color background: #005acf
- Custom splash logo (1024×1024 standard, 1152×1152 Android 12+)
- Full-screen mode across all platforms
- Platform-specific optimizations:
  - Android: Center gravity, Android 12+ Splash Screen API
  - iOS: scaleAspectFit content mode
  - Web: CSS-based splash screen
- No distortion or cropping on any device
- Smooth transition to app launch
- Generated using flutter_native_splash package

#### Custom App Icon
- Professional app icon matching brand identity
- Generated for all platforms and densities:
  - Android: All densities (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
  - Android 8.0+: Adaptive icons with #005acf background
  - iOS: All required sizes (20pt to 1024pt) in AppIcon.appiconset
  - Web: Favicon (16×16, 32×32) and manifest icons (192×192, 512×512)
- Consistent visual identity across launcher and in-app
- 1024×1024 source image
- Manual generation using online tools

#### Custom UI Icons
- Custom SVG home icon in bottom navigation
- Smooth color transitions for state changes
- Selected state: Brand primary color (#005acf)
- Unselected state: Grey tint (Colors.grey.shade600)
- Proper SVG rendering with ColorFilter.mode and BlendMode.srcIn
- 24×24 logical pixel sizing
- Matches overall brand aesthetic

#### Documentation Updates
- Updated CHANGELOG.md with v0.6.0 features
- Updated README.md with branding section
- Updated CHECKLIST.md with branding tasks
- Added tech stack documentation for new packages

### Completed (v0.5.1 - Comprehensive Testing Suite)

#### Test Infrastructure
- **74 tests** with 100% pass rate
- Execution time: ~19 seconds
- No mocking - real integration testing approach
- Clean test output with disabled logging
- Unique Hive paths per test file to prevent conflicts

#### Unit Tests (~70 tests)
**Model Tests** (5 files, ~25 tests)
- UserModel: JSON serialization, initial generation, lastSeenText formatting
- MessageModel: Sent/received creation, unique IDs, JSON serialization
- QuoteModel: API response deserialization with required ID field
- DictionaryModel: Full response structure, phonetics, meanings, definitions
- ChatHistoryItem: Chat item creation with nullable lastMessage handling

**Service Tests** (3 files, ~22 tests)
- UserService: CRUD operations, getAllUsers sorting, updateLastOnline, copyWith
- MessageService: Send/receive messages, getMessagesForUser, getAllChatUserIds
- DictionaryService: Input validation (empty, invalid characters, spaces), helper methods

**BLoC Tests** (1 file, ~12 tests)
- ChatBloc: Initial state verification
- LoadChatMessages: Empty/loaded/error states, message persistence
- SendMessage: User message + API reply handling with real HTTP calls
- ReceiveMessage: Incoming message storage
- State transitions: userId preservation, loading→loaded flow
- Multiple event sequences: Complex workflows and state consistency

#### Integration Tests (~8 tests)
**Dictionary API Integration**
- Valid word lookup with real API calls (dictionaryapi.dev)
- Invalid word error handling
- Input validation (empty, spaces, special characters)
- Synonyms and antonyms extraction

**Quote API Integration**
- Random quote fetching (dummyjson.com)
- Multiple API calls to verify different quotes
- Error handling and fallback mechanisms

**Full Flow Integration**
- Complete user workflow: User creation → Message sending → API reply
- Word lookup flow: Quote fetch → Word extraction → Dictionary lookup
- Real API integration without mocks

#### Widget Tests (~5 tests)
- HomeScreen: Basic rendering, FAB visibility, tab navigation
- Component visibility based on tab state
- Sizer initialization for responsive design

#### Testing Approach
- **Integration-First**: Real Hive storage, real API calls
- **No Mocking**: Tests use actual services and APIs for better confidence
- **Isolated**: Each test file uses unique Hive paths
- **Clean Output**: ApiClient._isInTestMode() disables verbose logging
- **Fast Execution**: Despite real API calls, completes in ~19 seconds
- **Type-Safe**: Proper error handling and state verification

#### Test Configuration
- Removed TestWidgetsFlutterBinding from API tests (blocks HTTP)
- ApiClient.reset() for test isolation
- Graceful package_info_plus handling in test environment
- Increased wait times for API-dependent tests (3 seconds)
- All API integration tests removed mockito/mocktail dependencies
  
### Completed (v0.5.0 - BONUS)

#### Word Lookup Feature (BONUS)
- SelectableText in message bubbles
- Context menu with "Look up" option
- Dictionary API integration (dictionaryapi.dev)
- Beautiful bottom sheet with:
  - Word, phonetic pronunciation
  - Part of speech tags
  - Multiple definitions (up to 3)
  - Example sentences
  - Synonyms and antonyms (up to 5 each)
  - Loading and error states
  - Retry functionality
- Input validation (letters only)
- Specific error messages
- Result wrapper for type-safe error handling

#### Utility Classes
- SnackBarUtil for consistent success/error messages
- Result<T> wrapper for API responses
- Reusable UI components

### Core UI/UX Enhancements (v0.4.0+)

#### Smart UI Behaviors
- **AppBar Auto-Hide**: AppBar hides when scrolling down in Users tab for more screen space
- **AppBar Auto-Show**: AppBar slides back in when scrolling up
- **Tab-Specific Behavior**: AppBar only hides on Users tab; stays fixed on Chat History
- **Scroll Memory**: Each tab remembers its scroll position when switching
- **Independent Scrolling**: Users tab and Chat History maintain separate scroll states

#### Auto-Refresh Features
- **Timestamp Updates**: All timestamps update every 30 seconds (auto-refresh timer)
  - "Just now" → "1m ago" → "5m ago" → "2h ago"
- **Online Status**: User online status updates every 30 seconds
  - "Online" if active within 5 minutes
  - "Last seen Xm ago" otherwise
- **Unread Counts**: Random unread badges (0-5) refresh every 30 seconds
  - Note: Simulated for demo purposes; would use real data in production

#### Bottom Navigation
- Type-safe navigation with GoRouter
- No splash/ripple effect on tab switches (BottomNavigationBarType.fixed)
- Persistent navigation state across screens
- Custom SVG home icon with state-based colors

### Completed (v0.4.0)

#### Navigation & Routing
- Type-safe routing with go_router and ShellRoute
- Persistent bottom navigation across screens
- Chat screen routing with user ID validation
- 404 error page with navigation
- RouteAware mixin for lifecycle awareness

#### User Management (v0.3.0)
- Add users with dialog and validation
- Users stored in Hive with UUID
- Real-time online status (last seen < 5 minutes)
- Last seen text: "Online", "Last seen 5m ago"
- Gradient circular avatars
- Empty state when no users
- Auto-refresh every 30 seconds

#### Chat History (v0.3.0)
- Shows only users with messages
- Real last message preview
- Sorted by most recent message
- Random unread count badges (0-2) that refresh every 30 seconds
- Note: Unread counts are simulated with random values (0-2) and automatically 
  refresh with the 30-second auto-refresh timer
- Timestamps with relative formatting
- Empty state when no chats
- Navigate to chat with state refresh

#### Chat Screen (v0.4.0)
- Bloc state management (ChatBloc)
- Sender messages (right, blue bubbles)
- Receiver messages (left, grey bubbles)
- Auto-reply from Quotable API
- Message timestamps with auto-update (30s timer)
- 12-hour time format with AM/PM
- Multi-line expanding text input
- Empty state: "No messages yet"
- Loading state with spinner
- Error handling with fallback messages
- Auto-scroll to bottom
- Updates lastOnline on open
- Messages persist in Hive

#### Theme System
- ColorScheme.fromSeed (seed: 0xff005acf)
- Automatic light/dark theme generation
- Consistent colors throughout app
- Bottom nav with filled icons when selected


#### Responsive Design
- Percentage-based sizing with sizer
- AppConfig for all dimensions
- Theme-aware text styles
- Smooth animations (200ms transitions)
- Custom scroll behavior

#### AppBar Behavior & Interactions
- Custom AppBar scroll behavior (hide on scroll down, show on scroll up)
- Implemented only on Users tab; Chat History keeps AppBar fixed
- Smooth animations with AnimationController (200ms ease-in-out)
- Scroll position preservation when switching between tabs
- Each tab maintains independent scroll state using PageStorageKey
- Bottom navigation without splash/ripple effect (type: BottomNavigationBarType.fixed)

#### Accessibility & Theming
- **Light/Dark Theme Support**
  - Automatic system theme detection
  - Material Design 3 with ColorScheme.fromSeed
  - All colors use theme (no hardcoded colors)
  - Seamless switching between light and dark modes
  
- **Text Scaling**
  - Full accessibility support for system text size settings
  - All text uses Theme.textTheme styles
  - Scales from 0.5x to 2.0x based on user preferences
  - Maintains readability across all scaling levels

- **Offline Support**
  - Messages and users persist in Hive local storage
  - App fully functional without internet (except API features)
  - Graceful degradation when network unavailable
  - Data syncs automatically when connection restored


## Getting Started
```bash
# Clone the repository
git clone https://github.com/dhyaan-dds08/Chat_Module.git

# Navigate to project directory
cd Chat_Module

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Testing 🧪

This project includes a comprehensive test suite with **74 tests** covering all critical paths.

### Test Structure
```
test/
├── models/              # Unit tests for data models (5 files, ~25 tests)
├── services/            # Unit tests for business logic (3 files, ~22 tests)
├── bloc/                # BLoC state management tests (1 file, ~15 tests)
├── integration/         # API integration tests (1 file, ~10 tests)
└── widget_test.dart     # Widget/UI tests (~5 tests)
```

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test suites
flutter test test/models/           # Model tests only
flutter test test/services/         # Service tests only
flutter test test/bloc/             # BLoC tests only
flutter test test/integration/      # Integration tests only

```

### Test Coverage

**Unit Tests** (Fast - No Network)
- All 5 models tested (serialization, validation, edge cases)
- Service CRUD operations (Hive integration)
- BLoC state management (events, states, transitions)
- Input validation and helper methods

**Integration Tests** (Real APIs)
- Dictionary API (dictionaryapi.dev) - word lookup, validation
- Quote API (dummyjson.com) - random quotes, error handling
- Full user workflows - end-to-end testing

**Widget Tests**
- HomeScreen rendering and navigation
- Component visibility and interactions

### Test Results
```
Total Tests: 74
Pass Rate: 100%
Execution Time: ~19 seconds
```

### Key Testing Features

- **Real API Integration**: Tests make actual HTTP calls to verify API contracts
- **Clean Test Output**: Logging disabled in test mode for readability
- **Isolated Tests**: Each test file uses unique Hive storage paths
- **Comprehensive Coverage**: Unit, integration, and widget tests
- **Fast Execution**: Optimized test suite completes in under 20 seconds

### Testing Best Practices

This project follows Flutter testing best practices:
- Separate unit and integration tests
- Test-specific Hive paths to avoid conflicts
- Real API calls in integration tests (no mocks for API verification)
- BLoC tested independently of UI
- Clean, readable test organization

## Assignment Details

**Duration**: 48-72 hours  
**Status**: 🟢 Chat Screen Complete with API Integration
**Started**: December 25, 2024  
**Target Completion**: December 27, 2024  
**Submitted to**: MySivi AI

## Project Timeline

- ✅ **v0.0.1** - Project setup and documentation
- ✅ **v0.1.0** - Navigation system complete
- ✅ **v0.2.0** - Users List with dummy data
- ✅ **v0.2.1** - Navigation with go_router
- ✅ **v0.3.0** - Hive storage, real user/chat data, API setup
- ✅ **v0.4.0** - Chat screen with Bloc, messages, API integration
- ✅ **v0.5.0** - Word lookup feature (BONUS) + utilities
- ✅ **v0.5.1** - Unit, widget and Integration Tests
- ✅ **v0.6.0** - Native splash screen and app icon + UI enhancement wrt ui provided
- ✅ **v1.0.0** - Final Review and Submission