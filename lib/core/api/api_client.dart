import 'dart:convert';
import '../../core/api/api_endpoints.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'api_exception.dart';

class ApiClient {
  final String baseUrl;

  ApiClient({this.baseUrl = ApiEndpoints.baseUrl});

  Future<dynamic> get(String endpoint,
      {Map<String, String>? headers,
      Map<String, String>? queryParameters}) async {
    try {
      var url = Uri.parse('$baseUrl$endpoint');
      if (queryParameters != null) {
        url = url.replace(queryParameters: queryParameters);
      }
      if (AppConfig().enableLogging) {
        print('GET request to: $url');
      }
      final response = await http.get(
        url,
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

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.body}');
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      var url = Uri.parse('$baseUrl$endpoint');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
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
