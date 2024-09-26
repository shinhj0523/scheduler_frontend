import 'package:dio/dio.dart';

class ReservationService {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://127.0.0.1:8001"));

  // 예약 조회 (특정 날짜의 예약)
  Future<List<Map<String, dynamic>>> getReservations(String date) async {
    try {
      final response = await dio.get('/reservations/$date');
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> reservations =
            List<Map<String, dynamic>>.from(response.data['reservations']);
        print(reservations); // 예약 데이터를 확인하는 디버깅 출력
        return reservations;
      } else {
        print('Failed to fetch reservations');
        return [];
      }
    } catch (e) {
      print('Error fetching reservations: $e');
      return [];
    }
  }

  Future<bool> createReservation(
      int userId, DateTime selectedDate, List<int> selectedSlots) async {
    try {
      for (var hour in selectedSlots) {
        String reservationTime =
            '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:00:00';

        final response = await dio.post('/users/$userId/reservations',
            data: {'reserved_time': reservationTime, 'duration_hours': 1});

        if (response.statusCode != 200) {
          return false;
        }
      }
      return true;
    } catch (e) {
      print('Error creating reservation: $e');
      return false;
    }
  }

  Future<bool> deleteReservation(int reservationId) async {
    try {
      final response = await dio.delete('/reservations/$reservationId');
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting reservation: $e');
      return false;
    }
  }

  Future<bool> updateReservation(int reservationId, String newTime) async {
    try {
      final response = await dio.put('/reservations/$reservationId', data: {
        'new_time': newTime,
      });
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating reservation: $e');
      return false;
    }
  }
}
