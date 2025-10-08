import 'package:flutter/material.dart';
import '../../widgets/pattern_wheel.dart';
import '../../widgets/golden_button.dart';
import '../../constants/colors.dart';

class PatternPickerScreen extends StatefulWidget {
  final String? question;
  const PatternPickerScreen({super.key, this.question});

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
  String get patternKey => values.map((v) => v % 2 == 0 ? '2' : '1').join('-');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.gold),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.indigoDeep, AppColors.indigoDarker],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
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
                border: Border.all(color: AppColors.gold, width: 2),
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
