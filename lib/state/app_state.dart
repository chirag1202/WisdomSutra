import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/theme.dart';
import '../services/question_service.dart';

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
  final Map<AppLanguage, List<QuestionItem>> _questions = {};
  bool _initialized = false;
  String? _userName;

  // Random selections cache per language
  final Map<AppLanguage, List<QuestionItem>> _randomSelections = {};

  // Theme variant
  ThemeVariant _themeVariant = ThemeVariant.classic;
  Brightness? _brightnessOverride; // null => follow system

  bool get initialized => _initialized;
  AppLanguage get language => _language;
  String? get userName => _userName;
  // New typed getters including IDs
  List<QuestionItem> get questionsWithIds => _questions[_language] ?? const [];
  List<QuestionItem> get randomQuestionsWithIds =>
      _randomSelections[_language] ?? const [];
  // Back-compat string-only getters (derived)
  List<String> get questions =>
      (_questions[_language] ?? const []).map((q) => q.text).toList();
  List<String> get randomQuestions =>
      (_randomSelections[_language] ?? const []).map((q) => q.text).toList();
  ThemeVariant get themeVariant => _themeVariant;
  Brightness? get brightnessOverride => _brightnessOverride;
  bool isFavorite(String pattern) => _favoritePatterns.contains(pattern);
  Map<String, dynamic>? answerForPattern(String pattern) => _answers[pattern];
  Iterable<String> get favorites => _favoritePatterns;

  Future<void> initialize() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('app_lang');
    final savedTheme = prefs.getString('theme_variant');
    final savedBrightness = prefs.getString('brightness_override');
    _userName = prefs.getString('user_name');
    if (savedLang != null) {
      _language = AppLanguage.values.firstWhere(
        (e) => e.code == savedLang,
        orElse: () => AppLanguage.en,
      );
    }
    if (savedTheme != null) {
      _themeVariant = ThemeVariant.values.firstWhere(
        (e) => e.id == savedTheme,
        orElse: () => ThemeVariant.classic,
      );
    }
    if (savedBrightness != null) {
      switch (savedBrightness) {
        case 'light':
          _brightnessOverride = Brightness.light;
          break;
        case 'dark':
          _brightnessOverride = Brightness.dark;
          break;
        default:
          _brightnessOverride = null;
      }
    }
    _favoritePatterns.addAll(prefs.getStringList('favs') ?? const []);
    await _loadData();
    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadData() async {
    // Try Supabase first
    final supa = QuestionService();
    final supaRows = await supa.fetchQuestionsWithIds();

    if (supaRows.isNotEmpty) {
      // Build typed question list
      final items = <QuestionItem>[];
      for (final row in supaRows) {
        final text = (row['text'] ?? '').toString();
        final id = row['id'];
        if (text.isNotEmpty && (id is int || id is num)) {
          final intId = (id as num).toInt();
          items.add(QuestionItem(id: intId, text: text));
        }
      }
      // Use same list for all languages (no lang column yet)
      for (final lang in AppLanguage.values) {
        _questions[lang] = List<QuestionItem>.from(items);
      }
    } else {
      // Fallback to bundled assets per language
      Future<List<QuestionItem>> loadQ(String path) async =>
          (json.decode(await rootBundle.loadString(path)) as List)
              .cast<String>()
              .map((t) => QuestionItem(id: null, text: t))
              .toList();
      _questions[AppLanguage.en] = await loadQ('assets/data/questions_en.json');
      _questions[AppLanguage.gu] = await loadQ('assets/data/questions_gu.json');
      _questions[AppLanguage.hi] = await loadQ('assets/data/questions_hi.json');
      _questions[AppLanguage.mr] = await loadQ('assets/data/questions_mr.json');
      _questions[AppLanguage.bn] = await loadQ('assets/data/questions_bn.json');
    }

    // Answers remain local for now
    final ans = await rootBundle.loadString('assets/data/answers.json');
    _answers = json.decode(ans) as Map<String, dynamic>;

    // Generate initial random selections for all loaded languages
    for (final lang in _questions.keys) {
      _generateRandomFor(lang);
    }
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    // Ensure we have a random selection for this language
    _randomSelections.putIfAbsent(lang, () => _generateRandomFor(lang));
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

  // Theme handling
  Future<void> setThemeVariant(ThemeVariant variant) async {
    _themeVariant = variant;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_variant', variant.id);
    notifyListeners();
  }

  Future<void> setUserName(String? name) async {
    _userName = name;
    final prefs = await SharedPreferences.getInstance();
    if (name == null) {
      await prefs.remove('user_name');
    } else {
      await prefs.setString('user_name', name);
    }
    notifyListeners();
  }

  Future<void> setBrightnessOverride(Brightness? b) async {
    _brightnessOverride = b;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'brightness_override',
        b == null
            ? 'system'
            : b == Brightness.dark
                ? 'dark'
                : 'light');
    notifyListeners();
  }

  Future<void> cycleBrightness() async {
    if (_brightnessOverride == null) {
      await setBrightnessOverride(Brightness.light);
    } else if (_brightnessOverride == Brightness.light) {
      await setBrightnessOverride(Brightness.dark);
    } else {
      await setBrightnessOverride(null); // back to system
    }
  }

  // Regenerate random questions for current language
  void refreshRandomQuestions() {
    _generateRandomFor(_language, force: true);
    notifyListeners();
  }

  List<QuestionItem> _generateRandomFor(AppLanguage lang,
      {bool force = false}) {
    if (!force && _randomSelections.containsKey(lang)) {
      return _randomSelections[lang]!;
    }
    final list = [...?_questions[lang]]; // copy
    if (list.isEmpty) {
      _randomSelections[lang] = const [];
      return const [];
    }
    final rng = Random();
    // Fisher-Yates partial shuffle for first N items (N=16 or length)
    final n = list.length < 16 ? list.length : 16;
    for (int i = 0; i < n; i++) {
      final j = i + rng.nextInt(list.length - i);
      final tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;
    }
    final selection = list.take(n).toList();
    _randomSelections[lang] = selection;
    return selection;
  }
}

class QuestionItem {
  final int? id;
  final String text;
  const QuestionItem({required this.id, required this.text});
}
