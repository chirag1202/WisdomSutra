# WisdomSutra

An App which has all the answers of life.

## Project Overview

WisdomSutra is a mystical guidance Flutter application that provides wisdom and answers to life's questions through an interactive pattern-based divination system. The app features a beautiful UI with deep indigo, gold, and parchment color themes, creating a serene and contemplative user experience.

### Key Features
- **Multi-language Support**: Available in English, Gujarati, Hindi, Marathi, and Bengali
- **Interactive Pattern System**: Users select questions and tap to generate unique 4-slot parity patterns
- **Mystical Theme**: Beautiful gradient backgrounds with carefully chosen typography
- **User Authentication**: Secure login and signup via Supabase
- **Answer Reveal**: Animated answer cards based on generated patterns
- **Theme Variants**: Multiple color themes including Classic, Emerald Dawn, Crimson Lotus, and Night Sapphire
- **Progressive Web App (PWA)**: Installable on devices with offline support and native app-like experience

### Technology Stack
- **Framework**: Flutter (SDK >=3.0.0)
- **State Management**: Provider
- **Backend**: Supabase (Authentication & Database)
- **Storage**: shared_preferences (Local data persistence)
- **Fonts**: Google Fonts (Playfair Display + Noto Sans Gujarati)
- **Deep Linking**: app_links for navigation

## How to Run

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Supabase account (for authentication features)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/chirag1202/WisdomSutra.git
   cd WisdomSutra
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase** (Required for authentication)
   
   Set up your Supabase project and provide credentials:
   ```bash
   flutter run --dart-define=SUPABASE_URL=your_supabase_url \
               --dart-define=SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Run the app**
   ```bash
   # For development (with Supabase credentials)
   flutter run --dart-define=SUPABASE_URL=your_supabase_url \
               --dart-define=SUPABASE_ANON_KEY=your_supabase_anon_key
   
   # Or run on a specific device
   flutter run -d chrome --dart-define=SUPABASE_URL=your_url \
                          --dart-define=SUPABASE_ANON_KEY=your_key
   ```

5. **Build for production**
   ```bash
   # Android
   flutter build apk --release \
                     --dart-define=SUPABASE_URL=your_url \
                     --dart-define=SUPABASE_ANON_KEY=your_key
   
   # iOS
   flutter build ios --release \
                     --dart-define=SUPABASE_URL=your_url \
                     --dart-define=SUPABASE_ANON_KEY=your_key
   
   # Web (with PWA support)
   flutter build web --release \
                     --web-renderer html \
                     --dart-define=SUPABASE_URL=your_url \
                     --dart-define=SUPABASE_ANON_KEY=your_key
   ```

### PWA Support
WisdomSutra includes full Progressive Web App support for the web version:
- **Offline Support**: Works without internet connection using service workers
- **Installable**: Can be installed on devices like a native app
- **App-like Experience**: Runs in standalone mode without browser UI
- **Automatic Updates**: Service worker handles caching and updates

To test PWA features locally:
```bash
flutter build web
cd build/web
python3 -m http.server 8000
# Visit http://localhost:8000 and check PWA features
# Use pwa-test.html for comprehensive PWA testing
```

For detailed PWA documentation, see [docs/PWA_IMPLEMENTATION.md](docs/PWA_IMPLEMENTATION.md).

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

## App Screenshots

![WisdomSutra Screenshot 1](docs/screenshot1.png)
*Main Questions Screen with mystical gradient background*

![WisdomSutra Screenshot 2](docs/screenshot2.png)
*Pattern Picker Screen with interactive wheel interface*

## Data Structure

The app uses JSON files for questions and answers:
- Questions are stored in language-specific files (`questions_en.json`, `questions_gu.json`, etc.)
- Answers are mapped to 4-slot parity patterns in `answers.json`
- See [assets/data/schema.md](assets/data/schema.md) for detailed data structure documentation

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to:
- Clone the repository
- Create branches
- Make commits
- Open pull requests

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
