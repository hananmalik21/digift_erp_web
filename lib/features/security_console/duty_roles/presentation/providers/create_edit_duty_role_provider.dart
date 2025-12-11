import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/duty_role_model.dart';
import '../../../functions/data/models/module_dto.dart';
import '../../../function_privileges/data/models/function_privilege_dto.dart';

class CreateEditDutyRoleState {
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final int currentTabIndex;
  final ModuleDto? selectedModule;
  final int? selectedModuleId;
  final String selectedStatus;
  final int privilegesCount;
  final bool isLoading;
  final List<ModuleDto> modules;
  final bool isLoadingModules;
  final String? modulesError;
  final List<FunctionPrivilegeDto> selectedPrivileges;
  final List<FunctionPrivilegeDto> privileges;
  final bool isLoadingPrivileges;
  final String? privilegesError;

  CreateEditDutyRoleState({
    required this.nameController,
    required this.codeController,
    required this.descriptionController,
    this.currentTabIndex = 0,
    this.selectedModule,
    this.selectedModuleId,
    this.selectedStatus = 'Active',
    this.privilegesCount = 0,
    this.isLoading = false,
    this.modules = const [],
    this.isLoadingModules = false,
    this.modulesError,
    this.selectedPrivileges = const [],
    this.privileges = const [],
    this.isLoadingPrivileges = false,
    this.privilegesError,
  });

  CreateEditDutyRoleState copyWith({
    int? currentTabIndex,
    ModuleDto? selectedModule,
    int? selectedModuleId,
    bool clearModuleId = false,
    String? selectedStatus,
    int? privilegesCount,
    bool? isLoading,
    List<ModuleDto>? modules,
    bool? isLoadingModules,
    String? modulesError,
    List<FunctionPrivilegeDto>? selectedPrivileges,
    List<FunctionPrivilegeDto>? privileges,
    bool? isLoadingPrivileges,
    String? privilegesError,
    bool clearPrivilegesError = false,
  }) {
    return CreateEditDutyRoleState(
      nameController: nameController,
      codeController: codeController,
      descriptionController: descriptionController,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      selectedModule: selectedModule ?? this.selectedModule,
      selectedModuleId: clearModuleId ? null : (selectedModuleId ?? this.selectedModuleId),
      selectedStatus: selectedStatus ?? this.selectedStatus,
      privilegesCount: privilegesCount ?? this.privilegesCount,
      isLoading: isLoading ?? this.isLoading,
      modules: modules ?? this.modules,
      isLoadingModules: isLoadingModules ?? this.isLoadingModules,
      modulesError: clearPrivilegesError ? null : (modulesError ?? this.modulesError),
      selectedPrivileges: selectedPrivileges ?? this.selectedPrivileges,
      privileges: privileges ?? this.privileges,
      isLoadingPrivileges: isLoadingPrivileges ?? this.isLoadingPrivileges,
      privilegesError: clearPrivilegesError ? null : (privilegesError ?? this.privilegesError),
    );
  }

  bool get isFormValid {
    return nameController.text.trim().isNotEmpty &&
        codeController.text.trim().isNotEmpty &&
        selectedModule != null &&
        selectedModuleId != null &&
        selectedStatus.isNotEmpty;
  }
}

class CreateEditDutyRoleNotifier extends StateNotifier<CreateEditDutyRoleState> {
  CreateEditDutyRoleNotifier(DutyRoleModel? dutyRole)
      : super(CreateEditDutyRoleState(
          nameController: TextEditingController(),
          codeController: TextEditingController(),
          descriptionController: TextEditingController(),
        )) {
    if (dutyRole != null) {
      state.nameController.text = dutyRole.name;
      state.codeController.text = dutyRole.code;
      state.descriptionController.text = dutyRole.description;
      state = state.copyWith(selectedStatus: dutyRole.status);
    }
  }

  void setCurrentTabIndex(int index) {
    state = state.copyWith(currentTabIndex: index);
  }

  void setSelectedModule(ModuleDto? module) {
    state = state.copyWith(
      selectedModule: module,
      selectedModuleId: module?.id,
    );
  }

  void setSelectedStatus(String status) {
    state = state.copyWith(selectedStatus: status);
  }

  void addPrivilege(FunctionPrivilegeDto privilege) {
    final isDuplicate = state.selectedPrivileges.any((p) => p.id == privilege.id);
    if (!isDuplicate) {
      final updatedPrivileges = [...state.selectedPrivileges, privilege];
      state = state.copyWith(
        selectedPrivileges: updatedPrivileges,
        privilegesCount: updatedPrivileges.length,
      );
    }
  }

  void removePrivilege(FunctionPrivilegeDto privilege) {
    final updatedPrivileges = state.selectedPrivileges
        .where((p) => p.id != privilege.id)
        .toList();
    state = state.copyWith(
      selectedPrivileges: updatedPrivileges,
      privilegesCount: updatedPrivileges.length,
    );
  }

  void setModules(List<ModuleDto> modules) {
    state = state.copyWith(modules: modules, isLoadingModules: false);
  }

  void setLoadingModules(bool isLoading) {
    state = state.copyWith(isLoadingModules: isLoading);
  }

  void setModulesError(String? error) {
    state = state.copyWith(modulesError: error, isLoadingModules: false);
  }

  void setPrivileges(List<FunctionPrivilegeDto> privileges) {
    state = state.copyWith(privileges: privileges, isLoadingPrivileges: false);
  }

  void setLoadingPrivileges(bool isLoading) {
    state = state.copyWith(isLoadingPrivileges: isLoading);
  }

  void setPrivilegesError(String? error) {
    state = state.copyWith(privilegesError: error, isLoadingPrivileges: false);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setSelectedPrivileges(List<FunctionPrivilegeDto> privileges) {
    state = state.copyWith(
      selectedPrivileges: privileges,
      privilegesCount: privileges.length,
    );
  }

  void autoSelectExistingModule(String moduleName, List<ModuleDto> modules) {
    if (moduleName.isEmpty || modules.isEmpty) return;
    
    try {
      final module = modules.firstWhere(
        (m) => m.name.toLowerCase() == moduleName.toLowerCase(),
      );
      setSelectedModule(module);
    } catch (e) {
      // Module not found in list, keep as null
    }
  }

  @override
  void dispose() {
    state.nameController.dispose();
    state.codeController.dispose();
    state.descriptionController.dispose();
    super.dispose();
  }
}
