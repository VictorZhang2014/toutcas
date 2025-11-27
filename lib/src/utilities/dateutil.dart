

class DateUtil {

  // The output looks like '2025-11-27_12-30-54-123'
  static String getFormattedDateNow() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    String three(int n) => n.toString().padLeft(3, '0');
    return '${now.year}-${two(now.month)}-${two(now.day)}_${two(now.hour)}-${two(now.minute)}-${two(now.second)}-${three(now.millisecond)}';
  }

}