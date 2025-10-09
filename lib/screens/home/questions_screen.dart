import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../widgets/question_card.dart';
import '../../widgets/sutra_logo.dart';
import '../../constants/colors.dart';
import '../../constants/theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/sutra_app_bar.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final questions = app.randomQuestionsWithIds; // already limited to <=16
    final colors = Theme.of(context).extension<SutraColors>();
    return Scaffold(
      appBar: SutraAppBar(
        title: 'Questions',
        actions: [
          _BrightnessToggle(),
          const SizedBox(width: 8),
          const _OverflowMenu(),
        ],
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
                const SizedBox(height: 4),
                const SutraLogo(size: 72),
                const SizedBox(height: 24),
                _TopBar(),
                const SizedBox(height: 14),
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
                      padding: const EdgeInsets.fromLTRB(22, 26, 22, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Questions',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                        color: (colors?.textOnLight ??
                                            AppColors.indigoDeep),
                                      )),
                              const Spacer(),
                              _BrightnessToggle(),
                              const SizedBox(width: 8),
                              _OverflowMenu(
                                  iconColor: (colors?.textOnLight ??
                                      AppColors.indigoDeep)),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (ctx, constraints) {
                                // Adaptive columns: try 2 on narrow, 3 on wide
                                final width = constraints.maxWidth;
                                int columns = width > 980 ? 3 : 2;
                                final itemWidth =
                                    (width - (16 * (columns - 1))) / columns;
                                const itemHeight = 140.0;
                                return GridView.builder(
                                  key: ValueKey(app.language.code + '_grid'),
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: itemWidth / itemHeight,
                                  ),
                                  itemCount: questions.length,
                                  itemBuilder: (c, i) {
                                    final q = questions[i];
                                    return AnimatedQuestionCard(
                                      index: i,
                                      text: q.text,
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

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LanguageSelector(),
        const SizedBox(width: 12),
        _ThemeSelector(),
      ],
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
        color: AppColors.parchment.withAlpha((255 * .15).round()),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withAlpha((255 * .6).round())),
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

class _ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).extension<SutraColors>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (colors?.surface ?? AppColors.parchment)
            .withAlpha((255 * .15).round()),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: (colors?.accent ?? AppColors.gold)
                .withAlpha((255 * .6).round())),
      ),
      child: DropdownButton<ThemeVariant>(
        value: app.themeVariant,
        dropdownColor: colors?.gradientEnd ?? AppColors.indigoDarker,
        iconEnabledColor: colors?.accent ?? AppColors.gold,
        underline: const SizedBox.shrink(),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: colors?.textOnDark ?? AppColors.parchment,
            ),
        onChanged: (v) {
          if (v != null) context.read<AppState>().setThemeVariant(v);
        },
        items: ThemeVariant.values
            .map(
              (t) => DropdownMenuItem(
                value: t,
                child: Text(t.label),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BrightnessToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).extension<SutraColors>();
    final icon = app.brightnessOverride == null
        ? Icons.brightness_auto
        : app.brightnessOverride == Brightness.light
            ? Icons.light_mode
            : Icons.dark_mode;
    final label = app.brightnessOverride == null
        ? 'System'
        : app.brightnessOverride == Brightness.light
            ? 'Light'
            : 'Dark';
    return Tooltip(
      message: 'Theme brightness: $label (tap to cycle)',
      child: InkWell(
        onTap: () => context.read<AppState>().cycleBrightness(),
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: (colors?.accent ?? AppColors.gold)
                .withAlpha((255 * .18).round()),
          ),
          child: Icon(
            icon,
            size: 22,
            color: colors?.accent ?? AppColors.gold,
          ),
        ),
      ),
    );
  }
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({this.iconColor});
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: iconColor != null ? Icon(Icons.more_vert, color: iconColor) : null,
      onSelected: (value) async {
        if (value == 'logout') {
          // sign out and take user to login
          try {
            await const AuthService().signOut();
          } catch (_) {}
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
          }
        }
      },
      itemBuilder: (c) => [
        const PopupMenuItem(value: 'logout', child: Text('Logout')),
      ],
    );
  }
}
