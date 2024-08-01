import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

bool isAuthenticated = false; // 이 변수를 실제 인증 상태로 설정해야 합니다.

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  Locale? _selectedLocale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "사용 가능한 언어를 골라주세요.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Select language",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: context.supportedLocales.map((Locale locale) {
                  final isSelected = locale == _selectedLocale;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLocale = locale;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.blueAccent : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        locale.languageCode.toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _selectedLocale != null
                    ? () async {
                        // Update locale
                        context.setLocale(_selectedLocale!);

                        // Send selected locale to server
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var userId = prefs.getString('userId');

                        var response = await http.post(
                          Uri.parse('http://localhost:8082/api/setLanguage'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            'user_id': userId ?? "user1",
                          },
                          body: jsonEncode(
                              {'locale': _selectedLocale!.languageCode}),
                        );

                        // Navigate based on authentication status
                        if (response.statusCode == 200) {
                          if (isAuthenticated) {
                            context.go('/chat');
                          } else {
                            context.go('/login');
                          }
                        } else {
                          // Handle error
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Failed to update language on server')),
                          );
                        }
                      }
                    : null,
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
