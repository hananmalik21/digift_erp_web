import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedModuleState {
  final String selectedModule;

  SelectedModuleState({this.selectedModule = 'All'});

  SelectedModuleState copyWith({String? selectedModule}) {
    return SelectedModuleState(
      selectedModule: selectedModule ?? this.selectedModule,
    );
  }
}

class SelectedModuleNotifier extends StateNotifier<SelectedModuleState> {
  SelectedModuleNotifier() : super(SelectedModuleState());

  void selectModule(String module) {
    state = state.copyWith(selectedModule: module);
  }
}

final selectedModuleProvider = StateNotifierProvider.autoDispose<SelectedModuleNotifier, SelectedModuleState>(
  (ref) => SelectedModuleNotifier(),
);
