import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:secondly/service/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/user_data.dart';
import '../models/login_response.dart';
import '../config/api_config.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _persistLoginKey = 'persist_login';
  static const String _platformKey = 'login_platform';

  static final _apiClient = ApiClient();

  // Private constructor to prevent instantiation
  AuthService._();

  static UserData? _currentUser;
  static String? _authToken;

  // Getter for current user
  static UserData? get currentUser => _currentUser;

  // Getter for auth token
  static String? get authToken => _authToken;

  static bool _initialized = false;

  /// Initialize auth state with error handling
  static Future<void> init() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if we should persist login
      final shouldPersist = prefs.getBool(_persistLoginKey) ?? true;
      if (!shouldPersist) {
        await logout();
        return;
      }

      // Get stored token
      _authToken = prefs.getString(_tokenKey);

      // Get stored user data
      final userDataString = prefs.getString(_userDataKey);
      if (userDataString != null) {
        try {
          _currentUser = UserData.fromJson(jsonDecode(userDataString));
        } catch (e) {
          print('Error parsing stored user data: $e');
          await prefs.remove(_userDataKey);
          _currentUser = null;
        }
      }

      _initialized = true;
    } catch (e) {
      print('Auth initialization error: $e');
      _authToken = null;
      _currentUser = null;
      rethrow;
    }
  }

  // Login with persist option
  static Future<LoginResponse> login(String username, String password,
      {bool persist = true}) async {
    try {
      if (ApiConfig.isDevelopment &&
          username == 'admin' &&
          password == 'admin') {
        return await _handleAdminLogin();
      }

      final response = await _apiClient.post(
        'auth.php?action=login',
        body: {
          'username': username,
          'password': password,
        },
      );

      final loginResponse = LoginResponse.fromJson(response);

      if (loginResponse.success) {
        await _saveAuthData(loginResponse, persist);
      }

      return loginResponse;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Check if token is expired
  static bool isTokenExpired(String token) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final expiration =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      return DateTime.now().isAfter(expiration);
    } catch (e) {
      print('Error decoding token: $e');
      return true;
    }
  }

  // Check if token will expire soon (within 5 minutes)
  static bool willTokenExpireSoon(String token) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final expiration =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
      return fiveMinutesFromNow.isAfter(expiration);
    } catch (e) {
      return true;
    }
  }

  // Refresh token
  static Future<bool> refreshToken() async {
    try {
      final response = await _apiClient.post(
        'auth.php?action=refresh',
        headers: {'Authorization': 'Bearer $_authToken'},
      );

      if (response['success'] == true && response['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        _authToken = response['token'];
        await prefs.setString(_tokenKey, _authToken!);
        return true;
      }
      return false;
    } catch (e) {
      print('Token refresh failed: $e');
      return false;
    }
  }

  /// Validate token
  static Future<bool> validateToken() async {
    if (_authToken == null) return false;

    try {
      final response = await _apiClient.post(
        'auth.php?action=validate',
        headers: {'Authorization': 'Bearer $_authToken'},
      );

      return response['success'] ?? false;
    } catch (e) {
      await logout();
      return false;
    }
  }

  // Modified isLoggedIn to handle token expiration
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString(_tokenKey);

      if (_authToken == null) return false;

      // If token is expired, try to refresh it
      if (isTokenExpired(_authToken!)) {
        final refreshed = await refreshToken();
        if (!refreshed) {
          await logout();
          return false;
        }
      }
      // If token will expire soon, refresh in background
      else if (willTokenExpireSoon(_authToken!)) {
        refreshToken(); // Don't await this
      }

      return true;
    } catch (e) {
      print('Error checking login state: $e');
      return false;
    }
  }

  /// Get current user data
  static Future<UserData?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    return await getStoredUserData();
  }

  /// Get stored user data
  static Future<UserData?> getStoredUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userDataKey);

      if (userDataString != null) {
        _currentUser = UserData.fromJson(jsonDecode(userDataString));
        return _currentUser;
      }
    } catch (e) {
      await logout();
    }
    return null;
  }

  /// Update user data
  static Future<void> updateUserData(UserData userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, jsonEncode(userData.toJson()));
      _currentUser = userData;
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  /// Logout
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userDataKey);
      await prefs.remove(_tokenKey);
      await prefs.remove(_userDataKey);
      await prefs.remove(_platformKey);

      _authToken = null;
      _currentUser = null;
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  /// Handle admin login for development
  static Future<LoginResponse> _handleAdminLogin() async {
    final dummyUserData = UserData(
      userId: 1,
      username: 'admin',
      email: 'admin@example.com',
      fullName: 'Admin User',
      permissions: ['all_access', 'admin'],
      jobTitle: 'DEVELOPER',
      employeeId: 0,
    );

    final dummyResponse = LoginResponse(
      success: true,
      token: 'dummy_admin_token',
      user: dummyUserData,
    );

    await _saveAuthData(dummyResponse, true);
    return dummyResponse;
  }

  // Save authentication data
  static Future<void> _saveAuthData(
      LoginResponse loginResponse, bool persist) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save persistence preference
      await prefs.setBool(_persistLoginKey, persist);

      // Save auth data
      await prefs.setString(_tokenKey, loginResponse.token);
      await prefs.setString(
          _userDataKey, jsonEncode(loginResponse.user.toJson()));

      _authToken = loginResponse.token;
      _currentUser = loginResponse.user;
      _initialized = true;
    } catch (e) {
      throw Exception('Failed to save auth data: $e');
    }
  }

  // Check for internet connection
  static Future<bool> _hasInternetConnection() async {
    try {
      // Add your preferred connectivity check here
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Handle authentication errors
  static Exception _handleAuthError(dynamic error) {
    if (error is Exception) {
      if (error.toString().contains('Connection refused') ||
          error.toString().contains('SocketException')) {
        return Exception(
            'Unable to connect to server. Please check your internet connection.');
      }
      if (error.toString().contains('401')) {
        return Exception('Invalid username or password.');
      }
    }
    return Exception('Authentication failed: ${error.toString()}');
  }

  static Future<String?> getLastLoginPlatform() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_platformKey);
    } catch (e) {
      print('Error getting login platform: $e');
      return null;
    }
  }
}
