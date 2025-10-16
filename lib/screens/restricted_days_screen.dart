import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/theme.dart';
import '../widgets/golden_button.dart';

class RestrictedDay {
  final int month;
  final int day;
  final String name;

  RestrictedDay({
    required this.month,
    required this.day,
    required this.name,
  });

  factory RestrictedDay.fromJson(Map<String, dynamic> json) {
    return RestrictedDay(
      month: json['month'] as int,
      day: json['day'] as int,
      name: json['name'] as String,
    );
  }

  String get monthName => [
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

class RestrictedDaysScreen extends StatefulWidget {
  const RestrictedDaysScreen({super.key});

  @override
  State<RestrictedDaysScreen> createState() => _RestrictedDaysScreenState();
}

class _RestrictedDaysScreenState extends State<RestrictedDaysScreen>
    with SingleTickerProviderStateMixin {
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
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/restricted_days.json');
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final List<dynamic> daysJson = jsonData['restrictedDays'] as List<dynamic>;

      final days = daysJson
          .map((day) => RestrictedDay.fromJson(day as Map<String, dynamic>))
          .toList();

      // Check if today is a restricted day
      final now = DateTime.now();
      final todayMonth = now.month;
      final todayDay = now.day;

      final isRestricted = days.any(
        (day) => day.month == todayMonth && day.day == todayDay,
      );

      setState(() {
        _restrictedDays = days;
        _isRestricted = isRestricted;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading restricted days: $e')),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<SutraColors>();
    final theme = Theme.of(context);

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
                      color: (colors?.textOnDark ?? Colors.white).withOpacity(0.85),
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
                      color: (colors?.textOnDark ?? Colors.white).withOpacity(0.85),
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
                        color: (colors?.accent ?? AppColors.gold).withOpacity(0.55),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                        BoxShadow(
                          color: (colors?.accent ?? AppColors.gold).withOpacity(0.25),
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
                          'Restricted Days',
                          style: theme.textTheme.headlineMedium!.copyWith(
                            color: colors?.textOnLight ?? AppColors.indigoDeep,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _restrictedDays.length,
                            itemBuilder: (context, index) {
                              final day = _restrictedDays[index];
                              final now = DateTime.now();
                              final isToday = day.month == now.month && day.day == now.day;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? (colors?.accent ?? AppColors.gold).withOpacity(0.15)
                                      : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(16),
                                  border: isToday
                                      ? Border.all(
                                          color: colors?.accent ?? AppColors.gold,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: (colors?.accent ?? AppColors.gold)
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            day.day.toString(),
                                            style: theme.textTheme.headlineMedium!.copyWith(
                                              color: colors?.accent ?? AppColors.gold,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            day.monthName.substring(0, 3),
                                            style: theme.textTheme.bodySmall!.copyWith(
                                              color: colors?.textOnLight ?? AppColors.indigoDeep,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            day.name,
                                            style: theme.textTheme.bodyLarge!.copyWith(
                                              color: colors?.textOnLight ?? AppColors.indigoDeep,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (isToday) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              'Today',
                                              style: theme.textTheme.bodySmall!.copyWith(
                                                color: colors?.accent ?? AppColors.gold,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ],
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
