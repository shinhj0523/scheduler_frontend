import 'package:flutter/material.dart';
import '../services/reservation_service.dart'; // ReservationService import

class ReservationPage extends StatefulWidget {
  final DateTime selectedDate; // 사용자가 선택한 날짜
  final List<Map<String, dynamic>> reservedSlots; // 예약된 시간대 리스트
  final int userId; // 예약할 사용자 ID

  ReservationPage({
    required this.selectedDate,
    required this.reservedSlots,
    required this.userId,
  });

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<int> selectedSlots = [];
  final ReservationService reservationService = ReservationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Time Slots')),
      body: Column(
        children: [
          // 시간 선택 리스트
          Expanded(
            child: ListView.builder(
              itemCount: 24,
              itemBuilder: (context, index) {
                // 예약된 시간대에서 유저 이름도 포함된 슬롯을 확인
                Map<String, dynamic>? reservedSlot =
                    widget.reservedSlots.firstWhere(
                  (slot) => slot['hour'] == index,
                  orElse: () => {
                    'hour': -1, // 기본값으로 사용되지 않는 값을 넣습니다.
                    'user_name': '',
                    'user_id': null,
                    'id': null
                  },
                );

                bool isReserved =
                    reservedSlot['hour'] != -1; // 기본값과 비교하여 예약 여부 확인
                bool isSelected = selectedSlots.contains(index);

                return ListTile(
                  title: Text(
                    '${index}:00 ${isReserved ? '- Reserved by: ${reservedSlot['user_name']}' : ''}',
                  ),
                  tileColor: isReserved
                      ? Colors.red.withOpacity(0.5) // 예약된 시간대는 빨간색
                      : isSelected
                          ? Colors.green.withOpacity(0.5) // 선택된 시간대는 초록색
                          : null,
                  trailing:
                      isReserved && reservedSlot['user_id'] == widget.userId
                          ? IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _confirmDeleteReservation(reservedSlot['id']),
                            )
                          : null,
                  onTap: isReserved
                      ? null
                      : () => selectSlot(index), // 예약된 슬롯은 선택 불가
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed:
                selectedSlots.isEmpty ? null : () async => await reserve(),
            child: Text('Reserve'),
          ),
        ],
      ),
    );
  }

  // 시간 선택 처리 함수
  void selectSlot(int hour) {
    if (selectedSlots.contains(hour)) {
      setState(() {
        selectedSlots.remove(hour);
      });
    } else if (selectedSlots.length < 2) {
      setState(() {
        selectedSlots.add(hour);
      });
    }
  }

  // 예약 생성 함수
  Future<void> reserve() async {
    bool success = await reservationService.createReservation(
        widget.userId, widget.selectedDate, selectedSlots);
    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Reservation successful')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Reservation failed')));
    }
  }

  // 삭제 전에 확인 팝업을 보여주는 함수
  Future<void> _confirmDeleteReservation(int reservationId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Reservation"),
          content: Text("Are you sure you want to delete this reservation?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 확인 취소 시 팝업 닫기
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 확인 후 팝업 닫기
                _deleteReservation(reservationId); // 삭제 함수 호출
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // 삭제 함수
  Future<void> _deleteReservation(int reservationId) async {
    bool success = await reservationService.deleteReservation(reservationId);
    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Reservation deleted')));
      setState(() {
        widget.reservedSlots.removeWhere((slot) => slot['id'] == reservationId);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Deletion failed')));
    }
  }
}
