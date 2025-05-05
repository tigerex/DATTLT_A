import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


// import 'screens/home.dart';
// import './screens/admin_crud.dart';
// import './screens/finish.dart';

import 'screens/home22.dart';
import 'services/auth_service.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDVLGxK3JJnEAlVRTrjf8XAmMxNtYwC92k",
        authDomain: "my-first-project-ecf2b.firebaseapp.com",
        projectId: "my-first-project-ecf2b",
        storageBucket: "my-first-project-ecf2b.firebasestorage.app",
        messagingSenderId: "128557703341",
        appId: "1:128557703341:web:7c54b6e9dd9fe4e50de624"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String userID = '';
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userAge = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void getUserInfo() async {
    print('Fetching user info...');
    // Call the AuthService to get user info
    final response = await AuthService.getUserInfo();
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('User data: $data');
      // Check if 'user' exists and is not empty
      if (data != null && data.isNotEmpty) {
        setState(() {
          userID = data['_id'];
          userName = data['displayName'].toString();
          userEmail = data['email'].toString();
          userPhone = data['phone'].toString();
          userAge = data['age'].toString();
          userRole = data['role'].toString();
          print('User info updated!');
        });
      } else {
        print('User data is not available!');
      }
    } else {
      print('Failed to fetch user info!');
    }
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token'); // or whatever key you're using

    await Future.delayed(const Duration(seconds: 1)); // for splash effect

    if (token != null && token.isNotEmpty) {
      getUserInfo(); // Fetch user info if token is available
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen22(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // home: AdminCrudScreen(),
    );
  }
}
