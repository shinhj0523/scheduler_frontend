import 'package:dio/dio.dart';
import '../models/user_model.dart'; // User 모델을 import

class UserService {
  final Dio dio = Dio(); // Dio 인스턴스 생성
  final String baseUrl = "http://127.0.0.1:8001"; // FastAPI 서버의 로컬 주소와 포트

  UserService() {
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: Duration(seconds: 5), // Duration 객체로 변경
      receiveTimeout: Duration(seconds: 3), // Duration 객체로 변경
    );
  }

  // 사용자 인증 요청
  Future<User?> authenticateUser(User user) async {
    try {
      final response =
          await dio.post('/users/authenticate', data: user.toJson());
      if (response.statusCode == 200) {
        // 서버로부터 받은 JSON 데이터를 User 객체로 변환
        return User.fromJson(response.data);
      } else {
        return null; // 인증 실패
      }
    } catch (e) {
      print('Error authenticating user: $e');
      return null;
    }
  }

  // 회원가입 요청
  Future<bool> registerUser(User user) async {
    try {
      final response = await dio.post('/users/register', data: user.toJson());
      if (response.statusCode == 200) {
        return true; // 회원가입 성공
      } else {
        return false; // 회원가입 실패
      }
    } catch (e) {
      print('Error registering user: $e');
      return false; // 오류 발생 시 회원가입 실패
    }
  }
}
