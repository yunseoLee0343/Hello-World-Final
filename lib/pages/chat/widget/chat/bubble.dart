import 'package:flutter/material.dart';
import 'package:typewritertext/typewritertext.dart';

class ChatBubble extends StatelessWidget {
  final String title;
  final bool isBlue;
  final bool isLastMessage;

  const ChatBubble({
    super.key,
    required this.title,
    required this.isBlue,
    required this.isLastMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBlue ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isBlue ? 16 : 0),
          bottomRight: Radius.circular(isBlue ? 0 : 16),
        ),
      ),
      child: isLastMessage && isBlue
          ? TypeWriterText(
              text: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              duration: const Duration(milliseconds: 50), // Adjust speed here
            )
          : Text(
              title,
              style: TextStyle(
                color: isBlue ? Colors.white : Colors.black,
                fontSize: 13,
              ),
            ),
    );
  }
}
