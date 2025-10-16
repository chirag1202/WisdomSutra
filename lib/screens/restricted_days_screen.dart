import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/theme.dart';
import '../models/restricted_day.dart';
import '../services/restricted_dates_service.dart';
import '../widgets/golden_button.dart';

class RestrictedDaysScreen extends StatefulWidget {
  const RestrictedDaysScreen({super.key});

  @override
  State<RestrictedDaysScreen> createState() => _RestrictedDaysScreenState();
}

class _RestrictedDaysScreenState extends State<RestrictedDaysScreen>
    with SingleTickerProviderStateMixin {
  final RestrictedDatesService _service = const RestrictedDatesService();
  List<RestrictedDay> _restrictedDays = [];
  bool _loading = true;
  bool _isRestricted = false;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
    _loadRestrictedDays();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _loadRestrictedDays() async {
    List<RestrictedDay> days = [];
    try {
      days = await _service.fetchRestrictedDates();
    } catch (_) {
      // Service errors are handled by falling back to bundled data
    }

    if (days.isEmpty) {
      days = await _loadRestrictedDaysFromAsset();
    }

    days.sort((a, b) {
      if (a.month == b.month) {
        return a.day.compareTo(b.day);
      }
      return a.month.compareTo(b.month);
    });

    final now = DateTime.now();
    final isRestricted = days.any(
      (day) => day.month == now.month && day.day == now.day,
    );

    setState(() {
      _restrictedDays = days;
      _isRestricted = isRestricted;
      _loading = false;
    });
  }

  Future<List<RestrictedDay>> _loadRestrictedDaysFromAsset() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/restricted_days.json');
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final List<dynamic> daysJson =
          jsonData['restrictedDays'] as List<dynamic>;
      return daysJson
          .map((day) => RestrictedDay.fromJson(day as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return <RestrictedDay>[];
    }
  }

  void _proceedToQuestions() {
    Navigator.pushReplacementNamed(context, '/questions');
  }

  Widget _buildShimmerText(String text, TextStyle style, SutraColors? colors) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors?.accent ?? AppColors.gold,
                Colors.white,
                colors?.accent ?? AppColors.gold,
              ],
              stops: [
                (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                _shimmerAnimation.value.clamp(0.0, 1.0),
                (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: Text(text, style: style, textAlign: TextAlign.center),
        );
      },
    );
  }

  List<_MonthGroup> _groupByMonth(List<RestrictedDay> days) {
    final Map<int, List<int>> grouped = {};
    for (final day in days) {
      grouped.putIfAbsent(day.month, () => <int>[]).add(day.day);
    }
    final entries = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return entries
        .map((entry) => _MonthGroup(
              month: entry.key,
              days: (entry.value..sort()),
            ))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SutraColors>();
    final theme = Theme.of(context);
    final monthGroups = _groupByMonth(_restrictedDays);
    final now = DateTime.now();

    if (_loading) {
      return Scaffold(
        body: Container(
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
            child: CircularProgressIndicator(
              color: colors?.accent ?? AppColors.gold,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (_isRestricted) ...[
                  _buildShimmerText(
                    'The Cosmic Gates Are Closed Today',
                    theme.textTheme.displaySmall!.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colors?.textOnDark ?? Colors.white,
                    ),
                    colors,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Certain days hold deep silence in the universe.\nPlease return tomorrow.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: (colors?.textOnDark ?? Colors.white)
                          .withOpacity(0.85),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    'Sacred Days Calendar',
                    style: theme.textTheme.displaySmall!.copyWith(
                      color: colors?.textOnDark ?? Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Today the universe welcomes your questions',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: (colors?.textOnDark ?? Colors.white)
                          .withOpacity(0.85),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: (colors?.surface ?? AppColors.parchment)
                          .withOpacity(0.93),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: (colors?.accent ?? AppColors.gold)
                            .withOpacity(0.55),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                        BoxShadow(
                          color: (colors?.accent ?? AppColors.gold)
                              .withOpacity(0.25),
                          blurRadius: 36,
                          spreadRadius: -6,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The Sacred Days',
                          style: theme.textTheme.headlineMedium!.copyWith(
                            color: colors?.textOnLight ?? AppColors.indigoDeep,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Grouped by lunar whispers of each month.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: (colors?.textOnLight ?? AppColors.indigoDeep)
                                .withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _MonthTableHeader(colors: colors, theme: theme),
                        const SizedBox(height: 12),
                        if (monthGroups.isEmpty)
                          Expanded(
                            child: Center(
                              child: Text(
                                'No sacred days configured yet.',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colors?.textOnLight ??
                                      AppColors.indigoDeep,
                                ),
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: monthGroups.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final monthGroup = monthGroups[index];
                                final isCurrentMonth =
                                    monthGroup.month == now.month;
                                final isTodayRestricted = isCurrentMonth &&
                                    monthGroup.days.contains(now.day) &&
                                    _isRestricted;

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCurrentMonth
                                        ? (colors?.accent ?? AppColors.gold)
                                            .withOpacity(0.16)
                                        : Colors.white.withOpacity(0.55),
                                    borderRadius: BorderRadius.circular(18),
                                    border: isTodayRestricted
                                        ? Border.all(
                                            color: colors?.accent ??
                                                AppColors.gold,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          monthGroup.monthName,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            color: colors?.textOnLight ??
                                                AppColors.indigoDeep,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          monthGroup.days.join(', '),
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            color: colors?.textOnLight ??
                                                AppColors.indigoDeep,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (!_isRestricted)
                  GoldenButton(
                    label: 'Proceed',
                    onPressed: _proceedToQuestions,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthGroup {
  final int month;
  final List<int> days;

  const _MonthGroup({required this.month, required this.days});

  String get monthName => const [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ][month - 1];
}

class _MonthTableHeader extends StatelessWidget {
  final SutraColors? colors;
  final ThemeData theme;

  const _MonthTableHeader({required this.colors, required this.theme});

  @override
  Widget build(BuildContext context) {
    final baseColor = colors?.textOnLight ?? AppColors.indigoDeep;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Month',
              style: theme.textTheme.titleSmall?.copyWith(
                color: baseColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Dates',
              style: theme.textTheme.titleSmall?.copyWith(
                color: baseColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
