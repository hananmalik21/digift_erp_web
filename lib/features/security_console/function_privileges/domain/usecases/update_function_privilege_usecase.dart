import '../entities/function_privilege_entity.dart';
import '../repositories/function_privilege_repository.dart';

class UpdateFunctionPrivilegeUseCase {
  final FunctionPrivilegeRepository repository;

  UpdateFunctionPrivilegeUseCase(this.repository);

  Future<FunctionPrivilegeEntity> call(FunctionPrivilegeEntity privilege) async {
    return await repository.updateFunctionPrivilege(privilege);
  }
}
