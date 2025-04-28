import 'dart:convert'; // Thư viện để chuyển đổi JSON
import 'package:http/http.dart' as http; // Thư viện để gửi HTTP request
import 'package:shared_preferences/shared_preferences.dart'; // Thư viện để lưu trữ dữ liệu cục bộ
// import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Thư viện để lưu trữ dữ liệu bảo mật

class AuthService {
  // Địa chỉ server của bạn
  // Thay thế 'yourServerIp' bằng địa chỉ IP hoặc tên miền của server
  // static String yourServerIp = '192.168.2.53'; // Thay thế bằng địa chỉ IP
  static String yourServerIp = '192.168.2.60'; // Thay thế bằng địa chỉ IP
  // static String yourServerIp = '10.106.18.125';
  static String baseUrl = 'http://${yourServerIp}:5000/api';

  static Future<http.Response> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(
      'user_token',
    ); // Lấy token từ SharedPreferences

    final url = Uri.parse('$baseUrl/auth/user/token/$token');
    print("url: $url"); // UNFINISHED

    final response = await http.get(url);
    return response;
  }

  static Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'passWord': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token']; // or whatever key your backend returns
      String userID = data['user'][0]['_id'];
      String userName = data['user'][0]['displayName'];
      String userEmail = data['user'][0]['email'];
      String userPhone = data['user'][0]['phone'];
      String userAge = data['user'][0]['age'].toString();
      String userRole = data['user'][0]['role'];

      print('''
            User Info:
            - ID: $userID
            - Name: $userName
            - Email: $userEmail
            - Phone: $userPhone
            - Age: $userAge
            - Role: $userRole
            Token: $token
            ''');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', token);
      print('Token saved!');
    }
    return response;
  }

  static Future<http.Response> register(
    String email,
    String password,
    String phone,
    String displayName,
    int age,
  ) async {
    final url = Uri.parse('$baseUrl/register/newUser');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'passWord': password,
        'phone': phone,
        'displayName': displayName,
        'age': age,
      }),
    );
    print(response.body);
    return response;
  }

  static Future<void> logout() async {
    // Nếu backend cần gọi API để logout thì thêm ở đây
    // Còn nếu chỉ cần xoá token local thì dùng SharedPreferences

    // Tạm thời thì xóa token local trước nhé, sau này làm API logout sau
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    print('Token removed!');
  }
}
