import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../widgets/answer_card.dart';
import '../../constants/colors.dart';
import '../../widgets/sutra_app_bar.dart';
import '../../constants/theme.dart';

class ViewAnswerScreen extends StatelessWidget {
  final String pattern;
  final String patternDisplay;
  const ViewAnswerScreen(
      {super.key, required this.pattern, required this.patternDisplay});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).extension<SutraColors>();
    final answerMap =
        app.answerForPattern(pattern) ?? {'en': 'Your fortune looks bright.'};
    final langCode = app.language.code;
    final display = answerMap[langCode] ?? answerMap['en'] as String;
    final isFav = app.isFavorite(pattern);
    return Scaffold(
      appBar: SutraAppBar(
        title: 'Answer',
        actions: [
          Builder(builder: (context) {
            final ext = Theme.of(context).extension<SutraColors>();
            final iconColor = ext?.textOnDark ?? Colors.white;
            return Row(children: [
              IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                    color: iconColor),
                onPressed: () => app.toggleFavorite(pattern),
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
          gradient: LinearGradient(colors: [
            colors?.gradientStart ?? AppColors.indigoDeep,
            colors?.gradientEnd ?? AppColors.indigoDarker
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
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
