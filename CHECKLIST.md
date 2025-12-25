# MySivi Assignment Checklist

**Started:** 25/12/2025  
**Deadline:** 27/12/2025
**Current Phase**: 🟢 Chat Screen Complete with API Integration

---

## SETUP
- [x] Create Flutter project
- [x] Setup Git repo + first commit
- [x] Add project documentation (README, CHANGELOG, CHECKLIST)
- [x] Review UI/UX reference materials
- [x] Choose API: yet to be decided

---

## DEPENDENCIES
- [x] go_router (^17.0.1) - Navigation
- [x] sizer (^3.1.3) - Responsive design
- [x] dio (^5.9.0) - HTTP client
- [x] package_info_plus (^9.0.0) - App metadata
- [x] flutter_bloc (^8.1.6) - State management
- [x] equatable (^2.0.5) - Value equality
- [x] hive_ce (^2.16.0) - Local storage
- [x] uuid (^4.5.1) - Unique IDs
- [x] intl (^0.19.0) - Date formatting
- [x] path_provider (^2.1.4) - App directories
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

## BONUS FEATURES (Optional)
- [ ] Long press word → Show definition bottomsheet
- [ ] Use dictionary API

---

## TESTING (Bonus Points)
- [ ] Unit tests for services
- [ ] Widget tests for key screens
- [ ] Integration tests for user flows

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
- [ ] Clean code review
- [ ] Multiple commits with good messages
- [ ] Push to GitHub
- [ ] Build release APK
- [ ] Record demo video
- [ ] Upload APK + video to Google Drive
- [ ] Email to hiring@mysivi.ai & yash@mysivi.ai (Reply All)
- [ ] Include GitHub link + Drive link

---

## NOTES & DECISIONS

### Tech Stack
- **Navigation**: go_router ^17.0.1
- **State Management**: ValueListenable + ScrollController
- **Responsive Design**: sizer ^2.0.15 + custom AppConfig
- **Storage**: Hive (to be implemented)
- **API**: yet to be decided
- **HTTP Client**: dio ^5.9.0
- **App Info**: package_info_plus ^9.0.0

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

### Issues Faced
- `SliverAppBar` with `snap: true` and `floating: true` scrolls as part of the page content, whereas we needed it to stay fixed and animate in/out smoothly with ease-in-out transitions based on scroll direction, only on the Users tab.
- AppBar translucent background - Fixed with surfaceTintColor: Colors.transparent
- Scroll detection on wrong tab - Fixed with conditional logic
- Theme consistency - Resolved by using colorScheme throughout

### Features Implemented Beyond Requirements
- ValueListenable for efficient state management
- Proper error handling page
- AppConfig with theme-aware responsive sizing
- Network layer with DioErrorHandler
- App metadata in API headers
- Material Design 3 theme colors throughout
- VS Code launch configurations