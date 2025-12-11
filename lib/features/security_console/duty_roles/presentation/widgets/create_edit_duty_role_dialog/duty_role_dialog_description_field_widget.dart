import 'package:flutter/material.dart';
import 'duty_role_dialog_label_widget.dart';

class DutyRoleDialogDescriptionField extends StatelessWidget {
  final bool isDark;
  final TextEditingController controller;

  const DutyRoleDialogDescriptionField({
    super.key,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DutyRoleDialogLabel(text: 'Description', required: false),
        const SizedBox(height: 8),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFCAD5E2)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.1,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
              height: 1.59,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Provide details about what this role does',
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
