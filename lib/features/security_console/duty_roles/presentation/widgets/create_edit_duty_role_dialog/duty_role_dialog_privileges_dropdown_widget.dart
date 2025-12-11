import 'package:digify_erp/features/security_console/function_privileges/data/models/function_privilege_dto.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/paginated_dropdown.dart';
import 'duty_role_dialog_label_widget.dart';

class DutyRoleDialogPrivilegesDropdown extends StatelessWidget {
  final bool isDark;
  final List<FunctionPrivilegeDto> privileges;
  final bool isLoadingPrivileges;
  final String? privilegesError;
  final ValueChanged<FunctionPrivilegeDto> onPrivilegeSelected;

  const DutyRoleDialogPrivilegesDropdown({
    super.key,
    required this.isDark,
    required this.privileges,
    required this.isLoadingPrivileges,
    this.privilegesError,
    required this.onPrivilegeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DutyRoleDialogLabel(text: 'Privileges', required: false),
        const SizedBox(height: 8),
        PaginatedDropdown<FunctionPrivilegeDto>(
          items: privileges,
          selectedValue: null,
          getLabel: (privilege) => privilege.name,
          onChanged: (value) {
            if (value != null) {
              onPrivilegeSelected(value);
            }
          },
          onLoadMore: () async {
            // No pagination needed - all privileges loaded at once
          },
          isLoading: isLoadingPrivileges,
          hasMore: false,
          hintText: isLoadingPrivileges
              ? 'Loading privileges...'
              : privilegesError != null
                  ? 'Error loading privileges'
                  : privileges.isEmpty
                      ? 'No privileges found'
                      : 'Select Privilege',
          isDark: isDark,
          height: 44,
          error: privilegesError,
          enableSearch: true,
          useApiSearch: false, // Use local search
        ),
        const SizedBox(height: 8),
        if (privilegesError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              'Failed to load privileges. Please try again.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.8,
                fontWeight: FontWeight.w400,
                color: Colors.red,
                height: 1.36,
              ),
            ),
          ),
        const Text(
          'Search and select privileges to assign',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF62748E),
            height: 1.33,
          ),
        ),
      ],
    );
  }
}
