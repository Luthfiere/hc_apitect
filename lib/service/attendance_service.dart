import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/api_config.dart';
import '../service/auth_service.dart';
import '../service/api_client.dart';

class AttendanceResponse {
  final bool success;
  final String message;

  AttendanceResponse({
    required this.success,
    required this.message,
  });
}

class AttendanceService {
  static final _apiClient = ApiClient();

  static Future<Map<String, dynamic>?> getDailyAttendance(
      int employeeId, String date) async {
    try {
      final token = AuthService.authToken;
      if (token == null) {
        debugPrint('No auth token available');
        return null;
      }

      final response = await _apiClient.post(
        'api_mobile.php?operation=listDailyAttendance',
        body: {
          'employee_id': employeeId,
          'date': date,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response['success'] == true) {
        return response['data'];
      }

      debugPrint('Failed to fetch daily attendance: $response');
      return null;
    } catch (e) {
      debugPrint('Error fetching daily attendance: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getAttendanceData(
      int employeeId, String date) async {
    try {
      final token = AuthService.authToken;
      if (token == null) {
        debugPrint('No auth token available');
        return null;
      }

      final response = await _apiClient.post(
        'api_mobile.php?operation=getAttendance',
        body: {
          'employee_id': employeeId,
          'date': date,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response['success'] == true) {
        return response['data'];
      }

      debugPrint('Failed to fetch attendance: $response');
      return null;
    } catch (e) {
      debugPrint('Error fetching attendance: $e');
      return null;
    }
  }

  static Future<Map<String, String>> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String browser = 'unknown';
    String os = 'unknown';

    try {
      if (kIsWeb) {
        WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
        browser = webInfo.browserName.toString().toLowerCase();
        os = webInfo.platform ?? 'unknown';
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        browser = 'android-webview';
        os = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        browser = 'webkit';
        os = iosInfo.systemName ?? 'iOS';
      }
    } catch (e) {
      debugPrint('Error getting device info: $e');
    }

    return {
      'browser': browser,
      'os': os,
    };
  }

  static Future<AttendanceResponse> recordAttendance({
    required String address,
    required String addressLink,
  }) async {
    try {
      final currentUser = await AuthService.getCurrentUser();
      final token = AuthService.authToken;

      if (currentUser == null || token == null) {
        return AttendanceResponse(
          success: false,
          message: 'User not authenticated. Please log in again.',
        );
      }

      final deviceInfo = await _getDeviceInfo();

      final response = await _apiClient.post(
        'api_mobile.php?operation=recordAttendance',
        body: {
          'employee_id': currentUser.employeeId,
          'address': address,
          'address_link': addressLink,
          'browser': deviceInfo['browser'],
          'os': deviceInfo['os'],
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return AttendanceResponse(
        success: response['success'] ?? false,
        message: response['message'] ?? 'Attendance recorded successfully',
      );
    } catch (e) {
      return AttendanceResponse(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
}
