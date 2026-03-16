import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  // Android emulator uses 10.0.2.2 to reach your machine's localhost
  static const String baseUrl = 'http://10.0.2.2:8000';

  static String? get _token =>
      Supabase.instance.client.auth.currentSession?.accessToken;

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  

 static Future<dynamic> get(String path) async {
  final token = _token;
  print('API GET $path | token: ${token?.substring(0, 20)}...');
  
  if (token == null) {
    print('ERROR: No token available');
    throw ApiException(statusCode: 401, message: 'No token');
  }

  final resp = await http.get(
    Uri.parse('$baseUrl$path'),
    headers: _headers,
  );
  print('API Response: ${resp.statusCode} for $path');
  return _handle(resp);
}

  static Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final resp = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handle(resp);
  }

  static Future<dynamic> patch(String path, {Map<String, dynamic>? body}) async {
    final resp = await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handle(resp);
  }

  static dynamic _handle(http.Response resp) {
    final data = jsonDecode(resp.body);
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return data;
    }
    throw ApiException(
      statusCode: resp.statusCode,
      message: data['detail'] ?? 'Something went wrong.',
    );
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}