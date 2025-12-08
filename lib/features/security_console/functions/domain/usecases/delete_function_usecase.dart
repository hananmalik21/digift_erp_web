import '../repositories/function_repository.dart';

class DeleteFunctionUseCase {
  final FunctionRepository repository;

  DeleteFunctionUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteFunction(id);
  }
}

