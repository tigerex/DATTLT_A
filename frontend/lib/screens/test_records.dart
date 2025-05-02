import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/test_result.dart';

class TestRecords extends StatefulWidget {
  final List<Result> records;

  const TestRecords({super.key, required this.records});

  @override
  _TestRecordsState createState() => _TestRecordsState();
}

class _TestRecordsState extends State<TestRecords> {
  String selectedLevel = 'All';
  final List<String> levels = ['All', 'Easy', 'Medium', 'Hard'];

  late String selectedSortOption;

  void applySort() {
    if (selectedSortOption == 'score_asc') {
      widget.records.sort((a, b) => a.score.compareTo(b.score));
    } else if (selectedSortOption == 'score_desc') {
      widget.records.sort((a, b) => b.score.compareTo(a.score));
    // } else if (selectedSortOption == 'date_asc') {
    //   widget.records.sort((a, b) => a.date.compareTo(b.date));
    // } else if (selectedSortOption == 'date_desc') {
    //   widget.records.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Quiz Time',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFAFA),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: selectedLevel,
                      onChanged: (value) {
                        setState(() {
                          selectedLevel = value!;
                          // gọi hàm lọc records ở đây nếu cần
                        });
                      },
                      items:
                          levels.map((level) {
                            return DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            );
                          }).toList(),
                      style: const TextStyle(color: Color(0xFF3F3D56)),
                      underline: const SizedBox(), // bỏ gạch dưới mặc định
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
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
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(),
                child: Center(
                  child: Column(
                    children: [
                      Row(),
                      // LinearBorder(),
                      // list.generate results with values (level, score, date)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
