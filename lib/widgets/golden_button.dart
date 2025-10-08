import 'package:flutter/material.dart';
import '../constants/colors.dart';

class GoldenButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final bool filled;
  const GoldenButton(
      {super.key,
      required this.label,
      this.onPressed,
      this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      this.filled = true});

  @override
  Widget build(BuildContext context) {
    final child = Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: filled ? Colors.black : AppColors.gold,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: padding,
        decoration: BoxDecoration(
          gradient: filled
              ? const LinearGradient(
                  colors: AppColors.gradientButton,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)
              : null,
          color: filled ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.gold, width: filled ? 0 : 2),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(.55),
                    blurRadius: 18,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}
