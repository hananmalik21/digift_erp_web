class UpdateJobRoleRequestDto {
  final String jobRoleCode;
  final String jobRoleName;
  final String? description;
  final String? department;
  final String status;
  final String isSystemRole;
  final List<int> dutyRolesArray;
  final String updatedBy;

  UpdateJobRoleRequestDto({
    required this.jobRoleCode,
    required this.jobRoleName,
    this.description,
    this.department,
    required this.status,
    required this.isSystemRole,
    required this.dutyRolesArray,
    required this.updatedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobRoleCode': jobRoleCode,
      'jobRoleName': jobRoleName,
      if (description != null && description!.isNotEmpty) 'description': description,
      if (department != null && department!.isNotEmpty) 'department': department,
      'status': status,
      'isSystemRole': isSystemRole,
      'dutyRolesArray': dutyRolesArray,
      'updatedBy': updatedBy,
    };
  }
}
