import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/test_result.dart';

class ResultService {
  static String yourServerIp = '10.106.18.63'; // Thay thế bằng địa chỉ IP
  // static String baseUrl = 'http://$yourServerIp:5000/api/result';
  static String baseUrl = 'http://localhost:5000/api/result';

  // GET all results
  Future<List<Result>> fetchResults(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

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

  // GET top results (điểm cao nhất)
  Future<List<Result>> fetchTopResults(int limit,String level) async {
    final response = await http.get(Uri.parse('$baseUrl/rankings/$level?limit=$limit'));
    print("RESPONSE");
    print(response.body);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Result> results = data.map((json) => Result.fromJson(json)).toList();

      return results;
    } else {
      throw Exception('Failed to load top results');
    }
  }
}


