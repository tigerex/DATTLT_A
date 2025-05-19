import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  final String yourServerIp = '10.106.18.63'; // Thay thế bằng địa chỉ IP
  // final String baseUrl = 'http://$yourServerIp:5000/api';
  final String baseUrl = 'http://localhost:5000/api';


  Future<List<User>> fetchUser() async {
    final response = await http.get(Uri.parse('$baseUrl/user/roleUser'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<User> users =
          data.map((json) => User.fromJson(json)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<bool> disableUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/status/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    print(json.encode(user.toJson()));

    return response.statusCode == 200 || response.statusCode == 201;
  }

}
