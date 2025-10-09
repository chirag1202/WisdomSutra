import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class AnswerService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String?> fetchAnswer(
      {required int questionId, required String pattern}) async {
    try {
      if (kDebugMode) {
        // Debug log to verify the exact lookup used
        // Ensures we don't rely on any 'page' column
        // and confirms the incoming params
        // ignore: avoid_print
        print('AnswerService: fetchAnswer(qId=$questionId, pattern=$pattern)');
        // ignore: avoid_print
        print('AnswerService: auth user = '
            '${_client.auth.currentUser?.id ?? 'anon'}');
      }
      final data = await _client
          .from('answers')
          .select('answer_text')
          .eq('question_id', questionId)
          .eq('pattern', pattern)
          .maybeSingle();
      final map = (data as Map?)?.cast<String, dynamic>();
      if (map != null && map['answer_text'] is String) {
        if (kDebugMode) {
          // ignore: avoid_print
          print('AnswerService: DB HIT for qId=$questionId, pattern=$pattern');
        }
        return map['answer_text'] as String;
      }
      if (kDebugMode) {
        // ignore: avoid_print
        print('AnswerService: DB MISS for qId=$questionId, pattern=$pattern');
        // If RLS is ON and no SELECT policy, Supabase returns empty results
        // without throwing. This message hints at checking policies.
        // ignore: avoid_print
        print('AnswerService: No row returned. Check if answers has a row for '
            'this (question_id, pattern) and verify SELECT policy/RLS.');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('AnswerService: error fetching answer: $e');
      }
      return null;
    }
  }
}
