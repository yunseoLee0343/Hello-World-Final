// 별도로 정의한 ChatPage
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_world_final/common/appbar/appbar.dart';
import 'package:hello_world_final/pages/chat/model/message.dart';
import 'package:hello_world_final/pages/chat/widget/chat/input.dart';
import 'package:hello_world_final/pages/chat/widget/chat/list.dart';
import 'package:hello_world_final/pages/chat/widget/chat_drawer.dart';
import 'package:hello_world_final/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String? userId = "";

  void _sendMessage([String? initialMessage]) async {
    final message = initialMessage ?? _messageController.text;
    log("[chat_page.dart] message: $message");

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    if (message.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _focusNode.unfocus();
      });

      await Provider.of<Messages>(context, listen: false)
          .addMessage(message, 'user1' ?? "", 'room1');

      setState(() {
        _isLoading = false;
        _messageController.clear();
      });

      // Smooth scroll to the bottom after adding a message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Hide the keyboard
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              ListView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 80),
                children: const [
                  ChatList(userId: 'user1', roomId: 'room1'),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: MessageInputField(
                  controller: _messageController,
                  onSend: () => _sendMessage(),
                  focusNode: _focusNode,
                  isSendEnabled: !_isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const ChatDrawer(),
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
