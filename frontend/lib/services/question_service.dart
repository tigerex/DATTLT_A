import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/test_question.dart';

Future<List<TestQuestion>> fetchQuestions(String level) async {
  final response = await http.get(
    // Uri.parse('http://localhost/api/all'), // Này là hồi nãy tui test coi data thực kéo lên ổn không
    Uri.parse('http://192.168.0.105:5000/api/question/random/$level'),
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


// import 'dart:async';
// import '../models/test_question.dart';

// Future<List<TestQuestion>> fetchQuestions(String level) async {
//   // Giả lập delay như đang fetch từ mạng
//   await Future.delayed(const Duration(seconds: 1));

//   return [
//     TestQuestion(
//       id: '1',
//       questionText: 'Annet .... puppies',
//       image: null,
//       maxTimePerQuestion: 30,
//       options: ['loved', 'loves', 'love', 'None'],
//       correctIndex: 1,
//     ),
//     TestQuestion(
//       id: '2',
//       questionText: 'He .... playing football.',
//       image: null,
//       maxTimePerQuestion: 20,
//       options: ['was', 'is', 'are', 'be'],
//       correctIndex: 0,
//     ),
    
//     TestQuestion(
//       id: '3',
//       questionText: 'She .... playing guitar.',
//       image: null,
//       maxTimePerQuestion: 20,
//       options: ['was', 'is', 'are', 'be'],
//       correctIndex: 0,
//     ),
//   ];
// }
