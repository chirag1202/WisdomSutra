import 'package:supabase_flutter/supabase_flutter.dart';

class AnswerService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String?> fetchAnswer(
      {required int questionId, required String pattern}) async {
    try {
      final data = await _client
          .from('answers')
          .select('answer_text')
          .eq('question_id', questionId)
          .eq('pattern', pattern)
          .maybeSingle();
      final map = (data as Map?)?.cast<String, dynamic>();
      if (map != null && map['answer_text'] is String) {
        return map['answer_text'] as String;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
