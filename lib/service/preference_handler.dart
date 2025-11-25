import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyUserEmail = 'userEmail';
  static const String keyUserRole = 'userRole';

  /// Simpan status login
  static Future<void> saveLogin(String? email, String? role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', email ?? '');
    await prefs.setString('role', role ?? '');
  }

  /// Cek apakah user sudah login
  static Future<bool> isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(keyIsLoggedIn) ?? false;
  }

  /// Ambil email user
  static Future<String?> getUserEmail() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(keyUserEmail);
  }

  /// Ambil role user
  static Future<String?> getUserRole() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(keyUserRole);
  }

  /// Hapus data login (logout)
  static Future<void> clearLogin() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
