import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/theme.dart';

class QuestionCard extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final int? colorSeed; // optional seed to vary subtle tint
  final int? maxLines; // null => wrap fully
  const QuestionCard(
      {super.key,
      required this.text,
      this.onTap,
      this.colorSeed,
      this.maxLines});

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool _hovering = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<SutraColors>();
    final accent = ext?.accent ?? AppColors.gold;
    final accentAlt = ext?.accentAlt ?? AppColors.goldDark;
    final surface = ext?.surface ?? AppColors.parchment;
    // Compute a very light tint based on a seed (index) to add variety
    final seed = ((widget.colorSeed ?? widget.text.hashCode) % 6).abs();
    final tint = Color.alphaBlend(
      [
        accent,
        accentAlt,
        Colors.teal,
        Colors.deepPurple,
        Colors.orange,
        Colors.pinkAccent,
      ][seed]
          .withOpacity(.12),
      surface,
    );
    final targetScale = _pressed
        ? 0.98
        : (_hovering
            ? 1.02
            : 1.0); // hover grows slightly; press shrinks slightly
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: targetScale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              colors: [
                tint.withAlpha((255 * .88).round()),
                surface.withAlpha((255 * .98).round()),
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
                color: accent.withAlpha((255 * .22).round()),
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
              onHighlightChanged: (v) => setState(() => _pressed = v),
              onTap: widget.onTap,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline_rounded,
                        size: 22,
                        color: (ext?.textOnLight ?? AppColors.indigoDeep)
                            .withAlpha((255 * .85).round())),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        maxLines: widget.maxLines,
                        overflow: widget.maxLines == null
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
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
                              color: accent.withAlpha((255 * .28).round()),
                            ),
                          ],
                        ),
                      ),
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
  final int? maxLines;
  const AnimatedQuestionCard(
      {super.key,
      required this.text,
      this.onTap,
      required this.index,
      this.maxLines});

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
        child: QuestionCard(
            text: widget.text,
            onTap: widget.onTap,
            colorSeed: widget.index,
            maxLines: widget.maxLines),
      ),
    );
  }
}
