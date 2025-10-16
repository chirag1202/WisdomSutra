# Testing Guide for WisdomSutra Updates

This guide provides instructions for testing all the implemented features.

## Prerequisites

Before testing, ensure you have:
- Flutter SDK 3.0.0 or higher installed
- A physical device or emulator/simulator
- Supabase credentials configured

## Setup for Testing

```bash
# Clone the repository (if not already done)
git clone https://github.com/chirag1202/WisdomSutra.git
cd WisdomSutra

# Install dependencies
flutter pub get

# Run the app with Supabase credentials
flutter run --dart-define=SUPABASE_URL=your_url \
            --dart-define=SUPABASE_ANON_KEY=your_key
```

## Task 1: README.md Documentation

### What to Test
- Open `README.md` in GitHub or a Markdown viewer
- Verify all sections are present and readable

### Expected Results
✅ Project Overview section describes the app clearly  
✅ How to Run section has complete setup instructions  
✅ Commands for `flutter pub get` and `flutter run` are accurate  
✅ Technology stack is listed  
✅ Screenshot placeholders are referenced  

### How to Verify
```bash
# View README
cat README.md | grep -E "^##"
```

## Task 2: LICENSE File

### What to Test
- Check that LICENSE file exists
- Verify it contains MIT License text
- Confirm README mentions the license

### Expected Results
✅ LICENSE file exists in root directory  
✅ Contains standard MIT License text  
✅ Copyright year is 2024  
✅ README has "License" section at bottom  

### How to Verify
```bash
# Check LICENSE exists
ls -la LICENSE

# Verify README mentions license
grep -i "license" README.md
```

## Task 3: CONTRIBUTING.md

### What to Test
- Read through CONTRIBUTING.md
- Follow the workflow instructions conceptually

### Expected Results
✅ Clone instructions are present  
✅ Branch naming conventions explained (feature/*, fix/*)  
✅ Commit message format documented  
✅ PR process described step-by-step  
✅ PR checklist has 8+ items  

### How to Verify
```bash
# View CONTRIBUTING.md
cat CONTRIBUTING.md

# Check for PR checklist
grep "\[ \]" CONTRIBUTING.md
```

## Task 4: Local Font Files

### What to Test
1. Run the app offline (disable internet)
2. Navigate through different screens
3. Verify all text renders correctly

### Expected Results
✅ App runs without internet connection  
✅ Heading text uses PlayfairDisplay font  
✅ Body text uses Nunito font  
✅ Gujarati text uses NotoSansGujarati font  
✅ No errors about missing fonts  
✅ No network requests to fonts.googleapis.com  

### How to Verify
```bash
# Check font files exist
ls -lh assets/fonts/*.ttf

# Verify pubspec.yaml has font declarations
grep -A 10 "fonts:" pubspec.yaml

# Check theme.dart doesn't use google_fonts
grep -n "google_fonts" lib/constants/theme.dart
# Should return no results
```

### Manual Testing Steps
1. Build and install the app: `flutter build apk` or `flutter build ios`
2. Turn on airplane mode on your device
3. Launch the app
4. Verify all text displays correctly with proper fonts
5. Navigate to Questions screen, Pattern Picker, and Answer screens
6. Confirm no font loading errors

## Task 5: Data Schema Documentation

### What to Test
- Read `assets/data/schema.md`
- Verify it accurately describes the JSON structure

### Expected Results
✅ Questions data structure documented  
✅ Answers data structure documented  
✅ Field descriptions are clear  
✅ Pattern format explained (odd=1, even=2)  
✅ Example JSON snippets provided  
✅ Language codes listed (en, gu, hi, mr, bn)  

### How to Verify
```bash
# View schema documentation
cat assets/data/schema.md

# Compare with actual JSON files
cat assets/data/questions_en.json | head -10
cat assets/data/answers.json | head -10
```

## Task 6: Onboarding Flow

### What to Test
1. First Launch (onboarding should appear)
2. Skip functionality
3. Page navigation
4. Subsequent launches (onboarding should not appear)

### Expected Results
✅ Onboarding appears on first app launch  
✅ Three slides are present:
   - Slide 1: Welcome with WisdomSutra logo
   - Slide 2: How It Works with touch icon
   - Slide 3: Privacy with security icon
✅ Skip button works from any slide  
✅ Next button advances through slides  
✅ "Get Started" button appears on last slide  
✅ Page indicators show current slide  
✅ User can swipe between slides  
✅ Onboarding doesn't appear on subsequent launches  

### How to Test

#### First Time Experience
```bash
# Option 1: Clear app data (Android)
adb shell pm clear com.example.wisdom_sutra

# Option 2: Uninstall and reinstall
flutter clean
flutter pub get
flutter run
```

#### Testing Flow
1. Launch the app for the first time
2. ✓ Verify onboarding screen appears
3. ✓ Check Slide 1: Welcome content
4. ✓ Tap "Next" to advance
5. ✓ Check Slide 2: How It Works content
6. ✓ Tap "Next" again
7. ✓ Check Slide 3: Privacy content
8. ✓ Verify button shows "Get Started"
9. ✓ Tap "Get Started"
10. ✓ Confirm navigation to Login screen

#### Testing Skip
1. Clear app data and relaunch
2. On any onboarding slide, tap "Skip"
3. ✓ Verify immediate navigation to Login screen

#### Testing Persistence
1. Complete onboarding once
2. Close app completely
3. Relaunch app
4. ✓ Verify onboarding does NOT appear
5. ✓ Confirm direct navigation to Login/Questions screen

### Code Verification
```bash
# Check onboarding screen exists
cat lib/screens/onboarding_screen.dart | grep -E "class|Widget"

# Verify splash screen checks onboarding status
grep "onboarding_completed" lib/screens/splash_screen.dart

# Check route is registered
grep "onboarding" lib/app.dart
```

## Task 7: CI/CD Workflow

### What to Test
1. Workflow file is valid YAML
2. Workflow runs on push/PR
3. All steps execute successfully

### Expected Results
✅ `.github/workflows/ci.yml` exists  
✅ YAML syntax is valid  
✅ Workflow triggers on push to main/develop  
✅ Workflow triggers on PR to main/develop  
✅ Steps include: checkout, setup Flutter, pub get, analyze, test  
✅ Warning detection is implemented  

### How to Verify Locally
```bash
# Validate YAML syntax
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml'))"

# Run analyze locally (should match CI)
flutter analyze

# Run tests locally (should match CI)
flutter test

# Check for warnings
flutter analyze 2>&1 | grep -i "warning"
```

### Testing on GitHub
1. Push changes to the repository
2. Navigate to the "Actions" tab on GitHub
3. ✓ Verify workflow starts automatically
4. ✓ Check all steps complete successfully
5. ✓ Confirm no errors or warnings

### Manual CI Steps
Run these commands to simulate CI locally:
```bash
# Clean build
flutter clean
flutter pub get

# Format check
dart format --output=none --set-exit-if-changed .

# Analyze
flutter analyze

# Test
flutter test

# Check for warnings
ANALYZE_OUTPUT=$(flutter analyze 2>&1)
if echo "$ANALYZE_OUTPUT" | grep -q "warning"; then
  echo "❌ Warnings found"
  exit 1
else
  echo "✅ No warnings found"
fi
```

## Integration Testing Checklist

Run through the entire app to verify all changes work together:

### Complete User Journey
1. ✅ First launch shows onboarding (3 slides)
2. ✅ Complete onboarding → Login screen appears
3. ✅ Sign up/Login works
4. ✅ Questions screen loads with correct fonts
5. ✅ Gujarati text displays correctly
6. ✅ Pattern picker wheel works
7. ✅ Answer reveal screen displays properly
8. ✅ All fonts render without internet
9. ✅ Close and relaunch → no onboarding shown
10. ✅ App works completely offline (except auth)

### Documentation Verification
1. ✅ README is comprehensive and accurate
2. ✅ CONTRIBUTING guide is clear
3. ✅ Schema documentation matches actual data
4. ✅ LICENSE file is present
5. ✅ All documentation is accessible

### CI/CD Verification
1. ✅ Push to branch triggers CI
2. ✅ PR creation triggers CI
3. ✅ All CI checks pass
4. ✅ No warnings in flutter analyze

## Troubleshooting

### Onboarding Doesn't Appear
```dart
// Add this to splash_screen.dart temporarily for debugging
final prefs = await SharedPreferences.getInstance();
print('Onboarding completed: ${prefs.getBool('onboarding_completed')}');

// Or reset onboarding manually
await prefs.remove('onboarding_completed');
```

### Fonts Don't Load
```bash
# Verify font files are not empty
ls -lh assets/fonts/*.ttf

# Check pubspec.yaml indentation
flutter pub get

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### CI Fails
```bash
# Run locally to reproduce
flutter analyze
flutter test

# Check YAML syntax
yamllint .github/workflows/ci.yml
```

## Success Criteria

All tasks are successfully implemented if:
- ✅ All manual tests pass
- ✅ App works offline (fonts load correctly)
- ✅ Onboarding appears only on first launch
- ✅ CI workflow runs without errors
- ✅ Documentation is complete and accurate
- ✅ No warnings in flutter analyze
- ✅ All tests pass in flutter test

## Next Steps After Testing

1. Create actual app screenshots for README
2. Test on multiple devices (iOS and Android)
3. Verify RTL language support (if needed)
4. Performance test font loading times
5. Test onboarding on tablets and different screen sizes
