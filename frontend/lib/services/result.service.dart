import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/test_result.dart';

class ResultService {
  static String yourServerIp = '192.168.0.104'; // Thay thế bằng địa chỉ IP
  // static String baseUrl = 'http://$yourServerIp:5000/api/result/add'; 
  static String baseUrl = 'http://localhost:5000/api/result/add'; 

  // GET all results
  Future<List<Result>> fetchResults() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Result.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load results');
    }
  }

  // POST new result
  Future<bool> submitResult(Result result) async {
    print(json.encode(result.toJson()));

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(result.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
