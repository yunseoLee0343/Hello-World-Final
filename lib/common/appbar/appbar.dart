import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Image.asset('assets/images/chatbot.png', width: 24, height: 36),
      title: const Text(
        'Hello World',
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Color.fromRGBO(51, 105, 255, 1),
          fontFamily: 'Nunito',
          fontSize: 20,
          letterSpacing: 0,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.headphones_rounded, size: 24),
        ),
      ],

      centerTitle: false,
      elevation: 0, // 기본 AppBar 그림자 제거
      backgroundColor: Colors.white, // 배경색 투명으로 설정
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64); // 커스텀 높이 설정
}
