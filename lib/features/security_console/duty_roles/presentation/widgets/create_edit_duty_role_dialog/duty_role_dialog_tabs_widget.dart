import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../gen/assets.gen.dart';

class DutyRoleDialogTabs extends StatelessWidget {
  final bool isDark;
  final int currentTabIndex;
  final int privilegesCount;
  final ValueChanged<int> onTabChanged;

  const DutyRoleDialogTabs({
    super.key,
    required this.isDark,
    required this.currentTabIndex,
    required this.privilegesCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? Theme.of(context).brightness == Brightness.dark 
          ? Theme.of(context).scaffoldBackgroundColor 
          : const Color(0xFFF8FAFC)
          : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.all(24),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: _DutyRoleTab(
                isSelected: currentTabIndex == 0,
                label: 'Basic Details',
                iconPath: Assets.icons.securityConsoleIcon.path,
                onTap: () => onTabChanged(0),
              ),
            ),
            Expanded(
              child: _DutyRoleTab(
                isSelected: currentTabIndex == 1,
                label: 'Assign Privileges',
                iconPath: Assets.icons.keyIcon.path,
                badge: privilegesCount > 0 ? '$privilegesCount' : null,
                onTap: () => onTabChanged(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DutyRoleTab extends StatelessWidget {
  final bool isSelected;
  final String label;
  final String iconPath;
  final String? badge;
  final VoidCallback onTap;

  const _DutyRoleTab({
    required this.isSelected,
    required this.label,
    required this.iconPath,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Color(0xFF0F172B),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F172B),
                height: 1.45,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  border: Border.all(color: const Color(0xFFBEDBFF)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF193CB8),
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
