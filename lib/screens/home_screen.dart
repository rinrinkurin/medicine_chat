import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/medication.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'profile_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  final String role;
  final String userId;

  const HomeScreen({
    super.key,
    required this.name,
    required this.role,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final appState = AppState.instance;
        final displayName = appState.name.isEmpty ? name : appState.name;
        final todayList = appState.scheduleFor(DateTime.now());
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'こんにちは、$displayNameさん',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: kTextDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '今日もお薬を忘れずに飲みましょう',
                            style: TextStyle(
                              color: kTextMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tooltip(
                      message: 'プロフィールを編集',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileEditScreen(
                                initialName: displayName,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F7EE),
                            shape: BoxShape.circle,
                            border: Border.all(color: kPrimary, width: 1),
                          ),
                          child:
                              const Icon(Icons.edit, color: kPrimary, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimary.withOpacity(0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'パートナーとつながる',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'IDを共有して、親子や恋人同士で\nお薬の報告を受け取れるようにしましょう。',
                        style: TextStyle(
                          color: Color(0xFFE6FFF1),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2CD989),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                userId,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                Share.share(
                                  'パートナー接続申請がきたよ！\n以下アプリのURL\nhttps://example.com',
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Text(
                                  'ID共有',
                                  style: TextStyle(
                                    color: kPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
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
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3DF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.access_time,
                                color: Color(0xFFFF9F1C)),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '次の予定',
                                  style: TextStyle(
                                      color: kTextMuted, fontSize: 12),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '20:00 - 夜のお薬',
                                  style: TextStyle(
                                    color: kTextDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '1錠 (錠剤)',
                                  style: TextStyle(
                                      color: kTextMuted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(title: '今日の達成率', value: '0%'),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: _StatCard(title: '継続日数', value: '0日'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '今日のスケジュール',
                  style: TextStyle(
                    color: kTextDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                if (todayList.isEmpty)
                  const Text(
                    '今日は予定がありません',
                    style: TextStyle(color: kTextMuted, fontSize: 13),
                  )
                else
                  ...todayList.map(
                    (med) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ScheduleItem(
                        time: _formatTime(med.time),
                        title: med.name,
                        dose: _frequencyLabel(med),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _formatTime(TimeOfDay? time) {
  if (time == null) return '未設定';
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

String _frequencyLabel(Medication med) {
  switch (med.frequency) {
    case MedicationFrequency.daily:
      return '毎日';
    case MedicationFrequency.weekly:
    case MedicationFrequency.custom:
      return '曜日指定';
    case MedicationFrequency.monthly:
      return '毎月${med.dayOfMonth}日';
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F2F0)),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: kTextMuted, fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: kTextDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String time;
  final String title;
  final String dose;

  const _ScheduleItem({
    required this.time,
    required this.title,
    required this.dose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F2F0)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            child: Text(
              time,
              style: const TextStyle(color: kTextMuted, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: kTextDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(dose,
                    style: const TextStyle(color: kTextMuted, fontSize: 11)),
              ],
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD8DDD8)),
            ),
          ),
        ],
      ),
    );
  }
}
