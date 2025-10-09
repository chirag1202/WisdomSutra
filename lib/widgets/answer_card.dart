import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AnswerCard extends StatelessWidget {
  final String pattern;
  final String text;
  const AnswerCard({super.key, required this.pattern, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 34, 28, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: AppColors.indigoDeep)),
            const SizedBox(height: 22),
            if (pattern.isNotEmpty)
              Text('Pattern: $pattern',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color:
                          AppColors.indigoDeep.withAlpha((255 * .7).round()))),
          ],
        ),
      ),
    );
  }
}
