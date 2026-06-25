import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveGameResult(int score, int totalQuestions) async {
    await init();
    
    // Guardar total de juegos
    int totalGames = _prefs?.getInt(AppConstants.keyTotalGames) ?? 0;
    await _prefs?.setInt(AppConstants.keyTotalGames, totalGames + 1);
    
    // Guardar puntuación total acumulada
    int totalScore = _prefs?.getInt(AppConstants.keyTotalScore) ?? 0;
    await _prefs?.setInt(AppConstants.keyTotalScore, totalScore + score);
    
    // Guardar mejor puntuación
    int bestScore = _prefs?.getInt(AppConstants.keyBestScore) ?? 0;
    if (score > bestScore) {
      await _prefs?.setInt(AppConstants.keyBestScore, score);
    }
  }

  int getTotalGames() {
    return _prefs?.getInt(AppConstants.keyTotalGames) ?? 0;
  }

  int getTotalScore() {
    return _prefs?.getInt(AppConstants.keyTotalScore) ?? 0;
  }

  int getBestScore() {
    return _prefs?.getInt(AppConstants.keyBestScore) ?? 0;
  }

  double getAverageScore() {
    int totalGames = getTotalGames();
    int totalScore = getTotalScore();
    if (totalGames == 0) return 0.0;
    return totalScore / totalGames;
  }

  Future<void> clearAll() async {
    await init();
    await _prefs?.clear();
  }
}
