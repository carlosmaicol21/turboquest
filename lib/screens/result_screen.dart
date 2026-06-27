import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/quiz_category.dart';
import '../utils/app_theme.dart';
import '../services/storage_service.dart';
import 'review_screen.dart';
import 'quiz_screen.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final QuizCategory category;
  final List<Question> questions;
  final List<int?> userAnswers;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.category,
    required this.questions,
    required this.userAnswers,
  });

  String getMessage() {
    final percentage = score / totalQuestions;
    if (percentage >= 0.9) {
      return '¡Excelente! Eres un experto en Bolivia 🇧🇴';
    } else if (percentage >= 0.7) {
      return '¡Muy bien! Conoces bastante de Bolivia 👍';
    } else if (percentage >= 0.5) {
      return '¡Bien! Puedes mejorar tu conocimiento 📚';
    } else {
      return '¡Sigue aprendiendo sobre Bolivia! 💪';
    }
  }

  Color getScoreColor() {
    final percentage = score / totalQuestions;
    if (percentage >= 0.9) return AppTheme.success;
    if (percentage >= 0.7) return Colors.lightGreen;
    if (percentage >= 0.5) return AppTheme.warning;
    return AppTheme.error;
  }

  @override
  Widget build(BuildContext context) {
    // Guardar el resultado cuando se muestra la pantalla
    StorageService().saveGameResult(score, totalQuestions);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.resultGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 100,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'RESULTADOS',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$score',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: getScoreColor(),
                            ),
                          ),
                          Text(
                            '/$totalQuestions',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      getMessage(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppTheme.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 40),
                  
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewScreen(
                            questions: questions,
                            userAnswers: userAnswers,
                            category: category,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: AppTheme.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'VER RESPUESTAS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(category: category),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.white,
                      foregroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'JUGAR DE NUEVO',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.white,
                    ),
                    child: const Text(
                      'VOLVER AL INICIO',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
