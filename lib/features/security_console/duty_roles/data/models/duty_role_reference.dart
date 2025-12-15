class DutyRoleReference {
  final int dutyRoleId;
  final String dutyRoleName;
  final String roleCode;
  final String status;

  DutyRoleReference({
    required this.dutyRoleId,
    required this.dutyRoleName,
    required this.roleCode,
    required this.status,
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
      status: json['status']?.toString() ?? 'ACTIVE',
    );
  }
}
