String formatApiDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

DateTime? parseApiDate(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }

  try {
    return DateTime.parse(value);
  } catch (_) {
    return null;
  }
}
