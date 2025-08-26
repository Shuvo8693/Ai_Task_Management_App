// lib/data/datasources/local/auth_local_data_source.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _emailKey = 'user_email';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _tokenExpiryKey = 'token_expiry';

  Future<void> saveAuthData(String token, String userId, String email, {Duration? expiry}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_emailKey, email);

    if (expiry != null) {
      final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
      await prefs.setInt(_tokenExpiryKey, expiryTime);
    }

    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<Map<String, dynamic>> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userId = prefs.getString(_userIdKey);
    final email = prefs.getString(_emailKey);
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

    return {
      'token': token,
      'userId': userId,
      'email': email,
      'isLoggedIn': isLoggedIn,
    };
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_tokenExpiryKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Helper methods
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = prefs.getInt(_tokenExpiryKey);

    if (expiryTime == null) return true; // No expiry set, assume valid

    return DateTime.now().millisecondsSinceEpoch < expiryTime;
  }
}