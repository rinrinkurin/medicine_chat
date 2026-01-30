import 'package:flutter/material.dart';

import '../models/role_option.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/role_card.dart';
import 'name_input_screen.dart';

class RoleSelectScreen extends StatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  State<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends State<RoleSelectScreen> {
  String? _selectedRole;

  final List<RoleOption> _roles = const [
    RoleOption(label: '親', icon: Icons.favorite, color: Color(0xFFFF6B6B)),
    RoleOption(
        label: '子', icon: Icons.emoji_emotions, color: Color(0xFF6CC6FF)),
    RoleOption(label: '恋人', icon: Icons.star, color: Color(0xFFFFC857)),
    RoleOption(label: '個人', icon: Icons.person, color: Color(0xFF6FE0A3)),
  ];

  void _goNext() {
    if (_selectedRole == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NameInputScreen(role: _selectedRole!),
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
                'あなたの役割は？',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.05,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _roles
                      .map(
                        (role) => RoleCard(
                          option: role,
                          selected: _selectedRole == role.label,
                          onTap: () {
                            setState(() {
                              _selectedRole = role.label;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: '次へすすむ',
                onPressed: _selectedRole == null ? null : _goNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
