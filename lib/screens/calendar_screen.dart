import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CalendarScreen extends StatefulWidget {
  final String name;
  final String role;
  final String userId;

  const CalendarScreen({
    super.key,
    required this.name,
    required this.role,
    required this.userId,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
  }

  void _moveMonth(int diff) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + diff,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthLabel = '${_focusedMonth.year}年 ${_focusedMonth.month}月';
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'お薬カレンダー',
              style: TextStyle(
                color: kTextDark,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '日々の服用記録を確認しましょう',
              style: TextStyle(color: kTextMuted, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _moveMonth(-1),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      monthLabel,
                      style: const TextStyle(
                        color: kTextDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _moveMonth(1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _CalendarGrid(focusedMonth: _focusedMonth),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF0F2F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '今月のまとめ',
                    style: TextStyle(
                      color: kTextDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                            title: '継続日数', value: '0日', valueColor: kPrimary),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: _SummaryCard(
                            title: '達成率',
                            value: '0%',
                            valueColor: Color(0xFF1A78FF)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F2F0)),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: kTextMuted, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;

  const _CalendarGrid({required this.focusedMonth});

  @override
  Widget build(BuildContext context) {
    const weekdays = ['日', '月', '火', '水', '木', '金', '土'];
    final firstWeekday =
        DateTime(focusedMonth.year, focusedMonth.month, 1).weekday;
    final daysInMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    final offset = firstWeekday % 7;
    final days = List<int?>.generate(42, (index) {
      final day = index - offset + 1;
      if (day < 1 || day > daysInMonth) return null;
      return day;
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekdays
              .map(
                (label) => SizedBox(
                  width: 36,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kTextMuted, fontSize: 11),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          itemCount: days.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return _CalendarDay(day: days[index]);
          },
        ),
      ],
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final int? day;

  const _CalendarDay({required this.day});

  @override
  Widget build(BuildContext context) {
    if (day == null) {
      return const SizedBox(width: 36, height: 36);
    }

    const isCompleted = false;
    const isHighlighted = false;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isHighlighted ? kPrimary.withOpacity(0.15) : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted ? kPrimary : const Color(0xFFE0E4E0),
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            color: isCompleted ? kPrimary : kTextMuted,
            fontSize: 16,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
