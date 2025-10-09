import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Available theme variants.
enum ThemeVariant { classic, emeraldDawn, crimsonLotus, nightSapphire }

extension ThemeVariantX on ThemeVariant {
  String get id => name;
  String get label => switch (this) {
        ThemeVariant.classic => 'Classic',
        ThemeVariant.emeraldDawn => 'Emerald Dawn',
        ThemeVariant.crimsonLotus => 'Crimson Lotus',
        ThemeVariant.nightSapphire => 'Night Sapphire',
      };
}

/// Custom colors exposed to widgets without coupling to a single palette.
class SutraColors extends ThemeExtension<SutraColors> {
  final Color gradientStart;
  final Color gradientEnd;
  final Color surface;
  final Color accent;
  final Color accentAlt;
  final Color textOnDark;
  final Color textOnLight;
  final Color subtle;

  const SutraColors({
    required this.gradientStart,
    required this.gradientEnd,
    required this.surface,
    required this.accent,
    required this.accentAlt,
    required this.textOnDark,
    required this.textOnLight,
    required this.subtle,
  });

  @override
  ThemeExtension<SutraColors> copyWith({
    Color? gradientStart,
    Color? gradientEnd,
    Color? surface,
    Color? accent,
    Color? accentAlt,
    Color? textOnDark,
    Color? textOnLight,
    Color? subtle,
  }) =>
      SutraColors(
        gradientStart: gradientStart ?? this.gradientStart,
        gradientEnd: gradientEnd ?? this.gradientEnd,
        surface: surface ?? this.surface,
        accent: accent ?? this.accent,
        accentAlt: accentAlt ?? this.accentAlt,
        textOnDark: textOnDark ?? this.textOnDark,
        textOnLight: textOnLight ?? this.textOnLight,
        subtle: subtle ?? this.subtle,
      );

  @override
  ThemeExtension<SutraColors> lerp(
      ThemeExtension<SutraColors>? other, double t) {
    if (other is! SutraColors) return this;
    return SutraColors(
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentAlt: Color.lerp(accentAlt, other.accentAlt, t)!,
      textOnDark: Color.lerp(textOnDark, other.textOnDark, t)!,
      textOnLight: Color.lerp(textOnLight, other.textOnLight, t)!,
      subtle: Color.lerp(subtle, other.subtle, t)!,
    );
  }
}

/// Motion characteristics extension so widgets can query global animation preferences.
class SutraMotion extends ThemeExtension<SutraMotion> {
  final Duration short;
  final Duration medium;
  final Duration long;
  final Curve entrance;
  final Curve exit;
  final Curve emphasized;

  const SutraMotion({
    this.short = const Duration(milliseconds: 180),
    this.medium = const Duration(milliseconds: 360),
    this.long = const Duration(milliseconds: 650),
    this.entrance = Curves.easeOutCubic,
    this.exit = Curves.easeInCubic,
    this.emphasized = Curves.easeOutBack,
  });

  @override
  ThemeExtension<SutraMotion> copyWith({
    Duration? short,
    Duration? medium,
    Duration? long,
    Curve? entrance,
    Curve? exit,
    Curve? emphasized,
  }) =>
      SutraMotion(
        short: short ?? this.short,
        medium: medium ?? this.medium,
        long: long ?? this.long,
        entrance: entrance ?? this.entrance,
        exit: exit ?? this.exit,
        emphasized: emphasized ?? this.emphasized,
      );

  @override
  ThemeExtension<SutraMotion> lerp(
      ThemeExtension<SutraMotion>? other, double t) {
    if (other is! SutraMotion) return this;
    return SutraMotion(
      short: Duration(
          milliseconds: (short.inMilliseconds +
                  (other.short.inMilliseconds - short.inMilliseconds) * t)
              .round()),
      medium: Duration(
          milliseconds: (medium.inMilliseconds +
                  (other.medium.inMilliseconds - medium.inMilliseconds) * t)
              .round()),
      long: Duration(
          milliseconds: (long.inMilliseconds +
                  (other.long.inMilliseconds - long.inMilliseconds) * t)
              .round()),
      entrance: entrance,
      exit: exit,
      emphasized: emphasized,
    );
  }
}

SutraColors _paletteFor(ThemeVariant variant, Brightness brightness) {
  final light = brightness == Brightness.light;
  switch (variant) {
    case ThemeVariant.classic:
      return light
          ? const SutraColors(
              gradientStart: Color(0xFFEEE6D3),
              gradientEnd: Color(0xFFF8F2E5),
              surface: Colors.white,
              accent: AppColors.gold,
              accentAlt: Color(0xFFE6D8AF),
              textOnDark: AppColors.indigoDeep,
              textOnLight: AppColors.indigoDeep,
              subtle: Color(0xFFBCA77A),
            )
          : const SutraColors(
              gradientStart: AppColors.indigoDeep,
              gradientEnd: AppColors.indigoDarker,
              surface: AppColors.parchment,
              accent: AppColors.gold,
              accentAlt: Color(0xFFF5E4B8),
              textOnDark: AppColors.parchment,
              textOnLight: AppColors.indigoDeep,
              subtle: Color(0xFFBCA77A),
            );
    case ThemeVariant.emeraldDawn:
      return light
          ? const SutraColors(
              gradientStart: Color(0xFFE6F8EF),
              gradientEnd: Color(0xFFD2F1E1),
              surface: Colors.white,
              accent: Color(0xFF1F9A60),
              accentAlt: Color(0xFFA8E6C5),
              textOnDark: Color(0xFF063D2B),
              textOnLight: Color(0xFF063D2B),
              subtle: Color(0xFF4E7F66),
            )
          : const SutraColors(
              gradientStart: Color(0xFF063D2B),
              gradientEnd: Color(0xFF012016),
              surface: Color(0xFFE9F6EC),
              accent: Color(0xFF2BB673),
              accentAlt: Color(0xFFA8E6C5),
              textOnDark: Color(0xFFE9F6EC),
              textOnLight: Color(0xFF063D2B),
              subtle: Color(0xFF4E7F66),
            );
    case ThemeVariant.crimsonLotus:
      return light
          ? const SutraColors(
              gradientStart: Color(0xFFFFE8EC),
              gradientEnd: Color(0xFFFFF5F7),
              surface: Colors.white,
              accent: Color(0xFFD32749),
              accentAlt: Color(0xFFFF9BAE),
              textOnDark: Color(0xFF4C0015),
              textOnLight: Color(0xFF4C0015),
              subtle: Color(0xFFB05C6F),
            )
          : const SutraColors(
              gradientStart: Color(0xFF4C0015),
              gradientEnd: Color(0xFF120007),
              surface: Color(0xFFFFF3F5),
              accent: Color(0xFFE63B5B),
              accentAlt: Color(0xFFFF9BAE),
              textOnDark: Color(0xFFFFF3F5),
              textOnLight: Color(0xFF4C0015),
              subtle: Color(0xFFB05C6F),
            );
    case ThemeVariant.nightSapphire:
      return light
          ? const SutraColors(
              gradientStart: Color(0xFFE6F0FF),
              gradientEnd: Color(0xFFF6F9FF),
              surface: Colors.white,
              accent: Color(0xFF2F78E5),
              accentAlt: Color(0xFFA5CFFF),
              textOnDark: Color(0xFF03152F),
              textOnLight: Color(0xFF03152F),
              subtle: Color(0xFF5E7BA8),
            )
          : const SutraColors(
              gradientStart: Color(0xFF041B3D),
              gradientEnd: Color(0xFF010A17),
              surface: Color(0xFFF2F6FF),
              accent: Color(0xFF3F8CFF),
              accentAlt: Color(0xFFA5CFFF),
              textOnDark: Color(0xFFF2F6FF),
              textOnLight: Color(0xFF03152F),
              subtle: Color(0xFF5E7BA8),
            );
  }
}

ThemeData buildAppTheme(ThemeVariant variant,
    {Brightness brightness = Brightness.dark}) {
  final isDark = brightness == Brightness.dark;
  final base = (isDark
      ? ThemeData.dark(useMaterial3: false)
      : ThemeData.light(useMaterial3: false));
  final headingFont = GoogleFonts.playfairDisplay();
  // Gujarati font loaded on demand via helper; no direct reference needed here.
  final bodyFont = GoogleFonts.nunito();
  final ext = _paletteFor(variant, brightness);

  return base
      .copyWith(
        scaffoldBackgroundColor: ext.gradientStart,
        colorScheme: base.colorScheme.copyWith(
          primary: ext.accent,
          secondary: ext.accent,
          surface: ext.surface,
          onPrimary: ext.textOnDark,
          onSurface: ext.textOnLight,
        ),
        textTheme: TextTheme(
          displayLarge: headingFont.copyWith(
              fontSize: 42, fontWeight: FontWeight.w600, color: ext.textOnDark),
          displayMedium: headingFont.copyWith(
              fontSize: 34, fontWeight: FontWeight.w600, color: ext.textOnDark),
          displaySmall: headingFont.copyWith(
              fontSize: 28, fontWeight: FontWeight.w600, color: ext.textOnDark),
          headlineMedium: headingFont.copyWith(
              fontSize: 24, fontWeight: FontWeight.w600, color: ext.textOnDark),
          headlineSmall: headingFont.copyWith(
              fontSize: 20, fontWeight: FontWeight.w600, color: ext.textOnDark),
          titleLarge: headingFont.copyWith(
              fontSize: 20, fontWeight: FontWeight.w500, color: ext.textOnDark),
          bodyLarge: bodyFont.copyWith(fontSize: 16, color: ext.textOnDark),
          bodyMedium: bodyFont.copyWith(fontSize: 14, color: ext.textOnDark),
          bodySmall: bodyFont.copyWith(
              fontSize: 12,
              color: ext.textOnDark.withAlpha((255 * .85).round())),
          labelLarge: bodyFont.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ext.textOnLight),
        ),
        extensions: [ext, const SutraMotion()],
        cardTheme: CardThemeData(
          color: ext.surface,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          shadowColor: ext.accent.withAlpha((255 * .25).round()),
          margin: const EdgeInsets.all(0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ext.surface.withAlpha((255 * .12).round()),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: ext.accent.withAlpha((255 * .4).round())),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: ext.accent.withAlpha((255 * .4).round())),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ext.accent, width: 1.4),
          ),
          hintStyle: bodyFont.copyWith(
              color: ext.textOnDark.withAlpha((255 * .5).round())),
          labelStyle: bodyFont.copyWith(color: ext.textOnDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ext.accent,
            foregroundColor: ext.textOnLight,
            minimumSize: const Size.fromHeight(56),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            textStyle:
                headingFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      )
      .copyWith(
        // custom Gujarati style accessible via Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: ...)
        // Provide a dedicated style for Gujarati text.
        textSelectionTheme: TextSelectionThemeData(cursorColor: ext.accent),
      );
}

TextStyle gujaratiStyle([Color? color]) => GoogleFonts.notoSansGujarati(
      fontSize: 20,
      height: 1.3,
      color: color ?? AppColors.indigoDeep,
      fontWeight: FontWeight.w600,
    );
