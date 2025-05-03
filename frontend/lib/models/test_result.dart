import 'package:frontend/models/test_answer.dart';

class Result {
  final String resultId;
  final String userId;
  final String level;
  final int timeTaken;
  final int score;
  final List<Answer>
  questions; // This will have <<List answers>> data from calculateTest function in start.dart
  final DateTime? date;

  Result({
    required this.resultId,
    required this.userId,
    required this.level,
    required this.timeTaken,
    required this.score,
    required this.questions,
    this.date,
  });

  String get formattedDate {
    return "${date?.year}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}";
  }
  

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      resultId: json['resultId'],
      userId: json['userId'],
      level: json['level'],
      timeTaken: json['timeTaken'],
      score: json['score'],
      questions: List<Answer>.from(json['questions']),
      // date: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'resultId': resultId,
      'userId': userId,
      'level': level,
      'timeTaken': timeTaken,
      'score': score,
      'questions': questions,
    };
  }
}
