import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/duty_role_model.dart';
import '../../data/datasources/duty_role_remote_datasource.dart';

// Providers
final dutyRoleRemoteDataSourceProvider = Provider<DutyRoleRemoteDataSource>(
  (ref) => DutyRoleRemoteDataSourceImpl(),
);


// State
class DutyRolesState {
  final List<DutyRoleModel> dutyRoles;
  final bool isLoading;
  final bool isRefreshing;
  final bool isPaginationLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? searchQuery;
  final int? selectedModuleId;
  final String? selectedModule;

  DutyRolesState({
    this.dutyRoles = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.isPaginationLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.itemsPerPage = 10,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.searchQuery,
    this.selectedModuleId,
    this.selectedModule,
  });

  DutyRolesState copyWith({
    List<DutyRoleModel>? dutyRoles,
    bool? isLoading,
    bool? isRefreshing,
    bool? isPaginationLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
    String? searchQuery,
    int? selectedModuleId,
    String? selectedModule,
    bool clearModuleId = false,
  }) {
    return DutyRolesState(
      dutyRoles: dutyRoles ?? this.dutyRoles,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedModuleId: clearModuleId ? null : (selectedModuleId ?? this.selectedModuleId),
      selectedModule: selectedModule ?? this.selectedModule,
    );
  }
}

// Notifier
class DutyRolesNotifier extends StateNotifier<DutyRolesState> {
  final DutyRoleRemoteDataSource dataSource;

  DutyRolesNotifier(this.dataSource) : super(DutyRolesState(isLoading: true)) {
    loadDutyRoles();
  }

  Future<void> loadDutyRoles({
    int? page,
    String? search,
    int? moduleId,
    String? status,
    bool isRefresh = false,
    bool isPagination = false,
  }) async {
    if (state.isPaginationLoading && isPagination) return;
    if (state.isRefreshing && isRefresh) return;
    // Allow search to interrupt loading, but not pagination or refresh
    // Check if search query changed - if so, allow interruption
    final isSearchChange = search != null && search != state.searchQuery;
    // Don't block initial load or search changes
    if (state.isLoading && !isRefresh && !isPagination && !isSearchChange && state.dutyRoles.isNotEmpty) return;

    state = state.copyWith(
      isLoading: !isRefresh && !isPagination,
      isRefreshing: isRefresh,
      isPaginationLoading: isPagination,
      error: null,
      currentPage: page ?? state.currentPage,
      searchQuery: search ?? state.searchQuery,
      selectedModuleId: moduleId ?? state.selectedModuleId,
      clearModuleId: moduleId == null,
    );

    try {
      final result = await dataSource.getDutyRoles(
        page: state.currentPage,
        limit: state.itemsPerPage,
        search: state.searchQuery,
        moduleId: state.selectedModuleId,
        status: status,
      );

      state = state.copyWith(
        dutyRoles: result.data.map((dto) => dto.toModel()).toList(),
        isLoading: false,
        isRefreshing: false,
        isPaginationLoading: false,
        currentPage: result.meta.currentPage,
        totalPages: result.meta.totalPages,
        totalItems: result.meta.totalItems,
        itemsPerPage: result.meta.itemsPerPage,
        hasNextPage: result.meta.hasNextPage,
        hasPreviousPage: result.meta.hasPreviousPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isPaginationLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> filterByModule(String? module, int? moduleId) async {
    state = state.copyWith(
      selectedModule: module,
      selectedModuleId: moduleId,
    );
    await loadDutyRoles(
      moduleId: moduleId,
      page: 1,
    );
  }

  Future<void> search(String query) async {
    await loadDutyRoles(
      search: query.trim(),
      page: 1,
    );
  }

  Future<void> refresh() async {
    await loadDutyRoles(
      page: 1,
      isRefresh: true,
    );
  }

  Future<void> nextPage() async {
    if (state.hasNextPage && !state.isPaginationLoading) {
      await loadDutyRoles(
        page: state.currentPage + 1,
        isPagination: true,
      );
    }
  }

  Future<void> previousPage() async {
    if (state.hasPreviousPage && !state.isPaginationLoading) {
      await loadDutyRoles(
        page: state.currentPage - 1,
        isPagination: true,
      );
    }
  }

  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= state.totalPages && !state.isPaginationLoading && !state.isRefreshing && !state.isLoading) {
      await loadDutyRoles(
        page: page,
        isPagination: true,
      );
    }
  }

  void updateDutyRoleLocally(DutyRoleModel updatedRole) {
    // Normalize IDs for comparison (trim whitespace, convert to string)
    final normalizedUpdatedId = updatedRole.id.trim();
    
    final updatedList = state.dutyRoles.map((role) {
      final normalizedRoleId = role.id.trim();
      // Compare normalized IDs
      if (normalizedRoleId == normalizedUpdatedId) {
        return updatedRole;
      }
      return role;
    }).toList();

    // Check if any role was actually updated
    final wasUpdated = updatedList.any((r) => r.id.trim() == normalizedUpdatedId && r.name == updatedRole.name);

    if (!wasUpdated) {
      // If role not found, try to add it (shouldn't happen, but fallback)
      updatedList.add(updatedRole);
    }

    state = state.copyWith(
      dutyRoles: updatedList,
    );
  }

  void deleteDutyRoleLocally(String roleId) {
    final updatedList = state.dutyRoles.where((role) => role.id != roleId).toList();
    
    // Update total items count
    final newTotalItems = state.totalItems > 0 ? state.totalItems - 1 : 0;
    
    // Recalculate pagination
    final newTotalPages = (newTotalItems / state.itemsPerPage).ceil();
    final newCurrentPage = state.currentPage > newTotalPages && newTotalPages > 0 
        ? newTotalPages 
        : state.currentPage;

    state = state.copyWith(
      dutyRoles: updatedList,
      totalItems: newTotalItems,
      totalPages: newTotalPages > 0 ? newTotalPages : 1,
      currentPage: newCurrentPage,
      hasNextPage: newCurrentPage < newTotalPages,
      hasPreviousPage: newCurrentPage > 1,
    );
  }
}
