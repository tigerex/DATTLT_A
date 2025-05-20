import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/test_question.dart';

class QuestionService {
  static String yourServerIp = '10.106.19.44'; // Thay thế bằng địa chỉ IP
  final String baseUrl = 'http://$yourServerIp:5000/api';
  // final String baseUrl = 'http://localhost:5000/api';

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

  Future<List<TestQuestion>> fetchAll() async {
    final response = await http.get(Uri.parse('$baseUrl/question/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<TestQuestion> questions =
          data.map((json) => TestQuestion.fromJson(json)).toList();
      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  Future<bool> addQuestion(TestQuestion question) async {
    final response = await http.post(
      Uri.parse('$baseUrl/question/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(question.toJson()),
    );

    print(json.encode(question.toJson()));

    if (response.statusCode != 200) {
      print('Error: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> editQuestion(TestQuestion question) async {
    final response = await http.put(
      Uri.parse('$baseUrl/question/update/${question.questionId}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(question.toJson()),
    );

    print(json.encode(question.toJson()));

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<void> deleteQuestion(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/question/delete/$id'),
    );

    if (response.statusCode == 200) {
      print("✅ Deleted");
    } else {
      print("Haiz, bug again 😒");
    }

    // return response.statusCode == 200 || response.statusCode == 201;
  }
}
