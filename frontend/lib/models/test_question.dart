// class TestQuestion {
//   final String questionId;
//   final String questionText;
//   // final String? image;
//   final int maxTimePerQuestion;
//   final List<String> options;
//   final int isCorrectAnswer;

//   TestQuestion({
//     required this.questionId,
//     required this.questionText,
//     // this.image,
//     required this.maxTimePerQuestion,
//     required this.options,
//     required this.isCorrectAnswer,
//   });

//   factory TestQuestion.fromJson(Map<String, dynamic> json) {
//     return TestQuestion(
//       questionId: json['questionId'],
//       questionText: json['questionText'],
//       // image: json['image'],
//       maxTimePerQuestion: json['maxTimePerQuestion'],
//       options: [
//         json['option_a'],
//         json['option_b'],
//         json['option_c'],
//         json['option_d'],
//       ],
//       isCorrectAnswer: _convertAnswerToIndex(json['isCorrectAnswer']),
//     );
//   }

//   static int _convertAnswerToIndex(String key) {
//     switch (key.toLowerCase()) {
//       case 'a':
//         return 0;
//       case 'b':
//         return 1;
//       case 'c':
//         return 2;
//       case 'd':
//         return 3;
//       default:
//         return -1;
//     }
//   }
// }

class TestQuestion {
  final String questionId;
  final String questionLevel;
  final String questionImg;
  final String questionText;
  final int maxTime;
  final List<String> options;
  final int correctAnswerIndex;

  TestQuestion({
    required this.questionId,
    required this.questionLevel,
    required this.questionImg,
    required this.questionText,
    required this.maxTime,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory TestQuestion.fromJson(Map<String, dynamic> json) {
    List<dynamic> optionList = json['options'];
    List<String> optionTexts =
        optionList.map((opt) => opt['text'].toString()).toList();

    String correctLabel = json['correctAnswer'];
    int correctIndex = optionList.indexWhere(
      (opt) => opt['label'] == correctLabel,
    );

    return TestQuestion(
      questionId: json['_id'],
      questionLevel: json['level'],
      questionImg: json['questionImg'] ?? '', // Cái này có thể null
      questionText: json['questionText'],
      maxTime: json['maxTime'],
      options: optionTexts,
      correctAnswerIndex: correctIndex,
    );
  }
}
