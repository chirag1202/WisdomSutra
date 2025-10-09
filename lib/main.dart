// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'services/deep_link_service.dart';

const SUPABASE_URL = 'https://vqcmlvejkujnvikbhipi.supabase.co';
const SUPABASE_ANON_KEY =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxY21sdmVqa3VqbnZpa2JoaXBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5NTE4ODUsImV4cCI6MjA3NTUyNzg4NX0.iPAf1ftEPPLrQWxos049ga_p4Hm2WrelBGo-iAWGyvY';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );
  // Start deep link listener (non-intrusive)
  DeepLinkService.instance.start();
  runApp(const WisdomSutraApp());
}
