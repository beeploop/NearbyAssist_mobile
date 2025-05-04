bool isPreviousDay(DateTime timestamp) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final inputDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

  if (inputDate.isAfter(today)) {
    return false;
  }

  if (inputDate.isAtSameMomentAs(today)) {
    return false;
  }

  return true;
}
