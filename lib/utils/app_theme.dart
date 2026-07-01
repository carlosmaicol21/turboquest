import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales de Bolivia - Paleta profesional mejorada
  static const Color primaryGreen = Color(0xFF006B3F);
  static const Color primaryRed = Color(0xFFD9230F);
  static const Color primaryYellow = Color(0xFFF7B500);
  
  // Colores secundarios - Paleta moderna
  static const Color secondaryBlue = Color(0xFF2E5AAC);
  static const Color secondaryPurple = Color(0xFF6B4C9A);
  static const Color secondaryTeal = Color(0xFF00897B);
  
  // Colores neutros - Sombras y acentos
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color darkGrey = Color(0xFF2C2C2C);
  static const Color lightGrey = Color(0xFFF5F5F5);
  
  // Colores de estado - Mejorados
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFB8C00);
  static const Color info = Color(0xFF2196F3);
  
  // Gradientes modernos
  static const Color gradientStart = Color(0xFF006B3F);
  static const Color gradientMiddle = Color(0xFF009688);
  static const Color gradientEnd = Color(0xFFD9230F);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Gradiente para la pantalla de inicio - Moderno y profesional
  static LinearGradient get homeGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        gradientStart,
        gradientMiddle,
        gradientEnd,
      ],
      stops: [0.0, 0.5, 1.0],
    );
  }

  // Gradiente para resultados - Vibrante
  static LinearGradient get resultGradient {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        gradientStart,
        secondaryTeal,
        gradientEnd,
      ],
      stops: [0.0, 0.5, 1.0],
    );
  }

  // Gradiente para tarjetas - Sutil y elegante
  static LinearGradient get cardGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFF5F5F5),
      ],
    );
  }

  // Gradiente para botones principales
  static LinearGradient get buttonGradient {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        primaryGreen,
        secondaryTeal,
      ],
    );
  }
}
