import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/function_privilege_entity.dart';
import '../../domain/repositories/function_privilege_repository.dart';
import '../../domain/usecases/get_function_privileges_usecase.dart';
import '../../domain/usecases/create_function_privilege_usecase.dart';
import '../../domain/usecases/update_function_privilege_usecase.dart';
import '../../domain/usecases/delete_function_privilege_usecase.dart';
import '../../data/repositories/function_privilege_repository_impl.dart';
import '../../data/datasources/function_privilege_remote_datasource.dart';

// Providers
final functionPrivilegeRemoteDataSourceProvider = Provider<FunctionPrivilegeRemoteDataSource>(
  (ref) => FunctionPrivilegeRemoteDataSourceImpl(),
);

final functionPrivilegeRepositoryProvider = Provider<FunctionPrivilegeRepository>(
  (ref) => FunctionPrivilegeRepositoryImpl(
    ref.watch(functionPrivilegeRemoteDataSourceProvider),
  ),
);

final getFunctionPrivilegesUseCaseProvider = Provider<GetFunctionPrivilegesUseCase>(
  (ref) => GetFunctionPrivilegesUseCase(
    ref.watch(functionPrivilegeRepositoryProvider),
  ),
);

final createFunctionPrivilegeUseCaseProvider = Provider<CreateFunctionPrivilegeUseCase>(
  (ref) => CreateFunctionPrivilegeUseCase(
    ref.watch(functionPrivilegeRepositoryProvider),
  ),
);

final updateFunctionPrivilegeUseCaseProvider = Provider<UpdateFunctionPrivilegeUseCase>(
  (ref) => UpdateFunctionPrivilegeUseCase(
    ref.watch(functionPrivilegeRepositoryProvider),
  ),
);

final deleteFunctionPrivilegeUseCaseProvider = Provider<DeleteFunctionPrivilegeUseCase>(
  (ref) => DeleteFunctionPrivilegeUseCase(
    ref.watch(functionPrivilegeRepositoryProvider),
  ),
);

final functionPrivilegesProvider = StateNotifierProvider<FunctionPrivilegesNotifier, FunctionPrivilegesState>(
  (ref) => FunctionPrivilegesNotifier(
    ref.watch(getFunctionPrivilegesUseCaseProvider),
    ref.watch(createFunctionPrivilegeUseCaseProvider),
    ref.watch(updateFunctionPrivilegeUseCaseProvider),
    ref.watch(deleteFunctionPrivilegeUseCaseProvider),
  ),
);

// State
class FunctionPrivilegesState {
  final List<FunctionPrivilegeEntity> privileges;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? searchQuery;
  final int? selectedModuleId;
  final int? selectedOperationId;
  final String? selectedStatus;
  final int? totalActiveValue;
  final int? totalInactiveValue;

  FunctionPrivilegesState({
    this.privileges = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.itemsPerPage = 10,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.searchQuery,
    this.selectedModuleId,
    this.selectedOperationId,
    this.selectedStatus,
    this.totalActiveValue,
    this.totalInactiveValue,
  });

  FunctionPrivilegesState copyWith({
    List<FunctionPrivilegeEntity>? privileges,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
    String? searchQuery,
    int? selectedModuleId,
    int? selectedOperationId,
    String? selectedStatus,
    int? totalActiveValue,
    int? totalInactiveValue,
    bool clearModuleId = false,
    bool clearOperationId = false,
  }) {
    return FunctionPrivilegesState(
      privileges: privileges ?? this.privileges,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedModuleId: clearModuleId ? null : (selectedModuleId ?? this.selectedModuleId),
      selectedOperationId: clearOperationId ? null : (selectedOperationId ?? this.selectedOperationId),
      selectedStatus: selectedStatus ?? this.selectedStatus,
      totalActiveValue: totalActiveValue ?? this.totalActiveValue,
      totalInactiveValue: totalInactiveValue ?? this.totalInactiveValue,
    );
  }
}

// Notifier
class FunctionPrivilegesNotifier extends StateNotifier<FunctionPrivilegesState> {
  final GetFunctionPrivilegesUseCase getFunctionPrivilegesUseCase;
  final CreateFunctionPrivilegeUseCase createFunctionPrivilegeUseCase;
  final UpdateFunctionPrivilegeUseCase updateFunctionPrivilegeUseCase;
  final DeleteFunctionPrivilegeUseCase deleteFunctionPrivilegeUseCase;

  FunctionPrivilegesNotifier(
    this.getFunctionPrivilegesUseCase,
    this.createFunctionPrivilegeUseCase,
    this.updateFunctionPrivilegeUseCase,
    this.deleteFunctionPrivilegeUseCase,
  ) : super(FunctionPrivilegesState());

  Future<void> loadFunctionPrivileges({
    int? page,
    String? search,
    int? moduleId,
    int? operationId,
    String? status,
  }) async {
    final uiStatus = status == null
        ? 'All Status'
        : status == 'ACTIVE'
            ? 'Active'
            : 'Inactive';
    
    final shouldClearModuleId = moduleId == null;
    final shouldClearOperationId = operationId == null;
    
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: page ?? state.currentPage,
      searchQuery: search ?? state.searchQuery,
      selectedModuleId: shouldClearModuleId ? null : moduleId,
      selectedOperationId: shouldClearOperationId ? null : operationId,
      selectedStatus: uiStatus,
      clearModuleId: shouldClearModuleId,
      clearOperationId: shouldClearOperationId,
    );

    try {
      final result = await getFunctionPrivilegesUseCase(
        page: state.currentPage,
        limit: state.itemsPerPage,
        search: state.searchQuery,
        moduleId: state.selectedModuleId,
        operationId: state.selectedOperationId,
        status: status,
      );

      state = state.copyWith(
        privileges: result.data,
        isLoading: false,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        itemsPerPage: result.itemsPerPage,
        hasNextPage: result.hasNextPage,
        hasPreviousPage: result.hasPreviousPage,
        totalActiveValue: result.totalActiveValue,
        totalInactiveValue: result.totalInactiveValue,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> filterByModule(int? moduleId) async {
    final apiStatus = state.selectedStatus == 'All Status'
        ? null
        : state.selectedStatus == 'Active'
            ? 'ACTIVE'
            : 'INACTIVE';
    await loadFunctionPrivileges(
      moduleId: moduleId,
      page: 1,
      status: apiStatus,
    );
  }

  Future<void> filterByOperation(int? operationId) async {
    final apiStatus = state.selectedStatus == 'All Status'
        ? null
        : state.selectedStatus == 'Active'
            ? 'ACTIVE'
            : 'INACTIVE';
    await loadFunctionPrivileges(
      operationId: operationId,
      page: 1,
      status: apiStatus,
    );
  }

  Future<void> filterByStatus(String status) async {
    final mappedStatus = status == 'All Status' 
        ? null 
        : status == 'Active' 
            ? 'ACTIVE' 
            : 'INACTIVE';
    await loadFunctionPrivileges(
      status: mappedStatus,
      page: 1,
      moduleId: state.selectedModuleId,
      operationId: state.selectedOperationId,
    );
  }

  Future<void> search(String query) async {
    final apiStatus = state.selectedStatus == 'All Status'
        ? null
        : state.selectedStatus == 'Active'
            ? 'ACTIVE'
            : 'INACTIVE';
    
    // Preserve selected filters when searching
    await loadFunctionPrivileges(
      search: query.trim().isEmpty ? null : query.trim(),
      page: 1,
      moduleId: state.selectedModuleId,
      operationId: state.selectedOperationId,
      status: apiStatus,
    );
  }

  Future<void> refresh() async {
    final apiStatus = state.selectedStatus == 'All Status'
        ? null
        : state.selectedStatus == 'Active'
            ? 'ACTIVE'
            : 'INACTIVE';
    
    await loadFunctionPrivileges(
      page: 1,
      search: state.searchQuery,
      moduleId: state.selectedModuleId,
      operationId: state.selectedOperationId,
      status: apiStatus,
    );
  }

  Future<void> nextPage() async {
    if (state.hasNextPage && !state.isLoading) {
      final apiStatus = state.selectedStatus == 'All Status'
          ? null
          : state.selectedStatus == 'Active'
              ? 'ACTIVE'
              : 'INACTIVE';
      await loadFunctionPrivileges(
        page: state.currentPage + 1,
        search: state.searchQuery,
        moduleId: state.selectedModuleId,
        operationId: state.selectedOperationId,
        status: apiStatus,
      );
    }
  }

  Future<void> previousPage() async {
    if (state.hasPreviousPage && !state.isLoading) {
      final apiStatus = state.selectedStatus == 'All Status'
          ? null
          : state.selectedStatus == 'Active'
              ? 'ACTIVE'
              : 'INACTIVE';
      await loadFunctionPrivileges(
        page: state.currentPage - 1,
        search: state.searchQuery,
        moduleId: state.selectedModuleId,
        operationId: state.selectedOperationId,
        status: apiStatus,
      );
    }
  }

  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= state.totalPages && !state.isLoading) {
      final apiStatus = state.selectedStatus == 'All Status'
          ? null
          : state.selectedStatus == 'Active'
              ? 'ACTIVE'
              : 'INACTIVE';
      await loadFunctionPrivileges(
        page: page,
        search: state.searchQuery,
        moduleId: state.selectedModuleId,
        operationId: state.selectedOperationId,
        status: apiStatus,
      );
    }
  }

  Future<FunctionPrivilegeEntity> createFunctionPrivilege({
    required String code,
    required String name,
    required String description,
    required int moduleId,
    required String functionId,
    required int operationId,
    required String status,
    String? createdBy,
  }) async {
    try {
      final privilege = FunctionPrivilegeEntity(
        id: '',
        code: code,
        name: name,
        description: description,
        moduleId: moduleId,
        moduleName: '',
        functionId: functionId,
        functionName: '',
        operationId: operationId,
        operationName: '',
        status: status,
        usedInRoles: 0,
        createdAt: '',
        createdBy: createdBy ?? 'SYSTEM',
        updatedAt: '',
        updatedBy: createdBy ?? 'SYSTEM',
      );

      final createdPrivilege = await createFunctionPrivilegeUseCase(privilege);
      
      await refresh();
      
      return createdPrivilege;
    } catch (e) {
      throw Exception('Failed to create function privilege: ${e.toString()}');
    }
  }

  Future<FunctionPrivilegeEntity> updateFunctionPrivilege({
    required String id,
    required String name,
    required String description,
    required int moduleId,
    required String functionId,
    required int operationId,
    required String status,
    String? updatedBy,
  }) async {
    try {
      final existingPrivilege = state.privileges.firstWhere(
        (p) => p.id == id,
        orElse: () => FunctionPrivilegeEntity(
          id: id,
          code: '',
          name: name,
          description: description,
          moduleId: moduleId,
          moduleName: '',
          functionId: functionId,
          functionName: '',
          operationId: operationId,
          operationName: '',
          status: status,
          usedInRoles: 0,
          createdAt: '',
          createdBy: '',
          updatedAt: '',
          updatedBy: updatedBy ?? 'SYSTEM',
        ),
      );

      final updatedPrivilege = FunctionPrivilegeEntity(
        id: existingPrivilege.id,
        code: existingPrivilege.code,
        name: name,
        description: description,
        moduleId: moduleId,
        moduleName: existingPrivilege.moduleName,
        functionId: functionId,
        functionName: existingPrivilege.functionName,
        operationId: operationId,
        operationName: existingPrivilege.operationName,
        status: status,
        usedInRoles: existingPrivilege.usedInRoles,
        createdAt: existingPrivilege.createdAt,
        createdBy: existingPrivilege.createdBy,
        updatedAt: existingPrivilege.updatedAt,
        updatedBy: updatedBy ?? 'SYSTEM',
      );

      final result = await updateFunctionPrivilegeUseCase(updatedPrivilege);
      
      await refresh();
      
      return result;
    } catch (e) {
      throw Exception('Failed to update function privilege: ${e.toString()}');
    }
  }

  Future<bool> deleteFunctionPrivilege(String id) async {
    try {
      await deleteFunctionPrivilegeUseCase(id);
      
      await refresh();
      
      return true;
    } catch (e) {
      throw Exception('Failed to delete function privilege: ${e.toString()}');
    }
  }
}
