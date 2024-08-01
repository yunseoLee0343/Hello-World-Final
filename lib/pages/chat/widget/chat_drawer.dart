import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world_final/pages/chat/model/chat_log.dart';
import 'package:hello_world_final/pages/chat/model/message.dart';
import 'package:http/http.dart' as http;

class ChatDrawer extends StatefulWidget {
  final VoidCallback? onDrawerOpened;

  const ChatDrawer({super.key, this.onDrawerOpened});

  @override
  _ChatDrawerState createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  final messages = Messages();

/*
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onDrawerOpened != null) {
        // widget.onDrawerOpened!();
      }
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                const Text(
                  'Chat History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () => messages.createRoom('user1', 'room1'),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Add Chat',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return const ChatListTile();
            },
            itemCount: messages.messagesByRoomAndUser.length,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}

// Example Widget
class ChatListTile extends StatelessWidget {
  const ChatListTile({super.key});

  Future<ChatRoom?> fetchAndParseChatLogs() async {
    try {
      // Perform the HTTP GET request
      final response =
          await http.get(Uri.parse('http://localhost:8082/chat/recent-room'));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

        final dummyResponse = jsonEncode({
          'roomId': 'room1',
          'chatLogs': [
            {
              'content': 'Hello, how are you?',
              'sender': 'user1',
            },
            {
              'content': 'I am doing well, thank you!',
              'sender': 'bot',
            },
          ],
        });

        // Parse and return the ChatRoom object
        // return ChatRoom.fromJson(jsonDecode(dummyResponse));
        return ChatRoom.fromJson(decodedResponse);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching and parsing chat logs: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChatRoom?>(
      future: fetchAndParseChatLogs(),
      builder: (BuildContext context, AsyncSnapshot<ChatRoom?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: Text('Loading...'),
            subtitle: Text(""),
          );
        } else if (snapshot.hasError) {
          return ListTile(
            title: const Text('Error'),
            subtitle: Text(snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          final chatRoom = snapshot.data!;
          return ListTile(
            title: Text('Room ID: ${chatRoom.roomId}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: chatRoom.chatLogs
                  .map((log) => Text('${log.sender}: ${log.content}'))
                  .toList(),
            ),
          );
        } else {
          return const ListTile(
            title: Text('No data'),
            subtitle: Text(""),
          );
        }
      },
    );
  }
}
