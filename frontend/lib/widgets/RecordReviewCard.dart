import 'package:flutter/material.dart';
import '../models/test_question.dart';
import '../models/test_answer.dart';

class RecordReviewCard extends StatelessWidget {
  final TestQuestion question;
  final Answer answer;
  final int index;

  const RecordReviewCard({
    super.key,
    required this.question,
    required this.answer,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Q${index + 1}: ${question.questionText}',
                style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            ...List.generate(question.options.length, (i) {
              final isUserSelected = i == answer.selectedOptionIndex;
              final isCorrect = question.correctAnswerIndex == i;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? isUserSelected ? Colors.green.withOpacity(0.2) : Colors.blueGrey.shade300.withOpacity(0.2)
                      : isUserSelected
                          ? Colors.red.withOpacity(0.2)
                          : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(question.options[i].optionText!),
                  leading: Icon(
                    isCorrect
                        ? Icons.check_circle
                        : isUserSelected
                            ? Icons.cancel
                            : Icons.circle_outlined,
                    color: isCorrect
                        ? isUserSelected ? Colors.green : Colors.grey
                        : isUserSelected
                            ? Colors.red
                            : Colors.grey,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
