# MySivi Assignment Checklist

**Started:** 25/12/2025  
**Deadline:** 27/12/2025
**Current Status:** 🟡 In Progress - Navigation Complete

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
- [ ] sizer - Responsive design
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
- [ ] Custom AppBar with switcher (Users/Chat History)
- [ ] AppBar hides on scroll down, shows on scroll up
- [ ] Scrollable users list
- [ ] Each user shows: Avatar initial + Name
- [ ] FAB (+) button - only on Users tab
- [ ] Add user dialog/bottomsheet
- [ ] Show "User added: [Name]" snackbar
- [ ] Store users locally
- [ ] Preserve scroll position on tab switch
- [ ] Commit changes

---

## HOME SCREEN - CHAT HISTORY TAB
- [ ] List of chat sessions
- [ ] Each item: Avatar, Name, Last message, Timestamp
- [ ] Tap chat → Open Chat Screen
- [ ] Preserve scroll position on tab switch
- [ ] No FAB on this tab
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
- [ ] Match reference UI colors/design
- [ ] Smooth animations
- [ ] Proper spacing/padding
- [ ] Test on real device

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
- **State Management**: ValueListenable (simple), will add Bloc if needed
- **Storage**: Hive (fast, type-safe), sharedpreferences
- **API**: yet to be decided
- **HTTP Client**: dio

### Time Tracking
- Setup & Documentation: ~1 hour
- Navigation Setup: ~1 hour
- Users List: _____ hours
- Chat History: _____ hours
- Chat Screen: _____ hours
- Total Time: _____ hours

### Issues Faced
- None so far

### Features Implemented Beyond Requirements
- ValueListenable for efficient state management
- Proper error handling page
- VS Code launch configurations
