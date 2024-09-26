import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final UserService userService = UserService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
            TextField(
              controller: studentIdController,
              decoration: InputDecoration(labelText: 'Student ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // 회원가입 요청
                User user = User(
                  id: 0, // 회원가입 시 id는 0으로 설정, 서버에서 생성
                  name: nameController.text,
                  studentId: studentIdController.text,
                );
                bool success = await userService.registerUser(user);

                if (success) {
                  // 회원가입 성공
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration successful')),
                  );
                  Navigator.pop(context); // 회원가입 후 로그인 페이지로 돌아감
                } else {
                  // 회원가입 실패
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration failed')),
                  );
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
