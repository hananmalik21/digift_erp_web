import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/user_role_assignment_remote_datasource.dart';
import '../../data/models/user_role_model.dart';
import '../../../user_accounts/data/models/user_account_model.dart';

// State
class UserRoleAssignmentState {
  final List<UserRoleModel> users;
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

  UserRoleAssignmentState({
    this.users = const [],
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
  });

  UserRoleAssignmentState copyWith({
    List<UserRoleModel>? users,
    bool? isLoading,
    bool? isRefreshing,
    bool? isPaginationLoading,
    String? error,
    bool clearError = false,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
    String? searchQuery,
  }) {
    return UserRoleAssignmentState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      error: clearError ? null : (error ?? this.error),
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// Notifier
class UserRoleAssignmentNotifier
    extends StateNotifier<UserRoleAssignmentState> {
  final UserRoleAssignmentRemoteDataSource dataSource;

  UserRoleAssignmentNotifier(this.dataSource)
      : super(UserRoleAssignmentState(isLoading: true)) {
    loadUsers();
  }

  Future<void> loadUsers({
    int? page,
    String? search,
    bool isRefresh = false,
    bool isPagination = false,
  }) async {
    if (state.isPaginationLoading && isPagination) return;
    if (state.isRefreshing && isRefresh) return;

    final isSearchChange = search != null && search != state.searchQuery;
    if (state.isLoading &&
        !isRefresh &&
        !isPagination &&
        !isSearchChange &&
        state.users.isNotEmpty) {
      return;
    }

    state = state.copyWith(
      isLoading: !isRefresh && !isPagination,
      isRefreshing: isRefresh,
      isPaginationLoading: isPagination,
      error: null,
      clearError: true,
      currentPage: page ?? state.currentPage,
      searchQuery: search ?? state.searchQuery,
    );

    try {
      final result = await dataSource.getUsers(
        page: state.currentPage,
        limit: state.itemsPerPage,
        search: state.searchQuery,
      );

      // Convert UserAccountDto to UserRoleModel
      final userRoleModels = result.data.map((dto) {
        final model = dto.toModel();
        return _mapToUserRoleModel(model);
      }).toList();

      // If paginating, append to existing list; otherwise replace
      final updatedUsers = isPagination
          ? [...state.users, ...userRoleModels]
          : userRoleModels;

      state = state.copyWith(
        users: updatedUsers,
        isLoading: false,
        isRefreshing: false,
        isPaginationLoading: false,
        currentPage: result.meta.currentPage,
        totalPages: result.meta.totalPages,
        totalItems: result.meta.totalItems,
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

  /// Maps UserAccountModel to UserRoleModel
  UserRoleModel _mapToUserRoleModel(UserAccountModel account) {
    // Extract job role names from jobRoles list
    final assignedRoles = account.jobRoles.map((jobRole) => jobRole.name).toList();
    
    // If no job roles, use the roles field as fallback
    final roles = assignedRoles.isEmpty ? account.roles : assignedRoles;

    return UserRoleModel(
      id: account.id,
      name: account.displayName ?? account.name,
      username: account.username,
      department: account.department.isNotEmpty ? account.department : 'Not specified',
      email: account.email,
      assignedRoles: roles,
      avatarUrl: '',
      isCurrentUser: false, // TODO: Determine current user from auth state
    );
  }

  Future<void> search(String query) async {
    await loadUsers(
      search: query.trim(),
      page: 1,
    );
  }

  Future<void> refresh() async {
    await loadUsers(
      page: 1,
      isRefresh: true,
    );
  }

  Future<void> nextPage() async {
    if (state.hasNextPage && !state.isPaginationLoading) {
      await loadUsers(
        page: state.currentPage + 1,
        isPagination: true,
      );
    }
  }

  Future<void> previousPage() async {
    if (state.hasPreviousPage && !state.isPaginationLoading) {
      await loadUsers(
        page: state.currentPage - 1,
        isPagination: true,
      );
    }
  }

  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= state.totalPages && !state.isPaginationLoading) {
      await loadUsers(
        page: page,
        isPagination: true,
      );
    }
  }
}

// Provider
final userRoleAssignmentProvider =
    StateNotifierProvider.autoDispose<UserRoleAssignmentNotifier,
        UserRoleAssignmentState>((ref) {
  final dataSource = UserRoleAssignmentRemoteDataSourceImpl();
  return UserRoleAssignmentNotifier(dataSource);
});


