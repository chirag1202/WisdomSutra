import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/theme.dart';

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
    final ext = Theme.of(context).extension<SutraColors>();
    final accent = ext?.accent ?? AppColors.gold;
    final accentAlt = ext?.accentAlt ?? AppColors.goldDark;
    final enabled = onPressed != null;
    final textColor = filled ? (ext?.textOnLight ?? Colors.black) : accent;
    final child = Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: enabled ? textColor : textColor.withOpacity(0.55),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
    return IgnorePointer(
      ignoring: !enabled,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1 : 0.45,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(48),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: padding,
            decoration: BoxDecoration(
              gradient: filled
                  ? LinearGradient(
                      colors: [accentAlt, accent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)
                  : null,
              color: filled ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(48),
              border: Border.all(color: accent, width: filled ? 0 : 2),
              boxShadow: enabled && filled
                  ? [
                      BoxShadow(
                        color: accent.withAlpha((255 * .45).round()),
                        blurRadius: 24,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
