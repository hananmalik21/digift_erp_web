import '../../domain/entities/function_entity.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/repositories/function_repository.dart';
import '../datasources/function_remote_datasource.dart';
import '../datasources/module_remote_datasource.dart';

class FunctionRepositoryImpl implements FunctionRepository {
  final FunctionRemoteDataSource remoteDataSource;
  final ModuleRemoteDataSource? moduleRemoteDataSource;

  FunctionRepositoryImpl(
    this.remoteDataSource, {
    this.moduleRemoteDataSource,
  });

  @override
  Future<PaginatedResult<FunctionEntity>> getFunctions({
    required int page,
    required int limit,
    String? search,
    String? module,
    int? moduleId,
    String? status,
    Map<String, String>? dynamicFilters,
  }) async {
    try {
      final response = await remoteDataSource.getFunctions(
        page: page,
        limit: limit,
        search: search,
        module: module,
        moduleId: moduleId,
        status: status,
        dynamicFilters: dynamicFilters,
      );

      return PaginatedResult<FunctionEntity>(
        data: response.data.map((dto) => dto.toEntity()).toList(),
        currentPage: response.meta.currentPage,
        totalPages: response.meta.totalPages,
        totalItems: response.meta.totalItems,
        itemsPerPage: response.meta.itemsPerPage,
        hasNextPage: response.meta.hasNextPage,
        hasPreviousPage: response.meta.hasPreviousPage,
        totalActiveValue: response.activity?.totalActiveValue,
        totalInactiveValue: response.activity?.totalInactiveValue,
      );
    } catch (e) {
      throw Exception('Failed to fetch functions: ${e.toString()}');
    }
  }

  @override
  Future<FunctionEntity> getFunctionById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<FunctionEntity> createFunction(FunctionEntity function) async {
    try {
      // Map module name to moduleId from API
      final moduleId = await _getModuleId(function.module);
      
      // Map status to uppercase
      final status = function.status.toUpperCase() == 'ACTIVE' 
          ? 'ACTIVE' 
          : 'INACTIVE';
      
      final dto = await remoteDataSource.createFunction(
        moduleId: moduleId,
        functionCode: function.code,
        functionName: function.name,
        description: function.description,
        status: status,
        createdBy: function.updatedBy.isNotEmpty 
            ? function.updatedBy 
            : 'SYSTEM',
      );

      return dto.toEntity();
    } catch (e) {
      throw Exception('Failed to create function: ${e.toString()}');
    }
  }

  // Helper method to map module name to ID
  Future<int> _getModuleId(String moduleName) async {
    // Try to fetch from API first
    if (moduleRemoteDataSource != null) {
      try {
        final modules = await moduleRemoteDataSource!.getModules();
        final module = modules.firstWhere(
          (m) => m.name == moduleName,
          orElse: () => modules.isNotEmpty ? modules.first : throw Exception('No modules found'),
        );
        return module.id;
      } catch (e) {
        // Fall back to hardcoded map if API fails
      }
    }
    
    // Fallback to hardcoded mapping
    final moduleMap = {
      'General Ledger': 1,
      'Accounts Payable': 2,
      'Accounts Receivable': 3,
      'Cash Management': 4,
      'Fixed Assets': 5,
      'Expense Management': 6,
      'Security': 7,
      'Financial Reporting': 8,
    };
    
    // Try to extract module number from "Module X" format
    if (moduleName.startsWith('Module ')) {
      final moduleNum = int.tryParse(moduleName.replaceAll('Module ', ''));
      if (moduleNum != null) return moduleNum;
    }
    
    return moduleMap[moduleName] ?? 1; // Default to 1 if not found
  }

  @override
  Future<FunctionEntity> updateFunction(FunctionEntity function) async {
    try {
      // Map status to uppercase
      final status = function.status.toUpperCase() == 'ACTIVE' 
          ? 'ACTIVE' 
          : 'INACTIVE';
      
      // Map module name to moduleId from API if module is provided
      int? moduleId;
      if (function.module.isNotEmpty) {
        moduleId = await _getModuleId(function.module);
      }
      
      final dto = await remoteDataSource.updateFunction(
        id: function.id,
        functionName: function.name,
        description: function.description,
        status: status,
        updatedBy: function.updatedBy.isNotEmpty 
            ? function.updatedBy 
            : 'SYSTEM',
        moduleId: moduleId,
      );

      return dto.toEntity();
    } catch (e) {
      throw Exception('Failed to update function: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFunction(String id) async {
    try {
      await remoteDataSource.deleteFunction(id);
    } catch (e) {
      throw Exception('Failed to delete function: ${e.toString()}');
    }
  }
}

