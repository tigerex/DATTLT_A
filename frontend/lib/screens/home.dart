import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 200,
        height: 100,
        color: Colors.blueAccent,
        child: Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    );
  }
}
