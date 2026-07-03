import 'package:flutter/material.dart';
import 'property.dart';

class PropertiesProvider extends ChangeNotifier {
  final List<Property> _properties = [];

  List<Property> get properties => List.unmodifiable(_properties);

  void addProperty(Property property) {
    _properties.add(property);
    notifyListeners();
  }

  void updateProperty(String id, Property updated) {
    final index = _properties.indexWhere((p) => p.id == id);
    if (index == -1) return;

    _properties[index] = updated;
    notifyListeners();
  }

  void deleteProperty(String id) {
    _properties.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  Property? getById(String id) {
    try {
      return _properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}