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
  String selectedLevel = 'Easy';
  int selectedLimit = 10;
  final List<String> levels = ['Easy', 'Medium', 'Hard'];
  final List<int> limits = [10, 20, 50];
  bool isLoading = false;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    loadTopResults();
  }

  Future<void> loadTopResults() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });

    try {
      final levelParam = selectedLevel.toLowerCase();

      final results = await ResultService().fetchTopResults(selectedLimit, levelParam);

      setState(() {
        topResults = results; // directly assign the list of Result objects
      });
    } catch (e) {
      setState(() {
        errorMsg = 'Error loading results: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  void applyFilter(String level) {
    setState(() {
      selectedLevel = level;
    });
    loadTopResults();
  }

  void changeLimit(int newLimit) {
    setState(() {
      selectedLimit = newLimit;
    });
    loadTopResults();
  }

  String _formatDuration(int seconds) {
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  return '${minutes}m ${remainingSeconds}s';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 18, 58),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Results',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Level & limit filters
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Level dropdown
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLevel,
                        icon: Icon(Icons.arrow_drop_down),
                        onChanged: (value) {
                          if (value != null) {
                            applyFilter(value);
                          }
                        },
                        items: levels.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Limit dropdown
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedLimit,
                        icon: Icon(Icons.arrow_drop_down),
                        onChanged: (value) {
                          if (value != null) {
                            changeLimit(value);
                          }
                        },
                        items: limits.map((limit) {
                          return DropdownMenuItem(
                            value: limit,
                            child: Text('Top $limit'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Results
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF9D90FF), Colors.white],
                    ),
                  ),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : errorMsg != null
                          ? Center(
                              child: Text(
                                errorMsg!,
                                style: TextStyle(color: Colors.red, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.separated(
                              itemCount: topResults.length,
                              separatorBuilder: (_, __) => SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final result = topResults[index];

                                Widget leadingIcon;
                                if (index == 0) {
                                  leadingIcon = Icon(Icons.emoji_events, color: Colors.amber, size: 30); // 🥇
                                } else if (index == 1) {
                                  leadingIcon = Icon(Icons.emoji_events, color: Colors.grey, size: 30); // 🥈
                                } else if (index == 2) {
                                  leadingIcon = Icon(Icons.emoji_events, color: Colors.brown, size: 30); // 🥉
                                } else {
                                  leadingIcon = CircleAvatar(
                                    backgroundColor: const Color.fromARGB(73, 255, 255, 255),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 113, 98, 179),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: leadingIcon,
                                    title: Text(
                                      result.displayName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      result.formattedDateTime,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${result.score}/10',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          _formatDuration(result.timeTaken),
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      // Handle tap event
                                      Navigator.pushNamed(
                                        context,
                                        '/result_detail',
                                        arguments: result,
                                      );
                                    },

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
