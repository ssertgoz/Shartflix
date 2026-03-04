# Shartflix — Movie App

A Flutter case study for the **Flutter Developer** technical assessment. Shartflix is a Netflix-style movie app with authentication, an infinite-scroll home feed (reels-style), profile with favorites and photo upload, and several bonus features (localization, custom theme, navigation service, Firebase, and more).

---

## Demo Video

The following demo shows the app flow: splash → login/register → home (reels) → profile → limited offer bottom sheet → settings (language switch, logout).


---

## Project Description

Shartflix implements the requested feature set and tech stack:

- **Clean Architecture** — Domain (entities, repository contracts, use cases), Data (datasources, models, repository implementations), and Presentation (pages, widgets, BLoC).
- **BLoC state management** — Feature logic lives in Blocs (Auth, Home, Profile, Photo Upload, Limited Offer, etc.); the UI reacts to state via `BlocBuilder` / `BlocListener`.
- **Secure authentication** — Login and register with validation; session token and user id stored with `flutter_secure_storage`; redirect to home after successful login.
- **Home (Discover)** — Vertical reels-style feed with infinite scroll (next page when near the end), 5 movies per page, full-screen initial loader and a floating “loading next page” indicator, pull-to-refresh, and instant UI updates when toggling favorites.
- **Profile** — User info and favorite movies grid from API; profile photo upload (dedicated page with skip/continue).
- **Navigation** — Bottom navigation bar (Home, Profile) with localized labels; shell state preserved when switching tabs; app-wide `NavigationService` for `go` / `push` / `pop`.
- **Required screens** — Login, Register, Home (Discover), Profile, and Limited Offer bottom sheet (opened from profile).

Bonus items implemented: custom dark theme and colors, Navigation Service, localization (Turkish & English, persisted), Logger Service, Firebase Crashlytics & Analytics (optional), Lottie and other animations, secure token handling, native splash screen and app icon.

---

## Requirements Checklist

### 1. Authentication

- [x] Login and register flows with form validation  
- [x] Session token stored securely (e.g. `flutter_secure_storage`)  
- [x] Automatic redirect to home after successful login  

### 2. Home (Discover)

- [x] Infinite scroll (vertical reels; load next page when approaching end)  
- [x] 5 movies per page (API-driven)  
- [x] Loading indicators: full-screen for first load, floating pill for “loading next page”  
- [x] Pull-to-refresh  
- [x] Instant UI update when toggling favorites (optimistic update, Blocs in sync)  

### 3. Profile

- [x] Display user information (name, email, photo)  
- [x] Favorite movies list (grid)  
- [x] Profile photo upload (separate screen with skip/continue)  

### 4. Navigation

- [x] Bottom navigation bar for switching between main sections  
- [x] Home state preserved when switching tabs (e.g. `StatefulShellRoute` / indexed stack)  

### 5. Code Structure

- [x] Clean Architecture (domain / data / presentation)  
- [x] BLoC for state management  
- [x] Consistent structure across features  

### Required Screens

| Screen            | Route / Access                          |
|-------------------|------------------------------------------|
| Login             | `/login`                                 |
| Register          | `/register`                              |
| Home (Discover)   | `/home` — reels-style vertical feed      |
| Profile           | `/profile`                               |
| Limited Offer     | Bottom sheet from profile (Limited Offer button) |

### Bonus Features

| Feature                 | Implementation summary                                      |
|-------------------------|-------------------------------------------------------------|
| Custom theme            | `AppTheme.darkTheme`, `AppColors`, gradients                |
| Navigation Service      | Centralized `go` / `push` / `pop` / `canPop`                |
| Localization            | Flutter l10n (ARB); Turkish & English; persisted in Settings |
| Logger Service          | `logger` used in services and blocs                          |
| Firebase                | Crashlytics & Analytics (optional if config not added)      |
| Animations              | Lottie (e.g. login), splash, limited offer / card UI       |
| Secure token management | `flutter_secure_storage`; cleared on logout                |
| Splash & app icon       | `flutter_native_splash`, `flutter_launcher_icons`           |

---

## Tech Stack

| Area           | Choice                                                                 |
|----------------|-----------------------------------------------------------------------|
| Architecture   | Clean Architecture (domain, data, presentation)                        |
| State          | flutter_bloc (Bloc, BlocProvider, BlocBuilder, BlocListener)          |
| Navigation     | go_router + custom NavigationService                                  |
| DI             | get_it                                                                |
| Auth storage   | flutter_secure_storage                                                |
| Localization   | Flutter l10n (ARB), LocaleNotifier + secure storage for persistence   |
| Networking     | Dio (ApiClient)                                                        |
| Functional use | dartz (`Either`, `Failure`)                                           |

---

## Project Structure (Flutter app in `shartflix/`)

```
shartflix/
├── lib/
│   ├── main.dart
│   ├── l10n/                     # Localization (ARB + generated)
│   ├── core/
│   │   ├── constants/            # Routes, assets, API
│   │   ├── di/                   # GetIt setup
│   │   ├── network/              # ApiClient, exceptions
│   │   ├── services/            # Router, NavigationService, SecureStorage,
│   │   │                         # LocaleNotifier, Logger, Firebase
│   │   ├── theme/                # AppColors, AppTheme
│   │   ├── utils/                # Failures
│   │   └── widgets/               # Shared UI (e.g. AuthBackground)
│   └── features/
│       ├── auth/                 # data, domain, presentation (login, register)
│       ├── home/                 # data, domain, presentation (reels, favorites)
│       ├── profile/              # data, domain, presentation (profile, favorites grid)
│       ├── photo_upload/         # bloc, pages
│       ├── limited_offer/        # bloc, pages, widgets (bottom sheet, cards)
│       ├── settings/             # language + logout
│       └── splash/               # splash page
├── assets/                       # images, icons, animations, fonts
├── video/                        # Demo recording
└── pubspec.yaml
```

---

## Getting Started

1. **Clone** the repository and open the project (Flutter app is inside `shartflix/`).
2. **Install dependencies:**
   ```bash
   cd shartflix && flutter pub get
   ```
3. **Run:**
   ```bash
   flutter run
   ```
4. **Optional:** Add your Firebase configuration (`google-services.json` and `GoogleService-Info.plist`) for Crashlytics and Analytics; the app runs without it.

Assets (images, icons, fonts, animations) are under `shartflix/assets/`. API base URL and endpoints are configured in `core/constants/api_constants.dart`.

---

*This project is for assessment purposes only and is not intended for production or commercial use.*
