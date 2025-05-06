import 'package:frontend/models/question_option.dart';

class TestQuestion {
  final String? questionId;
  final String questionLevel;
  final String? questionImg;
  final String questionText;
  final int maxTime;
  final List<Options> options;
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

  String get correctAnswer {
    switch (correctAnswerIndex) {
      case 0:
        return 'A';
      case 1:
        return 'B';
      case 2:
        return 'C';
      case 3:
        return 'D';
      default:
        return 'Not answered';
    }
  }

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "level": questionLevel,
    "questionText": questionText,
    "options": options,
    "correctAnswer": correctAnswer,
    "maxTime": maxTime,
  };

  factory TestQuestion.fromJson(Map<String, dynamic> json) {
    List<dynamic> optionList = json['options'];
    // List<String> optionTexts =
    //     optionList.map((opt) => opt['text'].toString()).toList();

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
      options:
          (json['options'] as List)
              .map((item) => Options.fromJson(item as Map<String, dynamic>))
              .toList(),
      correctAnswerIndex: correctIndex,
    );
  }
}
