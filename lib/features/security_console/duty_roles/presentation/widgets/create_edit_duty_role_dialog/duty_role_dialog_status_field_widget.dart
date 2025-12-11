import 'package:flutter/material.dart';
import 'duty_role_dialog_label_widget.dart';

class DutyRoleDialogStatusField extends StatelessWidget {
  final bool isDark;
  final String selectedStatus;
  final List<String> statuses;
  final ValueChanged<String> onChanged;

  const DutyRoleDialogStatusField({
    super.key,
    required this.isDark,
    required this.selectedStatus,
    required this.statuses,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DutyRoleDialogLabel(text: 'Status', required: true),
        const SizedBox(height: 8),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFCAD5E2)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus,
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.keyboard_arrow_down, size: 20),
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.1,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0F172B),
                height: 1.26,
              ),
              items: statuses.map((String status) {
                return DropdownMenuItem<String>(
                  key: ValueKey(status),
                  value: status,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(status),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Role availability status',
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
