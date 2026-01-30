import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF18C76A);
const Color kBackground = Color(0xFFF7F9F7);
const Color kTextDark = Color(0xFF1A1E1A);
const Color kTextMuted = Color(0xFF7C857C);

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        scaffoldBackgroundColor: kBackground,
        useMaterial3: true,
      ),
      home: const RoleSelectScreen(),
    );
  }
}

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

class NameInputScreen extends StatefulWidget {
  final String role;

  const NameInputScreen({super.key, required this.role});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
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
        builder: (_) => IdInputScreen(
          role: widget.role,
          name: _controller.text.trim(),
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
                'お名前を入力してください',
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(role: widget.role),
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

// チャット画面（仮）
class ChatScreen extends StatefulWidget {
  final String role;

  const ChatScreen({super.key, required this.role});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(
        text: text,
        isParent: widget.role == '親',
      ));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('お薬チャット')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment:
                      message.isParent ? Alignment.topRight : Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isParent
                          ? Colors.blue.withOpacity(0.3)
                          : Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (text) => _sendMessage(text),
                    decoration: InputDecoration(
                      hintText: 'メッセージを入力',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isParent;

  Message({required this.text, required this.isParent});
}

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F7EE),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.medication, color: kPrimary, size: 32),
        ),
        const SizedBox(height: 12),
        const Text(
          'お薬チャット',
          style: TextStyle(
            color: kTextDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'CONNECTING CARE',
          style: TextStyle(
            color: kTextMuted,
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          disabledBackgroundColor: const Color(0xFFE2E6E2),
          foregroundColor: Colors.white,
          elevation: onPressed == null ? 0 : 6,
          shadowColor: kPrimary.withOpacity(0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color:
                    onPressed == null ? const Color(0xFFB1B6B1) : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              size: 18,
              color: onPressed == null ? const Color(0xFFB1B6B1) : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class RoleOption {
  final String label;
  final IconData icon;
  final Color color;

  const RoleOption({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class RoleCard extends StatelessWidget {
  final RoleOption option;
  final bool selected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? kPrimary : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: option.color.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(option.icon, color: option.color),
            ),
            const SizedBox(height: 12),
            Text(
              option.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kTextDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsageOption {
  final String title;
  final String subtitle;
  final IconData icon;

  const UsageOption({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class UsageCard extends StatelessWidget {
  final UsageOption option;
  final bool selected;
  final VoidCallback onTap;

  const UsageCard({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? kPrimary : const Color(0xFFE7EAE7),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? kPrimary.withOpacity(0.15) : kBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                option.icon,
                color: selected ? kPrimary : const Color(0xFFB6BCB6),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected ? kTextDark : kTextMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: kTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.check_circle_outline,
              color: selected ? kPrimary : const Color(0xFFC2C8C2),
            ),
          ],
        ),
      ),
    );
  }
}
