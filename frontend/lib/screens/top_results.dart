import 'package:flutter/material.dart';
import '../models/test_result.dart';
import '../services/result.service.dart';

class TopResults extends StatefulWidget {
  final String userId;

  const TopResults({super.key, required this.userId});

  @override
  _TopResultsState createState() => _TopResultsState();
}

class _TopResultsState extends State<TopResults> {
  List<Result> topResults = [];
  String selectedLevel = 'All';
  final List<String> levels = ['All', 'Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
    loadTopResults();
  }

  Future<void> loadTopResults() async {
    try {
      final results = await ResultService().fetchResults(widget.userId);

      // Lọc và sắp xếp điểm cao nhất, lấy top 10
      results.sort((a, b) => b.score.compareTo(a.score));
      setState(() {
        topResults = results.take(10).toList();
      });
    } catch (e) {
      print("Lỗi khi load top result: $e");
    }
  }

  void applyFilter(String level) async {
    final results = await ResultService().fetchResults(widget.userId);
    List<Result> filtered = level == 'All'
        ? results
        : results.where((r) => r.level.toLowerCase() == level.toLowerCase()).toList();

    filtered.sort((a, b) => b.score.compareTo(a.score));

    setState(() {
      selectedLevel = level;
      topResults = filtered.take(10).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2D3A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Top 10',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 100,
                height: 32,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLevel,
                    onChanged: (value) {
                      if (value != null) {
                        applyFilter(value);
                      }
                    },
                    items: levels
                        .map((level) => DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF9D90FF), Colors.white],
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: topResults.length,
                    itemBuilder: (context, index) {
                      final result = topResults[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF6E57E0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ListTile(
                            leading: Text(
                              '${index + 1}.',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            title: Text(
                              result.username ?? 'Unknown',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              '${result.score}/10   |   ${result.formattedDateTime}',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
