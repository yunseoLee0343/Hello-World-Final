import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_world_final/api_models/recent_applicants_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  var userId = "";

  Future<AllReservationListRes> _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";

    // final response = await http.post(
    //   Uri.parse('http://localhost:8082/myPage/allReservation'),
    //   headers: <String, String>{
    //     'accept': '*/*',
    //     'user_id': userId ?? "user1",
    //   },
    // );

    // var data = jsonDecode(response.body);

    var dummyData = {
      "allReservationList": [
        {
          "summaryId": 1,
          "identificationNum": "ID001",
          "uploadedAt": "2024-07-31T10:00:00",
          "name": "John Doe",
          "userImg": "https://example.com/images/user1.jpg",
          "title": "Reservation 1"
        },
        {
          "summaryId": 2,
          "identificationNum": "ID002",
          "uploadedAt": "2024-07-31T11:00:00",
          "name": "Jane Smith",
          "userImg": "https://example.com/images/user2.jpg",
          "title": "Reservation 2"
        },
        {
          "summaryId": 3,
          "identificationNum": "ID003",
          "uploadedAt": "2024-07-31T12:00:00",
          "name": "Alice Johnson",
          "userImg": "https://example.com/images/user3.jpg",
          "title": "Reservation 3"
        },
        {
          "summaryId": 4,
          "identificationNum": "ID004",
          "uploadedAt": "2024-07-31T13:00:00",
          "name": "Bob Brown",
          "userImg": "https://example.com/images/user4.jpg",
          "title": "Reservation 4"
        },
        {
          "summaryId": 5,
          "identificationNum": "ID005",
          "uploadedAt": "2024-07-31T14:00:00",
          "name": "Charlie Davis",
          "userImg": "https://example.com/images/user5.jpg",
          "title": "Reservation 5"
        },
        {
          "summaryId": 6,
          "identificationNum": "ID006",
          "uploadedAt": "2024-07-31T15:00:00",
          "name": "Diana Evans",
          "userImg": "https://example.com/images/user6.jpg",
          "title": "Reservation 6"
        },
        {
          "summaryId": 7,
          "identificationNum": "ID007",
          "uploadedAt": "2024-07-31T16:00:00",
          "name": "Ethan Foster",
          "userImg": "https://example.com/images/user7.jpg",
          "title": "Reservation 7"
        },
        {
          "summaryId": 8,
          "identificationNum": "ID008",
          "uploadedAt": "2024-07-31T17:00:00",
          "name": "Fiona Green",
          "userImg": "https://example.com/images/user8.jpg",
          "title": "Reservation 8"
        },
        {
          "summaryId": 9,
          "identificationNum": "ID009",
          "uploadedAt": "2024-07-31T18:00:00",
          "name": "George Harris",
          "userImg": "https://example.com/images/user9.jpg",
          "title": "Reservation 9"
        },
        {
          "summaryId": 10,
          "identificationNum": "ID010",
          "uploadedAt": "2024-07-31T19:00:00",
          "name": "Hannah Irvine",
          "userImg": "https://example.com/images/user10.jpg",
          "title": "Reservation 10"
        }
      ]
    };

    // data = dummyData;
    // log("data: $data");
    return AllReservationListRes.fromJson(dummyData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("최근 상담 신청자 목록"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: FutureBuilder<AllReservationListRes>(
          future: _getLocalData(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(child: CircularProgressIndicator());
            // } else if (snapshot.hasError) {
            //   return Center(child: Text('An error occurred: ${snapshot.error}'));
            // } else
            // if (snapshot.hasData) {
            var reservations = snapshot.data!.allReservationList;
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                var reservation = reservations[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/applicant_summary');
                  },
                  child: Container(
                      width: 316,
                      height: 128,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(reservation.summaryId.toString()),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(reservation.userImg),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(reservation.uploadedAt.toString()),
                                  Text(
                                    reservation.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      )),
                );

                // return ListTile(
                //   leading: CircleAvatar(
                //     backgroundImage: NetworkImage(reservation.userImg),
                //   ),
                //   title: Text(reservation.name),
                //   subtitle: Text(reservation.title),
                //   trailing: Text(reservation.uploadedAt.toString()),
                // );
              },
            );
            // }
            // else {
            //   return const Center(child: Text('No data available'));
            // }
          },
        ),
      ),
    );
  }
}
