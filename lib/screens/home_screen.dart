import 'package:flutter/material.dart';
import '../models/quiz_category.dart';
import '../data/quiz_data.dart';
import '../widgets/category_card.dart';
import '../utils/app_theme.dart';
import '../services/storage_service.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  int _totalGames = 0;
  int _bestScore = 0;
  double _averageScore = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    await _storageService.init();
    setState(() {
      _totalGames = _storageService.getTotalGames();
      _bestScore = _storageService.getBestScore();
      _averageScore = _storageService.getAverageScore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.homeGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/logo_catec.png',
                    width: 150,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.quiz,
                        size: 150,
                        color: Colors.white,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'TEST DE CONOCIMIENTOS',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '¡Elige una categoría y demuestra lo que sabes!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  
                  // Estadísticas del usuario
                  if (_totalGames > 0)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '$_totalGames',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Partidas',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '$_bestScore',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Mejor',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${_averageScore.toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Promedio',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 30),
                  
                  // Bolivia Card
                  CategoryCard(
                    title: 'BOLIVIA',
                    subtitle: 'Conocimientos generales del país',
                    icon: Icons.flag,
                    color: AppTheme.primaryRed,
                    questionsCount: QuizData.boliviaQuestions.length,
                    category: QuizCategory.bolivia,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(category: QuizCategory.bolivia),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Oruro Card
                  CategoryCard(
                    title: 'ORURO',
                    subtitle: 'Capital del Folklore Boliviano',
                    icon: Icons.celebration,
                    color: AppTheme.primaryYellow,
                    questionsCount: QuizData.oruroQuestions.length,
                    category: QuizCategory.oruro,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(category: QuizCategory.oruro),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
