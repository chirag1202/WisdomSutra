import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/theme.dart';
import 'state/app_state.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/questions_screen.dart';
import 'screens/pattern/pattern_picker_screen.dart';
import 'screens/answer/view_answer_screen.dart';

class WisdomSutraApp extends StatelessWidget {
  const WisdomSutraApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/questions':
        return MaterialPageRoute(builder: (_) => const QuestionsScreen());
      case '/patternPicker':
        final q = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => PatternPickerScreen(question: q));
      case '/viewAnswer':
        final args = settings.arguments as Map? ?? {};
        return MaterialPageRoute(
          builder: (_) => ViewAnswerScreen(
              pattern: args['pattern'] ?? '1-2-2-1',
              patternDisplay: args['string'] ?? '1 • 2 • 2 • 1'),
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..initialize(),
      child: Consumer<AppState>(
        builder: (_, app, __) => Builder(
          builder: (context) {
            final platformBrightness =
                MediaQuery.maybeOf(context)?.platformBrightness ??
                    Brightness.dark;
            final effectiveBrightness =
                app.brightnessOverride ?? platformBrightness;
            return MaterialApp(
              title: 'Wisdom Sutra',
              debugShowCheckedModeBanner: false,
              theme: buildAppTheme(app.themeVariant,
                  brightness: effectiveBrightness),
              navigatorKey: navigatorKey,
              onGenerateRoute: _onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}
