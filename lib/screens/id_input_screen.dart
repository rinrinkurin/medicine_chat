import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import 'usage_select_screen.dart';

class IdInputScreen extends StatefulWidget {
  final String role;
  final String name;

  const IdInputScreen({
    super.key,
    required this.role,
    required this.name,
  });

  @override
  State<IdInputScreen> createState() => _IdInputScreenState();
}

class _IdInputScreenState extends State<IdInputScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UsageSelectScreen(
          role: widget.role,
          name: widget.name,
          userId: _controller.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = _controller.text.trim().isNotEmpty;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            children: [
              const AppHeader(),
              const SizedBox(height: 24),
              const Text(
                '好きなIDを設定してください',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'my-id',
                  hintStyle: const TextStyle(color: Color(0xFFB3B9B3)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFFEFF3EF),
                      child: const Text(
                        '@',
                        style: TextStyle(
                          color: Color(0xFFB1B8B1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  prefixIconConstraints:
                      const BoxConstraints(minHeight: 40, minWidth: 40),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: const BorderSide(color: kPrimary, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: const BorderSide(color: kPrimary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: '次へすすむ',
                onPressed: isEnabled ? _goNext : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
