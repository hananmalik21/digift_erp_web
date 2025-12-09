import '../entities/function_privilege_entity.dart';
import '../entities/paginated_result.dart';
import '../repositories/function_privilege_repository.dart';

class GetFunctionPrivilegesUseCase {
  final FunctionPrivilegeRepository repository;

  GetFunctionPrivilegesUseCase(this.repository);

  Future<PaginatedResult<FunctionPrivilegeEntity>> call({
    required int page,
    required int limit,
    String? search,
    int? moduleId,
    int? operationId,
    String? status,
  }) {
    return repository.getFunctionPrivileges(
      page: page,
      limit: limit,
      search: search,
      moduleId: moduleId,
      operationId: operationId,
      status: status,
    );
  }
}
