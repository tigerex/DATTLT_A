import 'package:flutter/material.dart';
import '../widgets/start_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/question_service.dart';

import './start.dart';

class ChooseLevelScreen extends StatelessWidget {
  final String username;

  const ChooseLevelScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(color: Color(0xFFFFFAFA)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset(
              'lib/assets/images/monsterChooseLevel.svg',
              height: 80,
            ),
            const SizedBox(height: 24),
            Text(
              "Let's go, $username!",
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
                    builder: (context) => StartQuizScreen(username: username, questions: questions),
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
                    builder: (context) => StartQuizScreen(username: username, questions: questions),
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
                    builder: (context) => StartQuizScreen(username: username, questions: questions),
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
