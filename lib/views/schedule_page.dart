import 'package:flutter/material.dart';
import '../services/reservation_service.dart'; // ReservationService import
import '../models/user_model.dart';
import 'reservation_page.dart'; // 예약 페이지

class SchedulePage extends StatefulWidget {
  final User user;

  SchedulePage({required this.user});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime selectedDate = DateTime.now(); // 초기 날짜는 현재 날짜로 설정
  List<Map<String, dynamic>> reservedSlots = []; // 예약된 슬롯들

  final ReservationService reservationService = ReservationService();

  @override
  void initState() {
    super.initState();
    fetchReservedSlots(); // 페이지 초기화 시 예약된 시간 불러오기
  }

  // 예약된 슬롯 불러오기 함수
  Future<void> fetchReservedSlots() async {
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    try {
      final fetchedSlots =
          await reservationService.getReservations(formattedDate);
      setState(() {
        reservedSlots = List<Map<String, dynamic>>.from(fetchedSlots); // 타입 캐스팅
      });
    } catch (e) {
      print('Error fetching reservations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule a Reservation'),
      ),
      body: Column(
        children: [
          // 달력 위젯
          CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 30)), // 최대 30일 선택 가능
            onDateChanged: (date) {
              setState(() {
                selectedDate = date;
              });
              fetchReservedSlots(); // 날짜가 변경되면 예약된 슬롯 재로드
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 예약된 시간대 확인
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservationPage(
                    selectedDate: selectedDate,
                    reservedSlots: reservedSlots, // 예약된 슬롯 전달
                    userId: widget.user.id,
                  ),
                ),
              );
            },
            child: Text('Go to Reservation'),
          ),
        ],
      ),
    );
  }
}
