import '../entities/function_privilege_entity.dart';
import '../repositories/function_privilege_repository.dart';

class CreateFunctionPrivilegeUseCase {
  final FunctionPrivilegeRepository repository;

  CreateFunctionPrivilegeUseCase(this.repository);

  Future<FunctionPrivilegeEntity> call(FunctionPrivilegeEntity privilege) async {
    return await repository.createFunctionPrivilege(privilege);
  }
}
