import '../../domain/entities/function_privilege_entity.dart';

class FunctionPrivilegeDto {
  final String id;
  final String code;
  final String name;
  final String description;
  final int moduleId;
  final String? moduleName;
  final String functionId;
  final String? functionName;
  final int operationId;
  final String? operationName;
  final String status;
  final int? usedInRoles;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;

  FunctionPrivilegeDto({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.moduleId,
    this.moduleName,
    required this.functionId,
    this.functionName,
    required this.operationId,
    this.operationName,
    required this.status,
    this.usedInRoles,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory FunctionPrivilegeDto.fromJson(Map<String, dynamic> json) {
    final privilegeId = json['privilege_id']?.toString() ?? 
                        json['id']?.toString() ?? 
                        json['_id']?.toString() ?? '';
    
    final privilegeCode = json['privilege_code']?.toString() ?? 
                         json['code']?.toString() ?? 
                         json['privilegeCode']?.toString() ?? '';
    
    final privilegeName = json['privilege_name']?.toString() ?? 
                         json['name']?.toString() ?? 
                         json['privilegeName']?.toString() ?? '';
    
    final description = json['description']?.toString() ?? '';
    
    final moduleId = json['module_id'] as int? ?? 
                    int.tryParse(json['module_id']?.toString() ?? '') ?? 0;
    
    final moduleName = json['module_name']?.toString() ?? 
                      json['moduleName']?.toString();
    
    final functionId = json['function_id']?.toString() ?? 
                      json['functionId']?.toString() ?? '';
    
    final functionName = json['function_name']?.toString() ?? 
                        json['functionName']?.toString();
    
    final operationId = json['operation_id'] as int? ?? 
                        int.tryParse(json['operation_id']?.toString() ?? '') ?? 0;
    
    final operationName = json['operation_name']?.toString() ?? 
                         json['operationName']?.toString();
    
    final statusValue = json['status']?.toString() ?? '';
    final status = statusValue.toUpperCase() == 'ACTIVE' ? 'Active' : 
                  statusValue.toUpperCase() == 'INACTIVE' ? 'Inactive' : 
                  statusValue.isNotEmpty ? statusValue : 'Inactive';
    
    final usedInRoles = json['used_in_roles'] as int? ?? 
                       json['usedInRoles'] as int? ?? 
                       int.tryParse(json['used_in_roles']?.toString() ?? '0') ?? 0;
    
    final createdAt = json['created_at']?.toString() ?? 
                     json['createdAt']?.toString() ?? '';
    
    final createdBy = json['created_by']?.toString() ?? 
                     json['createdBy']?.toString() ?? '';
    
    final updatedAt = json['updated_at']?.toString() ?? 
                     json['updatedAt']?.toString() ?? 
                     json['created_at']?.toString() ?? '';
    
    final updatedBy = json['updated_by']?.toString() ?? 
                     json['updatedBy']?.toString() ?? 
                     json['created_by']?.toString() ?? '';
    
    return FunctionPrivilegeDto(
      id: privilegeId,
      code: privilegeCode,
      name: privilegeName,
      description: description,
      moduleId: moduleId,
      moduleName: moduleName,
      functionId: functionId,
      functionName: functionName,
      operationId: operationId,
      operationName: operationName,
      status: status,
      usedInRoles: usedInRoles,
      createdAt: createdAt,
      createdBy: createdBy,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'privilege_code': code,
      'privilege_name': name,
      'description': description,
      'module_id': moduleId,
      if (moduleName != null) 'module_name': moduleName,
      'function_id': functionId,
      if (functionName != null) 'function_name': functionName,
      'operation_id': operationId,
      if (operationName != null) 'operation_name': operationName,
      'status': status.toUpperCase(),
      if (usedInRoles != null) 'used_in_roles': usedInRoles,
      'created_at': createdAt,
      'created_by': createdBy,
      'updated_at': updatedAt,
      'updated_by': updatedBy,
    };
  }

  FunctionPrivilegeEntity toEntity() {
    return FunctionPrivilegeEntity(
      id: id,
      code: code,
      name: name,
      description: description,
      moduleId: moduleId,
      moduleName: moduleName ?? '',
      functionId: functionId,
      functionName: functionName ?? '',
      operationId: operationId,
      operationName: operationName ?? '',
      status: status,
      usedInRoles: usedInRoles ?? 0,
      createdAt: createdAt,
      createdBy: createdBy,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
    );
  }
}
