// lib/screens/home.dart
import 'package:flutter/material.dart';
import '../widgets/start_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './choose_level.dart';
import '../services/auth_service.dart';
import 'dart:convert';
import './login.dart';
import './test_records.dart';
import './top_results.dart';
import './account.dart';


class HomeScreen22 extends StatefulWidget {
  // final String userID;
  // final String userName;

  // required this.userName, required this.userID
  const HomeScreen22({super.key});

  @override
  State<HomeScreen22> createState() => _HomeScreen22State();
}

// State class cho HomeScreen22
// Chứa các biến trạng thái và phương thức để quản lý trạng thái của widget
class _HomeScreen22State extends State<HomeScreen22> {
  String userID = '';
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userAge = '';
  String userRole = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  // Hàm này sẽ gọi API để lấy thông tin người dùng
  // và cập nhật trạng thái của widget
  Future<void> fetchUserInfo() async {
    try {
      final response = await AuthService.getUserInfo();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // API trả về JSON
        print('User data: $data'); // In ra dữ liệu người dùng để kiểm tra
        // Cập nhật các biến trạng thái với dữ liệu từ API
        setState(() {
          userID = data['_id'].toString();
          userName = data['displayName'].toString();
          userEmail = data['email'].toString();
          userPhone = data['phone'].toString();
          userAge = data['age'].toString();
          userRole = data['role'].toString();
          isLoading = false; // Đặt isLoading thành false khi đã lấy xong dữ liệu
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error fetching user info: ${response.statusCode}'); // In ra mã lỗi nếu lấy không thành công
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Exception fetching user info: $e');
    }
  }

  // Hàm này sẽ hiển thị một hộp thoại xác nhận khi người dùng nhấn nút đăng xuất
  void showLogoutAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Đóng dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                AuthService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()), // Chuyển đến trang đăng nhập
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
  // Khúc này xây dựng các nút điều hướng
  Widget buildBottomNavButton(
    String label,
    String iconPath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, width: 36, height: 36, fit: BoxFit.contain),

          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }


  // Sử dụng Scaffold để tạo cấu trúc cơ bản cho ứng dụng
  // Sử dụng Container để tạo nền gradient
  // Sử dụng Column để sắp xếp các widget theo chiều dọc
  // Sử dụng Center để căn giữa các widget
  // Sử dụng SvgPicture để hiển thị hình ảnh SVG
  // Sử dụng Text để hiển thị văn bản
  // Sử dụng IconButton để tạo nút đăng xuất
  // Sử dụng Row để sắp xếp các nút điều hướng theo chiều ngang

  // Tui nhờ ChatGPT để vậy cho nhớ thôi, mốt nhớ rồi xóa 

  // Hàm này sẽ xây dựng giao diện của widget
  // Nó sẽ được gọi mỗi khi trạng thái của widget thay đổi và cần phải được vẽ lại
  // Giao diện chính của ứng dụng
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFFFFFAFA), // trắng
              Color(0xFF643DFF), // tím đậm
            ],
          ),
        ),
        child:
            isLoading
                // Nếu đang tải dữ liệu thì hiển thị CircularProgressIndicator
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Nếu đã tải xong dữ liệu thì hiển thị các widget khác
                  children: [
                    // Nút đăng xuất
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () => showLogoutAlert(context),
                      tooltip: "Logout",
                    ),
                    // Khoảng cách giữa nút đăng xuất và các widget khác
                    const Spacer(flex: 2),
                    Text(
                      'Hi $userName',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFAFA),
                      ),
                    ),
                    // Sizebox để tạo khoảng cách giữa các widget
                    const SizedBox(height: 12),
                    Text(
                      'Email: $userEmail',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFFAFA),
                      ),
                    ),
                    // Khúc này Copilot bắt đầu xàm xàm rồi nên tui stop document tại đây
                    Text(
                      'Phone: $userPhone',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFFAFA),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ready to take a test?',
                      style: TextStyle(fontSize: 16, color: Color(0xFFFFFAFA)),
                    ),
                    const Spacer(),
                    SvgPicture.asset('assets/monsterDonut.svg', height: 120),
                    const Spacer(),

                    // Nút bắt đầu làm bài test
                    StartButton(
                      text: 'Start now',
                      onPressed:
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChooseLevelScreen( // Chuyển đến trang chọn level
                                    userID: userID,
                                    username: userName,
                                  ),
                            ),
                          ),
                    ),
                    const Spacer(flex: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Đi đến trang kết quả bài test
                        buildBottomNavButton(
                          "History",
                          "assets/records.png",
                          () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => TestRecords(userId: userID),
                              ),
                            );
                          },
                        ),
                        // Đi đến trang top kết quả
                        buildBottomNavButton(
                          "Top 10", 
                          "assets/top10.png", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopResults(userId: userID),
                            ),
                          );
                        }),

                        // Đi đến trang account
                        buildBottomNavButton(
                          "Account",
                          "assets/account.png",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountScreen(
                                  displayName: userName,
                                  userEmail: userEmail,
                                  userPhone: userPhone,
                                  userAge: userAge,
                                  userRole: userRole,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
