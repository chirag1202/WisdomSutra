import 'package:flutter/material.dart';
import '../constants/colors.dart';

class QuestionCard extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const QuestionCard({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.parchment.withOpacity(.92),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 10,
                offset: const Offset(0, 6)),
            BoxShadow(
                color: AppColors.gold.withOpacity(.25),
                blurRadius: 18,
                spreadRadius: -4),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.indigoDeep,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
          ),
        ),
      ),
    );
  }
}
