import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {

  static const String backendUrl = 'http://192.168.1.103:8000/generate';

  static Future<String?> generateImage({
    required String prompt,
    required String imageUrl,
  }) async {

    try {

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "imageUrl": imageUrl,
          "prompt": prompt,
        }),
      );

      if (response.statusCode != 200) {
        print("Backend error: ${response.body}");
        return null;
      }

      final data = jsonDecode(response.body);

      return data["image"];

    } catch (e) {

      print("AIService error: $e");
      return null;

    }
  }
}