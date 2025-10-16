import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../widgets/answer_card.dart';
import '../../constants/colors.dart';
import '../../widgets/sutra_app_bar.dart';
import '../../constants/theme.dart';
import '../../services/answer_service.dart';

class ViewAnswerScreen extends StatefulWidget {
  final String pattern;
  final String patternDisplay;
  final int? questionId;
  final String? questionText;
  const ViewAnswerScreen({
    super.key,
    required this.pattern,
    required this.patternDisplay,
    this.questionId,
    this.questionText,
  });

  @override
  State<ViewAnswerScreen> createState() => _ViewAnswerScreenState();
}

class _ViewAnswerScreenState extends State<ViewAnswerScreen> {
  String? _answer;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _maybeFetch();
  }

  Future<void> _maybeFetch() async {
    if (widget.questionId == null) {
      return; // fall back to local answers
    }
    setState(() => _loading = true);
    final svc = AnswerService();
    final ans = await svc.fetchAnswer(
      questionId: widget.questionId!,
      pattern: widget.pattern,
    );
    if (!mounted) return;
    setState(() {
      _answer = ans;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).extension<SutraColors>();
    final isFav = app.isFavorite(widget.pattern);
    final displayName = (app.userName ?? '').trim();

    // Resolve answer text: DB > local > placeholder
    String resolvedText;
    if (_answer != null && _answer!.isNotEmpty) {
      resolvedText = _answer!;
    } else {
      // Local asset fallback now uses compact 4-digit keys like "1221"
      final answerMap = app.answerForPattern(widget.pattern);
      if (answerMap != null) {
        final langCode = app.language.code;
        resolvedText = (answerMap[langCode] ?? answerMap['en']) as String;
      } else {
        resolvedText = 'Under developement - Answers will be added soon';
      }
    }

    return Scaffold(
      appBar: SutraAppBar(
        title: 'Answer',
        showBack: false,
        actions: [
          Builder(builder: (context) {
            final ext = Theme.of(context).extension<SutraColors>();
            final iconColor = ext?.textOnDark ?? Colors.white;
            return Row(children: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: iconColor,
                ),
                onPressed: () => app.toggleFavorite(widget.pattern),
              ),
              IconButton(
                icon: Icon(Icons.share, color: iconColor),
                onPressed: () {},
              ),
            ]);
          }),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors?.gradientStart ?? AppColors.indigoDeep,
              colors?.gradientEnd ?? AppColors.indigoDarker,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if ((widget.questionText ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: (colors?.surface ?? AppColors.parchment)
                            .withOpacity(.96),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: (colors?.accent ?? AppColors.gold)
                              .withOpacity(.75),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.22),
                            blurRadius: 22,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.help_outline_rounded,
                              color: colors?.accent ?? AppColors.gold),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.questionText!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: colors?.textOnLight ??
                                        AppColors.indigoDeep,
                                    fontWeight: FontWeight.w700,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (displayName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Dear $displayName,',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: colors?.textOnDark ?? Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                if (!_loading && displayName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'The answer to your question is -',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: (colors?.textOnDark ?? Colors.white)
                              .withOpacity(.9)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                AnswerCard(
                  pattern: '', // pattern hidden
                  text: _loading ? 'Please wait…' : resolvedText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
