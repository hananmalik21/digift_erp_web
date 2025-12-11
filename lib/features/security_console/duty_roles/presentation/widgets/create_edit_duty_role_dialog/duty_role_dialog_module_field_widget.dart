import 'package:digify_erp/features/security_console/functions/data/models/module_dto.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/paginated_dropdown.dart';
import 'duty_role_dialog_label_widget.dart';

class DutyRoleDialogModuleField extends StatelessWidget {
  final bool isDark;
  final List<ModuleDto> modules;
  final ModuleDto? selectedModule;
  final bool isLoadingModules;
  final String? modulesError;
  final ValueChanged<ModuleDto?> onChanged;

  const DutyRoleDialogModuleField({
    super.key,
    required this.isDark,
    required this.modules,
    required this.selectedModule,
    required this.isLoadingModules,
    this.modulesError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DutyRoleDialogLabel(text: 'Module', required: true),
        const SizedBox(height: 8),
        PaginatedDropdown<ModuleDto>(
          items: modules,
          selectedValue: selectedModule,
          getLabel: (module) => module.name,
          onChanged: onChanged,
          onLoadMore: () async {
            // No pagination needed - all modules loaded at once
          },
          isLoading: isLoadingModules,
          hasMore: false,
          hintText: isLoadingModules
              ? 'Loading modules...'
              : modulesError != null
                  ? 'Error loading modules'
                  : modules.isEmpty
                      ? 'No modules found'
                      : 'Select Module',
          isDark: isDark,
          height: 44,
          error: modulesError,
          enableSearch: true,
          useApiSearch: false, // Use local search
        ),
        const SizedBox(height: 8),
        if (modulesError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              'Failed to load modules. Please try again.',
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
          'Primary functional module',
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
