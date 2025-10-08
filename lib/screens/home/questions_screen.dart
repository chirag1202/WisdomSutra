import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../widgets/question_card.dart';
import '../../widgets/sutra_logo.dart';
import '../../constants/colors.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final questions = app.questions.take(16).toList();
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.indigoDeep, AppColors.indigoDarker],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                const SizedBox(height: 4),
                const SutraLogo(size: 72),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text('Questions',
                          style: Theme.of(context).textTheme.displaySmall),
                    ),
                    _LanguageSelector(),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.25,
                    ),
                    itemCount: questions.length,
                    itemBuilder: (c, i) => QuestionCard(
                      text: questions[i],
                      onTap: () => Navigator.pushNamed(
                          context, '/patternPicker',
                          arguments: questions[i]),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.parchment.withOpacity(.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(.6)),
      ),
      child: DropdownButton<AppLanguage>(
        value: app.language,
        dropdownColor: AppColors.indigoDarker,
        iconEnabledColor: AppColors.gold,
        underline: const SizedBox.shrink(),
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppColors.parchment),
        onChanged: (v) {
          if (v != null) context.read<AppState>().setLanguage(v);
        },
        items: AppLanguage.values
            .map(
              (lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang.label),
              ),
            )
            .toList(),
      ),
    );
  }
}
