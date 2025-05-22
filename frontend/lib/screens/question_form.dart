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
  File? _imageFile;
  Uint8List? _webImage;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        if (kIsWeb) {
          _webImage = bytes;
          _questionImg.text = pickedFile.name;
        } else {
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

    if (q != null) {
      _questionId.text = q.questionId ?? '';
      _questionImg.text = q.questionImg ?? '';
      _contentController.text = q.questionText;
      _maxTimeController.text = q.maxTime.toString();
      selectedLevel = q.questionLevel;
      selectedAnswerIndex = q.correctAnswerIndex;
      options = q.options
          .map(
            (opt) => Options(
              optionText: opt.optionText,
              optionIndex: opt.optionIndex,
            ),
          )
          .toList();
    } else {
      options = List.generate(4, (index) => Options(optionText: '', optionIndex: index));
    }
  }

  void goBack() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminCrudScreen()));
  }

  void submit(bool isEdit) async {
    if (_formKey.currentState!.validate() && selectedAnswerIndex != null) {
      final questionData = TestQuestion(
        questionId: _questionId.text,
        questionLevel: selectedLevel,
        questionImg: _questionImg.text,
        questionText: _contentController.text,
        maxTime: int.parse(_maxTimeController.text),
        options: options,
        correctAnswerIndex: selectedAnswerIndex ?? 0,
      );

      bool submit;
      if (!isEdit) {
        submit = await QuestionService().addQuestion(
          questionData,
          imageFile: _imageFile,
          webImageBytes: _webImage,
          webImageName: _questionImg.text,
        );
      } else {
        submit = await QuestionService().editQuestion(
          questionData,
          imageFile: _imageFile,
          webImageBytes: _webImage,
          webImageName: _questionImg.text,
        );
      }

      if (submit) {
        print('✅ Thành công');
      } else {
        print('❌ Thất bại');
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Done!'),
            content: Text(isEdit ? 'Question edited successfully' : 'Question added successfully'),
          );
        },
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
        goBack();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.question != null;

    final primaryColor = Colors.deepPurple;
    final borderRadius = BorderRadius.circular(12);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: goBack,
        ),
        title: Text(
          isEdit ? 'EDIT QUESTION FORM' : 'ADD QUESTION FORM',
          style: TextStyle(color: primaryColor, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_questionId, 'Question ID (optional)', false, isReadOnly: isEdit, color: isEdit ? Colors.grey : null),
              const SizedBox(height: 16),
              _buildTextField(_contentController, 'Question Content', true, isMultiline: true),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedLevel,
                decoration: _inputDecoration('Level'),
                items: ['easy', 'medium', 'hard']
                    .map((level) => DropdownMenuItem(value: level, child: Text(level.capitalize())))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  elevation: 3,
                ),
                icon: const Icon(Icons.image_outlined, color: Color.fromARGB(255, 255, 225, 246)),
                label: const Text('Pick Image', style: TextStyle(color: Color.fromARGB(255, 255, 225, 246))),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 12),

              if (kIsWeb && _webImage != null)
                _buildImagePreviewBig(Image.memory(_webImage!), borderRadius, context)
              else if (!kIsWeb && _imageFile != null)
                _buildImagePreviewBig(Image.file(_imageFile!), borderRadius, context)
              else if (_questionImg.text.isNotEmpty)
                _buildImagePreviewBig(Image.network(_questionImg.text, fit: BoxFit.cover), borderRadius, context),

              const SizedBox(height: 16),
              _buildTextField(_maxTimeController, 'Max Time (seconds)', true, isNumber: true),
              const SizedBox(height: 24),
              const Text(
                'Options:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...options.asMap().entries.map((entry) {
                final idx = entry.key;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: options[idx].optionText,
                          decoration: InputDecoration(
                            labelText: 'Option ${idx + 1}',
                            border: OutlineInputBorder(borderRadius: borderRadius),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          ),
                          onChanged: (text) => options[idx].optionText = text,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          Radio<int>(
                            value: idx,
                            groupValue: selectedAnswerIndex,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              setState(() {
                                selectedAnswerIndex = value;
                              });
                            },
                          ),
                          const Text("Correct", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    elevation: 5,
                  ),
                  onPressed: () => submit(isEdit),
                  child: Text(isEdit ? 'Update' : 'Add', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Color.fromARGB(255, 255, 225, 246))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool required,
      {bool isNumber = false, bool isMultiline = false, bool isReadOnly = false, Color? color}) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: isMultiline
          ? TextInputType.multiline
          : (isNumber ? TextInputType.number : TextInputType.text),
      minLines: isMultiline ? 1 : 1,    // start with 3 lines tall for multiline
      maxLines: isMultiline ? null : 1, // grow vertically if multiline
      style: TextStyle(color: color),
      validator: (value) => (required && (value == null || value.isEmpty)) ? 'Required' : null,
      decoration: _inputDecoration(label),
    );
  }

  // Hàm dùng để tạo decoration cho TextFormField
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple.shade400, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    );
  }

  // Hàm dùng để coi trước hình ảnh trước khi push qua backend
  Widget _buildImagePreviewBig(Widget imageWidget, BorderRadius borderRadius, BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    return Center(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: width,
          height: width * 0.6,  // Tỉ lệ 16:9
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: width,
              height: width * 0.6,
              child: imageWidget,
            ),
          ),
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
