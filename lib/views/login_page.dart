import 'package:flutter/material.dart';
import 'register_page.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'schedule_page.dart'; // 스케줄 페이지

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserService userService = UserService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: studentIdController,
              decoration: InputDecoration(labelText: 'Student ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // 사용자 인증 요청
                User user = User(
                  id: 0,
                  name: nameController.text,
                  studentId: studentIdController.text,
                );
                User? authenticatedUser =
                    await userService.authenticateUser(user);

                if (authenticatedUser != null) {
                  // 로그인 성공 시 다음 페이지로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SchedulePage(user: authenticatedUser),
                    ),
                  );
                } else {
                  // 로그인 실패 시 알림
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed')),
                  );
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // 회원가입 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
