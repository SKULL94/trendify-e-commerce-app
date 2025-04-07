// services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

abstract class ApiService {
  static const String baseUrl = 'https://fs-ecommerce-app.onrender.com';

  Future<Map<String, dynamic>> handleRequest(
    Future<http.Response> Function() request, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(milliseconds: 500),
  }) async {
    int attempts = 0;
    while (true) {
      try {
        final response = await request();
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        }
        attempts++;
        if (attempts >= maxRetries) break;
        await Future.delayed(retryDelay);
      } on SocketException {
        attempts++;
        if (attempts >= maxRetries) break;
        await Future.delayed(retryDelay);
      }
    }
    throw HttpException('Request failed after $maxRetries attempts');
  }
}
