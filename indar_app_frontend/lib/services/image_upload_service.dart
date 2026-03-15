import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {

  static const String cloudName = "dcbch3p55";
  static const String uploadPreset = "interior_ai_upload";

  static Future<String?> uploadImage(XFile image) async {

    try {

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
        ),
      );

      request.fields['upload_preset'] = uploadPreset;

      /// WEB
      if (kIsWeb) {

        final bytes = await image.readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: image.name,
          ),
        );

      } 

      /// MOBILE
      else {

        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            image.path,
          ),
        );

      }

      var response = await request.send();

      if (response.statusCode != 200) {
        print("Cloudinary upload failed");
        return null;
      }

      var responseData = await response.stream.bytesToString();

      var data = jsonDecode(responseData);

      return data["secure_url"];

    } catch (e) {

      print("Upload error: $e");
      return null;

    }
  }
}