import 'package:flutter/material.dart';
import '../../../../functions/data/models/module_dto.dart';

class DutyRolesModuleButton extends StatelessWidget {
  final dynamic module; // String for "All" or ModuleDto
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  const DutyRolesModuleButton({
    super.key,
    required this.module,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String moduleName;
    if (module is String) {
      moduleName = module as String;
    } else if (module is ModuleDto) {
      moduleName = (module as ModuleDto).name;
    } else {
      return const SizedBox.shrink();
    }

    return IntrinsicWidth(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7.5),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF155DFC)
                : (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            moduleName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isSelected
                  ? Colors.white
                  : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563)),
              height: 1.21,
            ),
          ),
        ),
      ),
    );
  }
}
