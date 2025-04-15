import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  // Factory constructor
  factory ApiClient() {
    return _instance;
  }

  // Private constructor
  ApiClient._internal();

  // Generic GET request
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
        headers: _mergeHeaders(headers),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  // Generic POST request
  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
        headers: _mergeHeaders(headers),
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  // Helper to merge headers
  Map<String, String> _mergeHeaders(Map<String, String>? additionalHeaders) {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      ...ApiConfig.headers
    };
    if (additionalHeaders != null) {
      defaultHeaders.addAll(additionalHeaders);
    }
    return defaultHeaders;
  }

  // Handle response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      throw Exception(
          '${response.statusCode}: ${decoded['message'] ?? 'Unknown error'}');
    }
  }
}
