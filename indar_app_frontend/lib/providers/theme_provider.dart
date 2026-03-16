import 'package:flutter/material.dart';

class ThemeProviderModel extends ChangeNotifier {
  String? _selectedTheme;
  String? _description;

  String? get selectedTheme => _selectedTheme;
  String? get description => _description;

  void setTheme(String title, String description) {
    _selectedTheme = title;
    _description = description;
    notifyListeners();
  }

  void clear() {
    _selectedTheme = null;
    _description = null;
    notifyListeners();
  }
}