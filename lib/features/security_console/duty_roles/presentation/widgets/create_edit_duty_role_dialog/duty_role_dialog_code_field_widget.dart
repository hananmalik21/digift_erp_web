import 'package:flutter/material.dart';
import 'duty_role_dialog_label_widget.dart';

class DutyRoleDialogCodeField extends StatelessWidget {
  final bool isDark;
  final TextEditingController controller;
  final VoidCallback onChanged;

  const DutyRoleDialogCodeField({
    super.key,
    required this.isDark,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DutyRoleDialogLabel(text: 'Role Code', required: true),
        const SizedBox(height: 8),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            border: Border.all(color: const Color(0xFFCAD5E2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12.75,
              ),
            ),
            onChanged: (_) => onChanged(),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Unique code for system\nidentification',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.8,
            fontWeight: FontWeight.w400,
            color: Color(0xFF62748E),
            height: 1.36,
          ),
        ),
      ],
    );
  }
}
