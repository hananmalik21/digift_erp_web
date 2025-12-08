import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/function_entity.dart';
import '../../domain/repositories/function_repository.dart';
import '../../domain/usecases/get_functions_usecase.dart';
import '../../domain/usecases/create_function_usecase.dart';
import '../../domain/usecases/update_function_usecase.dart';
import '../../domain/usecases/delete_function_usecase.dart';
import '../../data/repositories/function_repository_impl.dart';
import '../../data/datasources/function_remote_datasource.dart';

// Providers
final functionRemoteDataSourceProvider = Provider<FunctionRemoteDataSource>(
  (ref) => FunctionRemoteDataSourceImpl(),
);

final functionRepositoryProvider = Provider<FunctionRepository>(
  (ref) => FunctionRepositoryImpl(
    ref.watch(functionRemoteDataSourceProvider),
  ),
);

final getFunctionsUseCaseProvider = Provider<GetFunctionsUseCase>(
  (ref) => GetFunctionsUseCase(
    ref.watch(functionRepositoryProvider),
  ),
);

final createFunctionUseCaseProvider = Provider<CreateFunctionUseCase>(
  (ref) => CreateFunctionUseCase(
    ref.watch(functionRepositoryProvider),
  ),
);

final updateFunctionUseCaseProvider = Provider<UpdateFunctionUseCase>(
  (ref) => UpdateFunctionUseCase(
    ref.watch(functionRepositoryProvider),
  ),
);

final deleteFunctionUseCaseProvider = Provider<DeleteFunctionUseCase>(
  (ref) => DeleteFunctionUseCase(
    ref.watch(functionRepositoryProvider),
  ),
);

final functionsProvider = StateNotifierProvider<FunctionsNotifier, FunctionsState>(
  (ref) => FunctionsNotifier(
    ref.watch(getFunctionsUseCaseProvider),
    ref.watch(createFunctionUseCaseProvider),
    ref.watch(updateFunctionUseCaseProvider),
    ref.watch(deleteFunctionUseCaseProvider),
  ),
);

// State
class FunctionsState {
  final List<FunctionEntity> functions;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? searchQuery;
  final String? selectedModule;
  final String? selectedStatus;
  final List<String> selectedFilterKeys;

  FunctionsState({
    this.functions = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.itemsPerPage = 10,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.searchQuery,
    this.selectedModule,
    this.selectedStatus,
    this.selectedFilterKeys = const [],
  });

  FunctionsState copyWith({
    List<FunctionEntity>? functions,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
    String? searchQuery,
    String? selectedModule,
    String? selectedStatus,
    List<String>? selectedFilterKeys,
  }) {
    return FunctionsState(
      functions: functions ?? this.functions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedModule: selectedModule ?? this.selectedModule,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedFilterKeys: selectedFilterKeys ?? this.selectedFilterKeys,
    );
  }
}

// Notifier
class FunctionsNotifier extends StateNotifier<FunctionsState> {
  final GetFunctionsUseCase getFunctionsUseCase;
  final CreateFunctionUseCase createFunctionUseCase;
  final UpdateFunctionUseCase updateFunctionUseCase;
  final DeleteFunctionUseCase deleteFunctionUseCase;

  FunctionsNotifier(
    this.getFunctionsUseCase,
    this.createFunctionUseCase,
    this.updateFunctionUseCase,
    this.deleteFunctionUseCase,
  ) : super(FunctionsState());

  Future<void> loadFunctions({
    int? page,
    String? search,
    String? module,
    String? status, // This is the API status: null, "ACTIVE", or "INACTIVE"
    List<String>? selectedFilterKeys,
  }) async {
    // Store UI status for display (convert API status to UI status)
    final uiStatus = status == null
        ? 'All Status'
        : status == 'ACTIVE'
            ? 'Active'
            : 'Inactive';
    
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: page ?? state.currentPage,
      searchQuery: search ?? state.searchQuery,
      selectedModule: module ?? state.selectedModule,
      selectedStatus: uiStatus,
      selectedFilterKeys: selectedFilterKeys ?? state.selectedFilterKeys,
    );

    // Build dynamic filters map if a filter key is selected
    Map<String, String>? dynamicFilters;
    if (state.selectedFilterKeys.isNotEmpty && state.searchQuery != null && state.searchQuery!.isNotEmpty) {
      // Use the selected filter key (only one allowed) as the parameter name
      final filterKey = state.selectedFilterKeys.first;
      dynamicFilters = {filterKey: state.searchQuery!};
      
      // If status is selected, always include it in dynamic filters
      if (status != null && status.isNotEmpty) {
        dynamicFilters['status'] = status;
      }
    }

    try {
      final result = await getFunctionsUseCase(
        page: state.currentPage,
        limit: state.itemsPerPage,
        search: dynamicFilters == null ? state.searchQuery : null, // Only use search if no dynamic filters
        module: state.selectedModule,
        // Pass status separately if not already in dynamicFilters, or if no dynamicFilters exist
        status: (dynamicFilters != null && dynamicFilters.containsKey('status')) ? null : status,
        dynamicFilters: dynamicFilters,
      );

      state = state.copyWith(
        functions: result.data,
        isLoading: false,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        itemsPerPage: result.itemsPerPage,
        hasNextPage: result.hasNextPage,
        hasPreviousPage: result.hasPreviousPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      // Log error for debugging - removed to avoid production issues
    }
  }

  Future<void> nextPage() async {
    if (state.hasNextPage && !state.isLoading) {
      // Map UI status to API status
      final apiStatus = state.selectedStatus == 'All Status'
          ? null
          : state.selectedStatus == 'Active'
              ? 'ACTIVE'
              : 'INACTIVE';
      await loadFunctions(
        page: state.currentPage + 1,
        status: apiStatus,
      );
    }
  }

  Future<void> previousPage() async {
    if (state.hasPreviousPage && !state.isLoading) {
      // Map UI status to API status
      final apiStatus = state.selectedStatus == 'All Status'
          ? null
          : state.selectedStatus == 'Active'
              ? 'ACTIVE'
              : 'INACTIVE';
      await loadFunctions(
        page: state.currentPage - 1,
        status: apiStatus,
      );
    }
  }

  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= state.totalPages && !state.isLoading) {
      // Map UI status to API status
      final apiStatus = state.selectedStatus == 'All Status'
          ? null
          : state.selectedStatus == 'Active'
              ? 'ACTIVE'
              : 'INACTIVE';
      await loadFunctions(
        page: page,
        status: apiStatus,
      );
    }
  }

  Future<void> search(String query, {List<String>? selectedFilterKeys}) async {
    // Map UI status to API status
    final apiStatus = state.selectedStatus == 'All Status'
        ? null
        : state.selectedStatus == 'Active'
            ? 'ACTIVE'
            : 'INACTIVE';
    await loadFunctions(
      search: query,
      page: 1,
      selectedFilterKeys: selectedFilterKeys ?? state.selectedFilterKeys,
      status: apiStatus,
    );
  }

  Future<void> filterByModule(String module) async {
    // Map UI status to API status
    final apiStatus = state.selectedStatus == 'All Status'
        ? null
        : state.selectedStatus == 'Active'
            ? 'ACTIVE'
            : 'INACTIVE';
    await loadFunctions(
      module: module,
      page: 1,
      status: apiStatus,
    );
  }

  Future<void> filterByStatus(String status) async {
    // Map status: "All Status" -> null, "Active" -> "ACTIVE", "Inactive" -> "INACTIVE"
    final mappedStatus = status == 'All Status' 
        ? null 
        : status == 'Active' 
            ? 'ACTIVE' 
            : 'INACTIVE';
    await loadFunctions(status: mappedStatus, page: 1);
  }

  Future<void> refresh() async {
    // Reset to page 1 and reload data from API
    // Map UI status to API status
    final apiStatus = state.selectedStatus == 'All Status'
        ? null
        : state.selectedStatus == 'Active'
            ? 'ACTIVE'
            : 'INACTIVE';
    
    await loadFunctions(
      page: 1,
      search: state.searchQuery,
      module: state.selectedModule,
      status: apiStatus,
      selectedFilterKeys: state.selectedFilterKeys,
    );
  }

  Future<FunctionEntity> createFunction({
    required String code,
    required String name,
    required String description,
    required String module,
    required String status,
    String? createdBy,
  }) async {
    try {
      final function = FunctionEntity(
        id: '', // Will be set by API
        code: code,
        name: name,
        description: description,
        module: module,
        category: '', // Not required for creation
        accessType: '', // Not required for creation
        status: status,
        updatedDate: '', // Will be set by API
        updatedBy: createdBy ?? 'SYSTEM',
      );

      final createdFunction = await createFunctionUseCase(function);
      
      // Refresh the list to show the new function
      await refresh();
      
      return createdFunction;
    } catch (e) {
      throw Exception('Failed to create function: ${e.toString()}');
    }
  }

  Future<FunctionEntity> updateFunction({
    required String id,
    required String name,
    required String description,
    required String status,
    String? updatedBy,
  }) async {
    try {
      // Get the existing function to preserve other fields
      final existingFunction = state.functions.firstWhere(
        (f) => f.id == id,
        orElse: () => FunctionEntity(
          id: id,
          code: '',
          name: name,
          description: description,
          module: '',
          category: '',
          accessType: '',
          status: status,
          updatedDate: '',
          updatedBy: updatedBy ?? 'SYSTEM',
        ),
      );

      final updatedFunction = FunctionEntity(
        id: existingFunction.id,
        code: existingFunction.code,
        name: name,
        description: description,
        module: existingFunction.module,
        category: existingFunction.category,
        accessType: existingFunction.accessType,
        status: status,
        updatedDate: existingFunction.updatedDate,
        updatedBy: updatedBy ?? 'SYSTEM',
      );

      final result = await updateFunctionUseCase(updatedFunction);
      
      // Refresh the list to show the updated function
      await refresh();
      
      return result;
    } catch (e) {
      throw Exception('Failed to update function: ${e.toString()}');
    }
  }

  Future<bool> deleteFunction(String id) async {
    try {
      await deleteFunctionUseCase.call(id);
      
      // Refresh the list to remove the deleted function
      await refresh();
      
      return true;
    } catch (e) {
      throw Exception('Failed to delete function: ${e.toString()}');
    }
  }
}


