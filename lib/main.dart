// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'services/deep_link_service.dart';

const SUPABASE_URL = String.fromEnvironment('SUPABASE_URL');
const SUPABASE_ANON_KEY = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (SUPABASE_URL.isEmpty || SUPABASE_ANON_KEY.isEmpty) {
    throw StateError(
      'Missing Supabase configuration. Provide SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
    );
  }
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );
  // Start deep link listener (non-intrusive)
  DeepLinkService.instance.start();
  runApp(const WisdomSutraApp());
}
