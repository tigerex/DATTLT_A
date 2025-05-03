class Answer {
  final String questionId;            // ID của câu hỏi
  int? selectedOptionIndex;           // Chỉ số đáp án đã chọn (0 = A, 1 = B, ...), null nếu chưa chọn

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
    return Answer(
      questionId: json['question_Id'],
      selectedOptionIndex: json['userAnswer']
    );
  }
}
