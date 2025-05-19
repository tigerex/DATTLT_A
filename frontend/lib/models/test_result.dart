import 'package:frontend/models/test_answer.dart';
import 'package:intl/intl.dart';

class Result {
  final String resultId;
  final String userId;
  final String displayName;
  final String level;
  final int timeTaken;
  final int score;

  final List<Answer>
  questions; // This will have <<List answers>> data from calculateTest function in start.dart

  final DateTime? date;

  Result({
    required this.resultId,
    required this.userId,
    required this.displayName,
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
  try {
    return Result(
      resultId: json['_id'] ?? 'unknown_id',
      userId: json['userId'] is Map<String, dynamic>
          ? json['userId']['_id'] ?? ''  // if needed
          : json['userId'] ?? '',
      displayName: json['userId'] is Map<String, dynamic>
          ? json['userId']['displayName'] ?? ''
          : '',
      level: json['level'] ?? 'unknown',
      timeTaken: json['timeTaken'] ?? 0,
      score: json['score'] ?? 0,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((item) => Answer.fromJson(item))
              .toList() ??
          [],
      date: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  } catch (e) {
    print('Error parsing Result JSON: $e');
    print('Problematic JSON: $json');
    rethrow;
  }
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
