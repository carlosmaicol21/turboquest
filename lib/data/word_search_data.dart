class WordSearchData {
  static const String _alphabet = 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ';
  static const int _maxConsecutiveSame = 2;
  
  static String _getRandomLetter({String? previousLetter, int consecutiveCount = 0}) {
    String letter;
    int attempts = 0;
    
    do {
      final random = DateTime.now().millisecondsSinceEpoch + attempts;
      letter = _alphabet[random % _alphabet.length];
      attempts++;
    } while (previousLetter != null && 
             letter == previousLetter && 
             consecutiveCount >= _maxConsecutiveSame &&
             attempts < 10);
    
    return letter;
  }
  
  static List<List<String>> _fillGridWithRandomLetters(List<List<String>> grid) {
    final filledGrid = <List<String>>[];
    String? previousLetter;
    int consecutiveCount = 0;
    
    for (var row in grid) {
      final filledRow = <String>[];
      for (var cell in row) {
        if (cell == 'X' || cell == 'Y' || cell == 'Z') {
          final newLetter = _getRandomLetter(
            previousLetter: previousLetter,
            consecutiveCount: consecutiveCount,
          );
          
          if (newLetter == previousLetter) {
            consecutiveCount++;
          } else {
            consecutiveCount = 0;
            previousLetter = newLetter;
          }
          
          filledRow.add(newLetter);
        } else {
          filledRow.add(cell);
          previousLetter = null;
          consecutiveCount = 0;
        }
      }
      filledGrid.add(filledRow);
    }
    return filledGrid;
  }
  
  static final List<WordSearchPuzzle> puzzles = [
    WordSearchPuzzle(
      gridSize: 10,
      words: ['BOLIVIA', 'SUCRE', 'LLAMA', 'TITICACA'],
      grid: _fillGridWithRandomLetters([
        ['B', 'O', 'L', 'I', 'V', 'I', 'A', 'X', 'Y', 'Z'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['S', 'U', 'C', 'R', 'E', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['L', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['L', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['A', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['M', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['A', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['T', 'I', 'T', 'I', 'C', 'A', 'C', 'A', 'X', 'X'],
      ]),
      funFact: 'Bolivia tiene 9 departamentos y 37 idiomas oficiales.',
    ),
    WordSearchPuzzle(
      gridSize: 10,
      words: ['SAJAMA', 'CHARANGO', 'KANTUTA'],
      grid: _fillGridWithRandomLetters([
        ['S', 'A', 'J', 'A', 'M', 'A', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['C', 'H', 'A', 'R', 'A', 'N', 'G', 'O', 'X', ' '],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['K', 'A', 'N', 'T', 'U', 'T', 'A', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
      ]),
      funFact: 'El Nevado Sajama es el pico más alto de Bolivia con 6,542 metros.',
    ),
    WordSearchPuzzle(
      gridSize: 10,
      words: ['ORURO', 'POTOSI', 'SALAR'],
      grid: _fillGridWithRandomLetters([
        ['O', 'R', 'U', 'R', 'O', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['P', 'O', 'T', 'O', 'S', 'I', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['S', 'A', 'L', 'A', 'R', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
      ]),
      funFact: 'El Salar de Uyuni es el desierto de sal más grande del mundo con más de 10,000 km².',
    ),
    WordSearchPuzzle(
      gridSize: 10,
      words: ['COCHABAMBA', 'SANTACRUZ', 'LA PAZ'],
      grid: _fillGridWithRandomLetters([
        ['C', 'O', 'C', 'H', 'A', 'B', 'A', 'M', 'B', 'A'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['S', 'A', 'N', 'T', 'A', 'C', 'R', 'U', 'Z', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['L', 'A', 'P', 'A', 'Z', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
      ]),
      funFact: 'Cochabamba es conocida como el Granero de Bolivia por su producción agrícola.',
    ),
    WordSearchPuzzle(
      gridSize: 10,
      words: ['WIPHALA', 'PATUJU', 'DIABLADA'],
      grid: _fillGridWithRandomLetters([
        ['W', 'I', 'P', 'H', 'A', 'L', 'A', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['P', 'A', 'T', 'U', 'J', 'U', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['D', 'I', 'A', 'B', 'L', 'A', 'D', 'A', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
        ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'],
      ]),
      funFact: 'La Wiphala es el símbolo de los pueblos indígenas de Bolivia.',
    ),
  ];
}

class WordSearchPuzzle {
  final int gridSize;
  final List<String> words;
  final List<List<String>> grid;
  final String funFact;

  WordSearchPuzzle({
    required this.gridSize,
    required this.words,
    required this.grid,
    required this.funFact,
  });
}
