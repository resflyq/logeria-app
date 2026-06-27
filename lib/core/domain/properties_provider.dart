import 'package:flutter/material.dart';

// Имя класса с большой буквы: PropertiesProvider
class propertiesProvider extends ChangeNotifier {
  final List<String> _properties = [];

  List<String> get properties => List.unmodifiable(_properties);

  void addProperty(String text) {
    if (text.trim().isNotEmpty) {
      _properties.add(text);
      notifyListeners(); 
    }
  }

  void updateProperty(int index, String newText) {
    if (newText.trim().isNotEmpty) {
      _properties[index] = newText;
      notifyListeners();
    }
  }

  void deleteProperty(int index) {
    _properties.removeAt(index);
    notifyListeners();
  }
}
