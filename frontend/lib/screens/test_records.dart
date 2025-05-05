import 'package:flutter/material.dart';
import '../models/test_result.dart';
import '../services/result.service.dart';

class TestRecords extends StatefulWidget {
  const TestRecords({super.key});

  @override
  _TestRecordsState createState() => _TestRecordsState();
}

class _TestRecordsState extends State<TestRecords> {
  List<Result> records = [];
  List<Result> tempList = [];
  String selectedLevel = 'All';
  final List<String> levels = ['All', 'Easy', 'Medium', 'Hard'];

  late String selectedSortOption;

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

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    try {
      final results = await ResultService().fetchResults();
      setState(() {
        records = results; // records là List<Result>
        tempList = results;
      });
    } catch (e) {
      print("Lỗi khi load kết quả: $e");
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                            const PopupMenuItem(
                              value: 'score_asc',
                              child: Text('Sort by score ↑'),
                            ),
                            const PopupMenuItem(
                              value: 'score_desc',
                              child: Text('Sort by score ↓'),
                            ),
                            const PopupMenuItem(
                              value: 'date_asc',
                              child: Text('Sort by date ↑'),
                            ),
                            const PopupMenuItem(
                              value: 'date_desc',
                              child: Text('Sort by date ↓'),
                            ),
                          ],
                    ),
                  ],
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
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
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Score',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Date',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                const SizedBox(height: 25),
                                Row(
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
