import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app.dart';

class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;

  void start() {
    // Initialize app_links and subscribe to link stream
    _appLinks ??= AppLinks();
    // Handle subsequent links
    _sub?.cancel();
    _sub = _appLinks!.uriLinkStream.listen((uri) {
      _handleUri(uri);
    }, onError: (_) {});
  }

  Future<void> _handleUri(Uri uri) async {
    // First, let Supabase try to recover a session from the URL if applicable.
    // This is safe to call even if the URL isn't a Supabase OAuth redirect.
    try {
      Supabase.instance.client.auth.onAuthStateChange; // ensure client ready
      await Supabase.instance.client.auth.getSessionFromUrl(uri);
    } catch (_) {
      // ignore
    }
    // If session now exists, go to Questions
    final nav = WisdomSutraApp.navigatorKey.currentState;
    final session = Supabase.instance.client.auth.currentSession;
    if (nav != null && session != null) {
      nav.pushNamedAndRemoveUntil('/questions', (_) => false);
      return;
    }
    // Otherwise, for our custom callback, ensure we're on Login
    if (uri.scheme == 'wisdomsutra' && uri.host == 'login-callback') {
      if (nav == null) return;
      final currentRoute = ModalRoute.of(nav.context)?.settings.name;
      if (currentRoute != '/questions' && currentRoute != '/login') {
        nav.pushNamedAndRemoveUntil('/login', (_) => false);
      }
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
