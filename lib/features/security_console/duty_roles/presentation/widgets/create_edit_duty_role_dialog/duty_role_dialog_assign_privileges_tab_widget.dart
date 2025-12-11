import 'package:digify_erp/features/security_console/function_privileges/data/models/function_privilege_dto.dart';
import 'package:flutter/material.dart';
import 'duty_role_dialog_section_header_widget.dart';
import 'duty_role_dialog_privileges_dropdown_widget.dart';
import 'duty_role_dialog_selected_privileges_chips_widget.dart';

class DutyRoleDialogAssignPrivilegesTab extends StatelessWidget {
  final bool isDark;
  final List<FunctionPrivilegeDto> privileges;
  final List<FunctionPrivilegeDto> selectedPrivileges;
  final bool isLoadingPrivileges;
  final String? privilegesError;
  final ValueChanged<FunctionPrivilegeDto> onPrivilegeSelected;
  final ValueChanged<FunctionPrivilegeDto> onPrivilegeRemoved;

  const DutyRoleDialogAssignPrivilegesTab({
    super.key,
    required this.isDark,
    required this.privileges,
    required this.selectedPrivileges,
    required this.isLoadingPrivileges,
    this.privilegesError,
    required this.onPrivilegeSelected,
    required this.onPrivilegeRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DutyRoleDialogSectionHeader(
          title: 'Assign Privileges',
          subtitle: 'Select privileges to assign to this duty role',
        ),
        const SizedBox(height: 28),
        DutyRoleDialogPrivilegesDropdown(
          isDark: isDark,
          privileges: privileges,
          isLoadingPrivileges: isLoadingPrivileges,
          privilegesError: privilegesError,
          onPrivilegeSelected: onPrivilegeSelected,
        ),
        const SizedBox(height: 24),
        DutyRoleDialogSelectedPrivilegesChips(
          isDark: isDark,
          selectedPrivileges: selectedPrivileges,
          onPrivilegeRemoved: onPrivilegeRemoved,
        ),
      ],
    );
  }
}
