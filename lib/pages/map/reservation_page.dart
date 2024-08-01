import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReservationPage extends StatefulWidget {
  final String centerID;
  final String centerName;

  const ReservationPage(
      {super.key, required this.centerID, required this.centerName});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  String? activeButton = "button1";
  DateTime? _selectedDate;
  late DateTime initialDate;
  late DateTime firstDate;
  late DateTime lastDate;

  @override
  void initState() {
    super.initState();

    // 날짜 설정
    initialDate = DateTime.now();
    firstDate = DateTime(2000, 1, 1);
    lastDate = DateTime(2100, 12, 31);

    // DatePicker를 자동으로 보여주기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_selectDate();
    });
  }

  Future<void> _getCenterInfo() async {
    // API 호출
    final response = await http.get(Uri.parse(
        'http://localhost:8082/center/${widget.centerID}/reservation'));
    final Map<String, dynamic> responseData = json.decode(response.body);

    // API 호출 결과를 ApiResponse 객체로 변환
    // searchedCenterInfo = ApiResponse.fromJson(responseData);
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        initialDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    DateTime firstDate = DateTime(2000, 1, 1);
    DateTime lastDate = DateTime(2100, 12, 31);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.centerName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activeButton = 'button1'; // Update active button
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (activeButton == 'button1') {
                          return Colors.blue; // Active button color
                        }
                        return Colors.grey; // Default color
                      },
                    ),
                  ),
                  child:
                      const Text('예약하기', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      activeButton = 'button2'; // Update active button
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (activeButton == 'button2') {
                          return Colors.blue; // Active button color
                        }
                        return Colors.grey; // Default color
                      },
                    ),
                  ),
                  child:
                      const Text('상세정보', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            activeButton == 'button1' // Check active button
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.filter_alt),
                            Text('언어 필터링'),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text("날짜와 시간을 선택해 주세요"),
                        const SizedBox(
                          height: 8,
                        ),
                        CalendarDatePicker(
                          initialDate: selectedDate,
                          firstDate: firstDate,
                          lastDate: lastDate,
                          onDateChanged: (DateTime newDate) {
                            setState(() {
                              selectedDate = newDate;
                            });
                          },
                        ),
                        Container(
                            child: const Column(
                          children: [],
                        ))
                      ],
                    ),
                  )
                : const Text('상세정보 페이지'),
          ],
        ),
      ),
    );
  }
}
