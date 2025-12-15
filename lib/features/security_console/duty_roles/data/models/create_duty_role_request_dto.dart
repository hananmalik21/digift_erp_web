class CreateDutyRoleRequestDto {
  final String dutyRoleName;
  final String roleCode;
  final String? description;
  final int moduleId;
  final List<int> functionPrivileges;
  final List<int> inheritedFromRoles;
  final String status;
  final String createdBy;

  CreateDutyRoleRequestDto({
    required this.dutyRoleName,
    required this.roleCode,
    this.description,
    required this.moduleId,
    required this.functionPrivileges,
    this.inheritedFromRoles = const [],
    required this.status,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'dutyRoleName': dutyRoleName,
      'roleCode': roleCode,
      if (description != null && description!.isNotEmpty) 'description': description,
      'moduleId': moduleId,
      'functionPrivileges': functionPrivileges,
      if (inheritedFromRoles.isNotEmpty) 'inheritedFromRoles': inheritedFromRoles,
      'status': status,
      'createdBy': createdBy,
    };
  }
}
