# Habitly

A modern, offline-first habit tracking and daily life optimization app built with Flutter.

## Features

- ✅ Daily habit tracking with one-tap completion
- ⏱️ Built-in timers (Focus, Reading, Exercise)
- 📊 Dashboard with analytics and streaks
- 🔔 Smart notifications and reminders
- 💾 Export/Import for data backup
- 🎨 Material 3 design with light/dark themes
- 📱 100% offline - no account required



## Getting Started

### Prerequisites

This project is designed to be built using [Codemagic](https://codemagic.io/).

### Building with Codemagic

1. Push this repository to GitHub/GitLab/Bitbucket
2. Connect to Codemagic
3. Codemagic will automatically use `codemagic.yaml` configuration
4. Build will produce APK and AAB files

### Required Assets

Before building, add the following assets:

1. **Fonts**: Download from Google Fonts and add to `assets/fonts/`
   - [Outfit](https://fonts.google.com/specimen/Outfit) (Regular, Medium, SemiBold, Bold)
   - [Inter](https://fonts.google.com/specimen/Inter) (Regular, Medium, SemiBold, Bold)

2. **Sounds** (optional): Add MP3 files to `assets/sounds/`
   - `habit_complete.mp3`
   - `timer_complete.mp3`
   - `streak_milestone.mp3`

3. **App Icon**: Replace `android/app/src/main/res/mipmap-*/ic_launcher.png`

### Code Generation

After Codemagic installs dependencies, it will run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- `database.g.dart` - Drift database code
- `*_dao.g.dart` - DAO implementations

## Project Structure

```
lib/
├── main.dart              # App entry point
├── app.dart               # MaterialApp configuration
├── core/
│   ├── constants/         # App-wide constants
│   ├── router/            # GoRouter configuration
│   ├── services/          # Notification, Sound, Export services
│   └── theme/             # Material 3 theme system
├── data/
│   └── database/          # Drift database, tables, DAOs
└── presentation/
    ├── providers/         # Riverpod providers
    ├── screens/           # UI screens
    └── widgets/           # Reusable widgets
```

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Database**: Drift (SQLite)
- **Navigation**: GoRouter
- **CI/CD**: Codemagic
- **Java**: 21

## License

MIT License







