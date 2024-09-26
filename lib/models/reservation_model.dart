class Reservation {
  final String reservedTime;
  final int durationHours;
  final int? id; // 예약 생성 후 서버에서 부여받는 ID
  final int? userId;

  Reservation(
      {required this.reservedTime,
      required this.durationHours,
      this.id,
      this.userId});

  // JSON 데이터를 모델로 변환
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservedTime: json['reserved_time'],
      durationHours: json['duration_hours'],
      id: json['id'],
      userId: json['user_id'],
    );
  }

  // 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'reserved_time': reservedTime,
      'duration_hours': durationHours,
    };
  }
}
