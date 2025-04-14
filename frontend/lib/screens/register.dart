import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/round_icon_button.dart';
import '../services/auth_service.dart';
import './home.dart';
import './login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final displayNameController = TextEditingController();
  final ageController = TextEditingController();
  bool isLoading = false;
  String errorText = '';

    void wrongRegister(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ê!!!'),
          content: const Text('Điền cho đầy đủ coi!'),
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

  void handleRegister() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final phone = phoneController.text.trim();
    final displayName = displayNameController.text.trim();
    int age = int.tryParse(ageController.text) ?? 0;

    setState(() {
      isLoading = true;
      errorText = '';
    });

    final response = await AuthService.register(email,password,phone,displayName,age);
    if (response.statusCode == 201) {
      // Đăng ký thành công
      print('Register OK: ${response.body}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        wrongRegister(context);
      });

      ///Cần thay đổi chỗ này
    }

    setState(() {
      isLoading = false;
    });
  }

  void handleBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                    'Register',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: emailController,
                    label: 'Email',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 11),
                  CustomTextField(
                    controller: passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),

                  const SizedBox(height: 11),
                  CustomTextField(
                    controller: phoneController,
                    label: 'Phone',
                    icon: Icons.phone,
                    // obscureText: true,
                  ),
                  const SizedBox(height: 11),
                  CustomTextField(
                    controller: displayNameController,
                    label: 'Display Name',
                    icon: Icons.person,
                    // obscureText: true,
                  ),
                  const SizedBox(height: 11),
                  CustomTextField(
                    controller: ageController,
                    label: 'Age',
                    icon: Icons.calendar_month,
                    // obscureText: true,
                  ),

                  const SizedBox(height: 24),

                  RoundIconButton(
                    onPressed: handleRegister,
                  ),// Nút tròn màu tím với icon mũi tên

                  ElevatedButton(
                    onPressed: handleBack,
                    child: const Text("Back"),
                  ), 

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SocialIcon(icon: FontAwesomeIcons.instagram),
                      SizedBox(width: 11),
                      SocialIcon(icon: FontAwesomeIcons.facebookF),
                    ],
                  ),
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
