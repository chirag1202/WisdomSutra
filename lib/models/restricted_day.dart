class RestrictedDay {
  final int month;
  final int day;
  final String? name;

  const RestrictedDay({
    required this.month,
    required this.day,
    this.name,
  });

  factory RestrictedDay.fromJson(Map<String, dynamic> json) {
    return RestrictedDay(
      month: (json['month'] as num).toInt(),
      day: (json['day'] as num).toInt(),
      name: json['name'] as String?,
    );
  }

  factory RestrictedDay.fromSupabase(Map<String, dynamic> row) {
    return RestrictedDay(
      month: (row['month'] as num).toInt(),
      day: (row['day'] as num).toInt(),
    );
  }

  String get monthName => const [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ][month - 1];

  String get displayLabel =>
      name ?? 'Sacred silence - the lineage keeps the book sealed today.';
}
