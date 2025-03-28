import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'api_exception.dart';

class ApiClient {
  final http.Client _httpClient;
  final String baseUrl;

  ApiClient({http.Client? httpClient, String? baseUrl})
    : _httpClient = httpClient ?? http.Client(),
      baseUrl = baseUrl ?? AppConfig().apiBaseUrl;

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      if (AppConfig().enableLogging) {
        print('GET request to: $baseUrl$endpoint');
      }

      final response = await _httpClient.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json', ...?headers},
      );

      if (AppConfig().enableLogging) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      return _handleResponse(response);
    } catch (e) {
      if (AppConfig().enableLogging) {
        print('Error in GET request: $e');
      }
      throw ApiException('Network error: $e');
    }
  }

  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      if (AppConfig().enableLogging) {
        print('POST request to: $baseUrl$endpoint');
        print('Request body: $body');
      }

      final response = await _httpClient.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json', ...?headers},
        body: jsonEncode(body),
      );

      if (AppConfig().enableLogging) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      return _handleResponse(response);
    } catch (e) {
      if (AppConfig().enableLogging) {
        print('Error in POST request: $e');
      }
      throw ApiException('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      final message = body['message'] ?? 'Unknown error occurred';
      throw ApiException(message, statusCode: response.statusCode);
    }
  }
}
