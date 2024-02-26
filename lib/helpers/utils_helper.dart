class UtilsHelper {
  static bool isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str.toString()) != null;
  }
}
