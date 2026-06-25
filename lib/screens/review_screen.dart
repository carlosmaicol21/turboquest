import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/quiz_category.dart';
import '../utils/app_theme.dart';

class ReviewScreen extends StatelessWidget {
  final List<Question> questions;
  final List<int?> userAnswers;
  final QuizCategory category;

  const ReviewScreen({
    super.key,
    required this.questions,
    required this.userAnswers,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    int correctCount = 0;
    int incorrectCount = 0;
    int unansweredCount = 0;

    for (int i = 0; i < questions.length; i++) {
      if (i < userAnswers.length && userAnswers[i] != null) {
        if (userAnswers[i] == questions[i].correctAnswerIndex) {
          correctCount++;
        } else {
          incorrectCount++;
        }
      } else {
        unansweredCount++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisión de Respuestas'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: AppTheme.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryGreen.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn(Icons.check_circle, AppTheme.success, correctCount, 'Correctas'),
                _buildStatColumn(Icons.cancel, AppTheme.error, incorrectCount, 'Incorrectas'),
                _buildStatColumn(Icons.help_outline, Colors.grey, unansweredCount, 'Sin responder'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final userAnswer = index < userAnswers.length ? userAnswers[index] : null;
                final isCorrect = userAnswer == question.correctAnswerIndex;
                final hasAnswered = userAnswer != null;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: hasAnswered
                          ? (isCorrect ? AppTheme.success : AppTheme.error)
                          : Colors.grey,
                      child: Icon(
                        hasAnswered
                            ? (isCorrect ? Icons.check : Icons.close)
                            : Icons.help_outline,
                        color: AppTheme.white,
                      ),
                    ),
                    title: Text(
                      'Pregunta ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      question.questionText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.questionText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(
                              question.options.length,
                              (optionIndex) {
                                final isSelected = userAnswer == optionIndex;
                                final isCorrectAnswer = question.correctAnswerIndex == optionIndex;
                                
                                Color backgroundColor;
                                IconData? icon;
                                
                                if (isCorrectAnswer) {
                                  backgroundColor = AppTheme.success.withOpacity(0.2);
                                  icon = Icons.check_circle;
                                } else if (isSelected && !isCorrectAnswer) {
                                  backgroundColor = AppTheme.error.withOpacity(0.2);
                                  icon = Icons.cancel;
                                } else {
                                  backgroundColor = Colors.transparent;
                                  icon = null;
                                }
                                
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isCorrectAnswer
                                          ? AppTheme.success
                                          : (isSelected ? AppTheme.error : Colors.grey.shade300),
                                      width: isCorrectAnswer || isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      if (icon != null)
                                        Icon(
                                          icon,
                                          color: isCorrectAnswer ? AppTheme.success : AppTheme.error,
                                          size: 20,
                                        ),
                                      if (icon != null)
                                        const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          question.options[optionIndex],
                                          style: TextStyle(
                                            fontWeight: isCorrectAnswer || isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isCorrectAnswer
                                                ? AppTheme.success
                                                : (isSelected ? AppTheme.error : AppTheme.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.primaryGreen),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.lightbulb,
                                    color: AppTheme.primaryGreen,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      question.funFact,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(IconData icon, Color color, int count, String label) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
