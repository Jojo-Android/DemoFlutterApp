import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  static const _keyEmail = 'loggedInEmail';

  static Future<void> setLoggedInEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
  }

  static Future<String?> getLoggedInEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<void> removeLoggedInEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    // ถ้ามี key อื่นก็ค่อยเพิ่มตรงนี้
    // await prefs.remove('authToken');
    // await prefs.remove('userId');
  }

  static Future<bool> isLoggedIn() async {
    final email = await getLoggedInEmail();
    return email != null && email.isNotEmpty;
  }
}
