import 'package:flutter/material.dart';
import '../models/test_question.dart';
import '../models/test_answer.dart';
import './test_records.dart';

class RecordReview extends StatefulWidget {
  final List<TestQuestion> question;
  final List<Answer> answer;
  final String userId;

  const RecordReview({
    super.key,
    required this.question,
    required this.answer,
    required this.userId,
  });

  @override
  State<RecordReview> createState() => _RecordReviewState();
}

class _RecordReviewState extends State<RecordReview> {
  void goToBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TestRecords(userId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review record'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            goToBack();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Builder(
          builder:
              (_) => ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: widget.question.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white54, // hoặc màu nền nhẹ
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${index + 1}: ${widget.question[index].questionText}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 8),

                        ...List.generate(
                          widget.question[index].options.length,
                          (i) {
                            final isUserSelected =
                                i == widget.answer[index].selectedOptionIndex;
                            final isCorrect =
                                widget.question[index].correctAnswerIndex == i;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    isCorrect
                                        ? Colors.green.withOpacity(0.2)
                                        : isUserSelected
                                        ? Colors.red.withOpacity(0.2)
                                        : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                title: Text(
                                  widget.question[index].options[i].optionText!,
                                ),
                                leading: Icon(
                                  isUserSelected
                                      ? isCorrect
                                          ? Icons.check_circle
                                          : Icons.cancel
                                      : Icons.circle_outlined,
                                  color:
                                      isCorrect
                                          ? isUserSelected
                                              ? Colors.green
                                              : Colors.grey
                                          : isUserSelected
                                          ? Colors.red
                                          : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }
}
