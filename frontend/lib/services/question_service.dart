import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/test_question.dart';

class QuestionService {
  final String yourServerIp = '192.168.0.101'; // Thay thế bằng địa chỉ IP
  // final String baseUrl = 'http://$yourServerIp:5000/api';
  final String baseUrl = 'http://localhost:5000/api';

  Future<List<TestQuestion>> fetchQuestions(String level) async {
    final response = await http.get(
      Uri.parse('$baseUrl/question/random/$level'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<TestQuestion> questions =
          data.map((json) => TestQuestion.fromJson(json)).toList();
      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  Future<TestQuestion> fetchWithID(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/question/id/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return TestQuestion.fromJson(data);
    } else {
      throw Exception('Failed to load question with ID $id');
    }
  }
}
