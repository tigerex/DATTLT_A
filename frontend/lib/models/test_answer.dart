class Answer {
  final String questionId; // ID của câu hỏi
  int?
  selectedOptionIndex; // Chỉ số đáp án đã chọn (0 = A, 1 = B, ...), null nếu chưa chọn

  String get userAnswer {
    switch (selectedOptionIndex) {
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

  Answer({required this.questionId, this.selectedOptionIndex});

  Map<String, dynamic> toJson() => {
    "question_Id": questionId,
    "userAnswer": userAnswer,
  };

  factory Answer.fromJson(Map<String, dynamic> json) {
    final answerLetter = json['userAnswer'];

    int? index;
    switch (answerLetter) {
      case 'A':
        index = 0;
        break;
      case 'B':
        index = 1;
        break;
      case 'C':
        index = 2;
        break;
      case 'D':
        index = 3;
        break;
      default:
        index = null;
    }

    return Answer(questionId: json['question_Id'], selectedOptionIndex: index);
  }
}
