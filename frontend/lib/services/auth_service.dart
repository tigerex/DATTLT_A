import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://192.168.0.105:5000/api'; // Đổi theo IP nếu chạy thật

  static Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'passWord': password}),
    );
    return response;
  }

  static Future<http.Response> register(String email, String password, String phone, String displayName, int age) async {
    final url = Uri.parse('$baseUrl/register/newUser');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'passWord': password,
                        'phone': phone, 'displayName': displayName, 'age': age}),
    );
    return response;
  }

  static Future<void> logout() async {
    // Nếu backend cần gọi API để logout thì thêm ở đây
    // Còn nếu chỉ cần xoá token local thì dùng SharedPreferences
  }
}
