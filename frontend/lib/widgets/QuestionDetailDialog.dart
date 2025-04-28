import 'package:flutter/material.dart';
import '../models/test_question.dart';
import '../models/test_answer.dart';

class QuestionDetailDialog extends StatelessWidget {
  final TestQuestion question;
  final Answer userAnswer;

  const QuestionDetailDialog({
    super.key,
    required this.question,
    required this.userAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Answer Detail'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...List.generate(4, (index) {
              final options = question.options;
              final isUserSelected = userAnswer.selectedOptionIndex == index;
              final isCorrectAnswer = question.correctAnswerIndex == index;

              Color bgColor = Color(0xFFFFFAFA);
              Color textColor = Colors.black;

              if (isCorrectAnswer && isUserSelected) {
                bgColor = Colors.green.shade800; // đúng + chọn
                textColor = Color(0xFFFFFAFA);
              } else if (isCorrectAnswer) {
                bgColor = Colors.green.shade800; // đúng nhưng user không chọn
                textColor = Color(0xFFFFFAFA);
              } else if (isUserSelected) {
                bgColor = Colors.red.shade800; // chọn sai
                textColor = Color(0xFFFFFAFA);
              }

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${['A', 'B', 'C', 'D'][index]}. ${options[index]}',
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
