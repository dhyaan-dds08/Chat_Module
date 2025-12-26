# MySivi Assignment Checklist

**Started:** 25/12/2025  
**Deadline:** 27/12/2025
**Submitted on** 26/12/2025
**Current Phase**: ✅ Core Features + Bonus Complete + Branding - Ready for Submission

---

## SETUP
- [x] Create Flutter project
- [x] Setup Git repo + first commit
- [x] Add project documentation (README, CHANGELOG, CHECKLIST)
- [x] Review UI/UX reference materials
- [x] Choose API: dummyjson

---

## DEPENDENCIES
- [x] go_router (^17.0.1) - Navigation
- [x] sizer (^3.1.3) - Responsive design
- [x] dio (^5.9.0) - HTTP client
- [x] package_info_plus (^9.0.0) - App metadata
- [x] flutter_bloc (^8.1.6) - State management
- [x] equatable (^2.0.7) - Value equality
- [x] hive_ce (^2.16.0) - Local storage
- [x] uuid (^4.5.1) - Unique IDs
- [x] intl (^0.19.0) - Date formatting
- [x] path_provider (^2.1.4) - App directories
- [x] flutter_svg (^2.2.3) - SVG rendering
- [x] flutter_native_splash (^2.4.7) - Native splash screens
---

## MAIN NAVIGATION
- [x] Bottom navigation with 3 tabs
- [x] ValueListenable for efficient state management
- [x] Home tab functional (basic structure)
- [x] Tab 2 & 3 placeholders
- [x] Commit changes

---

## HOME SCREEN - USERS LIST TAB
- [x] Custom AppBar with switcher (Users/Chat History)
- [x] AppBar hides on scroll down, shows on scroll up (Users tab only)
- [x] Scrollable users list (real data from Hive)
- [x] Each user shows: Avatar (gradient) + Name + Online Status
- [x] FAB (+) button - only on Users tab
- [x] Add user dialog/bottomsheet (functional)
- [x] Show "User added: [Name]" snackbar
- [x] Store users locally with Hive
- [x] Preserve scroll position on tab switch
- [x] Empty state when no users
- [x] Commit changes (v0.3.0)

---

## HOME SCREEN - CHAT HISTORY TAB
- [x] List of chat sessions (real data from Hive)
- [x] Each item: Avatar, Name, Last message, Timestamp
- [x] Unread message badges (random 0-5)
- [x] Tap chat → Navigate to Chat Screen
- [x] Preserve scroll position on tab switch
- [x] No FAB on this tab
- [x] AppBar always visible (no hide on scroll)
- [x] Shows only users with messages
- [x] Sorted by most recent message
- [x] Empty state when no chats
- [x] Commit changes (v0.3.0)

---

## CHAT SCREEN
- [x] AppBar with user name and online status
- [x] Back button navigation
- [x] **Sender messages** (right side):
  - [x] Blue bubble (colorScheme.primary)
  - [x] Avatar initial
  - [x] Send from bottom input
  - [x] Timestamps with AM/PM
- [x] **Receiver messages** (left side):
  - [x] Gray bubble (surfaceContainerHighest)
  - [x] Avatar initial
  - [x] Fetch from Quotable API
  - [x] Auto-reply after sending message
- [x] Bottom text field + send button
- [x] Multi-line expanding TextField
- [x] Save messages locally with Hive
- [x] Update lastOnline timestamp
- [x] Empty state: "No messages yet"
- [x] Loading state while fetching messages
- [x] Error handling with DioException
- [x] Auto-scroll to bottom on new messages
- [x] Timestamps auto-update every 30 seconds
- [x] Bloc state management
- [x] Commit changes (v0.4.0)

---

## ERROR HANDLING
- [x] Handle empty states (no users, no chats, no messages)
- [x] Handle API failures with fallback messages
- [x] Handle network errors with DioErrorHandler
- [x] Show loading indicators (CircularProgressIndicator)
- [x] User-friendly error messages
- [x] Production-safe logging (developer.log)
- [x] User validation (redirect if not found)

---

## BONUS FEATURES
- [x] Long press word → Show definition bottomsheet
- [x] Use dictionary API (dictionaryapi.dev)
- [x] Show word, phonetic, definitions, examples, synonyms, antonyms
- [x] Beautiful UI with loading and error states
- [x] Input validation and retry functionality
- [x] Commit changes (v0.5.0)

---

## BRANDING & VISUAL IDENTITY
- [x] **Native Splash Screen**
  - [x] Implemented with flutter_native_splash package
  - [x] Brand color background (#005acf)
  - [x] Custom splash logo (1024×1024 standard, 1152×1152 Android 12+)
  - [x] Full-screen mode (hides status bar)
  - [x] Platform support: Android (including 12+), iOS, Web
  - [x] Proper image scaling (scaleAspectFit for iOS, center for Android)
  - [x] Android 12+ adaptive icon background

- [x] **App Icon**
  - [x] Custom app icon designed (1024×1024)
  - [x] Generated all sizes manually using online tool
  - [x] Android: All densities (mdpi to xxxhdpi)
  - [x] Android 8.0+: Adaptive icon with brand color background
  - [x] iOS: All required sizes (AppIcon.appiconset)
  - [x] Web: Favicon and manifest icons
  - [x] Consistent with UI design language

- [x] **UI Icons**
  - [x] Custom home icon SVG in bottom navigation
  - [x] Selected state: Brand primary color (#005acf)
  - [x] Unselected state: Grey tint
  - [x] Smooth color transitions
  - [x] Proper SVG rendering with ColorFilter
  - [x] Commit changes (v0.6.0)

---

## Testing Checklist

### Unit Tests
- [x] Model Tests
  - [x] UserModel (JSON, initial, lastSeenText)
  - [x] MessageModel (creation, IDs, serialization)
  - [x] QuoteModel (API response parsing)
  - [x] DictionaryModel (full structure)
  - [x] ChatHistoryItem (nullable handling)

- [x] Service Tests  
  - [x] UserService CRUD operations
  - [x] MessageService CRUD operations
  - [x] DictionaryService validation logic

- [x] BLoC Tests
  - [x] ChatBloc initial state
  - [x] LoadChatMessages event
  - [x] SendMessage event (with API)
  - [x] ReceiveMessage event
  - [x] State transitions
  - [x] Multiple event sequences

- [x] Widget Tests
  - [x] HomeScreen rendering
  - [x] FAB visibility
  - [x] Tab navigation

### Integration Tests
- [x] Dictionary API Integration
  - [x] Valid word lookup
  - [x] Invalid word handling
  - [x] Input validation
  - [x] Synonyms/antonyms extraction

- [x] Quote API Integration
  - [x] Random quote fetching
  - [x] Multiple calls

- [x] Full Flow Integration
  - [x] User → Message → API Reply workflow
  - [x] Quote → Word lookup workflow

- [x] Error Handling
  - [x] Malformed input
  - [x] Network failures

### Test Infrastructure
- [x] Unique Hive paths per test file
- [x] ApiClient reset mechanism
- [x] Clean test output (no verbose logging)
- [x] Real API calls in integration tests
- [x] Graceful package_info_plus handling

### Test Metrics
- [x] 74 total tests passing
- [x] ~19 second execution time
- [x] 100% pass rate
- [x] All critical paths covered

---

## UI POLISH
- [x] Match reference UI colors/design
- [x] Theme-based colors throughout
- [x] Responsive sizing with Sizer
- [x] AppConfig for consistent dimensions
- [x] Smooth animations
- [x] Proper spacing/padding
- [x] Test on real device

---

## SUBMISSION
- [x] Clean code review
- [x] Multiple commits with good messages ✅ (ongoing)
- [x] Push to GitHub with tags (ongoing)
- [x] Build release APK
- [x] Record demo video (show all features + bonus)
- [x] Upload APK + video to Google Drive
- [x] Email to hiring@mysivi.ai & yash@mysivi.ai (Reply All)
- [x] Include GitHub link + Drive link
---

## NOTES & DECISIONS

### Tech Stack

#### Core Framework
- **Flutter**: 3.38.5
- **Dart**: ^3.10.4

#### State Management
- **flutter_bloc**: ^8.1.6 - Bloc pattern with BlocProvider and reactive widgets
- **equatable**: ^2.0.7 - Value equality for Bloc states/events
- **ValueNotifier**: Built-in Flutter reactive state for simple cases

#### Navigation
- **go_router**: ^17.0.1 - Declarative routing with ShellRoute and path parameters

#### Local Storage
- **hive_ce**: ^2.16.0 - Fast NoSQL key-value database
- **hive_ce_flutter**: ^2.1.0 - Flutter integration for Hive
- **path_provider**: ^2.1.4 - Platform-specific directory paths

#### Networking
- **dio**: ^5.9.0 - HTTP client with interceptors and error handling
- **package_info_plus**: ^9.0.0 - App metadata (version, build number)

#### Code Generation
- **build_runner**: ^2.4.13 - Code generation tool
- **json_serializable**: ^6.9.4 - JSON serialization/deserialization

#### Utilities
- **uuid**: ^4.5.1 - RFC4122 UUID generation for unique IDs
- **intl**: ^0.19.0 - Date/time formatting and internationalization
- **sizer**: ^2.0.15 - Percentage-based responsive sizing
- **flutter_svg**: ^2.2.3 - SVG rendering for custom icons and graphics

#### Development Tools (dev_dependencies)
- **flutter_native_splash**: ^2.4.7 - Native splash screen generation for Android, iOS, and Web
  
#### APIs Used
- **Quotable API** (api.quotable.io) - Random quotes for receiver messages
- **Dictionary API** (dictionaryapi.dev) - Word definitions, synonyms, antonyms

#### Custom Architecture
- **AppConfig** - Theme-aware responsive sizing configuration
- **Result<T>** - Type-safe API response wrapper
- **SnackBarUtil** - Reusable UI feedback utilities
- **DioErrorHandler** - Centralized error handling for network calls

### Time Tracking
- Setup & Documentation: ~15 mins
- Navigation Setup: ~30 mins
- Network Layer (Dio + Error Handler): ~15 mins
- Responsive Design (AppConfig + Sizer): ~30 mins
- Users List UI: ~30 mins
- Chat History UI: ~30 mins
- Hive Setup & User Management: ~1 hours
- Message System & API Integration: ~1 hours
- Chat Screen UI & Bloc: ~1 hours
- Online Status & Auto-refresh: ~1 hour
- Word Lookup Feature (BONUS): ~1 hours
- Utilities & Error Handling: ~30 mins
- Testing Suite (78 tests - Unit, Integration, Widget): ~2 hours
- Native Splash Screen Setup & Configuration: ~30 mins
- App Icon Design & Generation: ~20 mins
- Custom UI Icons (SVG integration): ~15 mins
- Documentation Updates (README, CHANGELOG, CHECKLIST): ~30 mins
- Code Cleanup & Refactoring: ~20 mins

### Issues Faced
- `SliverAppBar` with `snap: true` and `floating: true` scrolls as part of the page content, whereas we needed it to stay fixed and animate in/out smoothly with ease-in-out transitions based on scroll direction, only on the Users tab.
- AppBar translucent background - Fixed with surfaceTintColor: Colors.transparent
- Scroll detection on wrong tab - Fixed with conditional logic
- Theme consistency - Resolved by using colorScheme throughout
- All HTTP requests returned 400 status code in integration tests due to Flutter test framework intercepting network calls
- Dictionary API and Quote API returning "No such word found" errors in release APK despite working in debug mode

### Features Implemented Beyond Requirements
- **Advanced Navigation**: go_router with type-safe declarative routing
- **State Management**: flutter_bloc for predictable state management
- **Fast Storage**: hive_ce for NoSQL local storage with zero-copy reads
- **Code Generation**: JSON serializable models with build_runner
- **Efficient State**: ValueListenable for lightweight reactive updates
- **Error Handling**: Custom error page with 404 navigation
- **Responsive Design**: AppConfig with theme-aware sizing
- **Network Layer**: DioErrorHandler with detailed error messages
- **API Metadata**: Version, platform, build number in API headers
- **Material Design 3**: ColorScheme.fromSeed throughout
- **Developer Tools**: VS Code launch configurations (debug, profile, release)
- **Bonus Feature**: Word lookup with dictionary API
- **Type Safety**: Result<T> wrapper for error handling
- **UI Feedback**: SnackBarUtil for consistent user feedback
- **Retry Logic**: Comprehensive error messages with retry functionality
- **Lifecycle Management**: RouteObserver for state management
- **Auto-refresh**: Timer-based updates for timestamps and online status
- **Comprehensive Testing**: 74 tests covering unit, integration, and widgets
- **Professional Branding**: Native splash screen and custom app icon
- **Custom UI Icons**: SVG icons with smooth state transitions
- **Clean Code**: No unused dependencies, no compiler warnings