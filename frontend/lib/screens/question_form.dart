import 'package:flutter/material.dart';
import 'package:frontend/models/question_option.dart';
import 'package:frontend/models/test_question.dart';
import 'package:frontend/screens/admin_crud.dart';
import '../services/question_service.dart';

class QuestionFormWidget extends StatefulWidget {
  final TestQuestion? question;
  const QuestionFormWidget({super.key, required this.question});

  @override
  State<QuestionFormWidget> createState() => _QuestionFormWidgetState();
}

class _QuestionFormWidgetState extends State<QuestionFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _questionId = TextEditingController();
  final TextEditingController _questionImg = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _maxTimeController = TextEditingController();
  List<Options> options = [];
  String selectedLevel = 'easy';
  int? selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    final q = widget.question;
    // Khởi tạo 4 option mặc định

    if (q != null) {
      _questionId.text = q.questionId!;
      _questionImg.text = q.questionImg!;
      _contentController.text = q.questionText;
      _maxTimeController.text = q.maxTime.toString();
      selectedLevel = q.questionLevel;
      selectedAnswerIndex = q.correctAnswerIndex;
      options =
          q.options
              .map(
                (opt) => Options(
                  optionText: opt.optionText,
                  optionIndex: opt.optionIndex,
                ),
              )
              .toList();
    } else {
      options = List.generate(
        4,
        (index) => Options(optionText: '', optionIndex: index),
      );
    }
  }

  void goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminCrudScreen()),
    );
  }

  void submit(bool isEdit) async {
    final submit;

    if (_formKey.currentState!.validate() && selectedAnswerIndex != null) {
      final TestQuestion questionData = TestQuestion(
        // questionId: isEdit ? _questionId : null,
        questionId: _questionId.text,
        questionLevel: selectedLevel,
        // questionImg: isEdit? _questionImg : null,
        questionImg: _questionImg.text,
        questionText: _contentController.text,
        maxTime: int.parse(_maxTimeController.text),
        options: options,
        correctAnswerIndex: selectedAnswerIndex ?? 0,
      );

      if (isEdit != true) {
        submit = await QuestionService().addQuestion(questionData);
      } else {
        submit = await QuestionService().editQuestion(questionData);
      }

      if (submit) {
        print('✅ Thành công');
      } else {
        print('❌ Thất bại');
      }

      showDialog(
        context: context,
        barrierDismissible: false, // Prevent user from closing it manually
        builder: (context) {
          return AlertDialog(
            title: const Text('Done!'),
            content: Text(
              isEdit
                  ? 'Question edited successfully'
                  : 'Question added successfully',
            ),
          );
        },
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close the dialog
        goBack();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.question != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.deepPurple),
          onPressed: () => goBack(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionId,
                decoration: const InputDecoration(
                  labelText: 'Question ID (optional)',
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Question Content',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                value: selectedLevel,
                items:
                    ['easy', 'medium', 'hard']
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Level'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _questionImg,
                decoration: const InputDecoration(
                  labelText: 'Question Image URL (optional)',
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _maxTimeController,
                decoration: const InputDecoration(
                  labelText: 'Max Time (seconds)',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              const Text(
                'Options:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...options.asMap().entries.map((entry) {
                final index = entry.key;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: options[index].optionText,
                        decoration: InputDecoration(
                          labelText: 'Option ${index + 1}',
                        ),
                        onChanged: (text) {
                          options[index].optionText = text;
                        },
                      ),
                    ),
                    Radio<int>(
                      value: index,
                      groupValue: selectedAnswerIndex,
                      onChanged: (value) {
                        setState(() {
                          selectedAnswerIndex = value;
                        });
                      },
                    ),
                    const Text("Correct"),
                  ],
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  submit(isEdit);
                },
                child: Text(isEdit ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
