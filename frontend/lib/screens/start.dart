// lib/screens/start.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/test_question.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './finish.dart';
import '../models/test_answer.dart';

class StartQuizScreen extends StatefulWidget {
  final String username;
  final List<TestQuestion> questions;

  const StartQuizScreen({
    super.key,
    required this.questions,
    required this.username,
  });

  @override
  State<StartQuizScreen> createState() => _StartQuizScreenState();
}

class _StartQuizScreenState extends State<StartQuizScreen> {
  int currentIndex = 0;
  int remainingTime = 0;
  late Timer timer;
  int score = 0;

  late List<Answer> answers;

  @override
  void initState() {
    super.initState();

    // Lý do khai báo List answers như này là để cho trường hợp
    // user bỏ qua/không chọn answer cho câu hỏi nào đó
    // Từng answer trong list sẽ tương ứng với List questions
    answers = List.generate(
      widget.questions.length,
      (index) => Answer(
        questionId: widget.questions[index].questionId,
        selectedOptionIndex: null,
      ),
    );

    remainingTime = widget.questions[0].maxTime * 10; // Time tổng của bài test
    startTimer();
  }

  // Hàm đếm thời gian tổng bài test
  // Nếu hết giờ mà user chưa chủ động finish bài
  // thì sẽ dừng bài test và gọi calculateTest
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        calculateTest();
      }
    });
  }

  // Hàm để chuyển câu hỏi tiếp theo
  // Nếu là câu cuối thì sẽ kết thúc bài test và gọi calculateTest
  void goToNextQuestion() {
    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      timer.cancel();
      calculateTest();
    }
  }

  // Hàm để quay lại các câu hỏi trước
  void goToBack() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  // Hàm này được gọi khi người dùng đã hoàn thành bài test
  // Được dùng để tính điểm bài test và chuyển sang trang Finish
  void calculateTest() {
    for (int i = 0; i < widget.questions.length; i++) {
      if (answers[i].selectedOptionIndex ==
          widget.questions[i].correctAnswerIndex) {
        score++;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => FinishScreen(
              userName: widget.username,
              score: score,
              total: 10,
              answers: answers,
              questions: widget.questions,
            ),
      ),
    );
  }

  //Hàm để lưu answer của người dùng cho mỗi câu hỏi
  void selectAnswer(int selectedIndex) {
    //selectedIndex là option người dùng chọn cho câu hỏi nào đó
    setState(() {
      answers[currentIndex].selectedOptionIndex = selectedIndex;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentIndex];
    double progress = (currentIndex + 1) / widget.questions.length;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Color(0xFFFFFAFA)),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quiz Time',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8E3DFF),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Color(0xFF8E3DFF)),
                    const SizedBox(width: 4),
                    Text(
                      '${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Color(0xFF8E3DFF)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 32),

            Text(
              question.questionText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Đoạn này bắt đầu liệt kê các option của một câu hỏi với index đi từ 0-3
            ...List.generate(question.options.length, (index) {
              //Biến này để tô đậm option mà người dùng chọn
              final isSelected =
                  answers[currentIndex].selectedOptionIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // Nếu isSelected là true thì option sẽ có background màu đậm hơn các option còn lại
                    backgroundColor:
                        isSelected ? Color(0xFF493D79) : Color(0xFF7F5CFF),

                    foregroundColor: Color(0xFFFFFAFA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed:
                      () => selectAnswer(
                        index,
                      ), // Gọi hàm để lưu answer của người dùng theo thứ tự tương ứng với question

                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 12,
                      ),
                      child: Text(
                        '${String.fromCharCode(97 + index)}. ${question.options[index]}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              );
            }),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '${(currentIndex + 1).toString()}/10', // Này là để hiển thị số thứ tự câu hỏi đang làm
                    style: const TextStyle(
                      // Ví dụ đang làm câu 2 trong tổng số 10 câu -> 2/10
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF121212),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.deepPurple,
                        ),
                        onPressed:
                            goToBack, //Mũi tên để lui lại mấy câu hỏi trước
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.deepPurple,
                        ),
                        onPressed:
                            goToNextQuestion, //Mũi tên để đi tới câu hỏi tiếp
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                'lib/assets/images/monsterQuestion.svg',
                height: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
