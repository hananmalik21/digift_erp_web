class DutyRoleModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final String module;
  final String status;
  final int usersAssigned;
  final int jobRolesCount;
  final List<String> privileges;
  final List<String> inheritedFromRoles;
  final String lastModified;

  DutyRoleModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.module,
    required this.status,
    required this.usersAssigned,
    required this.jobRolesCount,
    required this.privileges,
    this.inheritedFromRoles = const [],
    required this.lastModified,
  });

}



