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

  void openQuestionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade200,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // 5 ô mỗi hàng
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5, // chỉnh cho ô gọn
            ),
            itemCount: widget.questions.length,
            itemBuilder: (context, index) {
              bool haveDone = answers[index].selectedOptionIndex != null;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: haveDone ? Color(0xFF493D79) : Colors.deepPurpleAccent.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () {
                  setState(() {
                    currentIndex = index; // chuyển tới câu chọn
                  });
                },
                child: Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFAFA),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 15,
        leading: Center( // 👈 Bọc IconButton bằng Center
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.menu, size: 20),
            // constraints: const BoxConstraints(),
            onPressed: () => openQuestionMenu(context),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Color(0xFFFFFAFA)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        
              const Spacer(),
        
              // Đoạn này hiển thị câu hỏi hiện tại
              // Nếu câu hỏi có ảnh thì sẽ hiển thị ảnh lên trước câu hỏi
              if (question.questionImg != null &&
                  question.questionImg.isNotEmpty) ...[
                Image.network(
                  question.questionImg, // Đường dẫn ảnh từ backend
                  height: 140, // Chiều cao của ảnh
                  width: double.infinity, // Chiều rộng của ảnh
                  fit: BoxFit.contain, // Cách hiển thị ảnh
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Error loading image!!!',
                    ); // Nếu không tải được ảnh thì sẽ hiển thị text này
                  },
                ),
                const SizedBox(height: 16),
              ],
        
              Text(
                question.questionText,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
        
              // Đoạn này bắt đầu liệt kê các option của một câu hỏi với index đi từ 0-3
              ...List.generate(question.options.length, (index) {
                //Biến này để tô đậm option mà người dùng chọn
                final isSelected =
                    answers[currentIndex].selectedOptionIndex == index;
        
                return Padding(
                  padding: const EdgeInsets.only(bottom: 3),
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
                          vertical: 6.0,
                          horizontal: 6,
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
                      '${(currentIndex + 1).toString()}/${widget.questions.length}', // Này là để hiển thị số thứ tự câu hỏi đang làm
                      style: const TextStyle(
                        // Ví dụ đang làm câu 2 trong tổng số 10 câu -> 2/10
                        fontSize: 13,
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
        
              // const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: SvgPicture.asset(
                  'lib/assets/images/monsterQuestion.svg',
                  height: 50,
                ),
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
