// lib/screens/home.dart
import 'package:flutter/material.dart';
import '../widgets/start_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './choose_level.dart';
import '../services/auth_service.dart';
import 'dart:convert';
import './login.dart';

class HomeScreen22 extends StatefulWidget {
  final String userName;

  const HomeScreen22({super.key, required this.userName});

  @override
  State<HomeScreen22> createState() => _HomeScreen22State();
}

class _HomeScreen22State extends State<HomeScreen22> {
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

  Future<void> fetchUserInfo() async {
    try {
      final response = await AuthService.getUserInfo(); // Hàm này là ví dụ
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('User data: $data');
        setState(() {
          userName = data['displayName'].toString();
          userEmail = data['email'].toString();
          userPhone = data['phone'].toString();
          userAge = data['age'].toString();
          userRole = data['role'].toString();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error fetching user info: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Exception fetching user info: $e');
    }
  }

  void showLogoutAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                AuthService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home"),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout),
      //       onPressed: () => showLogoutAlert(context),
      //       tooltip: "Logout",
      //     ),
      //     // ElevatedButton(
      //     //   onPressed: () => showLogoutAlert(context),

      //     //   child: const Text("Logout"),
      //     // ),
      //   ],
      // ),
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
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () => showLogoutAlert(context),
                      tooltip: "Logout",
                    ),
                    const Spacer(flex: 2),
                    Text(
                      'Hi ${widget.userName}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFAFA),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Email: $userEmail',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFFAFA),
                      ),
                    ),
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
                    SvgPicture.asset(
                      'lib/assets/images/monsterDonut.svg',
                      height: 120,
                    ),
                    const Spacer(),
                    StartButton(
                      text: 'Start now',
                      onPressed:
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChooseLevelScreen(
                                    username: widget.userName,
                                  ),
                            ),
                          ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
      ),
    );
  }
}
