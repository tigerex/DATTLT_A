// lib/screens/home.dart
import 'package:flutter/material.dart';
import '../widgets/start_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './choose_level.dart';

class HomeScreen22 extends StatelessWidget {
  final String username;

  const HomeScreen22({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFFFFFAFA), // trắng
              Color(0xFF643DFF), // tím đậm
            ],
          ),
        ),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Text(
              'Hi $username',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFAFA),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ready to take a test?',
              style: TextStyle(fontSize: 16, color: Color(0xFFFFFAFA)),
            ),
            const Spacer(),
            // Add your own image widget here
            SvgPicture.asset('lib/assets/images/monsterDonut.svg', height: 120),
            const Spacer(),
            StartButton(
              text: 'Start now',
              onPressed: () => Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => ChooseLevelScreen(username: username,))
                ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
