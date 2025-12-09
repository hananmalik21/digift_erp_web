import '../entities/function_privilege_entity.dart';
import '../entities/paginated_result.dart';

abstract class FunctionPrivilegeRepository {
  Future<PaginatedResult<FunctionPrivilegeEntity>> getFunctionPrivileges({
    required int page,
    required int limit,
    String? search,
    int? moduleId,
    int? operationId,
    String? status,
  });

  Future<FunctionPrivilegeEntity> getFunctionPrivilegeById(String id);
  Future<FunctionPrivilegeEntity> createFunctionPrivilege(FunctionPrivilegeEntity privilege);
  Future<FunctionPrivilegeEntity> updateFunctionPrivilege(FunctionPrivilegeEntity privilege);
  Future<void> deleteFunctionPrivilege(String id);
}
