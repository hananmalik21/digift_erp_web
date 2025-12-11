import 'package:flutter/material.dart';

/// A reusable status badge widget for table cells
class CustomStatusCell extends StatelessWidget {
  final String status;
  final bool isDark;
  final double? width;

  const CustomStatusCell({
    super.key,
    required this.status,
    required this.isDark,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final badge = _buildStatusBadge(status, isDark);
    
    if (width != null) {
      return SizedBox(
        width: width,
        child: badge,
      );
    }
    
    return badge;
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    final isActive = status == 'Active' || status == 'ACTIVE';

    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFD1FAE5)
            : const Color(0xFFF3F4F6),
        border: Border.all(
          color: isActive
              ? const Color(0xFFB9F8CF)
              : const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 12,
            color: isActive
                ? const Color(0xFF008236)
                : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isActive
                  ? const Color(0xFF008236)
                  : const Color(0xFF6B7280),
              height: 1.36,
            ),
          ),
        ],
      ),
    );
  }
}


