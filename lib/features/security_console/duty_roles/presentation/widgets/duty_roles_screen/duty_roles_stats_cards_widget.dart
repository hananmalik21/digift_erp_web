import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../gen/assets.gen.dart';

class DutyRolesStatsCards extends StatelessWidget {
  final bool isDark;
  final bool isMobile;
  final int totalDutyRoles;
  final int activeDutyRoles;
  final int totalUsers;
  final int avgPrivileges;

  const DutyRolesStatsCards({
    super.key,
    required this.isDark,
    required this.isMobile,
    required this.totalDutyRoles,
    required this.activeDutyRoles,
    required this.totalUsers,
    required this.avgPrivileges,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'label': 'Total Duty Roles',
        'value': '$totalDutyRoles',
        'color': const Color(0xFF155DFC),
        'icon': Assets.icons.dutyRoleIcon.path
      },
      {
        'label': 'Active',
        'value': '$activeDutyRoles',
        'color': const Color(0xFF00A63E),
        'icon': Assets.icons.workflowApprovalsIcon.path
      },
      {
        'label': 'Users Assigned',
        'value': '$totalUsers',
        'color': const Color(0xFF9810FA),
        'icon': Assets.icons.userManagementIcon.path
      },
      {
        'label': 'Avg Privileges',
        'value': '$avgPrivileges',
        'color': const Color(0xFF155DFC),
        'icon': Assets.icons.keyIcon.path
      },
    ];

    if (isMobile) {
      return Column(
        children: stats
            .map(
              (stat) => Padding(
                key: ValueKey(stat['label']),
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildStatCard(context, stat, isDark),
              ),
            )
            .toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth < 900;

        if (isTablet) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, stats[0], isDark)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, stats[1], isDark)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, stats[2], isDark)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, stats[3], isDark)),
                ],
              ),
            ],
          );
        }

        return Row(
          children: stats.map((stat) {
            return Expanded(
              key: ValueKey(stat['label']),
              child: Padding(
                padding: EdgeInsets.only(right: stat == stats.last ? 0 : 16),
                child: _buildStatCard(context, stat, isDark),
              ),
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
    return Container(
      constraints: const BoxConstraints(minHeight: 86),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
      padding: const EdgeInsets.all(17),
      child: Row(
        children: [
          SvgPicture.asset(
            stat['icon'] as String,
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              stat['color'] as Color,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat['label'] as String,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.7,
                    fontWeight: FontWeight.w400,
                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
                    height: 1.46,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['value'] as String,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
