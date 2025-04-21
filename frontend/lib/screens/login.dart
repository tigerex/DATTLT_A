import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import '../widgets/custom_textfield.dart';
import '../widgets/round_icon_button.dart';
import '../services/auth_service.dart';
// import '../screens/home.dart';

import './home22.dart';
import 'register.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String errorText = '';

  void wrongLogin(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Password or email is incorrect!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showLoginWelcomeDialog(BuildContext context, String userName) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent user from closing it manually
    builder: (context) {
      return AlertDialog(
        title: const Text('Welcome'),
        content: Text('Welcome back, $userName!'),
      );
    },
  );

  Future.delayed(const Duration(seconds: 2), () {
    Navigator.of(context).pop(); // Close the dialog
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen22()),
    );
  });
}


  void handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    setState(() {
      isLoading = true;
      errorText = '';
    });

    final response = await AuthService.login(email, password);
    if (response.statusCode == 200) {
      // Đăng nhập thành công
      print('Login OK!');
      final data = jsonDecode(response.body);
      final String userName = data['user'][0]['displayName'];
      showLoginWelcomeDialog(context, userName); // Show welcome dialog

    } 

    if (response.statusCode == 400) {
      // Sai email hoặc mật khẩu
      wrongLogin(context);
    } else if (response.statusCode == 500) {
      // Lỗi server
      setState(() {
        errorText = 'Lỗi server, vui lòng thử lại sau!';
      });
    } else {
      // Lỗi khác
      setState(() {
        errorText = 'Đã xảy ra lỗi, vui lòng thử lại!';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void handleRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFFFFFFFF), // trắng
                Color(0xFF643DFF), // tím đậm
              ],
            ),
          ),

          

        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: emailController,
                    label: 'Email',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  
                  RoundIconButton(
                    onPressed: handleLogin,
                  ), // Nút tròn màu tím với icon mũi tên
                  ElevatedButton(
                    onPressed: handleRegister,
            
                    child: const Text("Register"),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SocialIcon(icon: FontAwesomeIcons.instagram),
                      SizedBox(width: 16),
                      SocialIcon(icon: FontAwesomeIcons.facebookF),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  const SocialIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: 20,
      child: FaIcon(icon, color: Colors.white, size: 20),
    );
  }
}

