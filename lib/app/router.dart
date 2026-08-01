// Navigation rules and routes of the app

import 'package:go_router/go_router.dart';
import 'package:logeria/core/domain/property.dart';
import '../features/shell/shell_page.dart';
import '../features/properties/pages/properties_page.dart';
import '../features/properties/pages/editor_page.dart';

final router = GoRouter(
  initialLocation: '/properties',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ShellPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/properties',
          builder: (context, state) => const PropertiesPage(),
        ),
        GoRoute(
          path: '/editor',
          builder: (context, state) {
            final property = state.extra as Property?; 
            
            return PropertyEditor(initialProperty: property);
          },
        ),
      ],
    ),
  ],
);
