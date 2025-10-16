import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../state/app_state.dart';
import '../widgets/sutra_logo.dart';
import '../constants/colors.dart';
import '../constants/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    Future.microtask(() async {
      final nav = Navigator.of(context);
      await context.read<AppState>().initialize();
      if (!mounted) return;
      _controller.forward();
      await Future.delayed(const Duration(milliseconds: 1200));
      
      // Check if onboarding has been completed
      final prefs = await context.read<AppState>().getPreferences();
      final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
      
      if (!mounted) return;
      
      if (!onboardingCompleted) {
        // First time user - show onboarding
        nav.pushReplacementNamed('/onboarding');
      } else {
        // Existing user - check auth status
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          nav.pushReplacementNamed('/restrictedDays');
        } else {
          nav.pushReplacementNamed('/login');
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<SutraColors>();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ext?.gradientStart ?? AppColors.indigoDeep,
              ext?.gradientEnd ?? AppColors.indigoDarker,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: const SutraLogo(size: 120),
          ),
        ),
      ),
    );
  }
}
