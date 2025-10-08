import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported language codes in the app UI.
enum AppLanguage { en, hi, mr, gu, bn }

extension AppLanguageX on AppLanguage {
  String get code => name; // identical names (en, hi, mr, gu, bn)
  String get label => switch (this) {
        AppLanguage.en => 'English',
        AppLanguage.hi => 'Hindi',
        AppLanguage.mr => 'Marathi',
        AppLanguage.gu => 'Gujarati',
        AppLanguage.bn => 'Bengali',
      };
}

class AppState extends ChangeNotifier {
  AppLanguage _language = AppLanguage.en;
  final Set<String> _favoritePatterns = {};
  Map<String, dynamic> _answers = {}; // pattern -> { 'en': 'text', ... }
  final Map<AppLanguage, List<String>> _questions = {};
  bool _initialized = false;

  bool get initialized => _initialized;
  AppLanguage get language => _language;
  List<String> get questions => _questions[_language] ?? const [];
  bool isFavorite(String pattern) => _favoritePatterns.contains(pattern);
  Map<String, dynamic>? answerForPattern(String pattern) => _answers[pattern];
  Iterable<String> get favorites => _favoritePatterns;

  Future<void> initialize() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('app_lang');
    if (savedLang != null) {
      _language = AppLanguage.values.firstWhere(
        (e) => e.code == savedLang,
        orElse: () => AppLanguage.en,
      );
    }
    _favoritePatterns.addAll(prefs.getStringList('favs') ?? const []);
    await _loadData();
    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadData() async {
    Future<List<String>> loadQ(String path) async =>
        (json.decode(await rootBundle.loadString(path)) as List).cast<String>();
    _questions[AppLanguage.en] = await loadQ('assets/data/questions_en.json');
    _questions[AppLanguage.gu] = await loadQ('assets/data/questions_gu.json');
    _questions[AppLanguage.hi] = await loadQ('assets/data/questions_hi.json');
    _questions[AppLanguage.mr] = await loadQ('assets/data/questions_mr.json');
    _questions[AppLanguage.bn] = await loadQ('assets/data/questions_bn.json');
    final ans = await rootBundle.loadString('assets/data/answers.json');
    _answers = json.decode(ans) as Map<String, dynamic>;
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_lang', lang.code);
    notifyListeners();
  }

  Future<void> toggleFavorite(String pattern) async {
    if (_favoritePatterns.contains(pattern)) {
      _favoritePatterns.remove(pattern);
    } else {
      _favoritePatterns.add(pattern);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favs', _favoritePatterns.toList());
    notifyListeners();
  }
}
