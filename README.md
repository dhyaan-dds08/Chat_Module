# Mini Chat Application

A Flutter-based mini chat application built as part of the MySivi AI Flutter Developer assignment.

## Project Overview

This is a chat application with the following features:
- **Users List**: Add and manage users with avatar initials
- **Chat History**: View previous chat sessions
- **Chat Screen**: Send messages and receive responses from API
- **Custom UI**: AppBar with tab switcher, floating action buttons, and message bubbles

## Development Progress

- **Current Phase**: 🟢 Navigation & Routing Complete
- Track the implementation progress in [CHECKLIST.md](CHECKLIST.md)
- View detailed change history in [CHANGELOG.md](CHANGELOG.md)

## Architecture

This project follows a simple, scalable folder structure optimized for the project scope:
- `lib/core/` - Core functionality (routes, config, constants)
- `lib/screens/` - All application screens

## Project Structure
```
lib/
├── core/                          # Core functionality and configuration
│   ├── config/
│   │   └── app_config.dart       # Responsive sizing and theme-aware config
│   ├── dio/
│   │   └── api_client.dart       # Dio HTTP client setup and interceptors
│   └── routes/
│       └── app_router.dart       # GoRouter configuration with ShellRoute
│
├── data/
│   └── model/
│       ├── quote_model.dart      # Quote data model
│       └── quote_model.g.dart    # Generated JSON serialization (auto-generated)
│
├── screens/                       # All application screens
│   ├── home_screen.dart          # Users List + Chat History tabs
│   ├── main_screen.dart          # Bottom navigation wrapper (ShellRoute)
│   └── placeholder_screen.dart   # Offers/Settings placeholder screens
│
└── main.dart                      # App entry point
```

### Key Files

| File | Purpose |
|------|---------|
| `app_config.dart` | Centralized responsive sizing (AppConfig.avatarSize, AppConfig.w(), AppConfig.h()) |
| `app_router.dart` | Navigation configuration with ShellRoute for persistent bottom nav |
| `api_client.dart` | Dio client with interceptors, headers, and error handling |
| `quote_model.dart` | JSON-serializable model for API responses |
| `home_screen.dart` | Custom AppBar with tab switcher, Users List, Chat History |
| `main_screen.dart` | Bottom navigation that persists across routes |

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

### To Be Implemented

- **State Management**: flutter_bloc - For complex state (users, chats, messages)
- **Local Storage**: hive_ce and SharedPreferences - Persistent data storage
- **Code Generation**: build_runner, json_serializable

## Current Features

### ✅ Completed
- **Navigation System**
  - Type-safe routing with go_router
  - ShellRoute with persistent bottom navigation
  - Chat screen routing with user ID parameters
  - 404 error page with "Go Home" button
  
- **Home Screen (v0.2.0)**
  - Custom tab switcher (Users List / Chat History)
  - Scroll-aware AppBar with smooth animations
  - Scroll position preservation per tab
  
- **Users List**
  - 20 mock users with gradient avatars
  - Online status indicators
  - Navigate to chat on tap
  - FAB for adding users (Users tab only)
  
- **Chat History**
  - Mock chat sessions with timestamps
  - Unread message badges
  - Last message preview

### 🚧 In Progress
- Users List screen with custom AppBar
- Chat History view
- Add users with FAB
- Chat screen UI with message bubbles
- API integration for receiver messages

### 📋 Planned

- Chat screen with sender/receiver messages
- API integration for receiver messages
- Local data persistence
- Word dictionary on long-press (bonus)


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
- ✅ **v0.2.1** - Navigation system with go_router
- 🚧 **v0.3.0** - Rendering local data from hive for user list and chat history, and attaching fab to create new user.
- 🚧 **v0.4.0** - Chat Screen UI (in progress)
- 📋 **v0.5.0** - API integration & message functionality
- 📋 **v1.0.0** - Final submission