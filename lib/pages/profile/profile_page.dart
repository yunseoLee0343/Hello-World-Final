import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                  Icons.person_4_rounded,
                  size: 32,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "MyPage",
                  style: TextStyle(fontSize: 28, color: Colors.white),
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
                    Image.asset('assets/images/chatbot.png',
                        width: 24, height: 36),
                    const SizedBox(width: 12),
                    const Text("User Name",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 18),
                const Text("상담", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 32),
                RowProfile(
                  text: "챗봇 상담 히스토리 요약 보기",
                  onTap: () {
                    context.push('/chatbot_history');
                  },
                ),
                const SizedBox(height: 24),
                RowProfile(
                  text: "상담 접수 내역",
                  onTap: () {
                    context.push('/chatbot_history');
                  },
                ),
              ],
            ),
          ),
        )
      ],
    ));
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
