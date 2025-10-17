import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/theme.dart';
import '../../widgets/golden_button.dart';
import '../../widgets/sutra_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<SutraColors>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors?.gradientStart ?? AppColors.indigoDeep,
              colors?.gradientEnd ?? AppColors.indigoDarker,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const SutraLogo(size: 120),
                const SizedBox(height: 40),
                Text(
                  'Welcome to WisdomSutra',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: colors?.textOnDark ?? AppColors.parchment,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  "Discover ancient wisdom and guidance for life's questions through our mystical divination system.",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors?.textOnDark ?? AppColors.parchment,
                    height: 1.5,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildFeatureCard(
                  context,
                  icon: Icons.menu_book_rounded,
                  title: 'Rooted in Myth',
                  description:
                      'WisdomSutra draws from a mythical scripture, penned seventy years ago, said to hold guidance for every seeker.',
                  colors: colors,
                  theme: theme,
                ),
                const SizedBox(height: 20),
                _buildFeatureCard(
                  context,
                  icon: Icons.touch_app,
                  title: 'How It Works',
                  description:
                      'Choose a question that speaks to you, then swipe the four sacred rollers to generate your unique pattern.',
                  colors: colors,
                  theme: theme,
                ),
                const SizedBox(height: 20),
                _buildFeatureCard(
                  context,
                  icon: Icons.security,
                  title: 'Your Privacy',
                  description:
                      'Your journey is personal and secure. All your questions and answers are kept private.',
                  colors: colors,
                  theme: theme,
                ),
                const Spacer(),
                GoldenButton(
                  label: 'Ask a Question',
                  onPressed: () {
                    Navigator.pushNamed(context, '/restrictedDays');
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required SutraColors? colors,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (colors?.surface ?? AppColors.parchment).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (colors?.accent ?? AppColors.gold).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 40,
            color: colors?.accent ?? AppColors.gold,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors?.textOnDark ?? AppColors.parchment,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        (colors?.textOnDark ?? AppColors.parchment).withOpacity(0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
