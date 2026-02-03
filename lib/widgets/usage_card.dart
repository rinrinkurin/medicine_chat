import 'package:flutter/material.dart';

import '../models/usage_option.dart';
import '../theme/app_theme.dart';

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
                      fontSize: kFontSmall,
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
