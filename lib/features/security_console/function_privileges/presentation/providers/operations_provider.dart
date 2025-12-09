import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/operation_remote_datasource.dart';
import '../../data/models/operation_dto.dart';

// Provider for operation datasource
final operationRemoteDataSourceProvider = Provider<OperationRemoteDataSource>(
  (ref) => OperationRemoteDataSourceImpl(),
);

// State for operations
class OperationsState {
  final List<OperationDto> operations;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final int itemsPerPage;

  OperationsState({
    this.operations = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = false,
    this.itemsPerPage = 10,
  });

  OperationsState copyWith({
    List<OperationDto>? operations,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
    int? itemsPerPage,
  }) {
    return OperationsState(
      operations: operations ?? this.operations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }
}

// Provider for operations state
final operationsProvider = StateNotifierProvider<OperationsNotifier, OperationsState>(
  (ref) => OperationsNotifier(
    ref.watch(operationRemoteDataSourceProvider),
  ),
);

// Notifier for operations
class OperationsNotifier extends StateNotifier<OperationsState> {
  final OperationRemoteDataSource operationRemoteDataSource;

  OperationsNotifier(this.operationRemoteDataSource) : super(OperationsState());

  Future<void> loadOperations({bool append = false}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final allOperations = await operationRemoteDataSource.getOperations();
      
      if (append) {
        // Load more: get next page of items
        final startIndex = state.operations.length;
        final endIndex = startIndex + state.itemsPerPage;
        final nextPageOperations = endIndex <= allOperations.length
            ? allOperations.sublist(startIndex, endIndex)
            : allOperations.sublist(startIndex);
        
        state = state.copyWith(
          operations: [...state.operations, ...nextPageOperations],
          isLoading: false,
          hasMore: endIndex < allOperations.length,
          currentPage: state.currentPage + 1,
        );
      } else {
        // Initial load: get first page
        final firstPageOperations = allOperations.length > state.itemsPerPage
            ? allOperations.sublist(0, state.itemsPerPage)
            : allOperations;
        
        state = state.copyWith(
          operations: firstPageOperations,
          isLoading: false,
          hasMore: allOperations.length > state.itemsPerPage,
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

  Future<void> loadMoreOperations() async {
    if (state.hasMore && !state.isLoading) {
      await loadOperations(append: true);
    }
  }

  Future<void> refresh() async {
    await loadOperations();
  }
}
