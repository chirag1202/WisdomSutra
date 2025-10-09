import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/theme.dart';
import '../../widgets/golden_button.dart';

class RevealScreen extends StatelessWidget {
  final String patternKey;
  final String patternString;
  const RevealScreen(
      {super.key, required this.patternKey, required this.patternString});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Answer'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).extension<SutraColors>()?.gradientStart ??
                AppColors.indigoDeep,
            Theme.of(context).extension<SutraColors>()?.gradientEnd ??
                AppColors.indigoDarker
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tap to view your guidance',
                    style: theme.textTheme.titleLarge),
                const SizedBox(height: 34),
                GoldenButton(
                  label: 'View Answer',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/viewAnswer', arguments: {
                    'pattern': patternKey,
                    'string': patternString,
                    // No question text available here
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
