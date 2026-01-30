import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CalendarScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                  onPressed: () {},
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      '2026年 1月',
                      style: TextStyle(
                        color: kTextDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            const _CalendarGrid(),
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
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid();

  @override
  Widget build(BuildContext context) {
    const weekdays = ['日', '月', '火', '水', '木', '金', '土'];
    final days = List<int?>.generate(42, (index) {
      final day = index - 2;
      if (day < 1 || day > 31) return null;
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
        const SizedBox(height: 8),
        GridView.builder(
          itemCount: days.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
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
            fontSize: 12,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
