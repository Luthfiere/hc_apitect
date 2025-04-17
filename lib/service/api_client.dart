import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  ApiClient._internal();

  // GET request
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

  // POST request
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

  // PUT request
  Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
        headers: _mergeHeaders(headers),
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/$endpoint'),
        headers: _mergeHeaders(headers),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  // Header merger
  Map<String, String> _mergeHeaders(Map<String, String>? additionalHeaders) {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      ...ApiConfig.headers,
    };
    if (additionalHeaders != null) {
      defaultHeaders.addAll(additionalHeaders);
    }
    return defaultHeaders;
  }

  // Handle response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty ? json.decode(response.body) : {};
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception(
          '${response.statusCode}: ${body['message'] ?? 'Unknown error'}');
    }
  }
}
