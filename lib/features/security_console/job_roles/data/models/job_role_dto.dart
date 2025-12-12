import 'job_role_model.dart';

class DutyRoleReference {
  final int dutyRoleId;
  final String dutyRoleName;
  final String roleCode;

  DutyRoleReference({
    required this.dutyRoleId,
    required this.dutyRoleName,
    required this.roleCode,
  });

  factory DutyRoleReference.fromJson(Map<String, dynamic> json) {
    return DutyRoleReference(
      dutyRoleId: json['duty_role_id'] as int? ?? 
                 json['dutyRoleId'] as int? ?? 
                 json['id'] as int? ?? 
                 0,
      dutyRoleName: json['duty_role_name']?.toString() ?? 
                   json['dutyRoleName']?.toString() ?? 
                   json['name']?.toString() ?? 
                   '',
      roleCode: json['role_code']?.toString() ?? 
               json['roleCode']?.toString() ?? 
               json['code']?.toString() ?? 
               '',
    );
  }
}

class JobRoleDto {
  final int jobRoleId;
  final String jobRoleCode;
  final String jobRoleName;
  final String? description;
  final String? department;
  final String status;
  final String? isSystemRole;
  final String? createdBy;
  final String? createdAt;
  final String? updatedBy;
  final String? updatedAt;
  final List<DutyRoleReference> dutyRoles;

  JobRoleDto({
    required this.jobRoleId,
    required this.jobRoleCode,
    required this.jobRoleName,
    this.description,
    this.department,
    required this.status,
    this.isSystemRole,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.dutyRoles = const [],
  });

  factory JobRoleDto.fromJson(Map<String, dynamic> json) {
    // Parse duty_roles array
    List<DutyRoleReference> parsedDutyRoles = [];
    
    if (json['duty_roles'] != null && json['duty_roles'] is List) {
      final dutyRolesList = json['duty_roles'] as List;
      parsedDutyRoles = dutyRolesList
          .map((e) {
            if (e is Map<String, dynamic>) {
              return DutyRoleReference.fromJson(e);
            }
            return null;
          })
          .where((dto) => dto != null)
          .cast<DutyRoleReference>()
          .toList();
    }

    return JobRoleDto(
      jobRoleId: json['job_role_id'] as int? ?? 
                json['jobRoleId'] as int? ?? 
                json['id'] as int? ?? 
                0,
      jobRoleCode: json['job_role_code']?.toString() ?? 
                  json['jobRoleCode']?.toString() ?? 
                  json['code']?.toString() ?? 
                  '',
      jobRoleName: json['job_role_name']?.toString() ?? 
                  json['jobRoleName']?.toString() ?? 
                  json['name']?.toString() ?? 
                  '',
      description: json['description']?.toString(),
      department: json['department']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE',
      isSystemRole: json['is_system_role']?.toString() ?? 
                   json['isSystemRole']?.toString(),
      createdBy: json['created_by']?.toString() ?? 
                json['createdBy']?.toString(),
      createdAt: json['created_at']?.toString() ?? 
                json['createdAt']?.toString(),
      updatedBy: json['updated_by']?.toString() ?? 
                json['updatedBy']?.toString(),
      updatedAt: json['updated_at']?.toString() ?? 
                json['updatedAt']?.toString(),
      dutyRoles: parsedDutyRoles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_role_id': jobRoleId,
      'job_role_code': jobRoleCode,
      'job_role_name': jobRoleName,
      if (description != null) 'description': description,
      if (department != null) 'department': department,
      'status': status,
      if (isSystemRole != null) 'is_system_role': isSystemRole,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dutyRoles.isNotEmpty)
        'duty_roles': dutyRoles.map((dr) => {
          'duty_role_id': dr.dutyRoleId,
          'duty_role_name': dr.dutyRoleName,
          'role_code': dr.roleCode,
        }).toList(),
    };
  }

  // Convert to JobRoleModel for UI
  JobRoleModel toModel() {
    // Format status for display (ACTIVE -> Active, INACTIVE -> Inactive)
    final displayStatus = status.toUpperCase() == 'ACTIVE' 
        ? 'Active' 
        : status.toUpperCase() == 'INACTIVE' 
            ? 'Inactive' 
            : status;
    
    // Extract duty role names from DutyRoleReference list
    final dutyRoleNames = dutyRoles
        .map((dr) => dr.dutyRoleName)
        .where((name) => name.isNotEmpty)
        .toList();
    
    return JobRoleModel(
      id: jobRoleId.toString(),
      name: jobRoleName,
      code: jobRoleCode,
      description: description ?? '',
      department: department ?? 'Unknown',
      status: displayStatus,
      usersAssigned: 0, // Not provided in API response, defaulting to 0
      privilegesCount: 0, // Not provided in API response, defaulting to 0
      dutyRoles: dutyRoleNames,
      inheritsFrom: null, // Not provided in API response
      lastModified: updatedAt ?? createdAt ?? '',
    );
  }
}
