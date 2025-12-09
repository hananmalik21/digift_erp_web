import '../../domain/entities/function_entity.dart';

class FunctionDto {
  final String id;
  final String code;
  final String name;
  final String description;
  final String module;
  final String moduleName;
  final String category;
  final String accessType;
  final String status;
  final String updatedDate;
  final String updatedBy;

  FunctionDto({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.module,
    required this.moduleName,
    required this.category,
    required this.accessType,
    required this.status,
    required this.updatedDate,
    required this.updatedBy,
  });

  factory FunctionDto.fromJson(Map<String, dynamic> json) {
    // Map API response fields to DTO fields
    // API uses: function_id, function_code, function_name, module_id, status, created_at, updated_at, etc.
    final functionId = json['function_id']?.toString() ?? 
                       json['id']?.toString() ?? 
                       json['_id']?.toString() ?? '';
    
    final functionCode = json['function_code']?.toString() ?? 
                         json['code']?.toString() ?? 
                         json['functionCode']?.toString() ?? '';
    
    final functionName = json['function_name']?.toString() ?? 
                        json['name']?.toString() ?? 
                        json['functionName']?.toString() ?? '';
    
    final description = json['description']?.toString() ?? '';
    
    // Module ID - we'll use the ID for now, or you can map it to module name later
    final moduleId = json['module_id']?.toString() ?? '';
    final moduleName = json['module_name']?.toString() ?? 
                       json['module']?.toString() ?? 
                       '';
    final module = moduleName.isNotEmpty 
        ? moduleName 
        : (moduleId.isNotEmpty ? 'Module $moduleId' : '');
    
    // Category and accessType might not be in API response, use defaults
    final category = json['category']?.toString() ?? 
                    json['category_name']?.toString() ?? 
                    '';
    
    final accessType = json['access_type']?.toString() ?? 
                       json['accessType']?.toString() ?? 
                       json['type']?.toString() ?? 
                       'View'; // Default value
    
    // Status: API returns "ACTIVE" but we need "Active" for display
    final statusValue = json['status']?.toString() ?? '';
    final status = statusValue.toUpperCase() == 'ACTIVE' ? 'Active' : 
                   statusValue.toUpperCase() == 'INACTIVE' ? 'Inactive' : 
                   statusValue.isNotEmpty ? statusValue : 'Inactive';
    
    // Use updated_at if available, otherwise use created_at
    final updatedDate = json['updated_at']?.toString() ?? 
                       json['updated_date']?.toString() ?? 
                       json['updatedDate']?.toString() ?? 
                       json['created_at']?.toString() ?? 
                       json['created_date']?.toString() ?? 
                       '';
    
    final updatedBy = json['updated_by']?.toString() ?? 
                     json['updatedBy']?.toString() ?? 
                     json['created_by']?.toString() ?? 
                     json['createdBy']?.toString() ?? 
                     '';
    
    return FunctionDto(
      id: functionId,
      code: functionCode,
      name: functionName,
      description: description,
      module: module,
      moduleName: moduleName,
      category: category,
      accessType: accessType,
      status: status,
      updatedDate: updatedDate,
      updatedBy: updatedBy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'module': module,
      'module_name': moduleName,
      'category': category,
      'accessType': accessType,
      'status': status,
      'updatedDate': updatedDate,
      'updatedBy': updatedBy,
    };
  }

  FunctionEntity toEntity() {
    return FunctionEntity(
      id: id,
      code: code,
      name: name,
      description: description,
      module: moduleName.isNotEmpty ? moduleName : module,
      category: category,
      accessType: accessType,
      status: status,
      updatedDate: updatedDate,
      updatedBy: updatedBy,
    );
  }
}

