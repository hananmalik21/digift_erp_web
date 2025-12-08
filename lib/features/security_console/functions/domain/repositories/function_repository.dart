import '../entities/function_entity.dart';
import '../entities/paginated_result.dart';

abstract class FunctionRepository {
  Future<PaginatedResult<FunctionEntity>> getFunctions({
    required int page,
    required int limit,
    String? search,
    String? module,
    String? status,
    Map<String, String>? dynamicFilters,
  });

  Future<FunctionEntity> getFunctionById(String id);
  Future<FunctionEntity> createFunction(FunctionEntity function);
  Future<FunctionEntity> updateFunction(FunctionEntity function);
  Future<void> deleteFunction(String id);
}

