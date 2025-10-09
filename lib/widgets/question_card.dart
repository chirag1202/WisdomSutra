import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/theme.dart';

class QuestionCard extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const QuestionCard({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<SutraColors>();
    final accent = ext?.accent ?? AppColors.gold;
    final surface = ext?.surface ?? AppColors.parchment;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [
            surface.withAlpha((255 * .75).round()),
            surface.withAlpha((255 * .95).round()),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: accent.withAlpha((255 * .55).round()),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * .2).round()),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: accent.withAlpha((255 * .25).round()),
            blurRadius: 18,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          splashColor: accent.withAlpha((255 * .25).round()),
          highlightColor: accent.withAlpha((255 * .18).round()),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .2,
                  color: (ext?.textOnLight ?? AppColors.indigoDeep)
                      .withAlpha((255 * .92).round()),
                  height: 1.22,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, .5),
                      blurRadius: 1,
                      color: accent.withAlpha((255 * .35).round()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated wrapper to provide a subtle staggered entrance for each question card.
class AnimatedQuestionCard extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final int index; // used for stagger delay
  const AnimatedQuestionCard(
      {super.key, required this.text, this.onTap, required this.index});

  @override
  State<AnimatedQuestionCard> createState() => _AnimatedQuestionCardState();
}

class _AnimatedQuestionCardState extends State<AnimatedQuestionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _scale = Tween(begin: .85, end: 1.0).animate(curve);
    _fade = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    // Staggered start
    Future.delayed(Duration(milliseconds: 40 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: QuestionCard(text: widget.text, onTap: widget.onTap),
      ),
    );
  }
}
