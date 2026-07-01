import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/quiz_category.dart';
import '../data/quiz_data.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;
  bool isAnswered = false;
  List<int?> userAnswers = [];
  Timer? _timer;
  int _remainingSeconds = AppConstants.defaultTimePerQuestion;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Question> get questions => QuizData.quizQuestions;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = AppConstants.defaultTimePerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _handleTimeUp();
        }
      });
    });
  }

  void _handleTimeUp() {
    if (!isAnswered) {
      if (userAnswers.length <= currentQuestionIndex) {
        userAnswers.add(null);
      } else {
        userAnswers[currentQuestionIndex] = null;
      }
      setState(() {
        isAnswered = true;
        selectedAnswerIndex = null;
      });
    }
    Future.delayed(const Duration(seconds: AppConstants.delayAfterAnswer), () {
      if (mounted) {
        nextQuestion();
      }
    });
  }

  void answerQuestion(int selectedIndex) {
    if (isAnswered) return;

    _timer?.cancel();

    setState(() {
      selectedAnswerIndex = selectedIndex;
      isAnswered = true;
      if (userAnswers.length <= currentQuestionIndex) {
        userAnswers.add(selectedIndex);
      } else {
        userAnswers[currentQuestionIndex] = selectedIndex;
      }
      if (selectedIndex == questions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: AppConstants.delayAfterAnswer), () {
      if (mounted) {
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    _timer?.cancel();
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isAnswered = false;
        _remainingSeconds = AppConstants.defaultTimePerQuestion;
      });
      _animationController.reset();
      _animationController.forward();
      _startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            totalQuestions: questions.length,
            category: widget.category,
            questions: questions,
            userAnswers: userAnswers,
          ),
        ),
      );
    }
  }

  Color _getTimerColor() {
    if (_remainingSeconds > 20) return AppTheme.success;
    if (_remainingSeconds > 10) return AppTheme.warning;
    return AppTheme.error;
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Pregunta ${currentQuestionIndex + 1}/${questions.length}'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: AppTheme.white,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                minHeight: 8,
              ),
              
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Puntuación: $score/${questions.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: _getTimerColor().withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: _getTimerColor(),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer,
                      color: _getTimerColor(),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$_remainingSeconds',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _getTimerColor(),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'seg',
                      style: TextStyle(
                        fontSize: 16,
                        color: _getTimerColor(),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _remainingSeconds / AppConstants.defaultTimePerQuestion,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(_getTimerColor()),
                    minHeight: 6,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    question.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.primaryGreen,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: AppTheme.white,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Imagen no disponible',
                                style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  question.questionText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              ...List.generate(
                question.options.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: isAnswered ? null : () => answerQuestion(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAnswered
                            ? index == question.correctAnswerIndex
                                ? AppTheme.success
                                : index == selectedAnswerIndex
                                    ? AppTheme.error
                                    : Colors.grey[300]
                            : AppTheme.white,
                        foregroundColor: isAnswered
                            ? index == question.correctAnswerIndex || index == selectedAnswerIndex
                                ? AppTheme.white
                                : AppTheme.black
                            : AppTheme.primaryGreen,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isAnswered
                                ? index == question.correctAnswerIndex
                                    ? AppTheme.success
                                    : index == selectedAnswerIndex
                                        ? AppTheme.error
                                        : Colors.grey
                                : AppTheme.primaryGreen,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (isAnswered && index == question.correctAnswerIndex)
                            const Icon(Icons.check_circle, color: AppTheme.white),
                          if (isAnswered && index == selectedAnswerIndex && index != question.correctAnswerIndex)
                            const Icon(Icons.cancel, color: AppTheme.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              question.options[index],
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (isAnswered && selectedAnswerIndex == null)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.error),
                  ),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.timer_off, color: AppTheme.error),
                          SizedBox(width: 8),
                          Text(
                            '¡Se acabó el tiempo!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.error,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'La respuesta correcta se muestra en verde',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

              if (isAnswered)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryGreen),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb, color: AppTheme.primaryGreen),
                          SizedBox(width: 8),
                          Text(
                            'Dato Curioso',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.funFact,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),

              if (isAnswered)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      foregroundColor: AppTheme.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      currentQuestionIndex < questions.length - 1
                          ? 'SIGUIENTE'
                          : 'VER RESULTADOS',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
