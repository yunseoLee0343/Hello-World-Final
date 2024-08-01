import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0, // Remove default title spacing
      title: Padding(
        padding: const EdgeInsets.only(left: 24), // Adjust padding as needed
        child: Row(
          children: [
            Image.asset('assets/images/chatbot.png', width: 24, height: 36),
            const SizedBox(width: 12),
            const Text(
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
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.headphones_rounded, size: 24),
        ),
      ],
      centerTitle: false,
      elevation: 0, // Remove default AppBar shadow
      backgroundColor: Colors.white, // Set background color to white
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64); // Set custom height
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('My Home Page'),
      ),
    );
  }
}
