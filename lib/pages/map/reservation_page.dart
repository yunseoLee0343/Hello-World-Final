import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world_final/api_models/reservation_model.dart';
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

  List<CounselorRes> counselorList = [];

  final dummyJson = jsonEncode({
    "today": "2024-08-01T12:00:00Z",
    "counselorList": [
      {
        "name": "John Doe",
        "centerName": "Wellness Center",
        "language": ["English", "Spanish"],
        "start": "2024-08-01T09:00:00Z",
        "end": "2024-08-01T17:00:00Z"
      },
      {
        "name": "Jane Smith",
        "centerName": "Health Hub",
        "language": ["English", "French"],
        "start": "2024-08-01T10:00:00Z",
        "end": "2024-08-01T16:00:00Z"
      },
      {
        "name": "Emily Johnson",
        "centerName": "Life Balance Center",
        "language": ["English", "German"],
        "start": "2024-08-01T11:00:00Z",
        "end": "2024-08-01T15:00:00Z"
      }
    ]
  });

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

  Future<List<CounselorRes>> _getCounselors() async {
    // API 호출
    final response = await http.get(
        Uri.parse('http://localhost:8082/center/${widget.centerID}/detail'));
    final Map<String, dynamic> responseData = json.decode(response.body);

    final data = responseData['counselorList'];
    data.forEach((element) {
      final counselor = CounselorRes.fromJson(element);
      counselorList.add(counselor);
    });
    return counselorList;
  }

  Future<void> _selectData() async {
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

  // Function to send data to the server
  Future<void> sendCounselorSelection(
      String centerID, DateTime selectedDate, CounselorRes counselor) async {
    final url = Uri.parse('http://localhost:8082/center/$centerID/selection');

    // Create a map to hold the data
    final Map<String, dynamic> data = {
      'selectedDate': selectedDate.toIso8601String(),
      'selectedTime': {
        'start': counselor.start.toIso8601String(),
        'end': counselor.end.toIso8601String(),
      },
      'selectedCounselor': {
        'name': counselor.name,
        'centerName': counselor.centerName,
        'language': counselor.language,
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Data sent successfully');
      } else {
        // Handle failure
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data: $e');
    }
  }

  Future<Map<String, dynamic>> fetchCenterDetail(String centerId) async {
    final url = Uri.parse('http://localhost:8082/center/$centerId/detail');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
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
            const SizedBox(height: 8),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              child: Column(
                            children: [
                              FutureBuilder<List<CounselorRes>>(
                                future: _getCounselors(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<CounselorRes>>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData) {
                                    final counselorList = snapshot.data!;
                                    return ListView.builder(
                                      itemCount: counselorList.length,
                                      itemBuilder: (context, index) {
                                        final counselor = counselorList[index];
                                        return Card(
                                          margin: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(16.0),
                                            title: Text(counselor.name),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${counselor.start} ~ ${counselor.end}'),
                                                Text(
                                                    'Center: ${counselor.name}'),
                                                Text(
                                                    'Center: ${counselor.centerName}'),
                                                // Languages with border-radius and hug width
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Text(
                                                    'Languages: ${counselor.language.join(', ')}',
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    softWrap: true,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              '예약하기'),
                                                          content: Column(
                                                            children: [
                                                              Text(
                                                                  '선택한 날짜: ${selectedDate.toString()}'),
                                                              Text(
                                                                  '선택한 시간: ${counselor.start} ~ ${counselor.end}'),
                                                              Text(
                                                                  '선택한 상담사: ${counselor.name}'),
                                                              Text(
                                                                  '선택한 센터: ${counselor.centerName}'),
                                                              Text(
                                                                  '선택한 언어: ${counselor.language.join(', ')}'),
                                                            ],
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  '취소'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  '예약하기'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: const Text("예약하기"),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return const Center(
                                        child: Text('No data available'));
                                  }
                                },
                              ),
                            ],
                          )),
                        )
                      ],
                    ),
                  )
                : FutureBuilder<Map<String, dynamic>>(
                    future: fetchCenterDetail(widget.centerID),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        // Assuming the response data contains keys `name`, `status`, `address`
                        final name = data['name'] ?? 'N/A';
                        final status = data['status'] ?? 'N/A';
                        final address = data['address'] ?? 'N/A';

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: $name',
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 8),
                              Text('Status: $status',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 8),
                              Text('Address: $address',
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
