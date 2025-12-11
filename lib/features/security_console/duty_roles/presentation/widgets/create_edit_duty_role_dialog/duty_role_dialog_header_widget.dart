import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../gen/assets.gen.dart';

class DutyRoleDialogHeader extends StatelessWidget {
  final bool isDark;
  final bool isEdit;
  final VoidCallback onClose;

  const DutyRoleDialogHeader({
    super.key,
    required this.isDark,
    required this.isEdit,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.icons.dutyRoleIcon.path,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF155DFC),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Duty Role' : 'Create Duty Role',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.9,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172B),
                    height: 1.48,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEdit
                      ? 'Update duty role information and privilege assignments'
                      : 'Create a new duty role with privileges',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF45556C),
                    height: 1.47,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF0F172B)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
