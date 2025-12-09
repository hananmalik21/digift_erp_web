import '../../domain/entities/function_privilege_entity.dart';

class FunctionPrivilegeModel {
  final String id;
  final String code;
  final String name;
  final String description;

  // 🔹 NEW: numeric IDs from backend
  final int moduleId;
  final int functionId;
  final int operationId;

  // 🔹 Existing display names
  final String module;
  final String function;
  final String operation;

  final int usedInRoles;
  final String status; // Active, Inactive
  final String createdAt;
  final String createdBy;
  final String updatedDate;
  final String updatedBy;

  FunctionPrivilegeModel({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.moduleId,
    required this.functionId,
    required this.operationId,
    required this.module,
    required this.function,
    required this.operation,
    required this.usedInRoles,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    required this.updatedDate,
    required this.updatedBy,
  });

  factory FunctionPrivilegeModel.fromEntity(FunctionPrivilegeEntity entity) {
    return FunctionPrivilegeModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      description: entity.description,

      // 🔹 IDs coming from backend/entity
      moduleId: entity.moduleId,
      functionId: int.parse(entity.functionId),
      operationId: entity.operationId,

      // 🔹 Names with fallbacks
      module: entity.moduleName.isNotEmpty
          ? entity.moduleName
          : 'Module ${entity.moduleId}',
      function: entity.functionName.isNotEmpty
          ? entity.functionName
          : 'Function ${entity.functionId}',
      operation: entity.operationName.isNotEmpty
          ? entity.operationName
          : 'Operation ${entity.operationId}',

      usedInRoles: entity.usedInRoles,
      status: entity.status,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
      updatedDate: entity.updatedAt,
      updatedBy: entity.updatedBy,
    );
  }

  // Sample data from Figma (IDs are just placeholders)
  static List<FunctionPrivilegeModel> getSamplePrivileges() {
    return [
      FunctionPrivilegeModel(
        id: '1',
        code: 'GL_JE_CREATE',
        name: 'Create Journal Entry',
        description: 'Permission to create journal entries in General Ledger',
        moduleId: 1,
        functionId: 1,
        operationId: 1,
        module: 'General Ledger',
        function: 'Journal Entry',
        operation: 'Create',
        usedInRoles: 12,
        status: 'Active',
        createdAt: '1/15/2024',
        createdBy: 'System Admin',
        updatedDate: '11/20/2024',
        updatedBy: 'John Smith',
      ),
      FunctionPrivilegeModel(
        id: '2',
        code: 'GL_JE_POST',
        name: 'Post Journal Entry',
        description: 'Permission to post journal entries to the ledger',
        moduleId: 1,
        functionId: 1,
        operationId: 2,
        module: 'General Ledger',
        function: 'Journal Entry',
        operation: 'Post',
        usedInRoles: 8,
        status: 'Active',
        createdAt: '1/10/2024',
        createdBy: 'System Admin',
        updatedDate: '10/15/2024',
        updatedBy: 'System Admin',
      ),
      // …you can keep adding the rest similarly or leave them if you don’t use sample data
    ];
  }
}
