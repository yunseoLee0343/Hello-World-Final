import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_world_final/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<bool> _authenticate() async {
    var result = await AuthService.authenticateUser();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset('assets/images/hello_world_logo.png',
                fit: BoxFit.cover),
            const SizedBox(
              height: 100,
            ),
            Container(
              child: FutureBuilder<bool>(
                future: _authenticate(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While the future is being resolved, show a loading indicator
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // If there is an error, show an error message
                    return const Center(
                      child: Text('An error occurred. Please try again.'),
                    );
                  } else if (snapshot.hasData && snapshot.data == true) {
                    // If the authentication is successful, navigate to the chat_intro screen
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go('/chat_intro');
                    });
                    return Container(); // Return an empty container as the navigation will happen
                  } else {
                    // If authentication fails, show the button and a popup
                    return TextButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('로그인 실패'),
                            content: const Text('로그인에 실패하였습니다. 다시 시도해주세요.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.ac_unit),
                          SizedBox(width: 8),
                          Text("Google으로 로그인"),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
