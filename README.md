# Mini Chat Application

A Flutter-based mini chat application built as part of the MySivi AI Flutter Developer assignment.

## Project Overview

This is a chat application with the following features:
- **Users List**: Add and manage users with avatar initials
- **Chat History**: View previous chat sessions
- **Chat Screen**: Send messages and receive responses from API
- **Custom UI**: AppBar with tab switcher, floating action buttons, and message bubbles

## Development Progress

- **Current Phase**: 🟢 Chat Screen Complete with API Integration
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
└── main.dart                      # App entry point + Hive init
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
**ValueListenable** ✅
- Efficient state updates with minimal rebuilds
- Perfect for simple state like tab switching
- Will integrate with Bloc for complex features

**flutter_bloc (^8.1.6) + equatable (^2.0.5)** ✅

Why Bloc over other solutions?
- **Separation of concerns**: Business logic separated from UI
- **Testability**: Easy to test blocs independently
- **Predictable state**: Clear state transitions
- **BlocProvider**: Dependency injection at route level
- **BlocConsumer**: Combined builder + listener for side effects

Implementation:
- ChatBloc manages message sending/receiving
- Events: LoadChatMessages, SendMessage, ReceiveMessage, DeleteMessage
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

#### Unique IDs
**uuid (^4.5.1)** ✅

- Generates RFC4122 UUIDs for users and messages
- v4 (random) UUIDs for global uniqueness
- Better than timestamps for distributed systems

#### Date Formatting
**intl (^0.19.0)** ✅

- Format timestamps: "2:30 PM", "Mon 2:30 PM", "Dec 25, 2:30 PM"
- 12-hour format with AM/PM
- Relative time: "Just now", "5 mins ago", "2 hours ago"

## Current Features
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
- Random unread count badges (0-5)
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

### 🚧 In Progress
- None - core features complete!
- Unit Tests


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

This project includes a comprehensive test suite with **78 tests** covering all critical paths.

### Test Structure
```
test/
├── models/              # Unit tests for data models (5 files, ~25 tests)
├── services/            # Unit tests for business logic (3 files, ~30 tests)
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
Total Tests: 78
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
**Status**: 🟡 In Progress - Phase 2: Users List Implementation  
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
- 📋 **v1.0.0** - Final polish and submission