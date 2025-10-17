import 'package:flutter/material.dart';
import '../../widgets/pattern_wheel.dart';
import '../../widgets/golden_button.dart';
import '../../constants/colors.dart';
import '../../widgets/sutra_app_bar.dart';
import '../../constants/theme.dart';

class PatternPickerScreen extends StatefulWidget {
  final String? question;
  final int? questionId;
  const PatternPickerScreen({super.key, this.question, this.questionId});

  @override
  State<PatternPickerScreen> createState() => _PatternPickerScreenState();
}

class _PatternPickerScreenState extends State<PatternPickerScreen> {
  // Start at 1 to align with 1..120 wheels
  final List<int> values = [1, 1, 1, 1];
  // Track which rollers have been touched at least once
  final Set<int> touchedRollers = {};

  void _onChanged(int idx, int val) {
    // Mark this roller as touched
    if (touchedRollers.add(idx)) {
      setState(() {});
    }
    // Avoid setState for value updates so the whole screen doesn't rebuild on every tick.
    // We only need the latest values when user taps "Reveal Answer".
    values[idx] = val;
  }

  bool get allRollersTouched => touchedRollers.length == 4;

  String get patternString =>
      values.map((v) => v % 2 == 0 ? '2' : '1').join(' • ');
  // DB now expects a 4-number comma-separated pattern like "1,2,2,1"
  String get patternKey => values.map((v) => v % 2 == 0 ? '2' : '1').join(',');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<SutraColors>();
    return Scaffold(
      appBar: const SutraAppBar(title: 'Choose Pattern'),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            colors?.gradientStart ?? AppColors.indigoDeep,
            colors?.gradientEnd ?? AppColors.indigoDarker
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                widget.question ?? 'What is the path to success?',
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Swipe the rollers smoothly. They’ll settle naturally.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color:
                        (colors?.textOnDark ?? Colors.white).withOpacity(.95)),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color:
                    (colors?.surface ?? AppColors.parchment).withOpacity(.12),
                border: Border.all(
                    color: (colors?.accent ?? AppColors.gold).withOpacity(.7),
                    width: 1.4),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.25),
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    4,
                    (i) => PatternWheel(
                          index: i,
                          value: values[i],
                          onChanged: _onChanged,
                          isTouched: touchedRollers.contains(i),
                        )),
              ),
            ),
            const SizedBox(height: 8),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
              child: GoldenButton(
                label: 'Reveal Answer',
                onPressed: allRollersTouched
                    ? () => Navigator.pushNamed(
                          context,
                          '/viewAnswer',
                          arguments: {
                            'pattern': patternKey,
                            'string': patternString,
                            if (widget.question != null)
                              'question': widget.question,
                            if (widget.questionId != null)
                              'questionId': widget.questionId,
                            // question id unknown here; let QuestionsScreen pass it when navigating to PatternPicker
                          },
                        )
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
