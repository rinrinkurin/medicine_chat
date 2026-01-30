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
                  mainAxisSpacing: 16,
