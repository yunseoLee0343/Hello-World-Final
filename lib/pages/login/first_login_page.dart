import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FirstLoginPage extends StatelessWidget {
  const FirstLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/main');
          },
          child: const Text('Go to Main'),
        ),
      ),
    );
  }
}
