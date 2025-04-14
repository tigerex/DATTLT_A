import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:5000/api/auth'; // Đổi theo IP nếu chạy thật

  static Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'passWord': password}),
    );
    return response;
  }

  // static Future<http.Response> register(String email, String password) async {
  //   final url = Uri.parse('$baseUrl/register');
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': email, 'password': password}),
  //   );
  //   return response;
  // }

  static Future<void> logout() async {
    // Nếu backend cần gọi API để logout thì thêm ở đây
    // Còn nếu chỉ cần xoá token local thì dùng SharedPreferences
  }
}
