// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'services/deep_link_service.dart';

const SUPABASE_URL = String.fromEnvironment('SUPABASE_URL');
const SUPABASE_ANON_KEY = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabaseUrl = SUPABASE_URL.trim();
  final supabaseAnonKey = SUPABASE_ANON_KEY.trim();

  if (supabaseUrl.isEmpty) {
    runApp(const MissingSupabaseConfigApp(
      missingField: 'SUPABASE_URL is missing or blank.',
    ));
    return;
  }

  if (supabaseAnonKey.isEmpty) {
    runApp(const MissingSupabaseConfigApp(
      missingField: 'SUPABASE_ANON_KEY is missing or blank.',
    ));
    return;
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  // Start deep link listener (non-intrusive)
  DeepLinkService.instance.start();
  runApp(const WisdomSutraApp());
}

class MissingSupabaseConfigApp extends StatelessWidget {
  const MissingSupabaseConfigApp({
    super.key,
    required this.missingField,
  });

  final String missingField;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WisdomSutra – Configuration Required',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF131A2F),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Supabase configuration missing',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      missingField,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Provide SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define when running or building the app.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Example:\nflutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
