import 'package:flutter/material.dart';
import 'dart:math';

// Tạo một widget Stateless để hiển thị thông tin tài khoản
// Tên lớp là AccountScreen
class AccountScreen extends StatelessWidget {
  final String displayName;
  final String userEmail;
  final String userPhone;
  final String userAge;
  final String userRole;

  // Constructor
  // Danh sách các tham số cần thiết để hiển thị thông tin tài khoản
  const AccountScreen({
    super.key,
    required this.displayName,
    required this.userEmail,
    required this.userPhone,
    required this.userAge,
    required this.userRole,
  });

  // Danh sách ảnh đại diện mặc định
  final List<String> defaultProfilePics = const [
    'assets/default_profile_pic_1.png',
    'assets/default_profile_pic_2.png',
    'assets/default_profile_pic_3.png',
  ];

  // Hàm để lấy ảnh đại diện ngẫu nhiên từ danh sách
  String get randomProfilePic {
    final random = Random(); // Tạo một đối tượng Random
    return defaultProfilePics[random.nextInt(defaultProfilePics.length)];
  }

  @override
  // Phương thức build để xây dựng giao diện
  Widget build(BuildContext context) {
    final profilePic = randomProfilePic; // Lấy ảnh đại diện ngẫu nhiên từ danh sách

    // Giao diện chính
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF643DFF),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFAFA),
              Color(0xFF643DFF),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Ảnh đại diện
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(profilePic), // Ảnh đại diện ngẫu nhiên
              // Nào làm user có thể chọn ảnh đại diện của mình thì update lại
            ),
            const SizedBox(height: 12),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userRole,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Color(0xFF555555),
              ),
            ),
            const SizedBox(height: 24),

            // Danh sách thông tin tài khoản
            Expanded(
              child: ListView(
                children: [
                  _buildInfoTile(Icons.email, 'Email', userEmail),
                  _buildInfoTile(Icons.phone, 'Phone', userPhone),
                  _buildInfoTile(Icons.cake, 'Age', userAge),
                  _buildInfoTile(Icons.verified_user, 'Role', userRole),
                ],
              ),
            ),
            // Nút quay lại
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF643DFF),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context), // Quay lại
              child: const Text('Back'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Hàm để xây dựng một ô thông tin tài khoản
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF643DFF)),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}
