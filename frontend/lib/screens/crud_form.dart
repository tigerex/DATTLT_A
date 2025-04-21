import 'package:flutter/material.dart';

class CrudFormScreen extends StatefulWidget {
  final Map<String, dynamic>? question; // null = add mode, not null = edit mode

  const CrudFormScreen({super.key, this.question});

  @override
  State<CrudFormScreen> createState() => _CrudFormScreenState();
}

class _CrudFormScreenState extends State<CrudFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _questionTextController;
  late TextEditingController _optionAController;
  late TextEditingController _optionBController;
  late TextEditingController _optionCController;
  late TextEditingController _optionDController;
  late TextEditingController _maxTimeController;

  String? _correctAnswer;
  String? _selectedLevel;

  final List<String> levels = ['easy', 'medium', 'hard'];
  final List<String> answerOptions = ['a', 'b', 'c', 'd'];

  @override
  void initState() {
    super.initState();
    _questionTextController = TextEditingController(text: widget.question?['questionText'] ?? '');
    _optionAController = TextEditingController(text: widget.question?['option_a'] ?? '');
    _optionBController = TextEditingController(text: widget.question?['option_b'] ?? '');
    _optionCController = TextEditingController(text: widget.question?['option_c'] ?? '');
    _optionDController = TextEditingController(text: widget.question?['option_d'] ?? '');
    _maxTimeController = TextEditingController(text: widget.question?['maxTimePerQuestion']?.toString() ?? '30');
    _correctAnswer = widget.question?['isCorrectAnswer'] ?? 'a';
    _selectedLevel = widget.question?['level'] ?? 'easy';
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    _optionAController.dispose();
    _optionBController.dispose();
    _optionCController.dispose();
    _optionDController.dispose();
    _maxTimeController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newQuestion = {
        'questionText': _questionTextController.text.trim(),
        'option_a': _optionAController.text.trim(),
        'option_b': _optionBController.text.trim(),
        'option_c': _optionCController.text.trim(),
        'option_d': _optionDController.text.trim(),
        'maxTimePerQuestion': int.tryParse(_maxTimeController.text.trim()) ?? 30,
        'isCorrectAnswer': _correctAnswer,
        'level': _selectedLevel,
      };

      // TODO: Gửi lên API hoặc truyền lại qua Navigator.pop
      print('Câu hỏi được lưu: $newQuestion');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question == null ? 'Add Question' : 'Edit Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionTextController,
                decoration: const InputDecoration(labelText: 'Question Text'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: _selectedLevel,
                items: levels.map((level) => DropdownMenuItem(value: level, child: Text(level))).toList(),
                onChanged: (val) => setState(() => _selectedLevel = val),
                decoration: const InputDecoration(labelText: 'Level'),
              ),
              const SizedBox(height: 12),
              TextFormField(controller: _optionAController, decoration: const InputDecoration(labelText: 'Option A')),
              TextFormField(controller: _optionBController, decoration: const InputDecoration(labelText: 'Option B')),
              TextFormField(controller: _optionCController, decoration: const InputDecoration(labelText: 'Option C')),
              TextFormField(controller: _optionDController, decoration: const InputDecoration(labelText: 'Option D')),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: _correctAnswer,
                items: answerOptions.map((a) => DropdownMenuItem(value: a, child: Text(a.toUpperCase()))).toList(),
                onChanged: (val) => setState(() => _correctAnswer = val),
                decoration: const InputDecoration(labelText: 'Correct Answer'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _maxTimeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Max Time (sec)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save Question'),
              )
            ],
          ),
        ),
      ),
    );
  }
}