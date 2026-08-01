import 'package:flutter/material.dart';
import 'package:logeria/core/database/app_database.dart';
import 'property.dart';

class PropertiesProvider extends ChangeNotifier {
  List<Property> _properties = [];
  List<Property> get properties => List.unmodifiable(_properties);

  PropertiesProvider() {
    loadProperties();
  }

  Future<void> loadProperties() async {
    try {
      final dbProperties = await AppDatabase.instance.readAllProperties();
      _properties = dbProperties;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading data from SQLite: $e");
    }
  }


  Future<void> addProperty(Property property) async {
    _properties.add(property);
    notifyListeners();

    try {
      await AppDatabase.instance.insertOrUpdateProperty(property);
    } catch (e) {
      debugPrint("Error saving to SQLite: $e");
    }
  }

  Future<void> updateProperty(String id, Property updated) async {
    final index = _properties.indexWhere((p) => p.id == id);
    if (index == -1) return;

    _properties[index] = updated;
    notifyListeners();

    try {
      await AppDatabase.instance.insertOrUpdateProperty(updated);
    } catch (e) {
      debugPrint("Error updating SQLite: $e");
    }
  }

  Future<void> deleteProperty(String id) async {
    _properties.removeWhere((p) => p.id == id);
    notifyListeners();

    try {
      await AppDatabase.instance.deleteProperty(id);
    } catch (e) {
      debugPrint("Error deleting from SQLite: $e");
    }
  }

  Property? getById(String id) {
    try {
      return _properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}