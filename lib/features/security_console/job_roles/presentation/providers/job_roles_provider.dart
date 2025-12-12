import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/job_role_model.dart';
import '../../data/datasources/job_role_remote_datasource.dart';

// Providers
final jobRoleRemoteDataSourceProvider = Provider<JobRoleRemoteDataSource>(
  (ref) => JobRoleRemoteDataSourceImpl(),
);

// State
class JobRolesState {
  final List<JobRoleModel> jobRoles;
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
  final String? selectedDepartment;
  final String? selectedStatus;

  JobRolesState({
    this.jobRoles = const [],
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
    this.selectedDepartment,
    this.selectedStatus,
  });

  JobRolesState copyWith({
    List<JobRoleModel>? jobRoles,
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
    String? selectedDepartment,
    String? selectedStatus,
    bool clearDepartment = false,
    bool clearStatus = false,
  }) {
    return JobRolesState(
      jobRoles: jobRoles ?? this.jobRoles,
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
      selectedDepartment: clearDepartment ? null : (selectedDepartment ?? this.selectedDepartment),
      selectedStatus: clearStatus ? null : (selectedStatus ?? this.selectedStatus),
    );
  }
}

// Notifier
class JobRolesNotifier extends StateNotifier<JobRolesState> {
  final JobRoleRemoteDataSource dataSource;

  JobRolesNotifier(this.dataSource) : super(JobRolesState(isLoading: true)) {
    loadJobRoles();
  }

  Future<void> loadJobRoles({
    int? page,
    String? search,
    String? department,
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
    if (state.isLoading && !isRefresh && !isPagination && !isSearchChange && state.jobRoles.isNotEmpty) return;

    state = state.copyWith(
      isLoading: !isRefresh && !isPagination,
      isRefreshing: isRefresh,
      isPaginationLoading: isPagination,
      error: null,
      currentPage: page ?? state.currentPage,
      searchQuery: search ?? state.searchQuery,
      selectedDepartment: department ?? state.selectedDepartment,
      selectedStatus: status ?? state.selectedStatus,
      clearDepartment: department == null,
      clearStatus: status == null,
    );

    try {
      final result = await dataSource.getJobRoles(
        page: state.currentPage,
        limit: state.itemsPerPage,
        search: state.searchQuery,
        department: state.selectedDepartment,
        status: state.selectedStatus,
      );

      state = state.copyWith(
        jobRoles: result.data.map((dto) => dto.toModel()).toList(),
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

  Future<void> filterByDepartment(String? department) async {
    state = state.copyWith(
      selectedDepartment: department,
    );
    await loadJobRoles(
      department: department,
      page: 1,
    );
  }

  Future<void> search(String query) async {
    await loadJobRoles(
      search: query.trim(),
      page: 1,
    );
  }

  Future<void> refresh() async {
    await loadJobRoles(
      page: 1,
      isRefresh: true,
    );
  }

  Future<void> nextPage() async {
    if (state.hasNextPage && !state.isPaginationLoading) {
      await loadJobRoles(
        page: state.currentPage + 1,
        isPagination: true,
      );
    }
  }

  Future<void> previousPage() async {
    if (state.hasPreviousPage && !state.isPaginationLoading) {
      await loadJobRoles(
        page: state.currentPage - 1,
        isPagination: true,
      );
    }
  }

  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= state.totalPages && !state.isPaginationLoading && !state.isRefreshing && !state.isLoading) {
      await loadJobRoles(
        page: page,
        isPagination: true,
      );
    }
  }

  void updateJobRoleLocally(JobRoleModel updatedRole) {
    if (kDebugMode) {
      print('updateJobRoleLocally called with role ID: ${updatedRole.id}, Name: ${updatedRole.name}');
      print('Current job roles count: ${state.jobRoles.length}');
    }
    
    // Normalize IDs for comparison (trim whitespace, convert to string)
    final normalizedUpdatedId = updatedRole.id.trim();
    
    final updatedList = state.jobRoles.map((role) {
      final normalizedRoleId = role.id.trim();
      // Compare normalized IDs
      if (normalizedRoleId == normalizedUpdatedId) {
        if (kDebugMode) {
          print('Found matching role with ID: ${role.id} (${role.name}), updating to: ${updatedRole.name}');
        }
        return updatedRole;
      }
      return role;
    }).toList();

    // Check if any role was actually updated
    final wasUpdated = updatedList.any((r) => r.id.trim() == normalizedUpdatedId && r.name == updatedRole.name);
    
    if (!wasUpdated) {
      if (kDebugMode) {
        print('ERROR: Could not find role to update. Adding to list instead.');
      }
      // If role not found, try to add it (shouldn't happen, but fallback)
      updatedList.add(updatedRole);
    }

    state = state.copyWith(
      jobRoles: updatedList,
    );
    
    if (kDebugMode) {
      print('State updated. New job roles count: ${state.jobRoles.length}');
    }
  }

  void addJobRoleLocally(JobRoleModel newRole) {
    if (kDebugMode) {
      print('addJobRoleLocally called with role ID: ${newRole.id}, Name: ${newRole.name}');
      print('Current job roles count: ${state.jobRoles.length}');
    }
    
    // Check if role already exists (shouldn't happen for new roles, but safety check)
    final exists = state.jobRoles.any((r) => r.id.trim() == newRole.id.trim());
    
    if (exists) {
      if (kDebugMode) {
        print('Role already exists, updating instead');
      }
      updateJobRoleLocally(newRole);
      return;
    }
    
    // Add to the beginning of the list
    final updatedList = [newRole, ...state.jobRoles];
    
    // Update total items count
    final newTotalItems = state.totalItems + 1;
    final newTotalPages = (newTotalItems / state.itemsPerPage).ceil();
    
    state = state.copyWith(
      jobRoles: updatedList,
      totalItems: newTotalItems,
      totalPages: newTotalPages > 0 ? newTotalPages : 1,
      hasNextPage: state.currentPage < newTotalPages,
    );
    
    if (kDebugMode) {
      print('State updated. New job roles count: ${state.jobRoles.length}');
    }
  }

  void deleteJobRoleLocally(String roleId) {
    final updatedList = state.jobRoles.where((role) => role.id != roleId).toList();
    
    // Update total items count
    final newTotalItems = state.totalItems > 0 ? state.totalItems - 1 : 0;
    
    // Recalculate pagination
    final newTotalPages = (newTotalItems / state.itemsPerPage).ceil();
    final newCurrentPage = state.currentPage > newTotalPages && newTotalPages > 0 
        ? newTotalPages 
        : state.currentPage;

    state = state.copyWith(
      jobRoles: updatedList,
      totalItems: newTotalItems,
      totalPages: newTotalPages > 0 ? newTotalPages : 1,
      currentPage: newCurrentPage,
      hasNextPage: newCurrentPage < newTotalPages,
      hasPreviousPage: newCurrentPage > 1,
    );
  }
}
