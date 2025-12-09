import '../../domain/entities/function_privilege_entity.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/repositories/function_privilege_repository.dart';
import '../datasources/function_privilege_remote_datasource.dart';

class FunctionPrivilegeRepositoryImpl implements FunctionPrivilegeRepository {
  final FunctionPrivilegeRemoteDataSource remoteDataSource;

  FunctionPrivilegeRepositoryImpl(this.remoteDataSource);

  @override
  Future<PaginatedResult<FunctionPrivilegeEntity>> getFunctionPrivileges({
    required int page,
    required int limit,
    String? search,
    int? moduleId,
    int? operationId,
    String? status,
  }) async {
    try {
      final response = await remoteDataSource.getFunctionPrivileges(
        page: page,
        limit: limit,
        search: search,
        moduleId: moduleId,
        operationId: operationId,
        status: status,
      );

      return PaginatedResult<FunctionPrivilegeEntity>(
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
      throw Exception('Failed to fetch function privileges: ${e.toString()}');
    }
  }

  @override
  Future<FunctionPrivilegeEntity> getFunctionPrivilegeById(String id) async {
    try {
      final dto = await remoteDataSource.getFunctionPrivilegeById(id);
      return dto.toEntity();
    } catch (e) {
      throw Exception('Failed to fetch function privilege: ${e.toString()}');
    }
  }

  @override
  Future<FunctionPrivilegeEntity> createFunctionPrivilege(FunctionPrivilegeEntity privilege) async {
    try {
      final status = privilege.status.toUpperCase() == 'ACTIVE' 
          ? 'ACTIVE' 
          : 'INACTIVE';
      
      final dto = await remoteDataSource.createFunctionPrivilege(
        privilegeCode: privilege.code,
        privilegeName: privilege.name,
        description: privilege.description,
        moduleId: privilege.moduleId,
        functionId: privilege.functionId,
        operationId: privilege.operationId,
        status: status,
        createdBy: privilege.createdBy.isNotEmpty 
            ? privilege.createdBy 
            : 'SYSTEM',
      );

      return dto.toEntity();
    } catch (e) {
      throw Exception('Failed to create function privilege: ${e.toString()}');
    }
  }

  @override
  Future<FunctionPrivilegeEntity> updateFunctionPrivilege(FunctionPrivilegeEntity privilege) async {
    try {
      final status = privilege.status.toUpperCase() == 'ACTIVE' 
          ? 'ACTIVE' 
          : 'INACTIVE';
      
      final dto = await remoteDataSource.updateFunctionPrivilege(
        id: privilege.id,
        privilegeName: privilege.name,
        description: privilege.description,
        moduleId: privilege.moduleId,
        functionId: privilege.functionId,
        operationId: privilege.operationId,
        status: status,
        updatedBy: privilege.updatedBy.isNotEmpty 
            ? privilege.updatedBy 
            : 'SYSTEM',
      );

      return dto.toEntity();
    } catch (e) {
      throw Exception('Failed to update function privilege: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFunctionPrivilege(String id) async {
    try {
      await remoteDataSource.deleteFunctionPrivilege(id);
    } catch (e) {
      throw Exception('Failed to delete function privilege: ${e.toString()}');
    }
  }
}
