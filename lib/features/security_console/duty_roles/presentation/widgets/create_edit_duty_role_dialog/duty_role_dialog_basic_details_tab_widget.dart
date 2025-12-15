import 'package:digify_erp/features/security_console/duty_roles/data/models/duty_role_reference.dart';
import 'package:digify_erp/features/security_console/functions/data/models/module_dto.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import 'duty_role_dialog_section_header_widget.dart';
import 'duty_role_dialog_info_box_widget.dart';
import 'duty_role_dialog_name_field_widget.dart';
import 'duty_role_dialog_code_field_widget.dart';
import 'duty_role_dialog_description_field_widget.dart';
import 'duty_role_dialog_module_field_widget.dart';
import 'duty_role_dialog_status_field_widget.dart';
import 'duty_role_dialog_inherit_from_section_widget.dart';

class DutyRoleDialogBasicDetailsTab extends StatelessWidget {
  final bool isDark;
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final List<ModuleDto> modules;
  final ModuleDto? selectedModule;
  final bool isLoadingModules;
  final String? modulesError;
  final String selectedStatus;
  final List<String> statuses;
  final ValueChanged<ModuleDto?> onModuleChanged;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onFieldChanged;
  final TextEditingController inheritedDutyRolesSearchController;
  final List<DutyRoleReference> inheritedDutyRolesSearchResults;
  final List<DutyRoleReference> selectedInheritedDutyRoles;
  final bool isLoadingInheritedDutyRoles;
  final String? inheritedDutyRolesError;
  final ValueChanged<DutyRoleReference> onInheritedDutyRoleSelected;
  final ValueChanged<DutyRoleReference> onInheritedDutyRoleRemoved;
  final ValueChanged<String> onInheritedDutyRoleSearchChanged;

  const DutyRoleDialogBasicDetailsTab({
    super.key,
    required this.isDark,
    required this.nameController,
    required this.codeController,
    required this.descriptionController,
    required this.modules,
    required this.selectedModule,
    required this.isLoadingModules,
    this.modulesError,
    required this.selectedStatus,
    required this.statuses,
    required this.onModuleChanged,
    required this.onStatusChanged,
    required this.onFieldChanged,
    required this.inheritedDutyRolesSearchController,
    required this.inheritedDutyRolesSearchResults,
    required this.selectedInheritedDutyRoles,
    required this.isLoadingInheritedDutyRoles,
    this.inheritedDutyRolesError,
    required this.onInheritedDutyRoleSelected,
    required this.onInheritedDutyRoleRemoved,
    required this.onInheritedDutyRoleSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DutyRoleDialogSectionHeader(
          title: 'Role Information',
          subtitle: 'Provide basic information about this duty role',
        ),
        const SizedBox(height: 28),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DutyRoleDialogNameField(
                isDark: isDark,
                controller: nameController,
                onChanged: onFieldChanged,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: DutyRoleDialogCodeField(
                isDark: isDark,
                controller: codeController,
                onChanged: onFieldChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        DutyRoleDialogDescriptionField(
          isDark: isDark,
          controller: descriptionController,
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DutyRoleDialogModuleField(
                isDark: isDark,
                modules: modules,
                selectedModule: selectedModule,
                isLoadingModules: isLoadingModules,
                modulesError: modulesError,
                onChanged: onModuleChanged,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: DutyRoleDialogStatusField(
                isDark: isDark,
                selectedStatus: selectedStatus,
                statuses: statuses,
                onChanged: onStatusChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        DutyRoleDialogInheritFromSection(
          isDark: isDark,
          searchController: inheritedDutyRolesSearchController,
          searchResults: inheritedDutyRolesSearchResults,
          selectedDutyRoles: selectedInheritedDutyRoles,
          isLoading: isLoadingInheritedDutyRoles,
          error: inheritedDutyRolesError,
          onDutyRoleSelected: onInheritedDutyRoleSelected,
          onDutyRoleRemoved: onInheritedDutyRoleRemoved,
          onSearchChanged: onInheritedDutyRoleSearchChanged,
        ),
        const SizedBox(height: 24),
        const DutyRoleDialogInfoBox(),
      ],
    );
  }
}
