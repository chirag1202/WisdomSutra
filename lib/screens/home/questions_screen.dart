import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../widgets/question_card.dart';
import '../../constants/colors.dart';
import '../../constants/theme.dart';
// import '../../services/auth_service.dart';
import '../../widgets/sutra_app_bar.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    // Always show questions ordered by ID ascending (null IDs last)
    final questions = [...app.questionsWithIds]..sort((a, b) {
        final ai = a.id;
        final bi = b.id;
        if (ai == null && bi == null) return 0;
        if (ai == null) return 1; // nulls last
        if (bi == null) return -1;
        return ai.compareTo(bi);
      });
    final colors = Theme.of(context).extension<SutraColors>();
    return Scaffold(
      appBar: const SutraAppBar(
        title: 'Questions',
        actions: [LanguagePickerAction()],
      ),
      body: SafeArea(
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOutQuad,
                    switchOutCurve: Curves.easeInQuad,
                    child: Container(
                      key: ValueKey(
                          app.language.code + questions.length.toString()),
                      decoration: BoxDecoration(
                        color: (colors?.surface ?? AppColors.parchment)
                            .withAlpha((255 * .93).round()),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: (colors?.accent ?? AppColors.gold)
                              .withAlpha((255 * .55).round()),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((255 * .35).round()),
                            blurRadius: 28,
                            offset: const Offset(0, 14),
                          ),
                          BoxShadow(
                            color: (colors?.accent ?? AppColors.gold)
                                .withAlpha((255 * .25).round()),
                            blurRadius: 36,
                            spreadRadius: -6,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Removed in-card header; AppBar title is sufficient
                          Expanded(
                            child: LayoutBuilder(
                              builder: (ctx, constraints) {
                                final width = constraints.maxWidth;
                                final bool singleColumn = width < 520; // phones
                                if (singleColumn) {
                                  return ListView.separated(
                                    key: ValueKey('${app.language.code}_list'),
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (c, i) {
                                      final q = questions[i];
                                      return AnimatedQuestionCard(
                                        index: i,
                                        text: q.text,
                                        maxLines: null, // let it wrap fully
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/patternPicker',
                                            arguments: {
                                              'question': q.text,
                                              if (q.id != null)
                                                'questionId': q.id,
                                            },
                                          );
                                        },
                                      );
                                    },
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemCount: questions.length,
                                  );
                                }
                                // Wider screens: grid with 2 or 3 columns
                                final columns = width > 980 ? 3 : 2;
                                final itemWidth =
                                    (width - (18 * (columns - 1))) / columns;
                                const itemHeight = 160.0;
                                return GridView.builder(
                                  key: ValueKey('${app.language.code}_grid'),
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    mainAxisSpacing: 18,
                                    crossAxisSpacing: 18,
                                    childAspectRatio: itemWidth / itemHeight,
                                  ),
                                  itemCount: questions.length,
                                  itemBuilder: (c, i) {
                                    final q = questions[i];
                                    return AnimatedQuestionCard(
                                      index: i,
                                      text: q.text,
                                      maxLines:
                                          3, // keep height consistent in grid
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/patternPicker',
                                          arguments: {
                                            'question': q.text,
                                            if (q.id != null)
                                              'questionId': q.id,
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Language picker moved into AppBar actions
class LanguagePickerAction extends StatelessWidget {
  const LanguagePickerAction({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final ext = Theme.of(context).extension<SutraColors>();
    final iconColor = ext?.textOnDark ?? Colors.white;
    return PopupMenuButton<AppLanguage>(
      tooltip: 'Change language',
      icon: Icon(Icons.language_rounded, color: iconColor),
      initialValue: app.language,
      onSelected: (lang) => context.read<AppState>().setLanguage(lang),
      itemBuilder: (ctx) => [
        for (final lang in AppLanguage.values)
          PopupMenuItem<AppLanguage>(
            value: lang,
            child: Row(
              children: [
                if (app.language == lang) ...[
                  Icon(Icons.check,
                      size: 18, color: ext?.accent ?? AppColors.gold),
                  const SizedBox(width: 6),
                ],
                Text(lang.label),
              ],
            ),
          ),
      ],
    );
  }
}
