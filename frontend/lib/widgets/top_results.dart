import 'package:flutter/material.dart';
import 'package:frontend/models/test_result.dart';
import 'package:frontend/services/result.service.dart';
import 'package:intl/intl.dart';

class TopResults extends StatelessWidget {
  const TopResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2730),
      appBar: AppBar(
        title: const Text("Test_records"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8F94FB), Color(0xFF4E54C8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 10,
                        child: Image.asset(
                          'assets/medal_top10.png',
                          width: 50,
                        ),
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Top 10',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4E54C8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder<List<Result>>(
                      future: ResultService().fetchTopResults(10),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text("Lỗi khi tải dữ liệu."));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("Chưa có dữ liệu."));
                        }

                        final topResults = snapshot.data!;
                        return ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: topResults.length,
                          itemBuilder: (context, index) {
                            final result = topResults[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${index + 1}.',
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(
                                    result.userId,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${result.score}/10'),
                                  Text(DateFormat('dd/MM/yyyy').format(result.date!)),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}