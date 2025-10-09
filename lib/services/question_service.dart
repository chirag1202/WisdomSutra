import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<String>> fetchQuestions() async {
    try {
      final data =
          await _client.from('questions').select('text').order('id').limit(200);
      return (data as List)
          .map((row) => (row as Map)['text'] as String?)
          .whereType<String>()
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchQuestionsWithIds() async {
    try {
      final data = await _client
          .from('questions')
          .select('id, text')
          .order('id')
          .limit(200);
      return (data as List)
          .map((row) => (row as Map).cast<String, dynamic>())
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
