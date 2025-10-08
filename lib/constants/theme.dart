import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: false);
  final headingFont = GoogleFonts.playfairDisplay();
  // Gujarati font loaded on demand via helper; no direct reference needed here.
  final bodyFont = GoogleFonts.nunito();

  return base
      .copyWith(
        scaffoldBackgroundColor: AppColors.indigoDeep,
        colorScheme: base.colorScheme.copyWith(
          primary: AppColors.gold,
          secondary: AppColors.gold,
          surface: AppColors.parchment,
          onPrimary: Colors.black,
          onSurface: AppColors.indigoDeep,
        ),
        textTheme: TextTheme(
          displayLarge: headingFont.copyWith(
              fontSize: 42,
              fontWeight: FontWeight.w600,
              color: AppColors.parchment),
          displayMedium: headingFont.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: AppColors.parchment),
          displaySmall: headingFont.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.parchment),
          headlineMedium: headingFont.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.parchment),
          headlineSmall: headingFont.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.parchment),
          titleLarge: headingFont.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.parchment),
          bodyLarge:
              bodyFont.copyWith(fontSize: 16, color: AppColors.parchment),
          bodyMedium:
              bodyFont.copyWith(fontSize: 14, color: AppColors.parchment),
          bodySmall: bodyFont.copyWith(
              fontSize: 12, color: AppColors.parchment.withOpacity(.85)),
          labelLarge: bodyFont.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.indigoDeep),
        ),
        extensions: const [],
        cardTheme: CardThemeData(
          color: AppColors.parchment,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          shadowColor: AppColors.gold.withOpacity(.25),
          margin: const EdgeInsets.all(0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.parchment.withOpacity(.12),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.gold.withOpacity(.4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.gold.withOpacity(.4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
          ),
          hintStyle:
              bodyFont.copyWith(color: AppColors.parchment.withOpacity(.5)),
          labelStyle: bodyFont.copyWith(color: AppColors.parchment),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: Colors.black,
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
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: AppColors.gold),
      );
}

TextStyle gujaratiStyle([Color? color]) => GoogleFonts.notoSansGujarati(
      fontSize: 20,
      height: 1.3,
      color: color ?? AppColors.indigoDeep,
      fontWeight: FontWeight.w600,
    );
