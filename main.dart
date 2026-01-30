import 'package:flutter/material.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'お薬チャット',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SetupScreen(),
    );
  }
}

// ロール設定画面
class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String _selectedRole = '親';
  final List<String> _roles = ['親', '子', '恋人', '見守り'];

  void _nextButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(role: _selectedRole),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('役割選択')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'お薬チャットに参加する役割を選んでください',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: _roles.map((role) {
                return ChoiceChip(
                  label: Text(role),
                  selected: _selectedRole == role,
                  onSelected: (selected) {
                    setState(() {
                      _selectedRole = role;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _nextButtonPressed,
              child: Text('次へ'),
            ),
          ],
        ),
      ),
    );
  }
}

// チャット画面（役割を引数で受け取る）
class ChatScreen extends StatefulWidget {
  final String role;

  ChatScreen({required this.role});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isParentTurn = true;

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(
        text: text,
        isParent: widget.role == '親',
      ));
      _controller.clear();
      // ロールに応じてターンを切り替えるロジック（例：親は常に先攻）
      if (widget.role == '親') {
        _isParentTurn = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('お薬チャット')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _nadage[index];
                return Align(
                  alignment: message.isParent ? Alignment.topRight : Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isParent ? Colors.blue.withOpacity(0.3) : Colors.green.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (text) => _sendMessage(text),
                    decoration: InputDecoration(
                      hintText: 'メッセージを入力',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
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
