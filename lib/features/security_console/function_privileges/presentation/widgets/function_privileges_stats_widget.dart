import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_extensions.dart';

class FunctionPrivilegesStatsCards extends StatelessWidget {
  final bool isDark;
  final bool isMobile;
  final bool isTablet;
  final int total;
  final int active;
  final int inactive;

  const FunctionPrivilegesStatsCards({
    super.key,
    required this.isDark,
    required this.isMobile,
    required this.isTablet,
    required this.total,
    required this.active,
    required this.inactive,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'label': 'Total Privileges',
        'value': '$total',
        'hasLeftBorder': false,
      },
      {
        'label': 'Active',
        'value': '$active',
        'hasLeftBorder': true,
        'leftBorderColor': const Color(0xFF00A63E),
        'valueColor': const Color(0xFF00A63E),
      },
      {
        'label': 'Inactive',
        'value': '$inactive',
        'hasLeftBorder': true,
        'leftBorderColor': const Color(0xFF4A5565),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        // RESPONSIVE BREAKPOINTS
        int columns;

        if (width < 480) {
          columns = 1; // small mobile
        } else if (width < 800) {
          columns = 2; // small desktop
        } else if (width < 1100) {
          columns = 3;
        } else if (width < 1400) {
          columns = 4;
        } else {
          columns = 5;
        }

        const spacing = 16.0;
        double cardWidth = (width - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: stats.map((stat) {
            return SizedBox(
              width: cardWidth,
              child: _buildStatCard(context, stat, isDark),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    Map<String, dynamic> stat,
    bool isDark,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Stack(
          children: [
            if (stat['hasLeftBorder'] == true)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: stat['leftBorderColor'] ?? Colors.transparent,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 17,
                right: 17,
                bottom: 17,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    stat['label'],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.6,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF4A5565),
                      height: 1.47,
                    ),
                  ),
                  const SizedBox(height: 31),
                  Text(
                    stat['value'],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: stat['valueColor'] ??
                          (isDark ? Colors.white : const Color(0xFF0F172B)),
                      height: 1.33,
                    ),
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
