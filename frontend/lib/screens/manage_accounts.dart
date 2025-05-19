import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import './admin_crud.dart';

class ManageAccounts extends StatefulWidget {
  const ManageAccounts({super.key});

  @override
  State<ManageAccounts> createState() => _ManageAccountsState();
}

class _ManageAccountsState extends State<ManageAccounts> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  // Load các bài test đã làm ngay khi người dùng vào trang test records
  Future<void> loadAccounts() async {
    try {
      final results = await UserService().fetchUser();
      setState(() {
        users = results;
      });
    } catch (e) {
      print("Lỗi khi load user: $e");
    }
  }

  void disabaleUserAlert(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(users[index].status == 'active' 
            ? 'Disable Account' 
            : 'Enable Account'),
          content: Text(users[index].status == 'active'
            ? 'Are you sure you want to disable this account?'
            : 'Are you sure you want to enable this account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                setState(() {
                  if(users[index].status == 'disabled') {
                    users[index].status = 'active';
                    UserService().disableUser(users[index]);
                  } else {
                    users[index].status = 'disabled';
                    UserService().disableUser(users[index]);
                  }
                });
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    // showDialog(
    //   context: context,
    //   barrierDismissible: false, // Prevent user from closing it manually
    //   builder: (context) {
    //     return AlertDialog(
    //       title: const Text('Done!'),
    //       content: Text('Question deleted successfully'),
    //     );
    //   },
    // );

    // Future.delayed(const Duration(seconds: 2), () {
    //   Navigator.of(context).pop(); // Close the dialog
    // });
  }

  void goToBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminCrudScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              heightFactor: 1,
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF121212)),
                onPressed: goToBack, //Mũi tên để lui lại trang home
              ),
            ),
            Text(
              'Manage Accounts',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF121212),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final q = users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        '${q.displayName} (${q.role})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${q.id}'),
                          Text('Email: ${q.email}'),
                          Text('Phone: ${q.phone}'),
                          Text('Age: ${q.age}'),
                          Text('Status: ${q.status}'),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: Icon(
                          q.status == 'disabled'
                              ? Icons.lock
                              : Icons.lock_open,
                          color:
                              q.status == 'disabled'
                                  ? Colors.red
                                  : Colors.green,
                        ),
                        onPressed: () {
                          // Gọi hàm disable/enable user
                          disabaleUserAlert(context, index);
                        },
                        tooltip:
                            q.status == 'disabled'
                                ? 'Enable Account'
                                : 'Disable Account',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
