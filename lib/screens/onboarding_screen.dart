import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/colors.dart';
import '../constants/theme.dart';
import '../widgets/sutra_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<SutraColors>();
    final textTheme = Theme.of(context).textTheme;

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
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: textTheme.bodyLarge?.copyWith(
                        color: ext?.textOnDark ?? AppColors.parchment,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              // Pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildPage(
                      context: context,
                      icon: const SutraLogo(size: 100),
                      title: 'Welcome to WisdomSutra',
                      description:
                          'Discover ancient wisdom and guidance for life\'s questions through our mystical divination system.',
                    ),
                    _buildPage(
                      context: context,
                      icon: Icon(
                        Icons.touch_app,
                        size: 100,
                        color: ext?.accent ?? AppColors.gold,
                      ),
                      title: 'How It Works',
                      description:
                          'Choose a question that speaks to you, then tap the sacred wheel four times to generate your unique pattern and reveal your answer.',
                    ),
                    _buildPage(
                      context: context,
                      icon: Icon(
                        Icons.security,
                        size: 100,
                        color: ext?.accent ?? AppColors.gold,
                      ),
                      title: 'Your Privacy',
                      description:
                          'Your journey is personal and secure. All your questions and answers are kept private and stored safely.',
                    ),
                  ],
                ),
              ),
              // Page indicators
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? (ext?.accent ?? AppColors.gold)
                            : (ext?.accent ?? AppColors.gold).withAlpha(102),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              // Next/Get Started button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == 2 ? 'Get Started' : 'Next',
                      style: textTheme.titleLarge?.copyWith(
                        color: ext?.textOnLight ?? AppColors.indigoDeep,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage({
    required BuildContext context,
    required Widget icon,
    required String title,
    required String description,
  }) {
    final ext = Theme.of(context).extension<SutraColors>();
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 48),
          Text(
            title,
            style: textTheme.displaySmall?.copyWith(
              color: ext?.textOnDark ?? AppColors.parchment,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            description,
            style: textTheme.bodyLarge?.copyWith(
              color: ext?.textOnDark ?? AppColors.parchment,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
