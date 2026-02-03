import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String role;
  final String userId;

  const ChatScreen({
    super.key,
    required this.name,
    required this.role,
    required this.userId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _capturedPhoto;
  final TextEditingController _textController = TextEditingController();
  final List<_ChatMessage> _messages = [];
  final List<_StickerItem> _stickers = const [
    _StickerItem(
      label: '',
      icon: Icons.favorite,
      color: Color(0xFFFFC4D6),
      assetPath: 'assets/stamps/のんだよ.png',
    ),
    _StickerItem(
      label: '',
      icon: Icons.verified,
      color: Color(0xFFFFD36A),
      assetPath: 'assets/stamps/はなまる.png',
    ),
    _StickerItem(
      label: '',
      icon: Icons.nightlight_round,
      color: Color(0xFFB9E3FF),
      assetPath: 'assets/stamps/おやすみ.png',
    ),
    _StickerItem(
      label: '',
      icon: Icons.emoji_emotions,
      color: Color(0xFFFFE3A1),
      assetPath: 'assets/stamps/ごほうび.png',
    ),
    _StickerItem(
      label: '',
      icon: Icons.access_time,
      color: Color(0xFFCDECCF),
      assetPath: 'assets/stamps/じかんだよ.png',
    ),
    _StickerItem(
      label: '',
      icon: Icons.favorite_border,
      color: Color(0xFFFFB3B3),
      assetPath: 'assets/stamps/おだいじに.png',
    ),
    _StickerItem(
      label: '',
      icon: Icons.help_outline,
      color: Color(0xFFE3E6FF),
      assetPath: 'assets/stamps/のんだ？.png',
    ),
  ];

  String get _todayLabel {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}/$month/$day';
  }

  Future<void> _capturePhoto() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return;
    setState(() {
      _capturedPhoto = file;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _openStickerPicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFDFEFD),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              24 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'スタンプ',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _stickers
                      .map(
                        (sticker) => InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              _messages.insert(
                                0,
                                _ChatMessage(
                                  text: sticker.label,
                                  imagePath: null,
                                  dateLabel: _todayLabel,
                                  isMe: true,
                                  isSticker: true,
                                  stickerIcon: sticker.icon,
                                  stickerAssetPath: sticker.assetPath,
                                ),
                              );
                            });
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border:
                                  Border.all(color: const Color(0xFFE6EAE6)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: sticker.color.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: sticker.assetPath != null
                                      ? Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            sticker.assetPath!,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : Icon(sticker.icon,
                                          color: kTextDark, size: 36),
                                ),
                                if (sticker.label.trim().isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    sticker.label,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: kTextMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendTakenMessage() async {
    if (_capturedPhoto == null) {
      await _capturePhoto();
    }
    if (_capturedPhoto == null) return;
    setState(() {
      _messages.insert(
        0,
        _ChatMessage(
          text: '飲んだよ！',
          imagePath: _capturedPhoto!.path,
          dateLabel: _todayLabel,
          isMe: true,
          isSticker: false,
          stickerIcon: null,
          stickerAssetPath: null,
        ),
      );
    });
  }

  void _sendTextMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.insert(
        0,
        _ChatMessage(
          text: text,
          imagePath: null,
          dateLabel: _todayLabel,
          isMe: true,
          isSticker: false,
          stickerIcon: null,
          stickerAssetPath: null,
        ),
      );
      _textController.clear();
    });
  }

  void _sendQuickMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _messages.insert(
        0,
        _ChatMessage(
          text: trimmed,
          imagePath: null,
          dateLabel: _todayLabel,
          isMe: true,
          isSticker: false,
          stickerIcon: null,
          stickerAssetPath: null,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F7EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: kPrimary, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'お薬チャット',
                        style: TextStyle(
                          color: kTextDark,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC9D0C9),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '未接続',
                            style: TextStyle(color: kTextMuted, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    final controller = TextEditingController();
                    showDialog<void>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('接続設定'),
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: '相手のIDを入力',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('キャンセル'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('接続する'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7EE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '接続設定',
                      style: TextStyle(
                        color: kPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFFF9FAF9),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEF0),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFFFD7DD)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFD9DE),
                            shape: BoxShape.circle,
                          ),
                          child:
                              const Icon(Icons.timer, color: Color(0xFFF03B57)),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'あなたのお薬',
                                style: TextStyle(
                                  color: kTextDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'まだ飲んでいません',
                                style: TextStyle(
                                  color: Color(0xFFF03B57),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _sendTakenMessage,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF03B57),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              '飲んだよ！',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE8EBE8)),
                    ),
                    child: Text(
                      '${widget.name}さん、接続されました！',
                      style: const TextStyle(color: kTextMuted, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7EE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.camera_alt, color: kPrimary, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '写真を添えて「飲んだよ！」を送ってね',
                            style: TextStyle(
                              color: kPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_capturedPhoto != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE8EBE8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '飲んだよ！',
                            style: TextStyle(
                              color: kTextDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                Image.file(
                                  File(_capturedPhoto!.path),
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 8,
                                  bottom: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _todayLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _MessageBubble(message: message);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _QuickChip(
                          label: 'お薬飲んだ？',
                          onTap: () => _sendQuickMessage('お薬飲んだ？'),
                        ),
                        _QuickChip(
                          label: 'あとで飲むね',
                          onTap: () => _sendQuickMessage('あとで飲むね'),
                        ),
                        _QuickChip(
                          label: 'ありがとう！',
                          onTap: () => _sendQuickMessage('ありがとう！'),
                        ),
                        _QuickChip(
                          label: 'お疲れ様！',
                          onTap: () => _sendQuickMessage('お疲れ様！'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: _capturePhoto,
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: const Color(0xFFE3E6E3)),
                            ),
                            child: const Icon(Icons.camera_alt,
                                size: 18, color: kTextMuted),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _openStickerPicker,
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: const Color(0xFFE3E6E3)),
                            ),
                            child: const Icon(Icons.emoji_emotions,
                                size: 18, color: kTextMuted),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            onSubmitted: (_) => _sendTextMessage(),
                            decoration: InputDecoration(
                              hintText: 'メッセージ...（撮影して送れます）',
                              hintStyle: const TextStyle(
                                  color: kTextMuted, fontSize: 18),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE3E6E3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE3E6E3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: kPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: _sendTextMessage,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: kPrimary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimary.withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.send,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _QuickChip({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6E9E6)),
        ),
        child: Text(
          label,
          style: const TextStyle(color: kTextMuted, fontSize: 18),
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final String? imagePath;
  final String dateLabel;
  final bool isMe;
  final bool isSticker;
  final IconData? stickerIcon;
  final String? stickerAssetPath;

  _ChatMessage({
    required this.text,
    required this.imagePath,
    required this.dateLabel,
    required this.isMe,
    required this.isSticker,
    required this.stickerIcon,
    required this.stickerAssetPath,
  });
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isMe ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = message.isMe ? const Color(0xFFE9F7F0) : Colors.white;
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EBE8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isSticker) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 136,
                    height: 136,
                    decoration: BoxDecoration(
                      color: kPrimary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: message.stickerAssetPath != null
                        ? Padding(
                            padding: const EdgeInsets.all(14),
                            child: Image.asset(
                              message.stickerAssetPath!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Icon(
                            message.stickerIcon ?? Icons.emoji_emotions,
                            color: kTextDark,
                            size: 72,
                          ),
                  ),
                  if (message.text.trim().isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Text(
                      message.text,
                      style: const TextStyle(
                        color: kTextDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ],
              ),
            ] else ...[
              Text(
                message.text,
                style: const TextStyle(
                  color: kTextDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
            if (message.imagePath != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.file(
                      File(message.imagePath!),
                      width: 260,
                      height: 190,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 6,
                      bottom: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message.dateLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StickerItem {
  final String label;
  final IconData icon;
  final Color color;
  final String? assetPath;

  const _StickerItem({
    required this.label,
    required this.icon,
    required this.color,
    this.assetPath,
  });
}
