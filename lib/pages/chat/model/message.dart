import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Messages extends ChangeNotifier {
  // Private static instance of the singleton
  static final Messages _instance = Messages._internal();

  // Factory constructor to return the singleton instance
  factory Messages() => _instance;

  // Private named constructor to create the singleton instance
  Messages._internal();

  final Map<String, List<Map<String, dynamic>>> messagesByRoomAndUser = {
    'user1-room1': [
      {'message': 'Hello, how are you?', 'isBlue': false},
      {'message': 'I am doing well, thank you!', 'isBlue': true},
      {'message': 'What can I help you with today?', 'isBlue': false},
    ],
    // Add other predefined messages as needed
  };

  List<Map<String, dynamic>> getMessages(String userId, String roomId) {
    final key = _getRoomUserKey(userId, roomId);
    return messagesByRoomAndUser[key] ?? [];
  }

  Future<void> addMessage(String message, String userId, String roomId) async {
    final key = _getRoomUserKey(userId, roomId);

    // Add user message immediately
    messagesByRoomAndUser.putIfAbsent(key, () => []);
    messagesByRoomAndUser[key]!.add({'message': message, 'isBlue': true});
    log("[message.dart] key: $key, messagesByRoomAndUser: $messagesByRoomAndUser");
    notifyListeners();

    try {
      // Send message to server and handle response
      final serverResponse = await sendMessageToServer(message, userId, roomId);

      if (serverResponse != null) {
        // Add server response to messages
        messagesByRoomAndUser[key]!
            .add({'message': serverResponse, 'isBlue': false});
        notifyListeners();
      } else {
        print('서버 응답이 없습니다.');
      }
    } catch (e) {
      print('메시지 추가 오류: $e');
    }

    print('Message added: $message');
  }

  Future<String?> sendMessageToServer(
      String message, String userId, String roomId) async {
    final url = Uri.parse('http://localhost:8082/chat/ask?roomId=$roomId');

    // Headers and body for the request
    Map<String, String> headers = {
      'accept': 'text/event-stream',
      'user_id': userId,
      'Content-Type': 'application/json',
    };
    String body = jsonEncode({'message': message});

    try {
      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = body;

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        print('Message sent successfully');
        return await _processResponseStream(streamedResponse.stream);
      } else {
        print(
            'Failed to send message. Status code: ${streamedResponse.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending message: $e');
      return null;
    }
  }

  Future<String?> _processResponseStream(Stream<List<int>> stream) async {
    final responseCompleter = Completer<String>();
    final stringBuffer = StringBuffer();

    stream.transform(utf8.decoder).listen(
      (String data) {
        // Append data to string buffer
        stringBuffer.write(data);
        print('Received data: $data');

        // Check if the response indicates the end of the conversation
        if (data.contains("Room Id:")) {
          final roomId = data.split('Room Id:').last.trim();
          print('Conversation ended. Room ID: $roomId');
          responseCompleter.complete(roomId);
        }
      },
      onDone: () {
        if (!responseCompleter.isCompleted) {
          responseCompleter.complete(stringBuffer.toString());
        }
      },
      onError: (e) {
        print('Error processing response stream: $e');
        if (!responseCompleter.isCompleted) {
          responseCompleter.completeError(e);
        }
      },
      cancelOnError: true,
    );

    return responseCompleter.future;
  }

  String _getRoomUserKey(String userId, String roomId) {
    return '$userId-$roomId';
  }
}
