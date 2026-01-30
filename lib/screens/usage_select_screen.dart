import 'package:flutter/material.dart';

import '../models/usage_option.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/usage_card.dart';
import 'main_shell.dart';

class UsageSelectScreen extends StatefulWidget {
  final String role;
  final String name;
  final String userId;

  const UsageSelectScreen({
    super.key,
    required this.role,
    required this.name,
    required this.userId,
  });

  @override
  State<UsageSelectScreen> createState() => _UsageSelectScreenState();
}

class _UsageSelectScreenState extends State<UsageSelectScreen> {
  int _selectedIndex = 0;

  final List<UsageOption> _options = const [
    UsageOption(
      title: '自分がお薬を飲む',
      subtitle: '飲んだよ！を報告できます',
      icon: Icons.medication,
    ),
    UsageOption(
      title: 'お薬を飲むのを確認する',
      subtitle: '相手の報告を確認できます',
      icon: Icons.check_circle,
    ),
  ];

  void _start() {
    final usageLabel = _options[_selectedIndex].title;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MainShell(
          name: widget.name,
          role: widget.role,
          userId: widget.userId,
          usageLabel: usageLabel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            children: [
              const AppHeader(),
              const SizedBox(height: 24),
              const Text(
                'アプリの使い方を選んでください',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: List.generate(
                  _options.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: UsageCard(
                      option: _options[index],
                      selected: _selectedIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(label: 'はじめる', onPressed: _start),
            ],
          ),
        ),
      ),
    );
  }
}
