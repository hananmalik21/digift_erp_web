import 'package:digify_erp/features/security_console/function_privileges/data/models/function_privilege_dto.dart';
import 'package:flutter/material.dart';
import 'duty_role_dialog_label_widget.dart';

class DutyRoleDialogSelectedPrivilegesChips extends StatelessWidget {
  final bool isDark;
  final List<FunctionPrivilegeDto> selectedPrivileges;
  final ValueChanged<FunctionPrivilegeDto> onPrivilegeRemoved;

  const DutyRoleDialogSelectedPrivilegesChips({
    super.key,
    required this.isDark,
    required this.selectedPrivileges,
    required this.onPrivilegeRemoved,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedPrivileges.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'No privileges selected. Select privileges from the dropdown above.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DutyRoleDialogLabel(
          text: 'Selected Privileges (${selectedPrivileges.length})',
          required: false,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedPrivileges.map((privilege) {
              final isInherited = privilege.inherited;
              return Chip(
                key: ValueKey(privilege.id),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isInherited) ...[
                      const Icon(
                        Icons.account_tree,
                        size: 14,
                        color: Color(0xFF155DFC),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: Text(
                        privilege.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: isInherited 
                              ? const Color(0xFF155DFC) 
                              : const Color(0xFF0F172B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                deleteIcon: isInherited 
                    ? null 
                    : const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFF6B7280),
                      ),
                onDeleted: isInherited ? null : () => onPrivilegeRemoved(privilege),
                backgroundColor: isInherited 
                    ? const Color(0xFFE3F2FD) 
                    : const Color(0xFFF3F4F6),
                side: isInherited 
                    ? const BorderSide(color: Color(0xFF90CAF9), width: 1)
                    : BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                // tooltip: isInherited
                //     ? 'Inherited privilege - cannot be removed'
                //     : null,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
