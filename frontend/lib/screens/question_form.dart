import 'package:flutter/material.dart';
import 'package:frontend/models/question_option.dart';
import 'package:frontend/models/test_question.dart';
import 'package:frontend/screens/admin_crud.dart';
import '../services/question_service.dart';

// class CrudFormScreen extends StatefulWidget {
//   final TestQuestion? question; // null = add mode, not null = edit mode

//   const CrudFormScreen({super.key, required this.question});

//   @override
//   State<CrudFormScreen> createState() => _CrudFormScreenState();
// }

// class _CrudFormScreenState extends State<CrudFormScreen> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _questionTextController;
//   late TextEditingController _optionAController;
//   late TextEditingController _optionBController;
//   late TextEditingController _optionCController;
//   late TextEditingController _optionDController;
//   late TextEditingController _maxTimeController;

//   int? _correctAnswer;
//   String? _selectedLevel;
//   List<Options> options = [];
//   final List<String> levels = ['easy', 'medium', 'hard'];
//   final List<String> answerOptions = ['a', 'b', 'c', 'd'];

//   @override
//   void initState() {
//     super.initState();
//     _questionTextController = TextEditingController(
//       text: widget.question?.questionText ?? '',
//     );
//     _optionAController = TextEditingController(
//       text: widget.question?.options[0].optionText ?? '',
//     );
//     _optionBController = TextEditingController(
//       text: widget.question?.options[1].optionText ?? '',
//     );
//     _optionCController = TextEditingController(
//       text: widget.question?.options[2].optionText ?? '',
//     );
//     _optionDController = TextEditingController(
//       text: widget.question?.options[3].optionText ?? '',
//     );
//     _maxTimeController = TextEditingController(
//       text: widget.question?.maxTime.toString() ?? '20',
//     );
//     _correctAnswer = widget.question?.correctAnswerIndex ?? 0;
//     _selectedLevel = widget.question?.questionLevel ?? 'easy';

//     options = List.generate(
//       4,
//       (index) => Options(optionText: null, optionIndex: index - 1),
//     );
//   }

//   @override
//   void dispose() {
//     _questionTextController.dispose();
//     _optionAController.dispose();
//     _optionBController.dispose();
//     _optionCController.dispose();
//     _optionDController.dispose();
//     _maxTimeController.dispose();
//     super.dispose();
//   }

//   void _saveForm() {
//     if (_formKey.currentState!.validate()) {
//       options[0].optionText = _optionAController.text.trim();
//       options[1].optionText = _optionBController.text.trim();
//       options[2].optionText = _optionCController.text.trim();
//       options[3].optionText = _optionDController.text.trim();

//       //Tạo mới để nạp question vào database
//       TestQuestion newQuestion = new TestQuestion(
//         questionId: '',
//         questionLevel: _selectedLevel.trim(),
//         questionImg: '',
//         questionText: _questionTextController.text.trim(),
//         maxTime: maxTime,
//         options: options,
//         correctAnswerIndex: correctAnswerIndex){
//       };

//       // TODO: Gửi lên API hoặc truyền lại qua Navigator.pop
//       print('Câu hỏi được lưu: $newQuestion');
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.question == null ? 'Add Question' : 'Edit Question'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _questionTextController,
//                 decoration: const InputDecoration(labelText: 'Question Text'),
//                 validator:
//                     (value) =>
//                         value == null || value.isEmpty ? 'Required' : null,
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField(
//                 value: _selectedLevel,
//                 items:
//                     levels
//                         .map(
//                           (level) => DropdownMenuItem(
//                             value: level,
//                             child: Text(level),
//                           ),
//                         )
//                         .toList(),
//                 onChanged: (val) => setState(() => _selectedLevel = val),
//                 decoration: const InputDecoration(labelText: 'Level'),
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _optionAController,
//                 decoration: const InputDecoration(labelText: 'Option A'),
//               ),
//               TextFormField(
//                 controller: _optionBController,
//                 decoration: const InputDecoration(labelText: 'Option B'),
//               ),
//               TextFormField(
//                 controller: _optionCController,
//                 decoration: const InputDecoration(labelText: 'Option C'),
//               ),
//               TextFormField(
//                 controller: _optionDController,
//                 decoration: const InputDecoration(labelText: 'Option D'),
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField(
//                 value: _correctAnswer,
//                 items:
//                     answerOptions
//                         .map(
//                           (a) => DropdownMenuItem(
//                             value: a,
//                             child: Text(a.toUpperCase()),
//                           ),
//                         )
//                         .toList(),
//                 onChanged: (val) => setState(() => _correctAnswer = val),
//                 decoration: const InputDecoration(labelText: 'Correct Answer'),
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _maxTimeController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: 'Max Time (sec)'),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _saveForm,
//                 child: const Text('Save Question'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class QuestionFormWidget extends StatefulWidget {
  final TestQuestion? question;
  const QuestionFormWidget({super.key, required this.question});

  @override
  State<QuestionFormWidget> createState() => _QuestionFormWidgetState();
}

class _QuestionFormWidgetState extends State<QuestionFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late String _questionId;
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
      _questionId = q.questionId!;
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
        questionId: isEdit ? _questionId : null,
        questionLevel: selectedLevel,
        questionImg: null,
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
                child: Text(isEdit ? 'Update' : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
