import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final Widget body;
  final IconButton? leftIcon;
  final IconButton? rightIcon;
  final String? title;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? customAppBar;

  const Layout({
    super.key,
    required this.body,
    this.leftIcon,
    this.rightIcon,
    this.title,
    this.bottomNavigationBar,
    this.customAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar ??
          AppBar(
            leading: leftIcon,
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: rightIcon,
              )
            ],
            elevation: 0,
            title: Text(
              title ?? '',
            ),
          ),
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}
