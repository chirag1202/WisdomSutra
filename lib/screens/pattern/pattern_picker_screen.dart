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
  final List<int> values = [0, 0, 0, 0];

  void _onChanged(int idx, int val) {
    setState(() => values[idx] = val);
  }

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
              child: Text('Drag each bar to set the count. Odd → 1, Even → 2.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(
                    color: (colors?.accent ?? AppColors.gold), width: 2),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    4,
                    (i) => PatternWheel(
                        index: i, value: values[i], onChanged: _onChanged)),
              ),
            ),
            const SizedBox(height: 28),
            Text('Pattern:  $patternString', style: theme.textTheme.titleLarge),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
              child: GoldenButton(
                label: 'Reveal Answer',
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/viewAnswer',
                  arguments: {
                    'pattern': patternKey,
                    'string': patternString,
                    if (widget.questionId != null)
                      'questionId': widget.questionId,
                    // question id unknown here; let QuestionsScreen pass it when navigating to PatternPicker
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
