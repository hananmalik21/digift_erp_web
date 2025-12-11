import 'package:flutter/foundation.dart';
import '../../data/models/duty_role_model.dart';
import '../../data/models/duty_role_dto.dart';
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
        autoSelectExistingPrivileges(notifier, dutyRole, privileges);
      }
    } catch (e) {
      notifier.setPrivilegesError(e.toString());
    }
  }

  /// Matches and auto-selects existing privileges based on privilege names
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
      if (kDebugMode) {
        print('Update response: $response');
      }

      final responseData = extractResponseData(response);
      
      if (responseData != null) {
        if (kDebugMode) {
          print('Parsing response data: $responseData');
        }
        
        final dutyRoleDto = DutyRoleDto.fromJson(responseData);
        
        if (kDebugMode) {
          print('Parsed DTO - ID: ${dutyRoleDto.id}, Name: ${dutyRoleDto.dutyRoleName}');
        }
        
        final updatedRole = dutyRoleDto.toModel();
        
        if (kDebugMode) {
          print('Converted to Model - ID: ${updatedRole.id}, Name: ${updatedRole.name}');
          if (originalRole != null) {
            print('Original role ID: ${originalRole.id}');
          }
        }
        
        return updatedRole;
      } else {
        if (kDebugMode) {
          print('No response data found in response');
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error parsing update response: $e');
        print('Stack trace: $stackTrace');
      }
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
    required String status,
    required String createdBy,
  }) async {
    final createRequest = CreateDutyRoleRequestDto(
      dutyRoleName: dutyRoleName,
      roleCode: roleCode,
      description: description,
      moduleId: moduleId,
      functionPrivileges: functionPrivileges,
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
    required String status,
    required String updatedBy,
  }) async {
    final updateRequest = UpdateDutyRoleRequestDto(
      dutyRoleName: dutyRoleName,
      roleCode: roleCode,
      description: description,
      moduleId: moduleId,
      functionPrivileges: functionPrivileges,
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
    required String status,
  }) {
    return {
      'name': name.trim(),
      'code': code.trim(),
      'description': description.trim().isEmpty ? null : description.trim(),
      'moduleId': moduleId,
      'selectedPrivileges': selectedPrivileges,
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
      status: status,
    );
    final privilegeIds = extractPrivilegeIds(formData['selectedPrivileges'] as List<FunctionPrivilegeDto>);
    
    final response = await updateDutyRole(
      dutyRoleId: dutyRoleId,
      dutyRoleName: formData['name'] as String,
      roleCode: formData['code'] as String,
      description: formData['description'] as String?,
      moduleId: formData['moduleId'] as int,
      functionPrivileges: privilegeIds,
      status: formData['status'] as String,
      updatedBy: updatedBy,
    );

    // Try to parse the API response
    final updatedRole = parseUpdateResponse(response, originalRole);

    // Fallback to constructing from form data if API response parsing failed
    if (updatedRole != null) {
      if (kDebugMode) {
        print('Returning updated role with ID: ${updatedRole.id}');
      }
      return updatedRole;
    }

    if (kDebugMode) {
      print('Using fallback: constructing from form data');
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
    required String status,
    required String createdBy,
  }) async {
    final formData = prepareFormData(
      name: dutyRoleName,
      code: roleCode,
      description: description,
      moduleId: moduleId,
      selectedPrivileges: selectedPrivileges,
      status: status,
    );
    
    final privilegeIds = extractPrivilegeIds(formData['selectedPrivileges'] as List<FunctionPrivilegeDto>);
    
    await createDutyRole(
      dutyRoleName: formData['name'] as String,
      roleCode: formData['code'] as String,
      description: formData['description'] as String?,
      moduleId: formData['moduleId'] as int,
      functionPrivileges: privilegeIds,
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
