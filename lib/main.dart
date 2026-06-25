import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BoliviaQuizApp());
}

class BoliviaQuizApp extends StatelessWidget {
  const BoliviaQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test de Bolivia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
