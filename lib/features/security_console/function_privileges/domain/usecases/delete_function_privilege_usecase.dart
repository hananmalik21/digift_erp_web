import '../repositories/function_privilege_repository.dart';

class DeleteFunctionPrivilegeUseCase {
  final FunctionPrivilegeRepository repository;

  DeleteFunctionPrivilegeUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteFunctionPrivilege(id);
  }
}
