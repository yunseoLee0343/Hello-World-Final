import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<bool> authenticateUser() async {
    // Replace with your actual authentication request
    final response = await http.post(
      Uri.parse('http://localhost:8082/user/passwordMailAuthCheck'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      // Parse the JSON string
      final parsedJson = jsonDecode(responseBody);
      final isSuccess = parsedJson['isSuccess'];
      String? atkToken;

      for (var tokenData in parsedJson['result']) {
        if (tokenData['types'] == 'atk') {
          atkToken = tokenData['token'];
          break;
        }
      }

      log('isSuccess: $isSuccess');
      log('atk token: $atkToken');

      final decoded = JwtDecoder.decode(atkToken ?? "");
      setUserId(decoded['id']);
    }
    return false;
  }
}
