import 'package:flutter/material.dart';
import '../data/word_completion_data.dart';
import '../utils/app_theme.dart';

class WordCompletionScreen extends StatefulWidget {
  const WordCompletionScreen({super.key});

  @override
  State<WordCompletionScreen> createState() => _WordCompletionScreenState();
}

class _WordCompletionScreenState extends State<WordCompletionScreen> with TickerProviderStateMixin {
  int currentIndex = 0;
  int score = 0;
  List<String> userLetters = [];
  List<bool> revealedLetters = [];
  bool isCompleted = false;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCurrentWord();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _initializeCurrentWord() {
    final item = WordCompletionData.items[currentIndex];
    userLetters = List.filled(item.word.length, '');
    revealedLetters = List.filled(item.word.length, false);
    isCompleted = false;
  }

  void _selectLetter(int index, String letter) {
    if (revealedLetters[index]) return;
    
    setState(() {
      userLetters[index] = letter;
      _checkCompletion();
    });
  }

  void _checkCompletion() {
    final item = WordCompletionData.items[currentIndex];
    final currentWord = userLetters.join();
    
    if (currentWord == item.word) {
      setState(() {
        score++;
        isCompleted = true;
      });
    }
  }

  void _nextWord() {
    if (currentIndex < WordCompletionData.items.length - 1) {
      setState(() {
        currentIndex++;
        _initializeCurrentWord();
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WordCompletionResultScreen(
          score: score,
          totalWords: WordCompletionData.items.length,
        ),
      ),
    );
  }

  void _revealLetter() {
    final item = WordCompletionData.items[currentIndex];
    for (int i = 0; i < item.word.length; i++) {
      if (!revealedLetters[i] && userLetters[i] != item.word[i]) {
        setState(() {
          revealedLetters[i] = true;
          userLetters[i] = item.word[i];
          _checkCompletion();
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = WordCompletionData.items[currentIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Palabra ${currentIndex + 1}/${WordCompletionData.items.length}'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.homeGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text(
                              'Puntuación: $score/${WordCompletionData.items.length}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: AppTheme.cardGradient,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              item.hint,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: List.generate(
                                item.word.length,
                                (index) => _buildLetterBox(index, item.word[index]),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      if (!isCompleted) ...[
                        const Text(
                          'Selecciona las letras:',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            ...['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'].map((letter) =>
                              _buildKeyboardButton(letter, item)),
                            ...['K', 'L', 'M', 'N', 'Ñ', 'O', 'P', 'Q', 'R', 'S'].map((letter) =>
                              _buildKeyboardButton(letter, item)),
                            ...['T', 'U', 'V', 'W', 'X', 'Y', 'Z'].map((letter) =>
                              _buildKeyboardButton(letter, item)),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        ElevatedButton.icon(
                          onPressed: _revealLetter,
                          icon: const Icon(Icons.lightbulb),
                          label: const Text('Pista'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryYellow,
                            foregroundColor: AppTheme.black,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],

                      if (isCompleted) ...[
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.success),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.check_circle, color: AppTheme.success, size: 40),
                              const SizedBox(height: 8),
                              const Text(
                                '¡Correcto!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.success,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.funFact,
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        ElevatedButton(
                          onPressed: _nextWord,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryRed,
                            foregroundColor: AppTheme.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            currentIndex < WordCompletionData.items.length - 1
                                ? 'SIGUIENTE'
                                : 'VER RESULTADOS',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterBox(int index, String correctLetter) {
    final item = WordCompletionData.items[currentIndex];
    final isRevealed = revealedLetters[index];
    final userLetter = userLetters[index];
    
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: isRevealed ? AppTheme.primaryYellow : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: userLetter.isNotEmpty ? AppTheme.primaryGreen : Colors.grey,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          userLetter.isNotEmpty ? userLetter : '',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isRevealed ? AppTheme.black : AppTheme.primaryGreen,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardButton(String letter, WordCompletionItem item) {
    return ElevatedButton(
      onPressed: () {
        for (int i = 0; i < item.word.length; i++) {
          if (userLetters[i].isEmpty && !revealedLetters[i]) {
            _selectLetter(i, letter);
            break;
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryGreen,
        minimumSize: const Size(45, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppTheme.primaryGreen),
        ),
      ),
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class WordCompletionResultScreen extends StatelessWidget {
  final int score;
  final int totalWords;

  const WordCompletionResultScreen({
    super.key,
    required this.score,
    required this.totalWords,
  });

  String getMessage() {
    final percentage = score / totalWords;
    if (percentage >= 0.9) {
      return '¡Excelente! Eres un experto en palabras bolivianas 🇧🇴';
    } else if (percentage >= 0.7) {
      return '¡Muy bien! Conoces bastante vocabulario 👍';
    } else if (percentage >= 0.5) {
      return '¡Bien! Puedes mejorar tu vocabulario 📚';
    } else {
      return '¡Sigue practicando! 💪';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Icons.spellcheck,
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
                              color: score >= totalWords * 0.7 ? AppTheme.success : AppTheme.primaryGreen,
                            ),
                          ),
                          Text(
                            '/$totalWords',
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WordCompletionScreen(),
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
                      Navigator.pop(context);
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
