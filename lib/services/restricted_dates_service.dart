import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/restricted_day.dart';

class RestrictedDatesService {
  const RestrictedDatesService();

  SupabaseClient get _client => Supabase.instance.client;

  Future<List<RestrictedDay>> fetchRestrictedDates() async {
    final response = await _client
        .from('restricted_dates')
        .select('month, day')
        .order('month')
        .order('day');

    return (response as List)
        .map((row) => RestrictedDay.fromSupabase(row as Map<String, dynamic>))
        .toList(growable: false);
  }
}
