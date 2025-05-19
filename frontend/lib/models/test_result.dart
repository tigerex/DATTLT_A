import 'package:frontend/models/test_answer.dart';
import 'package:intl/intl.dart';

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

  String get formattedDateTime {
    final vietnamTime = date!.toLocal().add(const Duration(hours: 7));
    return DateFormat('dd/MM/yyyy HH:mm').format(vietnamTime);
  }


  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      resultId: json['_id'],
      userId: '',
      // userId: json['userId'],
      level: json['level'],
      timeTaken: json['timeTaken'],
      score: json['score'],
      questions:
          (json['questions'] as List)
              .map((item) => Answer.fromJson(item as Map<String, dynamic>))
              .toList(),
      date: DateTime.parse(json['createdAt']),
    );
  }

  get username => null;

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
