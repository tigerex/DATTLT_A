class Answer {
  final String questionId;            // ID của câu hỏi
  int? selectedOptionIndex;           // Chỉ số đáp án đã chọn (0 = A, 1 = B, ...), null nếu chưa chọn

  Answer({required this.questionId, this.selectedOptionIndex});

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "selectedOptionIndex": selectedOptionIndex,
  };

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    questionId: json['questionId'],
    selectedOptionIndex: json['selectedOptionIndex'],
  );
}
