import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
  const ViewAnswerScreen({
    super.key,
    required this.pattern,
    required this.patternDisplay,
    this.questionId,
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
      if (kDebugMode) {
        // ignore: avoid_print
        print('ViewAnswerScreen: questionId is null, skipping DB fetch; '
            'will use local file if available for pattern=${widget.pattern}');
      }
      return; // fall back to local answers
    }
    setState(() => _loading = true);
    final svc = AnswerService();
    // Debug log the params we are fetching with
    if (kDebugMode) {
      // ignore: avoid_print
      print('ViewAnswerScreen: fetching from DB with questionId='
          '${widget.questionId}, pattern=${widget.pattern}');
    }
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

    // Resolve answer text: DB > local > placeholder
    String resolvedText;
    if (_answer != null && _answer!.isNotEmpty) {
      resolvedText = _answer!;
    } else {
      if (kDebugMode) {
        // ignore: avoid_print
        print(
            'ViewAnswerScreen: using local fallback for pattern=${widget.pattern}');
      }
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
            child: AnswerCard(
              pattern: '', // pattern hidden
              text: _loading ? 'Please wait…' : resolvedText,
            ),
          ),
        ),
      ),
    );
  }
}
