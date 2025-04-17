import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_response.dart';
import '../models/user_data.dart';

class AuthStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  // Save auth data
  static Future<void> saveAuthData(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, response.token);
    await prefs.setString(_userDataKey, jsonEncode({
      'user_id': response.user.userId,
      'username': response.user.username,
      'email': response.user.email,
      'full_name': response.user.fullName,
      'permissions': response.user.permissions,
      'employee_id': response.user.employeeId,
      'job_title': response.user.jobTitle
    }));
  }

  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get stored user data
  static Future<UserData?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      return UserData.fromJson(userData);
    }
    return null;
  }

  // Clear stored auth data (for logout)
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}