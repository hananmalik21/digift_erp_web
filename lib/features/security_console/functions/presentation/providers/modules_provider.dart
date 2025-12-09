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

  ModulesState({
    this.modules = const [],
    this.isLoading = false,
    this.error,
  });

  ModulesState copyWith({
    List<ModuleDto>? modules,
    bool? isLoading,
    String? error,
  }) {
    return ModulesState(
      modules: modules ?? this.modules,
      isLoading: isLoading ?? this.isLoading,
      error: error,
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

  Future<void> loadModules() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final modules = await moduleRemoteDataSource.getModules();
      state = state.copyWith(
        modules: modules,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadModules();
  }
}
