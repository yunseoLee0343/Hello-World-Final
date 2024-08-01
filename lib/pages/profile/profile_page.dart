import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_world_final/router/app_router.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String userImg = "assets/images/chatbot.png";

  _getImage(String userId) async {
    final response = await http.post(
      Uri.parse('http://localhost:8082/user/passwordMailAuthCheck'),
      headers: <String, String>{
        'accept': '*/*',
        'user_id': userId,
      },
    );

    final data = jsonDecode(response.body);
    name = data['result']['name'];
    userImg = data['result']['userImg'];
    return {"name": name, "userImg": userImg};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 294,
            decoration: const BoxDecoration(
              color: Color(0xFF4B7BF5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(
                top: 60,
                left: 24,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "MyPage",
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24, top: 128),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4B4B4B).withOpacity(0.15),
                    spreadRadius: 0,
                    blurRadius: 16,
                    offset: const Offset(0, 2),
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(userImg, width: 24, height: 36),
                      const SizedBox(width: 12),
                      Text(name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 18),
                  RowProfile(
                      text: "최근 상담 신청자 목록",
                      onTap: () => context.push('/recent_applicants')),
                  const SizedBox(height: 32),
                  RowProfile(
                      text: "상담 신청자 요약 보기",
                      onTap: () => context.push('/applicant_summary')),
                  const SizedBox(height: 32),
                  RowProfile(
                    text: "이전 상담 내역",
                    onTap: () => context.push('/applicant_past_records'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
          context.go(widgetNames[index].toLowerCase());
        },
      ),
    );
  }
}

class RowProfile extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const RowProfile({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 18)),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
