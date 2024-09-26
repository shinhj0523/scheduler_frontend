class User {
  final int id; // 사용자 ID
  final String name;
  final String studentId;

  User({required this.id, required this.name, required this.studentId});

  // JSON 데이터를 모델로 변환
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // JSON에서 사용자 ID를 받음
      name: json['name'],
      studentId: json['student_id'],
    );
  }

  // 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id, // 사용자 ID를 JSON으로 변환
      'name': name,
      'student_id': studentId,
    };
  }
}
