class Options {
  String? optionText; // Text của các đáp án trong câu hỏi
  int optionIndex; // Chỉ số đáp án (0 = A, 1 = B, ...)

  String get label {
    switch (optionIndex) {
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

  Options({required this.optionText, required this.optionIndex});

  Map<String, dynamic> toJson() => {
    "label": label,
    "text": optionText,
  };

  factory Options.fromJson(Map<String, dynamic> json) {
    final answerLetter = json['label'];

    late int index;
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
    }

    return Options(optionText: json['text'], optionIndex: index);
  }
}
