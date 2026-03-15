import 'package:flutter/material.dart';

class ThemeProviderModel extends ChangeNotifier {

  String? theme;
  String? description;

  void setTheme(String newTheme, String newDescription) {
    theme = newTheme;
    description = newDescription;
    notifyListeners();
  }
}