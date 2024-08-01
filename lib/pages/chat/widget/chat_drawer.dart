import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world_final/pages/chat/model/message.dart';
import 'package:http/http.dart' as http;

class ChatDrawer extends StatefulWidget {
  final VoidCallback? onDrawerOpened;

  const ChatDrawer({super.key, this.onDrawerOpened});

  @override
  _ChatDrawerState createState() => _ChatDrawerState();
}

/*
class ChatListTiles extends StatefulWidget {
  final int index;

  const ChatListTiles({super.key, required this.index});

  @override
  _ChatListTilesState createState() => _ChatListTilesState();
}

class _ChatListTilesState extends State<ChatListTiles> {
  final messages = Messages(); // Singleton instance

  @override
  Widget build(BuildContext context) {
    final key = messages.messagesByRoomAndUser.keys.elementAt(
        messages.messagesByRoomAndUser.keys.length - widget.index - 1);
    final chatLogs = messages.messagesByRoomAndUser[key] ?? [];

    return ListTile(
      title: Text('Room ID: $key'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: chatLogs
            .map((log) => Text('${log['sender']}: ${log['message']}'))
            .toList(),
      ),
    );
  }
}
*/

class _ChatDrawerState extends State<ChatDrawer> {
  final messages = Messages(); // Singleton instance

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onDrawerOpened != null) {
        widget.onDrawerOpened!();
      }
    });
  }

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
                  onTap: () {
                    setState() {
                      messages.createRoom('user1', 'room1');
                    }
                  },
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
          for (int i = 0; i < messages.messagesByRoomAndUser.keys.length; i++)
            ChatListTile(index: i),
        ],
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  final int index;

  const ChatListTile({super.key, required this.index});

  Future<String> fetchAndParseRecentRooms() async {
    try {
      // Perform the HTTP GET request
      final response =
          await http.get(Uri.parse('http://localhost:8082/chat/recent-room'));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        return decodedResponse['title'];
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return "Error";
      }
    } catch (e) {
      print('Error fetching and parsing chat logs: $e');
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    // final messages = Messages(); // Singleton instance
    // final key = messages.messagesByRoomAndUser.keys.elementAt(index);
    // final chatLogs = messages.messagesByRoomAndUser[key] ?? [];

    return FutureBuilder<String>(
      future: fetchAndParseRecentRooms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching chat logs'),
          );
        }

        return ListTile(
            title: const Text('Room ID: room1'),
            subtitle: Text('Summary: ${snapshot.data}'));
      },
    );
  }
}
