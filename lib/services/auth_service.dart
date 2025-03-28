import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/user_type.dart';

class AuthService {
  static const String _loggedInKey = 'isLoggedIn';
  static const String _userTypeKey = 'userType'; // Key to store user type

  // Save logged-in status
  static Future<void> saveLoggedInStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, isLoggedIn);
  }

  // Save phone number
  static Future<void> savePhoneNumber(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phone);
  }

  // Get logged-in status
  static Future<bool> getLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false; // Default to false if not set
  }

  // Save user type
  static Future<void> saveUserType(UserType userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userTypeKey, userType.index); // Save enum index
  }

  // Get user type
  static Future<UserType?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeIndex = prefs.getInt(_userTypeKey); // Retrieve enum index
    if (userTypeIndex == null) return null; // Return null if not set
    return UserType.values[userTypeIndex]; // Convert index back to enum
  }

  // Clear logged-in status and user type
  static Future<void> clearLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
    await prefs.remove(_userTypeKey);
  }
}
