class FunctionPrivilegeEntity {
  final String id;
  final String code;
  final String name;
  final String description;
  final int moduleId;
  final String moduleName;
  final String functionId;
  final String functionName;
  final int operationId;
  final String operationName;
  final String status;
  final int usedInRoles;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;

  FunctionPrivilegeEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.moduleId,
    required this.moduleName,
    required this.functionId,
    required this.functionName,
    required this.operationId,
    required this.operationName,
    required this.status,
    required this.usedInRoles,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });
}
