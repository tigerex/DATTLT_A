import 'package:flutter/material.dart';
// import 'dart:convert';
import '../models/test_result.dart';
import '../models/test_question.dart';
import './home22.dart';
import '../services/result.service.dart';
import '../services/question_service.dart';
import 'RecordReview.dart';

class TestRecords extends StatefulWidget {
  final String userId;

  const TestRecords({super.key, required this.userId});

  @override
  _TestRecordsState createState() => _TestRecordsState();
}

class _TestRecordsState extends State<TestRecords> {
  List<Result> records =
      []; //records và tempList đều để chứa các bài test đã làm
  List<Result> tempList =
      []; //tempList được tạo ra để sử dụng cho hàm applyFilter và applySort bên dưới
  String selectedLevel = 'All';
  final List<String> levels = ['All', 'Easy', 'Medium', 'Hard'];

  late String selectedSortOption = '';

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  // Load các bài test đã làm ngay khi người dùng vào trang test records
  Future<void> loadResults() async {
    try {
      final results = await ResultService().fetchResults(widget.userId);
      setState(() {
        records = results; // records là List<Result>
        tempList =
            results; //Lý do gán cho cả tempList là để hiển thị ban đầu là All
      });
    } catch (e) {
      print("Lỗi khi load kết quả: $e");
    }
  }

  void goToBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen22()),
    );
  }

  //Hàm để sort các bài test theo điểm tăng/giảm dần hoặc theo ngày
  void applySort() {
    if (selectedSortOption == 'score_asc') {
      tempList.sort((a, b) => a.score.compareTo(b.score));
    } else if (selectedSortOption == 'score_desc') {
      tempList.sort((a, b) => b.score.compareTo(a.score));
    } else if (selectedSortOption == 'date_asc') {
      tempList.sort((a, b) => a.date!.compareTo(b.date!));
    } else if (selectedSortOption == 'date_desc') {
      tempList.sort((a, b) => b.date!.compareTo(a.date!));
    }
  }

  void applyFilter() {
    if (selectedLevel == 'All') {
      tempList = records;
    } else {
      tempList =
          records
              .where(
                (r) => r.level.toLowerCase() == selectedLevel.toLowerCase(),
              )
              .toList();
    }
  }

  void showRecordDetail(BuildContext context, Result record) async {
    final questionIds = record.questions.map((q) => q.questionId).toList();
    final detailedQuestions = <TestQuestion>[];

    for (var id in questionIds) {
      final question = await QuestionService().fetchWithID(id);
      detailedQuestions.add(question);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => RecordReview(
              question: detailedQuestions,
              answer: record.questions,
              userId: widget.userId,
            ),
      ),
    );

    // showDialog(
    //   context: context,
    //   builder:
    //       (_) => Dialog(
    //         child: SizedBox(
    //           height: 400,
    //           width: double.maxFinite,
    //           child: ListView.builder(
    //             padding: EdgeInsets.all(20),
    //             itemCount: detailedQuestions.length,
    //             itemBuilder: (context, index) {
    //               return RecordReviewCard(
    //                 question: detailedQuestions[index],
    //                 answer: record.questions[index],
    //                 index: index,
    //               );
    //             },
    //           ),
    //         ),
    //       ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              heightFactor: 1,
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFFFFFAFA)),
                onPressed: goToBack, //Mũi tên để lui lại trang home
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Quiz Time',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFAFA),
                  ),
                ),
                const SizedBox(width: 15),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 95,
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: selectedLevel,
                          isDense: true,
                          isExpanded:
                              true, // để nội dung không bị ép và overflow
                          onChanged: (value) {
                            setState(() {
                              selectedLevel = value!;
                              applyFilter();
                            });
                          },
                          items:
                              levels.map((level) {
                                return DropdownMenuItem(
                                  value: level,
                                  child: Text(level),
                                );
                              }).toList(),
                          style: const TextStyle(
                            color: Color(0xFF3F3D56),
                            fontSize: 12,
                          ),
                          underline: const SizedBox(), // bỏ gạch dưới mặc định
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    PopupMenuButton(
                      icon: const Icon(Icons.sort, color: Color(0xFF121212)),
                      onSelected: (value) {
                        setState(() {
                          selectedSortOption = value;
                          applySort(); // hàm xử lý sort
                        });
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: 'score_asc',
                              child: Row(
                                children: [
                                  Text('Sort by score ↑'),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: selectedSortOption == 'score_asc'
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'score_desc',
                              child: Row(
                                children: [
                                  Text('Sort by score ↓'),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: selectedSortOption == 'score_desc'
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'date_asc',
                              child: Row(
                                children: [
                                  Text('Sort by date ↑'),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: selectedSortOption == 'date_asc'
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'date_desc',
                              child: Row(
                                children: [
                                  Text('Sort by date ↓'),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: selectedSortOption == 'date_desc'
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                height: 500,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFAFA),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Level',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Score',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Date',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Body scrollable
                      Expanded(
                        child: ListView.builder(
                          itemCount: tempList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFFFFAFA),
                                    shadowColor: Colors.grey.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          tempList[index].level,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${tempList[index].score}/10',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          tempList[index].formattedDateTime,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed:
                                      () => showRecordDetail(
                                        context,
                                        tempList[index],
                                      ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
