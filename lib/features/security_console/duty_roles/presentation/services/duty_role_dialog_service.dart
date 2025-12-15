import 'package:flutter/foundation.dart';
import '../../data/models/duty_role_model.dart';
import '../../data/models/duty_role_dto.dart';
import '../../data/models/duty_role_reference.dart';
import '../../data/datasources/duty_role_remote_datasource.dart';
import '../../data/models/create_duty_role_request_dto.dart';
import '../../data/models/update_duty_role_request_dto.dart';
import '../../../function_privileges/data/datasources/function_privilege_remote_datasource.dart';
import '../../../function_privileges/data/models/function_privilege_dto.dart';
import '../../../functions/data/datasources/module_remote_datasource.dart';
import '../providers/create_edit_duty_role_provider.dart';

class DutyRoleDialogService {
  final DutyRoleRemoteDataSource dataSource;
  final ModuleRemoteDataSource modulesDataSource;
  final FunctionPrivilegeRemoteDataSource privilegesDataSource;

  DutyRoleDialogService(
    this.dataSource, {
    ModuleRemoteDataSource? modulesDataSource,
    FunctionPrivilegeRemoteDataSource? privilegesDataSource,
  })  : modulesDataSource = modulesDataSource ?? ModuleRemoteDataSourceImpl(),
        privilegesDataSource = privilegesDataSource ?? FunctionPrivilegeRemoteDataSourceImpl();

  /// Loads modules and auto-selects module in edit mode
  Future<void> loadModules(
    CreateEditDutyRoleNotifier notifier,
    DutyRoleModel? dutyRole,
  ) async {
    notifier.setLoadingModules(true);

    try {
      final modules = await modulesDataSource.getModules();
      notifier.setModules(modules);

      // Auto-select module in edit mode after modules are loaded
      if (dutyRole != null) {
        final moduleName = dutyRole.module;
        if (moduleName.isNotEmpty) {
          notifier.autoSelectExistingModule(moduleName, modules);
        }
      }
    } catch (e) {
      notifier.setModulesError(e.toString());
    }
  }

  /// Loads privileges and auto-selects privileges in edit mode
  Future<void> loadPrivileges(
    CreateEditDutyRoleNotifier notifier,
    DutyRoleModel? dutyRole,
  ) async {
    notifier.setLoadingPrivileges(true);

    try {
      final response = await privilegesDataSource.getFunctionPrivileges(
        page: 1,
        limit: 1000,
        search: null,
      );

      final privileges = response.data.cast<FunctionPrivilegeDto>();
      notifier.setPrivileges(privileges);

      // Auto-select privileges in edit mode
      if (dutyRole != null) {
        // Fetch duty role details to get privileges with inherited flags
        final dutyRoleId = int.tryParse(dutyRole.id);
        if (dutyRoleId != null) {
          try {
            final dutyRoleDto = await dataSource.getDutyRoleById(dutyRoleId);
            if (dutyRoleDto != null && dutyRoleDto.functionPrivileges.isNotEmpty) {
              // Use privileges from duty role DTO (which have inherited flags)
              autoSelectExistingPrivilegesFromDto(notifier, dutyRoleDto.functionPrivileges, privileges);
            } else {
              // Fallback to name-based matching
              autoSelectExistingPrivileges(notifier, dutyRole, privileges);
            }
          } catch (e) {
            // Fallback to name-based matching if fetch fails
            autoSelectExistingPrivileges(notifier, dutyRole, privileges);
          }
        } else {
          // Fallback to name-based matching if ID parsing fails
          autoSelectExistingPrivileges(notifier, dutyRole, privileges);
        }
      }
    } catch (e) {
      notifier.setPrivilegesError(e.toString());
    }
  }

  /// Searches duty roles via API for inheritance selection
  Future<void> searchInheritedDutyRoles(
    CreateEditDutyRoleNotifier notifier,
    String searchQuery,
    DutyRoleModel? dutyRole,
  ) async {
    if (searchQuery.trim().isEmpty) {
      notifier.setInheritedDutyRolesSearchResults([]);
      return;
    }

    notifier.setLoadingInheritedDutyRoles(true);

    try {
      final response = await dataSource.getDutyRoles(
        page: 1,
        limit: 100,
        search: searchQuery.trim(),
        moduleId: null,
        status: null,
      );

      // Convert DutyRoleDto to DutyRoleReference, excluding the current duty role if editing
      final currentDutyRoleId = dutyRole != null ? int.tryParse(dutyRole.id) : null;
      final dutyRoles = response.data
          .where((dto) {
            final id = int.tryParse(dto.id);
            return id != null && id > 0 && id != currentDutyRoleId;
          })
          .map((dto) {
            return DutyRoleReference(
              dutyRoleId: int.tryParse(dto.id) ?? 0,
              dutyRoleName: dto.dutyRoleName,
              roleCode: dto.roleCode,
              status: dto.status,
            );
          })
          .toList();

      notifier.setInheritedDutyRolesSearchResults(dutyRoles);
    } catch (e) {
      notifier.setInheritedDutyRolesError(e.toString());
    }
  }

  /// Matches and auto-selects existing inherited duty roles based on role names
  void autoSelectExistingInheritedDutyRoles(
    CreateEditDutyRoleNotifier notifier,
    DutyRoleModel dutyRole,
    List<DutyRoleReference> availableDutyRoles,
  ) {
    if (dutyRole.inheritedFromRoles.isEmpty || availableDutyRoles.isEmpty) return;

    final matched = <DutyRoleReference>[];
    
    for (final inheritedRoleName in dutyRole.inheritedFromRoles) {
      try {
        final matchedRole = availableDutyRoles.firstWhere(
          (dr) => dr.dutyRoleName.toLowerCase().trim() == inheritedRoleName.toLowerCase().trim(),
          orElse: () => availableDutyRoles.firstWhere(
            (dr) => dr.dutyRoleName.toLowerCase().contains(inheritedRoleName.toLowerCase().trim()) ||
                   inheritedRoleName.toLowerCase().trim().contains(dr.dutyRoleName.toLowerCase()),
          ),
        );
        
        if (matchedRole.dutyRoleId > 0 && !matched.any((dr) => dr.dutyRoleId == matchedRole.dutyRoleId)) {
          matched.add(matchedRole);
        }
      } catch (e) {
        // Role not found, skip
      }
    }
    
    if (matched.isNotEmpty) {
      notifier.setSelectedInheritedDutyRoles(matched);
    }
  }

  /// Auto-selects privileges from duty role DTO (preserves inherited flags)
  void autoSelectExistingPrivilegesFromDto(
    CreateEditDutyRoleNotifier notifier,
    List<FunctionPrivilegeDto> dutyRolePrivileges,
    List<FunctionPrivilegeDto> allPrivileges,
  ) {
    if (dutyRolePrivileges.isEmpty) return;

    final matchedPrivileges = <FunctionPrivilegeDto>[];

    for (final dutyRolePrivilege in dutyRolePrivileges) {
      try {
        // Try to find matching privilege in all privileges list by ID
        final matched = allPrivileges.firstWhere(
          (p) => p.id == dutyRolePrivilege.id,
          orElse: () => allPrivileges.firstWhere(
            (p) => p.name.toLowerCase().trim() == dutyRolePrivilege.name.toLowerCase().trim(),
            orElse: () => dutyRolePrivilege, // Use the one from duty role if not found
          ),
        );

        // Create a new privilege DTO with inherited flag preserved
        final privilegeWithInherited = FunctionPrivilegeDto(
          id: matched.id,
          code: matched.code,
          name: matched.name,
          description: matched.description,
          moduleId: matched.moduleId,
          moduleName: matched.moduleName,
          functionId: matched.functionId,
          functionName: matched.functionName,
          operationId: matched.operationId,
          operationName: matched.operationName,
          status: matched.status,
          usedInRoles: matched.usedInRoles,
          inherited: dutyRolePrivilege.inherited, // Preserve inherited flag from duty role
          createdAt: matched.createdAt,
          createdBy: matched.createdBy,
          updatedAt: matched.updatedAt,
          updatedBy: matched.updatedBy,
        );

        if (privilegeWithInherited.id.isNotEmpty && 
            !matchedPrivileges.any((p) => p.id == privilegeWithInherited.id)) {
          matchedPrivileges.add(privilegeWithInherited);
        }
      } catch (e) {
        // Privilege not found, skip
      }
    }

    if (matchedPrivileges.isNotEmpty) {
      notifier.setSelectedPrivileges(matchedPrivileges);
    }
  }

  /// Matches and auto-selects existing privileges based on privilege names (fallback)
  void autoSelectExistingPrivileges(
    CreateEditDutyRoleNotifier notifier,
    DutyRoleModel dutyRole,
    List<FunctionPrivilegeDto> privileges,
  ) {
    if (dutyRole.privileges.isEmpty) return;

    final existingPrivilegeNames = dutyRole.privileges;
    final matchedPrivileges = <FunctionPrivilegeDto>[];

    for (final privilegeName in existingPrivilegeNames) {
      try {
        final matched = privileges.firstWhere(
          (p) => p.name.toLowerCase().trim() == privilegeName.toLowerCase().trim(),
          orElse: () => privileges.firstWhere(
            (p) => p.name.toLowerCase().contains(privilegeName.toLowerCase().trim()) ||
                   privilegeName.toLowerCase().trim().contains(p.name.toLowerCase()),
          ),
        );

        if (matched.id.isNotEmpty && !matchedPrivileges.any((p) => p.id == matched.id)) {
          matchedPrivileges.add(matched);
        }
      } catch (e) {
        // Privilege not found, skip
      }
    }

    if (matchedPrivileges.isNotEmpty) {
      notifier.setSelectedPrivileges(matchedPrivileges);
    }
  }

  /// Extracts privilege IDs from a list of FunctionPrivilegeDto
  List<int> extractPrivilegeIds(List<FunctionPrivilegeDto> privileges) {
    final privilegeIds = <int>[];
    for (final privilege in privileges) {
      final id = int.tryParse(privilege.id.trim());
      if (id != null && id > 0) {
        privilegeIds.add(id);
      }
    }
    return privilegeIds;
  }

  /// Extracts duty role IDs from a list of DutyRoleReference
  List<int> extractDutyRoleIds(List<DutyRoleReference> dutyRoles) {
    return dutyRoles.map((dr) => dr.dutyRoleId).where((id) => id > 0).toList();
  }

  /// Parses the API response to extract the duty role data
  Map<String, dynamic>? extractResponseData(Map<String, dynamic> response) {
    if (response.containsKey('data') && response['data'] != null) {
      return response['data'] as Map<String, dynamic>?;
    } else if (response.containsKey('duty_role_id') || 
               response.containsKey('dutyRoleId') || 
               response.containsKey('id')) {
      return response;
    }
    return null;
  }

  /// Parses the API response and converts it to DutyRoleModel
  DutyRoleModel? parseUpdateResponse(
    Map<String, dynamic> response,
    DutyRoleModel? originalRole,
  ) {
    try {
      final responseData = extractResponseData(response);
      
      if (responseData != null) {
        final dutyRoleDto = DutyRoleDto.fromJson(responseData);
        final updatedRole = dutyRoleDto.toModel();
        return updatedRole;
      }
    } catch (e) {
      // Error parsing response, will return null and use fallback
    }
    
    return null;
  }

  /// Creates a fallback DutyRoleModel from form data
  DutyRoleModel createFallbackModel({
    required String id,
    required String name,
    required String code,
    required String description,
    required String module,
    required String status,
    required List<String> privilegeNames,
    required int usersAssigned,
    required int jobRolesCount,
  }) {
    return DutyRoleModel(
      id: id,
      name: name,
      code: code,
      description: description,
      module: module,
      status: status,
      usersAssigned: usersAssigned,
      jobRolesCount: jobRolesCount,
      privileges: privilegeNames,
      lastModified: DateTime.now().toIso8601String(),
    );
  }

  /// Creates a new duty role
  Future<void> createDutyRole({
    required String dutyRoleName,
    required String roleCode,
    String? description,
    required int moduleId,
    required List<int> functionPrivileges,
    required List<int> inheritedFromRoles,
    required String status,
    required String createdBy,
  }) async {
    final createRequest = CreateDutyRoleRequestDto(
      dutyRoleName: dutyRoleName,
      roleCode: roleCode,
      description: description,
      moduleId: moduleId,
      functionPrivileges: functionPrivileges,
      inheritedFromRoles: inheritedFromRoles,
      status: status.toUpperCase(),
      createdBy: createdBy,
    );

    await dataSource.createDutyRole(createRequest);
  }

  /// Updates an existing duty role
  Future<Map<String, dynamic>> updateDutyRole({
    required int dutyRoleId,
    required String dutyRoleName,
    required String roleCode,
    String? description,
    required int moduleId,
    required List<int> functionPrivileges,
    required List<int> inheritedFromRoles,
    required String status,
    required String updatedBy,
  }) async {
    final updateRequest = UpdateDutyRoleRequestDto(
      dutyRoleName: dutyRoleName,
      roleCode: roleCode,
      description: description,
      moduleId: moduleId,
      functionPrivileges: functionPrivileges,
      inheritedFromRoles: inheritedFromRoles,
      status: status.toUpperCase(),
      updatedBy: updatedBy,
    );

    return await dataSource.updateDutyRole(dutyRoleId, updateRequest);
  }

  /// Prepares form data by trimming strings and handling empty values
  Map<String, dynamic> prepareFormData({
    required String name,
    required String code,
    required String description,
    required int moduleId,
    required List<FunctionPrivilegeDto> selectedPrivileges,
    required List<DutyRoleReference> selectedInheritedDutyRoles,
    required String status,
  }) {
    return {
      'name': name.trim(),
      'code': code.trim(),
      'description': description.trim().isEmpty ? null : description.trim(),
      'moduleId': moduleId,
      'selectedPrivileges': selectedPrivileges,
      'selectedInheritedDutyRoles': selectedInheritedDutyRoles,
      'status': status,
    };
  }

  /// Handles the complete update flow: API call, parsing, and fallback
  Future<DutyRoleModel> handleUpdate({
    required int dutyRoleId,
    required String dutyRoleName,
    required String roleCode,
    required String description,
    required int moduleId,
    required List<FunctionPrivilegeDto> selectedPrivileges,
    required List<DutyRoleReference> selectedInheritedDutyRoles,
    required String status,
    required String updatedBy,
    required DutyRoleModel originalRole,
    String? moduleName,
  }) async {
    final formData = prepareFormData(
      name: dutyRoleName,
      code: roleCode,
      description: description,
      moduleId: moduleId,
      selectedPrivileges: selectedPrivileges,
      selectedInheritedDutyRoles: selectedInheritedDutyRoles,
      status: status,
    );
    final privilegeIds = extractPrivilegeIds(formData['selectedPrivileges'] as List<FunctionPrivilegeDto>);
    final inheritedDutyRoleIds = extractDutyRoleIds(formData['selectedInheritedDutyRoles'] as List<DutyRoleReference>);
    
    final response = await updateDutyRole(
      dutyRoleId: dutyRoleId,
      dutyRoleName: formData['name'] as String,
      roleCode: formData['code'] as String,
      description: formData['description'] as String?,
      moduleId: formData['moduleId'] as int,
      functionPrivileges: privilegeIds,
      inheritedFromRoles: inheritedDutyRoleIds,
      status: formData['status'] as String,
      updatedBy: updatedBy,
    );

    // Try to parse the API response
    final updatedRole = parseUpdateResponse(response, originalRole);

    // Fallback to constructing from form data if API response parsing failed
    if (updatedRole != null) {
      return updatedRole;
    }

    final privilegeNames = (formData['selectedPrivileges'] as List<FunctionPrivilegeDto>).map((p) => p.name).toList();
    final finalModuleName = moduleName ?? originalRole.module;

    return createFallbackModel(
      id: originalRole.id,
      name: formData['name'] as String,
      code: formData['code'] as String,
      description: (formData['description'] as String?) ?? '',
      module: finalModuleName,
      status: formData['status'] as String,
      privilegeNames: privilegeNames,
      usersAssigned: originalRole.usersAssigned,
      jobRolesCount: originalRole.jobRolesCount,
    );
  }

  /// Handles the complete create flow
  Future<void> handleCreate({
    required String dutyRoleName,
    required String roleCode,
    required String description,
    required int moduleId,
    required List<FunctionPrivilegeDto> selectedPrivileges,
    required List<DutyRoleReference> selectedInheritedDutyRoles,
    required String status,
    required String createdBy,
  }) async {
    final formData = prepareFormData(
      name: dutyRoleName,
      code: roleCode,
      description: description,
      moduleId: moduleId,
      selectedPrivileges: selectedPrivileges,
      selectedInheritedDutyRoles: selectedInheritedDutyRoles,
      status: status,
    );
    
    final privilegeIds = extractPrivilegeIds(formData['selectedPrivileges'] as List<FunctionPrivilegeDto>);
    final inheritedDutyRoleIds = extractDutyRoleIds(formData['selectedInheritedDutyRoles'] as List<DutyRoleReference>);
    
    await createDutyRole(
      dutyRoleName: formData['name'] as String,
      roleCode: formData['code'] as String,
      description: formData['description'] as String?,
      moduleId: formData['moduleId'] as int,
      functionPrivileges: privilegeIds,
      inheritedFromRoles: inheritedDutyRoleIds,
      status: formData['status'] as String,
      createdBy: createdBy,
    );
  }

  /// Parses duty role ID from string to int
  int? parseDutyRoleId(String? id) {
    if (id == null) return null;
    return int.tryParse(id.trim());
  }

  /// Handles save operation (create or update) based on whether dutyRole is provided
  Future<Map<String, dynamic>> handleSave({
    required DutyRoleModel? existingDutyRole,
    required String dutyRoleName,
    required String roleCode,
    required String description,
    required int moduleId,
    required List<FunctionPrivilegeDto> selectedPrivileges,
    required List<DutyRoleReference> selectedInheritedDutyRoles,
    required String status,
    String? moduleName,
  }) async {
    final dutyRoleId = existingDutyRole != null 
        ? parseDutyRoleId(existingDutyRole.id) 
        : null;

    if (existingDutyRole != null && dutyRoleId != null) {
      // Update existing duty role
      final updatedRole = await handleUpdate(
        dutyRoleId: dutyRoleId,
        dutyRoleName: dutyRoleName,
        roleCode: roleCode,
        description: description,
        moduleId: moduleId,
        selectedPrivileges: selectedPrivileges,
        selectedInheritedDutyRoles: selectedInheritedDutyRoles,
        status: status,
        updatedBy: 'ADMIN',
        originalRole: existingDutyRole,
        moduleName: moduleName,
      );

      return {
        'success': true,
        'message': 'Duty role updated successfully',
        'updatedRole': updatedRole,
      };
    } else {
      // Create new duty role
      await handleCreate(
        dutyRoleName: dutyRoleName,
        roleCode: roleCode,
        description: description,
        moduleId: moduleId,
        selectedPrivileges: selectedPrivileges,
        selectedInheritedDutyRoles: selectedInheritedDutyRoles,
        status: status,
        createdBy: 'ADMIN',
      );

      return {
        'success': true,
        'message': 'Duty role created successfully',
      };
    }
  }
}
