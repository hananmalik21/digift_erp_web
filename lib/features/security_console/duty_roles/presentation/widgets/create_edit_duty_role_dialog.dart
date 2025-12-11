import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../data/models/duty_role_model.dart';
import '../../data/datasources/duty_role_remote_datasource.dart';
import '../providers/create_edit_duty_role_provider.dart';
import '../services/duty_role_dialog_service.dart';
import 'create_edit_duty_role_dialog/duty_role_dialog_header_widget.dart';
import 'create_edit_duty_role_dialog/duty_role_dialog_tabs_widget.dart';
import 'create_edit_duty_role_dialog/duty_role_dialog_basic_details_tab_widget.dart';
import 'create_edit_duty_role_dialog/duty_role_dialog_assign_privileges_tab_widget.dart';
import 'create_edit_duty_role_dialog/duty_role_dialog_footer_widget.dart';

class CreateEditDutyRoleDialog extends ConsumerStatefulWidget {
  final DutyRoleModel? dutyRole;

  const CreateEditDutyRoleDialog({super.key, this.dutyRole});

  @override
  ConsumerState<CreateEditDutyRoleDialog> createState() => _CreateEditDutyRoleDialogState();
}

class _CreateEditDutyRoleDialogState extends ConsumerState<CreateEditDutyRoleDialog> {
  late final DutyRoleDialogService _dialogService;
  final List<String> _statuses = ['Active', 'Inactive'];
  
  final createEditDutyRoleProvider = StateNotifierProvider.autoDispose.family<CreateEditDutyRoleNotifier, CreateEditDutyRoleState, DutyRoleModel?>(
    (ref, dutyRole) {
      final notifier = CreateEditDutyRoleNotifier(dutyRole);
      final dataSource = DutyRoleRemoteDataSourceImpl();
      final service = DutyRoleDialogService(dataSource);
      
      // Load modules and privileges on initialization
      service.loadModules(notifier, dutyRole);
      service.loadPrivileges(notifier, dutyRole);
      
      return notifier;
    },
  );

  @override
  void initState() {
    super.initState();
    final dataSource = DutyRoleRemoteDataSourceImpl();
    _dialogService = DutyRoleDialogService(dataSource);
  }

  Future<void> _handleSave() async {
    final provider = createEditDutyRoleProvider(widget.dutyRole);
    final notifier = ref.read(provider.notifier);
    final state = ref.read(provider);
    
    if (!state.isFormValid) return;

    notifier.setLoading(true);

    try {
      final result = await _dialogService.handleSave(
        existingDutyRole: widget.dutyRole,
        dutyRoleName: state.nameController.text,
        roleCode: state.codeController.text,
        description: state.descriptionController.text,
        moduleId: state.selectedModuleId!,
        selectedPrivileges: state.selectedPrivileges,
        status: state.selectedStatus,
        moduleName: state.selectedModule?.name,
      );

      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      if (mounted) {
        notifier.setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createEditDutyRoleProvider(widget.dutyRole));
    final notifier = ref.read(createEditDutyRoleProvider(widget.dutyRole).notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isEdit = widget.dutyRole != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 24,
      ),
      child: Container(
        width: isMobile ? double.infinity : 510,
        constraints: BoxConstraints(
          maxHeight: size.height - 48,
          minHeight: 600,
        ),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            DutyRoleDialogHeader(
              isDark: isDark,
              isEdit: isEdit,
              onClose: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Column(
                children: [
                  DutyRoleDialogTabs(
                    isDark: isDark,
                    currentTabIndex: state.currentTabIndex,
                    privilegesCount: state.privilegesCount,
                    onTabChanged: (index) => notifier.setCurrentTabIndex(index),
                  ),
                  Expanded(
                    child: Container(
                      color: isDark
                          ? context.themeBackground
                          : const Color(0xFFF8FAFC),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: state.currentTabIndex == 0
                            ? DutyRoleDialogBasicDetailsTab(
                                isDark: isDark,
                                nameController: state.nameController,
                                codeController: state.codeController,
                                descriptionController: state.descriptionController,
                                modules: state.modules,
                                selectedModule: state.selectedModule,
                                isLoadingModules: state.isLoadingModules,
                                modulesError: state.modulesError,
                                selectedStatus: state.selectedStatus,
                                statuses: _statuses,
                                onModuleChanged: (module) => notifier.setSelectedModule(module),
                                onStatusChanged: (status) => notifier.setSelectedStatus(status),
                                onFieldChanged: () {},
                              )
                            : DutyRoleDialogAssignPrivilegesTab(
                                isDark: isDark,
                                privileges: state.privileges,
                                selectedPrivileges: state.selectedPrivileges,
                                isLoadingPrivileges: state.isLoadingPrivileges,
                                privilegesError: state.privilegesError,
                                onPrivilegeSelected: (privilege) => notifier.addPrivilege(privilege),
                                onPrivilegeRemoved: (privilege) => notifier.removePrivilege(privilege),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DutyRoleDialogFooter(
              isEdit: isEdit,
              privilegesCount: state.privilegesCount,
              isLoading: state.isLoading,
              isFormValid: state.isFormValid,
              onCancel: () => Navigator.of(context).pop(),
              onSave: _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}
