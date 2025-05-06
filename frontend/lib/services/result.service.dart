import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/test_result.dart';

class ResultService {
  static String yourServerIp = '192.168.0.101'; // Thay thế bằng IP thực tế
  static String baseUrl = 'http://$yourServerIp:5000/api/result';
  // Nếu chạy emulator Android, dùng 10.0.2.2 thay vì localhost

  // GET all results
  Future<List<Result>> fetchResults() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Result.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load results');
    }
  }

  // POST new result
  Future<bool> submitResult(Result result) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(result.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // ✅ GET top results (điểm cao nhất)
  Future<List<Result>> fetchTopResults(int limit) async {
    final response = await http.get(Uri.parse('$baseUrl/top?limit=$limit'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Result.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top results');
    }
  }
}
