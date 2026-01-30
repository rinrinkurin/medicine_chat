import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/medication.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final String name;
  final String role;
  final String userId;
  final String usageLabel;

  const SettingsScreen({
    super.key,
    required this.name,
    required this.role,
    required this.userId,
    required this.usageLabel,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _showProfile = true;
  bool _shareLogs = true;
  bool _shareId = false;

  Future<void> _openMedicationDialog() async {
    final nameController = TextEditingController();
    MedicationFrequency frequency = MedicationFrequency.daily;
    final selectedWeekdays = <int>{};
    int? dayOfMonth;
    TimeOfDay? time;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('お薬の追加'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'お薬名',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<MedicationFrequency>(
                      value: frequency,
                      decoration: const InputDecoration(labelText: '頻度'),
                      items: const [
                        DropdownMenuItem(
                          value: MedicationFrequency.daily,
                          child: Text('毎日'),
                        ),
                        DropdownMenuItem(
                          value: MedicationFrequency.weekly,
                          child: Text('毎週（曜日指定）'),
                        ),
                        DropdownMenuItem(
                          value: MedicationFrequency.monthly,
                          child: Text('毎月（日付指定）'),
                        ),
                        DropdownMenuItem(
                          value: MedicationFrequency.custom,
                          child: Text('カスタム（曜日指定）'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() {
                          frequency = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    if (frequency == MedicationFrequency.weekly ||
                        frequency == MedicationFrequency.custom) ...[
                      const Text('曜日を選択'),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: List.generate(7, (index) {
                          final weekday = index + 1;
                          final label =
                              ['月', '火', '水', '木', '金', '土', '日'][index];
                          final selected = selectedWeekdays.contains(weekday);
                          return FilterChip(
                            label: Text(label),
                            selected: selected,
                            onSelected: (value) {
                              setDialogState(() {
                                if (value) {
                                  selectedWeekdays.add(weekday);
                                } else {
                                  selectedWeekdays.remove(weekday);
                                }
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (frequency == MedicationFrequency.monthly) ...[
                      DropdownButtonFormField<int>(
                        value: dayOfMonth,
                        decoration: const InputDecoration(labelText: '日付'),
                        items: List.generate(
                          31,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1}日'),
                          ),
                        ),
                        onChanged: (value) {
                          setDialogState(() => dayOfMonth = value);
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        const Text('時間'),
                        const SizedBox(width: 8),
                        Text(time == null ? '未設定' : time!.format(context)),
                        const Spacer(),
                        TextButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked == null) return;
                            setDialogState(() => time = picked);
                          },
                          child: const Text('設定'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('キャンセル'),
                ),
                TextButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    AppState.instance.addMedication(
                      Medication(
                        name: name,
                        frequency: frequency,
                        weekdays: selectedWeekdays.toList(),
                        dayOfMonth: dayOfMonth,
                        time: time,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('追加'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '設定',
              style: TextStyle(
                color: kTextDark,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'プロフィールの管理',
              style: TextStyle(color: kTextMuted, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFF0F2F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7EE),
                      shape: BoxShape.circle,
                      border: Border.all(color: kPrimary, width: 1),
                    ),
                    child: const Icon(Icons.person, color: kPrimary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppState.instance.name.isEmpty
                              ? widget.name
                              : AppState.instance.name,
                          style: const TextStyle(
                            color: kTextDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          children: [
                            _TagChip(label: widget.role),
                            _TagChip(label: widget.usageLabel),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.usageLabel != 'お薬を飲むのを確認する') ...[
              const SizedBox(height: 16),
              _SectionCard(
                title: 'お薬の設定',
                leadingIcon: Icons.medication,
                trailingIcon: Icons.add,
                onTrailingTap: _openMedicationDialog,
                onTap: _openMedicationDialog,
                child: AnimatedBuilder(
                  animation: AppState.instance,
                  builder: (context, _) {
                    if (AppState.instance.medications.isEmpty) {
                      return const Text(
                        'お薬が登録されていません',
                        style: TextStyle(color: kTextMuted, fontSize: 12),
                      );
                    }
                    return Column(
                      children: List.generate(
                        AppState.instance.medications.length,
                        (index) {
                          final med = AppState.instance.medications[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    med.name,
                                    style: const TextStyle(
                                      color: kTextDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      AppState.instance.removeMedication(index),
                                  icon: const Icon(Icons.close, size: 18),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            _SectionCard(
              title: 'パートナー接続',
              leadingIcon: Icons.people,
              trailingIcon: Icons.share,
              onTrailingTap: () {
                Share.share(
                  'パートナー接続申請がきたよ！\n以下アプリのURL\nhttps://example.com',
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '@',
                            style: TextStyle(
                              color: kTextMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.userId,
                        style: const TextStyle(color: kTextDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      final controller = TextEditingController();
                      showDialog<void>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('相手のIDを入力'),
                            content: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                hintText: 'partner_id',
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
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          '相手のIDを入力してつなぐ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _PrivacyCard(
              showProfile: _showProfile,
              shareLogs: _shareLogs,
              shareId: _shareId,
              onShowProfileChanged: (value) {
                setState(() => _showProfile = value);
              },
              onShareLogsChanged: (value) {
                setState(() => _shareLogs = value);
              },
              onShareIdChanged: (value) {
                setState(() => _shareId = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final VoidCallback? onTrailingTap;
  final VoidCallback? onTap;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.leadingIcon,
    required this.trailingIcon,
    this.onTrailingTap,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF0F2F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F7EE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(leadingIcon, color: kPrimary, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: kTextDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onTrailingTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(trailingIcon, color: kPrimary, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  final bool showProfile;
  final bool shareLogs;
  final bool shareId;
  final ValueChanged<bool> onShowProfileChanged;
  final ValueChanged<bool> onShareLogsChanged;
  final ValueChanged<bool> onShareIdChanged;

  const _PrivacyCard({
    required this.showProfile,
    required this.shareLogs,
    required this.shareId,
    required this.onShowProfileChanged,
    required this.onShareLogsChanged,
    required this.onShareIdChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0F2F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.security, color: kPrimary, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'プライバシー設定',
                  style: TextStyle(
                    color: kTextDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PrivacyRow(
            title: 'プロフィール表示',
            description: '相手に名前と役割を表示します',
            enabled: showProfile,
            onChanged: onShowProfileChanged,
          ),
          const SizedBox(height: 10),
          _PrivacyRow(
            title: '服薬記録の共有',
            description: '飲んだ/飲んでいないを共有します',
            enabled: shareLogs,
            onChanged: onShareLogsChanged,
          ),
          const SizedBox(height: 10),
          _PrivacyRow(
            title: 'IDの公開',
            description: '共有用IDをプロフィールに表示します',
            enabled: shareId,
            onChanged: onShareIdChanged,
          ),
        ],
      ),
    );
  }
}

class _PrivacyRow extends StatelessWidget {
  final String title;
  final String description;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _PrivacyRow({
    required this.title,
    required this.description,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => onChanged(!enabled),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0F2F0)),
        ),
        child: Row(
          children: [
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
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: kTextMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              width: 38,
              height: 22,
              alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: enabled ? kPrimary : const Color(0xFFE1E5E1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: kPrimary, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
