import 'package:flutter/material.dart';

class DutyRoleDialogLabel extends StatelessWidget {
  final String text;
  final bool required;

  const DutyRoleDialogLabel({
    super.key,
    required this.text,
    required this.required,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.8,
          fontWeight: FontWeight.w500,
          color: Color(0xFF0F172B),
          height: 1.45,
        ),
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Color(0xFFFB2C36),
              ),
            ),
        ],
      ),
    );
  }
}
