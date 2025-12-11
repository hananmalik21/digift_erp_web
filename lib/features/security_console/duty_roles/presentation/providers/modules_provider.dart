import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../functions/data/datasources/module_remote_datasource.dart';
import '../../../functions/data/models/module_dto.dart';

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

class ModulesNotifier extends StateNotifier<ModulesState> {
  final ModuleRemoteDataSource dataSource;

  ModulesNotifier(this.dataSource) : super(ModulesState()) {
    loadModules();
  }

  Future<void> loadModules() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final modules = await dataSource.getModules();
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
}

final modulesProvider = StateNotifierProvider.autoDispose<ModulesNotifier, ModulesState>(
  (ref) {
    final dataSource = ModuleRemoteDataSourceImpl();
    return ModulesNotifier(dataSource);
  },
);
