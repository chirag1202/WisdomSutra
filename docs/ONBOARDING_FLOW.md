# Onboarding Flow Documentation

## Overview
The onboarding flow appears only on the first app launch and consists of 3 slides introducing users to WisdomSutra.

## Flow Diagram

```
App Launch (First Time)
    ↓
Splash Screen
    ↓
[Check onboarding_completed flag = false]
    ↓
Onboarding Screen
    ↓
    ├── Slide 1: Welcome
    ├── Slide 2: How It Works  
    └── Slide 3: Privacy
        ↓
    [Set onboarding_completed = true]
        ↓
    Login Screen
```

## Slide Details

### Slide 1: Welcome
- **Icon**: WisdomSutra logo (custom SutraLogo widget, 100px)
- **Title**: "Welcome to WisdomSutra"
- **Description**: "Discover ancient wisdom and guidance for life's questions through our mystical divination system."
- **Color Scheme**: Deep indigo to darker indigo gradient background with parchment/gold text

### Slide 2: How It Works
- **Icon**: Touch/Tap icon (Material Icons touch_app, 100px, gold color)
- **Title**: "How It Works"
- **Description**: "Choose a question that speaks to you, then tap the sacred wheel four times to generate your unique pattern and reveal your answer."
- **Color Scheme**: Same gradient background as Slide 1

### Slide 3: Privacy
- **Icon**: Security shield icon (Material Icons security, 100px, gold color)
- **Title**: "Your Privacy"
- **Description**: "Your journey is personal and secure. All your questions and answers are kept private and stored safely."
- **Color Scheme**: Same gradient background as previous slides

## UI Elements

### Navigation Controls
1. **Skip Button**
   - Location: Top-right corner
   - Action: Bypasses onboarding, goes directly to login
   - Style: Text button with semi-transparent background

2. **Page Indicators**
   - Location: Bottom center, above the main button
   - Style: Horizontal dots (3 dots)
   - Current page: Wider dot (24px) with full opacity gold
   - Other pages: Smaller dots (8px) with 40% opacity gold

3. **Next/Get Started Button**
   - Location: Bottom of screen with padding
   - Text: "Next" (slides 1-2) or "Get Started" (slide 3)
   - Action: Advances to next slide or completes onboarding
   - Style: Full-width elevated button with gold background

## Animations

1. **Page Transitions**
   - Duration: 350ms
   - Curve: easeInOut
   - Effect: Horizontal slide between pages

2. **Page Indicator Animation**
   - Active dot expands from 8px to 24px width
   - Smooth color transition between active/inactive states

## State Management

### SharedPreferences Key
- **Key**: `onboarding_completed`
- **Type**: Boolean
- **Default**: false (not set)
- **Set to true**: When user completes or skips onboarding

### Implementation Details
```dart
// Check if onboarding is needed
final prefs = await SharedPreferences.getInstance();
final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

// Mark onboarding as complete
await prefs.setBool('onboarding_completed', true);
```

## Testing the Onboarding

### To View Onboarding Again
1. **Option 1**: Clear app data
   - Android: Settings → Apps → WisdomSutra → Storage → Clear Data
   - iOS: Delete and reinstall the app

2. **Option 2**: Programmatically reset (for development)
   ```dart
   final prefs = await SharedPreferences.getInstance();
   await prefs.remove('onboarding_completed');
   ```

### Expected Behavior
- ✅ First Launch: Shows onboarding
- ✅ Subsequent Launches: Goes directly to Login/Questions screen
- ✅ Skip Button: Bypasses all slides and marks onboarding complete
- ✅ Page Swipe: Users can swipe left/right to navigate slides
- ✅ Responsive: Adapts to different screen sizes

## Accessibility

- Text is readable with sufficient contrast (parchment on deep indigo)
- Touch targets meet minimum 48x48 dp requirement
- Icons have semantic meaning aligned with content
- Smooth animations with reasonable duration (not too fast)

## Future Enhancements

Potential improvements for future iterations:
- Add localization support for multiple languages
- Include a "Don't show again" checkbox
- Add video or animated demonstrations
- Collect initial preferences (theme, language) during onboarding
- Add progress percentage indicator
