// lib/screens/finish.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screens/home22.dart';
import '../widgets/start_button.dart';
import './choose_level.dart';
import '../models/test_answer.dart';
import '../models/test_question.dart';
import '../widgets/QuestionDetailDialog.dart';

class FinishScreen extends StatefulWidget {
  final String userID;
  final String userName;
  final int score;
  final int total;
  final List<Answer> answers;
  final List<TestQuestion> questions;

  const FinishScreen({
    super.key,
    required this.userID,
    required this.userName,
    required this.score,
    required this.total,
    required this.answers,
    required this.questions,
  });

  @override
  State<FinishScreen> createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  //Truyền biến cho widget QuestionDetailDialog để hiển thị chi tiết answer
  void showQuestionDetail(
    BuildContext context,
    TestQuestion question,
    Answer userAnswer,
  ) {
    showDialog(
      context: context,
      builder:
          (context) =>
              QuestionDetailDialog(question: question, userAnswer: userAnswer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7F5CFF), Color(0xFFDAAFFE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/monsterCongrats.svg', height: 150),
              const SizedBox(height: 10),
              Text(
                'Great job, ${widget.userName}!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFAFA),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "🌟 You've completed the test. 🎉",
                style: TextStyle(fontSize: 14, color: Colors.white60),
              ),
              const SizedBox(height: 24),
              Text(
                'You scored: ${widget.score} out of ${widget.total}', // Bên start giải thích cách tính. Hàm calculateTest
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFFFAFA),
                  fontWeight: FontWeight.w500,
                ),
              ),
              // const SizedBox(height: 15),

              //Từ chỗ này in 10 answer của user, bấm vào sẽ coi được chi tiết
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ), // 👈 chỉnh margin ngoài
                child: GridView.count(
                  crossAxisCount: 4, // 👉 4 ô answer mỗi hàng
                  mainAxisSpacing: 10, // 👈 khoảng cách giữa các hàng
                  crossAxisSpacing: 2, // 👈 khoảng cách giữa các cột
                  childAspectRatio: 2.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(widget.answers.length, (index) {
                    //Để check đúng sai, in ✅ nếu đúng và ❌ nếu sai hoặc không chọn option
                    //Biến được sử dụng ở line 123
                    final bool isCorrect =
                        (widget.answers[index].selectedOptionIndex ==
                            widget.questions[index].correctAnswerIndex);

                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFFAFA),
                          foregroundColor: Color(0xFF121212),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                        ),

                        //User bấm chọn câu nào đó trong 10 câu để coi chi tiết
                        //Gọi hàm hiển thị chi tiết câu trả lời
                        onPressed:
                            () => showQuestionDetail(
                              context,
                              widget.questions[index],
                              widget.answers[index],
                            ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Số thứ tự của từng câu
                              Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 3),

                              //icon thể hiện là câu đó user làm đúng hay sai
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect ? Colors.green : Colors.red,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Keep practicing to improve even more!',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 24),

              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Color(0xFFFFFAFA),
              //     foregroundColor: Color(0xFF7F5CFF),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(32),
              //     ),
              //   ),
              //   onPressed:
              //       () => Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //           builder:
              //               (context) => ChooseLevelScreen(
              //                 userID: widget.userID,
              //                 username: widget.userName,
              //               ),
              //         ),
              //       ),
              //   child: const Padding(
              //     padding: EdgeInsets.symmetric(
              //       horizontal: 24.0,
              //       vertical: 12.0,
              //     ),
              //     child: Text(
              //       'Take another test',
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StartButton(
                    text: 'Take another test',
                    onPressed:
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChooseLevelScreen(
                                  userID: widget.userID,
                                  username: widget.userName,
                                ),
                          ),
                        ),
                  ),
                  SizedBox(width: 5,),
                  StartButton(
                    text: 'No, me go home',
                    onPressed:
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HomeScreen22(),
                          ),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
