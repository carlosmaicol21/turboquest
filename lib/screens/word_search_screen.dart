import 'package:flutter/material.dart';
import '../data/word_search_data.dart';
import '../utils/app_theme.dart';

class WordSearchScreen extends StatefulWidget {
  const WordSearchScreen({super.key});

  @override
  State<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  int currentIndex = 0;
  int score = 0;
  Set<String> foundWords = {};
  List<List<bool>> selectedCells = [];
  bool isSelecting = false;
  int? startRow;
  int? startCol;
  List<List<int>> currentSelection = [];

  @override
  void initState() {
    super.initState();
    _initializeCurrentPuzzle();
  }

  void _initializeCurrentPuzzle() {
    final puzzle = WordSearchData.puzzles[currentIndex];
    foundWords = {};
    selectedCells = List.generate(
      puzzle.gridSize,
      (_) => List.filled(puzzle.gridSize, false),
    );
    isSelecting = false;
    startRow = null;
    startCol = null;
    currentSelection = [];
  }

  void _handleCellTap(int row, int col) {
    final puzzle = WordSearchData.puzzles[currentIndex];
    
    if (!isSelecting) {
      setState(() {
        isSelecting = true;
        startRow = row;
        startCol = col;
        currentSelection = [[row, col]];
      });
    } else {
      _checkSelection(row, col);
    }
  }

  void _handleCellDrag(int row, int col) {
    if (!isSelecting || startRow == null || startCol == null) return;
    
    setState(() {
      currentSelection = _getSelectionPath(startRow!, startCol!, row, col);
    });
  }

  List<List<int>> _getSelectionPath(int startR, int startC, int endR, int endC) {
    List<List<int>> path = [];
    int row = startR;
    int col = startC;
    
    int rowDir = endR.compareTo(startR);
    int colDir = endC.compareTo(startC);
    
    // Solo permitir selección horizontal, vertical o diagonal
    if (rowDir != 0 && colDir != 0 && rowDir.abs() != colDir.abs()) {
      return [[startR, startC]];
    }
    
    while (row != endR || col != endC) {
      path.add([row, col]);
      if (row != endR) row += rowDir;
      if (col != endC) col += colDir;
    }
    path.add([row, col]);
    
    return path;
  }

  void _checkSelection(int endRow, int endCol) {
    final puzzle = WordSearchData.puzzles[currentIndex];
    final selection = _getSelectionPath(startRow!, startCol!, endRow, endCol);
    final selectedWord = selection.map((pos) => puzzle.grid[pos[0]][pos[1]]).join();
    
    bool found = false;
    for (var word in puzzle.words) {
      if (selectedWord == word || selectedWord == word.split('').reversed.join()) {
        if (!foundWords.contains(word)) {
          setState(() {
            foundWords.add(word);
            score++;
            for (var pos in selection) {
              selectedCells[pos[0]][pos[1]] = true;
            }
          });
          found = true;
        }
      }
    }
    
    setState(() {
      isSelecting = false;
      startRow = null;
      startCol = null;
      currentSelection = [];
    });
  }

  void _nextPuzzle() {
    if (currentIndex < WordSearchData.puzzles.length - 1) {
      setState(() {
        currentIndex++;
        _initializeCurrentPuzzle();
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WordSearchResultScreen(
          score: score,
          totalPuzzles: WordSearchData.puzzles.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = WordSearchData.puzzles[currentIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Sopa ${currentIndex + 1}/${WordSearchData.puzzles.length}'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: AppTheme.white,
      ),
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
                  const SizedBox(height: 20),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          'Puntuación: $score/${puzzle.words.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Palabras a encontrar:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: puzzle.words.map((word) {
                            final isFound = foundWords.contains(word);
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isFound ? AppTheme.success.withOpacity(0.2) : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isFound ? AppTheme.success : Colors.grey,
                                ),
                              ),
                              child: Text(
                                word,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isFound ? AppTheme.success : Colors.grey[700],
                                  decoration: isFound ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: puzzle.gridSize,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: puzzle.gridSize * puzzle.gridSize,
                      itemBuilder: (context, index) {
                        final row = index ~/ puzzle.gridSize;
                        final col = index % puzzle.gridSize;
                        final isSelected = selectedCells[row][col];
                        final isInCurrentSelection = currentSelection.any((pos) => pos[0] == row && pos[1] == col);
                        
                        return GestureDetector(
                          onTapDown: (_) => _handleCellTap(row, col),
                          onPanUpdate: (details) {
                            final RenderBox box = context.findRenderObject() as RenderBox;
                            final localPosition = box.globalToLocal(details.globalPosition);
                            final cellSize = box.size.width / puzzle.gridSize;
                            final tappedRow = (localPosition.dy / cellSize).floor();
                            final tappedCol = (localPosition.dx / cellSize).floor();
                            
                            if (tappedRow >= 0 && tappedRow < puzzle.gridSize &&
                                tappedCol >= 0 && tappedCol < puzzle.gridSize) {
                              _handleCellDrag(tappedRow, tappedCol);
                            }
                          },
                          onPanEnd: (_) {
                            if (currentSelection.isNotEmpty) {
                              _checkSelection(currentSelection.last[0], currentSelection.last[1]);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.success
                                  : isInCurrentSelection
                                      ? AppTheme.primaryYellow
                                      : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isInCurrentSelection ? AppTheme.primaryGreen : Colors.grey.shade300,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                puzzle.grid[row][col],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? AppTheme.white : AppTheme.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (foundWords.length == puzzle.words.length) ...[
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
                            '¡Completado!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.success,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            puzzle.funFact,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    ElevatedButton(
                      onPressed: _nextPuzzle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: AppTheme.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        currentIndex < WordSearchData.puzzles.length - 1
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
    );
  }
}

class WordSearchResultScreen extends StatelessWidget {
  final int score;
  final int totalPuzzles;

  const WordSearchResultScreen({
    super.key,
    required this.score,
    required this.totalPuzzles,
  });

  String getMessage() {
    final percentage = score / totalPuzzles;
    if (percentage >= 0.9) {
      return '¡Excelente! Eres un experto buscando palabras 🇧🇴';
    } else if (percentage >= 0.7) {
      return '¡Muy bien! Tienes buena vista 👍';
    } else if (percentage >= 0.5) {
      return '¡Bien! Sigue practicando 📚';
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
                    Icons.grid_on,
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
                              color: score >= totalPuzzles * 0.7 ? AppTheme.success : AppTheme.primaryGreen,
                            ),
                          ),
                          Text(
                            '/$totalPuzzles',
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
                          builder: (context) => const WordSearchScreen(),
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
