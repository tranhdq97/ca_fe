import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const String _loginTypeKey = 'login_type';

  // Singleton pattern
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  // Get SharedPreferences instance
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // Save user data
  Future<bool> saveUser(Map<String, dynamic> userData) async {
    final prefs = await _prefs;
    return prefs.setString(_userKey, jsonEncode(userData));
  }

  // Get user data
  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await _prefs;
    final userData = prefs.getString(_userKey);

    if (userData != null) {
      return jsonDecode(userData) as Map<String, dynamic>;
    }

    return null;
  }

  // Save auth token
  Future<bool> saveToken(String token) async {
    final prefs = await _prefs;
    return prefs.setString(_tokenKey, token);
  }

  // Get auth token
  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }

  // Save login type (client or store)
  Future<bool> saveLoginType(String type) async {
    final prefs = await _prefs;
    return prefs.setString(_loginTypeKey, type);
  }

  // Get login type
  Future<String?> getLoginType() async {
    final prefs = await _prefs;
    return prefs.getString(_loginTypeKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Clear all stored data on logout
  Future<bool> clearAll() async {
    final prefs = await _prefs;
    return prefs.clear();
  }
}
