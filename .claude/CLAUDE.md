# Claude Code Configuration for Flutter Ride-Sharing App

## Project Overview
This is a Flutter ride-sharing application with the following key features:
- User authentication (Google Sign In, Apple Sign In, Firebase Auth)
- Real-time ride booking and tracking
- Driver and passenger roles
- Google Maps integration
- Firebase services (messaging, crashlytics, remote config)
- Multi-language support (English, Khmer, Vietnamese)
- Local notifications

## Project Structure
```
lib/
├── main/                 # Main application features
│   ├── data/            # Data layer (models, repositories, API)
│   │   ├── api/         # API endpoints
│   │   ├── model/       # Data models
│   │   └── repository/  # Repository implementations
│   ├── ui/              # UI layer (pages, widgets, BLoCs)
│   │   ├── auth/        # Authentication pages
│   │   ├── book_vehicle/ # Ride booking flow
│   │   ├── driver/      # Driver interface
│   │   └── home/        # Home screen
│   └── utils/           # Utilities and services
├── config/              # Configuration files
├── generated/           # Generated files (l10n, etc.)
└── res/                # Resources (themes, assets)
```

## Key Technologies
- **Framework**: Flutter 3.10+
- **State Management**: BLoC
- **Navigation**: GoRouter
- **Maps**: Google Maps / MapLibre GL
- **Backend**: Firebase
- **Database**: SQLite with Drift
- **HTTP Client**: Dio
- **Localization**: flutter_localizations

## Development Environment
- **Flutter SDK**: 3.38.5 (via FVM)
- **Environment**: Configurable via dart-define (dev/staging/prod)

## Common Commands
```bash
# Run development build
flutter run -t lib/main.dart --dart-define=ENV=dev

# Run staging build
flutter run -t lib/main.dart --dart-define=ENV=staging

# Build APK for production
flutter build apk -t lib/main.dart --dart-define=ENV=prod --release

# Generate localization files
flutter gen-l10n

# Generate Drift database
dart run build_runner build --delete-conflicting-outputs

# Update splash screen
flutter pub run flutter_native_splash:create

# Update app icons
flutter pub run flutter_launcher_icons
```

## Architecture Patterns
- **Clean Architecture**: Separation of concerns with data, business logic, and presentation layers
- **Repository Pattern**: Abstract data access through repositories
- **BLoC Pattern**: State management using BLoC for complex UI interactions
- **Dependency Injection**: Manual dependency injection for services

## Firebase Configuration
- Firebase initialized in main.dart
- Background message handling configured
- Crashlytics integrated for error tracking
- Remote config for feature flags

## Memory Notes
- User is working on a ride-sharing app with Flutter
- Project uses BLoC for state management
- Has authentication, ride booking, and driver interfaces
- Uses Firebase for backend services
- Multi-language support included