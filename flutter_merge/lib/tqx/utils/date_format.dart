
class DateUtils {

  static DateTime string2Date(String dateStr) {
    assert(dateStr != null);
    return DateTime.parse(dateStr);
  }

  /**
   * yyyy.MM.dd
   */
  static String date2String(DateTime date) {
    final sb = StringBuffer();
    sb.write(_digits(date.year, 4));
    sb.write('.');
    sb.write(_digits(date.month, 2));
    sb.write('.');
    sb.write(_digits(date.day, 2));
    return sb.toString();
  }

  // length不足，前面补0
  static String _digits(int value, int length) {
    String ret = '$value';
    if (ret.length < length) {
      ret = '0' * (length - ret.length) + ret;
    }
    return ret;
  }
}