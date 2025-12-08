import '../entities/function_entity.dart';
import '../repositories/function_repository.dart';

class CreateFunctionUseCase {
  final FunctionRepository repository;

  CreateFunctionUseCase(this.repository);

  Future<FunctionEntity> call(FunctionEntity function) async {
    return await repository.createFunction(function);
  }
}

