import 'package:flutter/material.dart';
import '../widgets/start_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/question_service.dart';
import '../services/auth_service.dart';
import './login.dart';

import './start.dart';

class ChooseLevelScreen extends StatefulWidget {
  final String userID;
  final String username;

  const ChooseLevelScreen({super.key, required this.userID, required this.username});

  @override
  State<ChooseLevelScreen> createState() => _ChooseLevelScreenState();
}

class _ChooseLevelScreenState extends State<ChooseLevelScreen> {
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
      body: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(color: Color(0xFFFFFAFA)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => showLogoutAlert(context),
              tooltip: "Logout",
            ),
            const Spacer(),
            SvgPicture.asset(
              'lib/assets/images/monsterChooseLevel.svg',
              height: 80,
            ),
            const SizedBox(height: 24),
            Text(
              "Let's go, ${widget.username}!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8E3DFF),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose your difficulty:",
              style: TextStyle(fontSize: 14, color: Color(0xFF8E3DFF)),
            ),
            const SizedBox(height: 32),
            StartButton(
              text: 'Easy',
              onPressed: () async {
                final questions = await fetchQuestions('easy');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => StartQuizScreen(
                          userID: widget.userID,
                          username: widget.username,
                          questions: questions,
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            StartButton(
              text: 'Medium',
              onPressed: () async {
                final questions = await fetchQuestions('medium');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => StartQuizScreen(
                          userID: widget.userID,
                          username: widget.username,
                          questions: questions,
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            StartButton(
              text: 'Hard',
              onPressed: () async {
                final questions = await fetchQuestions('hard');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => StartQuizScreen(
                          userID: widget.userID,
                          username: widget.username,
                          questions: questions,
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            StartButton(
              text: 'Image Only',
              onPressed: () async {
                final questions = await fetchQuestions('imgonly');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => StartQuizScreen(
                          userID: widget.userID,
                          username: widget.username,
                          questions: questions,
                        ),
                  ),
                );
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
