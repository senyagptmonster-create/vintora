import 'package:flutter/material.dart';
import 'theme/vintora_theme.dart';
import 'screens/brew_dashboard_screen.dart';

void main() {
  runApp(const VintoraApp());
}

class VintoraApp extends StatelessWidget {
  const VintoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vintora Brew',
      debugShowCheckedModeBanner: false,
      theme: VintoraTheme.themeData,
      home: const BrewDashboardScreen(),
    );
  }
}
