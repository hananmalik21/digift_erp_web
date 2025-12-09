import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/module_remote_datasource.dart';
import '../../data/models/module_dto.dart';

// Provider for module datasource
final moduleRemoteDataSourceProvider = Provider<ModuleRemoteDataSource>(
  (ref) => ModuleRemoteDataSourceImpl(),
);

// State for modules
class ModulesState {
  final List<ModuleDto> modules;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final int itemsPerPage;

  ModulesState({
    this.modules = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = false,
    this.itemsPerPage = 10,
  });

  ModulesState copyWith({
    List<ModuleDto>? modules,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
    int? itemsPerPage,
  }) {
    return ModulesState(
      modules: modules ?? this.modules,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }
}

// Provider for modules state
final modulesProvider = StateNotifierProvider<ModulesNotifier, ModulesState>(
  (ref) => ModulesNotifier(
    ref.watch(moduleRemoteDataSourceProvider),
  ),
);

// Notifier for modules
class ModulesNotifier extends StateNotifier<ModulesState> {
  final ModuleRemoteDataSource moduleRemoteDataSource;

  ModulesNotifier(this.moduleRemoteDataSource) : super(ModulesState());

  Future<void> loadModules({bool append = false}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final allModules = await moduleRemoteDataSource.getModules();
      
      if (append) {
        // Load more: get next page of items
        final startIndex = state.modules.length;
        final endIndex = startIndex + state.itemsPerPage;
        final nextPageModules = endIndex <= allModules.length
            ? allModules.sublist(startIndex, endIndex)
            : allModules.sublist(startIndex);
        
        state = state.copyWith(
          modules: [...state.modules, ...nextPageModules],
          isLoading: false,
          hasMore: endIndex < allModules.length,
          currentPage: state.currentPage + 1,
        );
      } else {
        // Initial load: get first page
        final firstPageModules = allModules.length > state.itemsPerPage
            ? allModules.sublist(0, state.itemsPerPage)
            : allModules;
        
        state = state.copyWith(
          modules: firstPageModules,
          isLoading: false,
          hasMore: allModules.length > state.itemsPerPage,
          currentPage: 1,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMoreModules() async {
    if (state.hasMore && !state.isLoading) {
      await loadModules(append: true);
    }
  }

  Future<void> refresh() async {
    await loadModules();
  }
}
