import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_final/api_models/detailed_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: context.locale,
      items: context.supportedLocales.map((Locale locale) {
        return DropdownMenuItem<Locale>(
          value: locale,
          child: Text(locale.languageCode),
        );
      }).toList(),
      onChanged: (Locale? locale) {
        if (locale != null) {
          context.setLocale(locale);
          // Ensure the widget is rebuilt to reflect the new locale
          (context as Element).reassemble();
        }
      },
    );
  }
}

class DetailedPage extends StatefulWidget {
  var summaryId;

  DetailedPage({super.key, required this.summaryId});

  @override
  State<DetailedPage> createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  Future<DetailSummaryRes> _getDetailedInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    // Sample JSON data
    String jsonString = '''
    {
      "summaryId": 12345,
      "identificationNum": "ID001",
      "uploadedAt": "2024-07-31T10:00:00",
      "name": "John Doe",
      "userImg": "https://example.com/images/user1.jpg",
      "chatSummary": "This is a summary of the chat.",
      "mainPoint": "The main point of the discussion."
    }
    ''';
    // Parse JSON data
    final jsonData = jsonDecode(jsonString);
    // Create Reservation object
    DetailSummaryRes data = DetailSummaryRes.fromJson(jsonData);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("app_title".tr()),
        actions: const [
          LanguageSwitcher(), // 언어 전환 위젯 추가
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: FutureBuilder<DetailSummaryRes>(
              future: _getDetailedInfo(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${'summary_id'.tr()}: ${snapshot.data.summaryId.toString()}"),
                      Text(
                          "${'chat_summary'.tr()}: ${snapshot.data.chatSummary.toString()}"),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
