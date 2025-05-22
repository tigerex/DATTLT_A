import 'package:flutter/material.dart';
import 'package:frontend/models/question_option.dart';
import 'package:frontend/models/test_question.dart';
import 'package:frontend/screens/admin_crud.dart';
import '../services/question_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;


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
  final ImagePicker _picker = ImagePicker();
  List<Options> options = [];
  String selectedLevel = 'easy';
  int? selectedAnswerIndex;
  File? _imageFile;       // Dùng để lưu trữ ảnh trên Android
  Uint8List? _webImage;   // Dùng để lưu trữ ảnh trên web

  // Hàm để chọn ảnh từ local
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        // Nếu đang chạy trên web, lưu trữ ảnh dưới dạng Uint8List
        if (kIsWeb) {
          _webImage = bytes;
          _questionImg.text = pickedFile.name; // Tên file trên web
        } 
        // Nếu không phải web, lưu trữ ảnh dưới dạng File
        else {
          _imageFile = File(pickedFile.path);
          _questionImg.text = pickedFile.path;
        }
      });
    }
  }


  @override
  void initState() {
    super.initState();
    final q = widget.question;
    // Khởi tạo 4 option mặc định

    if (q != null) {
      _questionId.text = q.questionId!;                 // Có thể null
      _questionImg.text = q.questionImg!;               // Có thể null
      _contentController.text = q.questionText;         // Không thể null
      _maxTimeController.text = q.maxTime.toString();   // Không thể null
      selectedLevel = q.questionLevel;                  // Không thể null
      selectedAnswerIndex = q.correctAnswerIndex;       // Không thể null
      options =                                         // Danh sách, không thể null
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
    final bool submit;
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
        submit = await QuestionService().addQuestion(questionData,imageFile: _imageFile,webImageBytes: _webImage,webImageName: _questionImg.text,);
      } else {
        submit = await QuestionService().editQuestion(questionData,imageFile: _imageFile,webImageBytes: _webImage,webImageName: _questionImg.text,);
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
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text("Pick Image"),
                    onPressed: _pickImage,
                  ),
                  const SizedBox(width: 10),
                  if (kIsWeb && _webImage != null)
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.memory(_webImage!),
                    )
                  else if (!kIsWeb && _imageFile != null)
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.file(_imageFile!),
                    )
                  else if (_questionImg.text.isNotEmpty)
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(_questionImg.text),
                    ),
                ],
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
