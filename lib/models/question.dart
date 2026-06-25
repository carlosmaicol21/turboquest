class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String imageAsset;
  final String funFact;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.imageAsset,
    required this.funFact,
  });
}
