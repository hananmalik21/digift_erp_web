import 'package:flutter/material.dart';

class DutyRoleDialogInfoBox extends StatelessWidget {
  const DutyRoleDialogInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: const Color(0xFFBEDBFF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: Color(0xFF1C398E),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'About Duty Roles',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C398E),
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Duty roles represent a set of privileges required to perform a specific business function. They are used to compose Job Roles and ensure consistent security assignments across your organization.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF193CB8),
                    height: 1.47,
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
