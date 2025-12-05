import 'package:flutter_riverpod/flutter_riverpod.dart';

class SidebarState {
  final Set<String> expandedItems;
  final String? selectedItemId;
  final bool isCollapsed;

  SidebarState({
    this.expandedItems = const {},
    this.selectedItemId,
    this.isCollapsed = false,
  });

  SidebarState copyWith({
    Set<String>? expandedItems,
    String? selectedItemId,
    bool? isCollapsed,
  }) {
    return SidebarState(
      expandedItems: expandedItems ?? this.expandedItems,
      selectedItemId: selectedItemId ?? this.selectedItemId,
      isCollapsed: isCollapsed ?? this.isCollapsed,
    );
  }
}

class SidebarNotifier extends StateNotifier<SidebarState> {
  SidebarNotifier() : super(SidebarState());

  void toggleExpanded(String itemId) {
    final expandedItems = Set<String>.from(state.expandedItems);
    if (expandedItems.contains(itemId)) {
      expandedItems.remove(itemId);
    } else {
      expandedItems.add(itemId);
    }
    state = state.copyWith(expandedItems: expandedItems);
  }

  void selectItem(String itemId) {
    state = state.copyWith(selectedItemId: itemId);
  }

  void toggleCollapsed() {
    state = state.copyWith(isCollapsed: !state.isCollapsed);
  }
}

final sidebarProvider =
    StateNotifierProvider<SidebarNotifier, SidebarState>((ref) {
  return SidebarNotifier();
});

