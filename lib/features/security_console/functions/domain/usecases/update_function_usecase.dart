import '../entities/function_entity.dart';
import '../repositories/function_repository.dart';

class UpdateFunctionUseCase {
  final FunctionRepository repository;

  UpdateFunctionUseCase(this.repository);

  Future<FunctionEntity> call(FunctionEntity function) async {
    return await repository.updateFunction(function);
  }
}

