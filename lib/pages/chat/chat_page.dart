import 'package:flutter/material.dart';
import 'package:hello_world_final/common/appbar/appbar.dart';
import 'package:hello_world_final/common/layout/layout.dart';
import 'package:hello_world_final/pages/chat/widget/chat/input.dart';
import 'package:hello_world_final/pages/chat/widget/intro/intro.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final bool _isLoading = false;

  void _navigateToChat(String question) {
    // _setFirstLaunchFlag(); // Set the flag
    // context.go('/main');
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      customAppBar: const MyAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              ListView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 80),
                children: [
                  IntroBox(
                    icon: const Icon(Icons.book),
                    title: "법률",
                    sampleText1:
                        "근로계약서에 ‘근무시간은 주 40시간 이내’라고 되어 있는데, 실제로는 50시간 넘게 일하고 있어요. 이게 법적으로 문제 없나요?",
                    sampleText2:
                        "회사가 휴가를 주지 않거나 병가를 제대로 인정해주지 않아요. 이럴 때 어떻게 대응해야 하나요?",
                    onTap: _navigateToChat, // Pass the handler
                  ),
                  const SizedBox(height: 24),
                  IntroBox(
                    icon: const Icon(Icons.book),
                    title: "비자",
                    sampleText1:
                        "현재 비자가 ‘일반 취업 비자’인데, 일자리를 바꾸려면 어떻게 해야 하나요? 비자 변경 절차가 복잡한가요?",
                    sampleText2: "비자 연장 절차는 어떻게 되나요? 필요한 서류와 절차를 알려주세요.",
                    onTap: _navigateToChat, // Pass the handler
                  ),
                  const SizedBox(height: 24),
                  IntroBox(
                    icon: const Icon(Icons.book),
                    title: "생활 정보",
                    sampleText1:
                        "새로 이사했는데, 지역 주민센터에서 해야 할 일이 뭐가 있을까요? 주소 변경 같은 건 어떻게 하나요?",
                    sampleText2: "주변에서 참여할 수 있는 관내 문화 교육 프로그램이 있나요?",
                    onTap: _navigateToChat, // Pass the handler
                  ),
                  const SizedBox(height: 24),
                  const Column(
                    children: <Widget>[
                      Icon(
                        Icons.book,
                        size: 28,
                      ),
                      SizedBox(height: 1),
                      Text(
                        "취업 지원",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      await launchUrl(Uri.parse("https://www.klik.co.kr/"));
                    },
                    child: const Text(
                      'KILK 취업지원센터 바로가기',
                      style: TextStyle(color: Color.fromRGBO(51, 105, 255, 1)),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: MessageInputField(
                  controller: _messageController,
                  onSend: () {
                    // _setFirstLaunchFlag(); // 처음 실행된 경우 플래그 설정
                    // Navigator.pushReplacementNamed(context, '/chat');
                    _navigateToChat(_messageController.text);
                  },
                  focusNode: _focusNode,
                  isSendEnabled: !_isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _setFirstLaunchFlag() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isFirstLaunch', false);
  // }
}
