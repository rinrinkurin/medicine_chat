import 'package:flutter/material.dart';

import 'screens/role_select_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'お薬チャット',
      theme: buildAppTheme(),
      home: const RoleSelectScreen(),
    );
  }
}
