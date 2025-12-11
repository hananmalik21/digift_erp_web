class UpdateDutyRoleRequestDto {
  final String dutyRoleName;
  final String roleCode;
  final String? description;
  final int moduleId;
  final List<int> functionPrivileges;
  final String status;
  final String updatedBy;

  UpdateDutyRoleRequestDto({
    required this.dutyRoleName,
    required this.roleCode,
    this.description,
    required this.moduleId,
    required this.functionPrivileges,
    required this.status,
    required this.updatedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'dutyRoleName': dutyRoleName,
      'roleCode': roleCode,
      if (description != null && description!.isNotEmpty) 'description': description,
      'moduleId': moduleId,
      'functionPrivileges': functionPrivileges,
      'status': status,
      'updatedBy': updatedBy,
    };
  }
}
