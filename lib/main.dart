// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logeria/app/app.dart';
import 'core/domain/properties_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PropertiesProvider(), 
      child: const App(),
    ),
  );
}