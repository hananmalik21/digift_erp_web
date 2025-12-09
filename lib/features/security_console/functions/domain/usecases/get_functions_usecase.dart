import '../entities/function_entity.dart';
import '../entities/paginated_result.dart';
import '../repositories/function_repository.dart';

class GetFunctionsUseCase {
  final FunctionRepository repository;

  GetFunctionsUseCase(this.repository);

  Future<PaginatedResult<FunctionEntity>> call({
    required int page,
    required int limit,
    String? search,
    String? module,
    int? moduleId,
    String? status,
    Map<String, String>? dynamicFilters,
  }) {
    return repository.getFunctions(
      page: page,
      limit: limit,
      search: search,
      module: module,
      moduleId: moduleId,
      status: status,
      dynamicFilters: dynamicFilters,
    );
  }
}

