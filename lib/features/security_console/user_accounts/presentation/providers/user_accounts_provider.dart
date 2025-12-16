import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_account_model.dart';
import '../../data/datasources/user_account_remote_datasource.dart';

// State
class UserAccountsState {
  final List<UserAccountModel> users;
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
  final String? accountStatus;
  final String? accountType;
  final int? activeCount;
  final int? inactiveCount;

  UserAccountsState({
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
    this.accountStatus,
    this.accountType,
    this.activeCount,
    this.inactiveCount,
  });

  UserAccountsState copyWith({
    List<UserAccountModel>? users,
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
    String? accountStatus,
    bool clearAccountStatus = false,
    String? accountType,
    bool clearAccountType = false,
    int? activeCount,
    int? inactiveCount,
  }) {
    return UserAccountsState(
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
      accountStatus: clearAccountStatus ? null : (accountStatus ?? this.accountStatus),
      accountType: clearAccountType ? null : (accountType ?? this.accountType),
      activeCount: activeCount ?? this.activeCount,
      inactiveCount: inactiveCount ?? this.inactiveCount,
    );
  }
}

// Notifier
class UserAccountsNotifier extends StateNotifier<UserAccountsState> {
  final UserAccountRemoteDataSource dataSource;

  UserAccountsNotifier(this.dataSource) : super(UserAccountsState(isLoading: true)) {
    loadUsers();
  }

  Future<void> loadUsers({
    int? page,
    String? search,
    String? accountStatus,
    String? accountType,
    String? username,
    bool isRefresh = false,
    bool isPagination = false,
  }) async {
    if (state.isPaginationLoading && isPagination) return;
    if (state.isRefreshing && isRefresh) return;
    
    final isSearchChange = search != null && search != state.searchQuery;
    if (state.isLoading && !isRefresh && !isPagination && !isSearchChange && state.users.isNotEmpty) return;

    // Determine if we should preserve existing filters or use new ones
    // If accountStatus/accountType is explicitly passed (even if null), use it
    // Otherwise, preserve existing state values
    final shouldPreserveFilters = accountStatus == null && accountType == null && 
                                   (search != null || page != null || isRefresh || isPagination);
    
    state = state.copyWith(
      isLoading: !isRefresh && !isPagination,
      isRefreshing: isRefresh,
      isPaginationLoading: isPagination,
      error: null,
      clearError: true,
      currentPage: page ?? state.currentPage,
      searchQuery: search ?? state.searchQuery,
      accountStatus: shouldPreserveFilters ? state.accountStatus : accountStatus,
      clearAccountStatus: shouldPreserveFilters ? false : (accountStatus == null),
      accountType: shouldPreserveFilters ? state.accountType : accountType,
      clearAccountType: shouldPreserveFilters ? false : (accountType == null),
    );

    try {
      // Use the final values after state update
      final result = await dataSource.getUsers(
        page: state.currentPage,
        limit: state.itemsPerPage,
        search: state.searchQuery,
        accountStatus: state.accountStatus,
        accountType: state.accountType,
        username: username,
      );

      state = state.copyWith(
        users: result.data.map((dto) => dto.toModel()).toList(),
        isLoading: false,
        isRefreshing: false,
        isPaginationLoading: false,
        totalPages: result.meta.totalPages,
        totalItems: result.meta.totalItems,
        itemsPerPage: result.meta.itemsPerPage,
        hasNextPage: result.meta.hasNextPage,
        hasPreviousPage: result.meta.hasPreviousPage,
        activeCount: result.activity?.totalActiveValue,
        inactiveCount: result.activity?.totalInactiveValue,
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

  Future<void> search(String query) async {
    await loadUsers(
      search: query.trim(),
      page: 1,
      accountStatus: state.accountStatus,
      accountType: state.accountType,
    );
  }

  Future<void> filterByStatus(String? status) async {
    await loadUsers(
      accountStatus: status,
      accountType: state.accountType, // Preserve existing accountType filter
      page: 1,
    );
  }

  Future<void> filterByType(String? type) async {
    await loadUsers(
      accountStatus: state.accountStatus, // Preserve existing accountStatus filter
      accountType: type,
      page: 1,
    );
  }

  Future<void> refresh() async {
    await loadUsers(
      page: 1,
      isRefresh: true,
      accountStatus: state.accountStatus,
      accountType: state.accountType,
    );
  }

  Future<void> nextPage() async {
    if (state.hasNextPage && !state.isPaginationLoading) {
      await loadUsers(
        page: state.currentPage + 1,
        isPagination: true,
        accountStatus: state.accountStatus,
        accountType: state.accountType,
      );
    }
  }

  Future<void> previousPage() async {
    if (state.hasPreviousPage && !state.isPaginationLoading) {
      await loadUsers(
        page: state.currentPage - 1,
        isPagination: true,
        accountStatus: state.accountStatus,
        accountType: state.accountType,
      );
    }
  }

  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= state.totalPages && !state.isPaginationLoading) {
      await loadUsers(
        page: page,
        isPagination: true,
        accountStatus: state.accountStatus,
        accountType: state.accountType,
      );
    }
  }

  void deleteUserLocally(String userId) {
    final updatedUsers = state.users.where((user) => user.id != userId).toList();
    state = state.copyWith(
      users: updatedUsers,
      totalItems: state.totalItems > 0 ? state.totalItems - 1 : 0,
    );
  }
}
