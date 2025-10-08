import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../widgets/answer_card.dart';
import '../../constants/colors.dart';

class ViewAnswerScreen extends StatelessWidget {
  final String pattern;
  final String patternDisplay;
  const ViewAnswerScreen(
      {super.key, required this.pattern, required this.patternDisplay});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final answerMap =
        app.answerForPattern(pattern) ?? {'en': 'Your fortune looks bright.'};
    final langCode = app.language.code;
    final display = answerMap[langCode] ?? answerMap['en'] as String;
    final isFav = app.isFavorite(pattern);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Answer'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                color: AppColors.gold),
            onPressed: () => app.toggleFavorite(pattern),
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.gold),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.indigoDeep, AppColors.indigoDarker],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: AnswerCard(
              pattern: '', // pattern hidden
              text: display,
            ),
          ),
        ),
      ),
    );
  }
}
