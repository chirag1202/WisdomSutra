import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  const AuthService();

  SupabaseClient get _client => Supabase.instance.client;

  Session? get currentSession => _client.auth.currentSession;

  Future<AuthResponse> signInWithPassword(
      {required String email, required String password}) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(
      {required String email, required String password}) {
    final redirect =
        kIsWeb ? Uri.base.toString() : 'wisdomsutra://login-callback';
    return _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: redirect,
    );
  }

  Future<void> signOut() {
    return _client.auth.signOut();
  }
}
