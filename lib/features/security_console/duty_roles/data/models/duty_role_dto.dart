import 'duty_role_model.dart';
import '../../../function_privileges/data/models/function_privilege_dto.dart';

class DutyRoleDto {
  final String id;
  final String dutyRoleName;
  final String roleCode;
  final String? description;
  final int moduleId;
  final String? moduleName;
  final String status;
  final int? usersAssigned;
  final int? jobRolesCount;
  final List<FunctionPrivilegeDto> functionPrivileges;
  final String? lastModified;
  final String? createdAt;
  final String? createdBy;
  final String? updatedAt;
  final String? updatedBy;
  final List<Map<String, dynamic>> inheritedFromRoles;

  DutyRoleDto({
    required this.id,
    required this.dutyRoleName,
    required this.roleCode,
    this.description,
    required this.moduleId,
    this.moduleName,
    required this.status,
    this.usersAssigned,
    this.jobRolesCount,
    this.functionPrivileges = const [],
    this.lastModified,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.inheritedFromRoles = const [],
  });

  factory DutyRoleDto.fromJson(Map<String, dynamic> json) {
    // Parse function_privileges array into FunctionPrivilegeDto objects
    List<FunctionPrivilegeDto> parsedPrivileges = [];
    
    if (json['function_privileges'] != null && json['function_privileges'] is List) {
      final privilegesList = json['function_privileges'] as List;
      parsedPrivileges = privilegesList
          .map((e) {
            if (e is Map<String, dynamic>) {
              return FunctionPrivilegeDto.fromJson(e);
            }
            return null;
          })
          .where((dto) => dto != null)
          .cast<FunctionPrivilegeDto>()
          .toList();
    }

    // Parse inherited_from_roles array
    List<Map<String, dynamic>> parsedInheritedRoles = [];
    if (json['inherited_from_roles'] != null && json['inherited_from_roles'] is List) {
      final inheritedRolesList = json['inherited_from_roles'] as List;
      parsedInheritedRoles = inheritedRolesList
          .where((e) => e is Map<String, dynamic>)
          .cast<Map<String, dynamic>>()
          .toList();
    }

    return DutyRoleDto(
      id: json['duty_role_id']?.toString() ?? 
          json['id']?.toString() ?? 
          json['_id']?.toString() ?? 
          json['dutyRoleId']?.toString() ?? 
          '',
      dutyRoleName: json['duty_role_name']?.toString() ?? 
                   json['dutyRoleName']?.toString() ?? 
                   json['name']?.toString() ?? 
                   '',
      roleCode: json['role_code']?.toString() ?? 
               json['roleCode']?.toString() ?? 
               json['code']?.toString() ?? 
               '',
      description: json['description']?.toString(),
      moduleId: json['module_id'] as int? ?? 
                json['moduleId'] as int? ?? 
                0,
      moduleName: json['module_name']?.toString() ?? 
                 json['moduleName']?.toString() ?? 
                 json['module']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE',
      usersAssigned: json['usersAssigned'] as int? ?? 
                    json['users_assigned'] as int? ?? 
                    json['userCount'] as int?,
      jobRolesCount: json['jobRolesCount'] as int? ?? 
                    json['job_roles_count'] as int? ?? 
                    json['jobRoleCount'] as int?,
      functionPrivileges: parsedPrivileges,
      lastModified: json['updated_at']?.toString() ?? 
                   json['updatedAt']?.toString() ?? 
                   json['lastModified']?.toString() ?? 
                   json['last_modified']?.toString(),
      createdAt: json['created_at']?.toString() ?? 
                json['createdAt']?.toString(),
      createdBy: json['created_by']?.toString() ?? 
                json['createdBy']?.toString(),
      updatedAt: json['updated_at']?.toString() ?? 
                json['updatedAt']?.toString(),
      updatedBy: json['updated_by']?.toString() ?? 
                json['updatedBy']?.toString(),
      inheritedFromRoles: parsedInheritedRoles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dutyRoleName': dutyRoleName,
      'roleCode': roleCode,
      if (description != null) 'description': description,
      'moduleId': moduleId,
      if (moduleName != null) 'moduleName': moduleName,
      'status': status,
      if (usersAssigned != null) 'usersAssigned': usersAssigned,
      if (jobRolesCount != null) 'jobRolesCount': jobRolesCount,
      if (functionPrivileges.isNotEmpty)
        'function_privileges': functionPrivileges.map((p) => p.toJson()).toList(),
      if (lastModified != null) 'lastModified': lastModified,
      if (createdAt != null) 'createdAt': createdAt,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (updatedBy != null) 'updatedBy': updatedBy,
    };
  }

  // Convert to DutyRoleModel for UI
  DutyRoleModel toModel() {
    // Format status for display (ACTIVE -> Active, INACTIVE -> Inactive)
    final displayStatus = status.toUpperCase() == 'ACTIVE' 
        ? 'Active' 
        : status.toUpperCase() == 'INACTIVE' 
            ? 'Inactive' 
            : status;
    
    // Extract privilege names from FunctionPrivilegeDto list
    final privilegeNames = functionPrivileges
        .map((p) => p.name)
        .where((name) => name.isNotEmpty)
        .toList();
    
    // Extract inherited role names from inherited_from_roles list
    final inheritedRoleNames = inheritedFromRoles
        .map((role) => role['duty_role_name']?.toString() ?? 
                      role['dutyRoleName']?.toString() ?? 
                      role['name']?.toString() ?? 
                      '')
        .where((name) => name.isNotEmpty)
        .toList();
    
    return DutyRoleModel(
      id: id,
      name: dutyRoleName,
      code: roleCode,
      description: description ?? '',
      module: moduleName ?? 'Unknown',
      status: displayStatus,
      usersAssigned: usersAssigned ?? 0,
      jobRolesCount: jobRolesCount ?? 0,
      privileges: privilegeNames,
      inheritedFromRoles: inheritedRoleNames,
      lastModified: lastModified ?? updatedAt ?? createdAt ?? '',
    );
  }
}
