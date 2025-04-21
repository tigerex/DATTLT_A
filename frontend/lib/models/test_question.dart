class TestQuestion {
  final String id;
  final String questionText;
  final String? image;
  final int maxTimePerQuestion;
  final List<String> options;
  final int correctIndex;

  TestQuestion({
    required this.id,
    required this.questionText,
    this.image,
    required this.maxTimePerQuestion,
    required this.options,
    required this.correctIndex,
  });

  factory TestQuestion.fromJson(Map<String, dynamic> json) {
    return TestQuestion(
      id: json['id'],
      questionText: json['questionText'],
      image: json['image'],
      maxTimePerQuestion: json['maxTimePerQuestion'],
      options: [
        json['option_a'],
        json['option_b'],
        json['option_c'],
        json['option_d'],
      ],
      correctIndex: _convertAnswerToIndex(json['isCorrectAnswer']),
    );
  }

  static int _convertAnswerToIndex(String key) {
    switch (key.toLowerCase()) {
      case 'a':
        return 0;
      case 'b':
        return 1;
      case 'c':
        return 2;
      case 'd':
        return 3;
      default:
        return -1;
    }
  }
}
