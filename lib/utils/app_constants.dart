class AppConstants {
  static const int defaultTimePerQuestion = 30;
  static const int delayAfterAnswer = 2;
  
  static const String appName = 'Test de Bolivia';
  static const String appVersion = '1.0.0';
  
  // Rutas
  static const String homeRoute = '/';
  static const String quizRoute = '/quiz';
  static const String resultRoute = '/result';
  static const String reviewRoute = '/review';
  
  // Claves de SharedPreferences
  static const String keyTotalGames = 'total_games';
  static const String keyTotalScore = 'total_score';
  static const String keyBestScore = 'best_score';
  static const String keyDarkMode = 'dark_mode';
}
