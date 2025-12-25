# MySivi Assignment Checklist

**Started:** 25/12/2025  
**Deadline:** 27/12/2025
**Current Status:** 🟡 In Progress - Users List UI Complete using Dummy Data

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
- [x] sizer (^2.0.15) - Responsive design
- [x] dio (^5.9.0) - HTTP client
- [x] package_info_plus (^9.0.0) - App metadata
- [ ] flutter_bloc - State management
- [ ] dio - HTTP client
- [ ] hive_ce - Local storage

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
- [x] Scrollable users list (mock data)
- [x] Each user shows: Avatar (gradient) + Name
- [x] FAB (+) button - only on Users tab
- [ ] Add user dialog/bottomsheet (functional)
- [ ] Show "User added: [Name]" snackbar
- [ ] Store users locally with Hive
- [x] Preserve scroll position on tab switch
- [ ] Commit changes

---

## HOME SCREEN - CHAT HISTORY TAB
- [x] List of chat sessions (mock data)
- [x] Each item: Avatar, Name, Last message, Timestamp
- [x] Unread message badges
- [ ] Tap chat → Navigate to Chat Screen
- [x] Preserve scroll position on tab switch
- [x] No FAB on this tab
- [x] AppBar always visible (no hide on scroll)
- [ ] Commit changes

---

## CHAT SCREEN
- [ ] AppBar with user name
- [ ] **Sender messages** (right side):
  - [ ] Blue bubble
  - [ ] Avatar initial
  - [ ] Send from bottom input
- [ ] **Receiver messages** (left side):
  - [ ] Gray bubble
  - [ ] Avatar initial
  - [ ] Fetch from API
- [ ] Bottom text field + send button
- [ ] Save messages locally
- [ ] Update chat history after messages sent
- [ ] Commit changes

---

## ERROR HANDLING
- [ ] Handle empty states (no users, no chats)
- [ ] Handle API failures with retry
- [ ] Handle network errors
- [ ] Show loading indicators
- [ ] User-friendly error messages

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