import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/auth_service.dart';
import 'login.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userAge = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    getUserInfo();  // Fetch user info when the screen loads
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
      if (data!= null && data.isNotEmpty) {
        setState(() {
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
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => showLogoutAlert(context),
            tooltip: "Logout",
          ),
          ElevatedButton(
            onPressed: () => showLogoutAlert(context),
            
            child: const Text("Logout"),
          ),
        ],
      ),
      body: Center(
        child: userName.isEmpty
        ? const CircularProgressIndicator()
        : Container(
          // color: Colors.blue,
          width: 360, // Set the width of the card
          padding: const EdgeInsets.all(16), // Optional: adds padding around the card
          child: Card(
            color: Colors.white, // Card background color
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24), // Inside padding for content
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 50, // Made it a lil bigger
                    child: Icon(Icons.person, size: 60),
                  ),
                  const SizedBox(height: 20),
                  Text(userName,style: const TextStyle(fontSize: 48,fontWeight: FontWeight.bold,),),
                  const SizedBox(height: 18),
                  Text('Email: $userEmail', style: const TextStyle(fontSize: 18)),
                  Text('Phone: $userPhone', style: const TextStyle(fontSize: 18)),
                  Text('Age: $userAge', style: const TextStyle(fontSize: 18)),
                  Text('Role: $userRole', style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
