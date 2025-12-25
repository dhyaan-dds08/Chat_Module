# Mini Chat Application

A Flutter-based mini chat application built as part of the MySivi AI Flutter Developer assignment.

## Project Overview

This is a chat application with the following features:
- **Users List**: Add and manage users with avatar initials
- **Chat History**: View previous chat sessions
- **Chat Screen**: Send messages and receive responses from API
- **Custom UI**: AppBar with tab switcher, floating action buttons, and message bubbles

## Development Progress

- **Current Phase**: 🟡 Users List Implementation
- Track the implementation progress in [CHECKLIST.md](CHECKLIST.md)
- View detailed change history in [CHANGELOG.md](CHANGELOG.md)

## Architecture

This project follows a simple, scalable folder structure optimized for the project scope:
- `lib/core/` - Core functionality (routes, config, constants)
- `lib/screens/` - All application screens

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

Alternative Considered: Traditional Navigator 2.0 was rejected due to verbose API and lack of declarative structure.

#### State Management
**ValueListenable** ✅
- Efficient state updates with minimal rebuilds
- Perfect for simple state like tab switching
- Will integrate with Bloc for complex features

### To Be Implemented

- **State Management**: flutter_bloc - For complex state (users, chats, messages)
- **Responsive Design**: sizer - Percentage-based responsive sizing
- **HTTP Client**: dio - API calls for receiver messages
- **Local Storage**: hive_ce and SharedPreferences - Persistent data storage
- **Code Generation**: build_runner, json_serializable

## Current Features

### ✅ Completed
- Bottom navigation with 3 tabs (Home, Offers, Settings)
- Tab state preservation using ValueListenable
- Material Design 3 theming
- Error handling for unknown routes
- Centralized routing configuration

### 🚧 In Progress
- Users List screen with custom AppBar
- Chat History view

### 📋 Planned
- Add users with FAB
- Chat screen with sender/receiver messages
- API integration for receiver messages
- Local data persistence
- Scroll position preservation

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
- 🚧 **v0.2.0** - Users List (in progress)
- 📋 **v0.3.0** - Chat History
- 📋 **v0.4.0** - Chat Screen
- 📋 **v1.0.0** - Final submission