import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageProviderModel extends ChangeNotifier {

  XFile? selectedImage;

  void setImage(XFile image) {
    selectedImage = image;
    notifyListeners();
  }

  XFile? get image => selectedImage;
}