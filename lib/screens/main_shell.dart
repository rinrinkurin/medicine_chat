import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'calendar_screen.dart';
import 'chat_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  final String name;
  final String role;
  final String userId;
  final String usageLabel;

  const MainShell({
    super.key,
    required this.name,
    required this.role,
    required this.userId,
    required this.usageLabel,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        name: widget.name,
        role: widget.role,
        userId: widget.userId,
      ),
      ChatScreen(
        name: widget.name,
        role: widget.role,
        userId: widget.userId,
      ),
      CalendarScreen(
        name: widget.name,
        role: widget.role,
        userId: widget.userId,
      ),
      SettingsScreen(
        name: widget.name,
        role: widget.role,
        userId: widget.userId,
        usageLabel: widget.usageLabel,
      ),
    ];

    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimary,
        unselectedItemColor: kTextMuted,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'チャット'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: '記録'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
      ),
    );
  }
}
