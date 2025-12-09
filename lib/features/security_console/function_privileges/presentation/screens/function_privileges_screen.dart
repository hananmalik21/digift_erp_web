import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../data/models/function_privilege_model.dart';
import '../../domain/entities/function_privilege_entity.dart';
import '../../domain/usecases/get_function_privileges_usecase.dart';
import '../../domain/usecases/create_function_privilege_usecase.dart';
import '../../domain/usecases/update_function_privilege_usecase.dart';
import '../../domain/usecases/delete_function_privilege_usecase.dart';
import '../../data/repositories/function_privilege_repository_impl.dart';
import '../../data/datasources/function_privilege_remote_datasource.dart';
import '../widgets/function_privileges_header_widget.dart';
import '../widgets/function_privileges_stats_widget.dart';
import '../widgets/function_privileges_search_filters_widget.dart';
import '../widgets/function_privileges_mobile_list_widget.dart';
import '../widgets/function_privileges_data_table_widget.dart';
import '../widgets/function_privileges_footer_widget.dart';
import '../widgets/function_privileges_empty_state_widget.dart';
import '../widgets/create_privilege_dialog.dart';

class FunctionPrivilegesScreen extends StatefulWidget {
  const FunctionPrivilegesScreen({super.key});

  @override
  State<FunctionPrivilegesScreen> createState() =>
      _FunctionPrivilegesScreenState();
}

class _FunctionPrivilegesScreenState extends State<FunctionPrivilegesScreen> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  String _selectedModule = 'All Modules';
  String _selectedOperation = 'All Operations';
  String _selectedStatus = 'All Status';
  Timer? _debounceTimer;

  // Local state
  List<FunctionPrivilegeEntity> _privileges = [];
  bool _isLoading = false; // For initial loading (when list is empty)
  bool _isRefreshing = false; // For refresh button loading
  bool _isPaginationLoading = false; // For pagination loading
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  int _itemsPerPage = 10;
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;
  int? _totalActiveValue;
  int? _totalInactiveValue;
  int? _selectedModuleId;
  int? _selectedOperationId;

  // Local instances - created fresh each time screen is built
  late final FunctionPrivilegeRemoteDataSource _remoteDataSource;
  late final FunctionPrivilegeRepositoryImpl _repository;
  late final GetFunctionPrivilegesUseCase _getUseCase;
  late final CreateFunctionPrivilegeUseCase _createUseCase;
  late final UpdateFunctionPrivilegeUseCase _updateUseCase;
  late final DeleteFunctionPrivilegeUseCase _deleteUseCase;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Create fresh local instances
    _remoteDataSource = FunctionPrivilegeRemoteDataSourceImpl();
    _repository = FunctionPrivilegeRepositoryImpl(_remoteDataSource);
    _getUseCase = GetFunctionPrivilegesUseCase(_repository);
    _createUseCase = CreateFunctionPrivilegeUseCase(_repository);
    _updateUseCase = UpdateFunctionPrivilegeUseCase(_repository);
    _deleteUseCase = DeleteFunctionPrivilegeUseCase(_repository);

    // Load data on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFunctionPrivileges(isRefresh: false);
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reload data when app comes back to foreground
      _loadFunctionPrivileges(isRefresh: false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _search(_searchController.text);
    });
  }

  Future<void> _loadFunctionPrivileges({
    int? page,
    String? search,
    int? moduleId,
    int? operationId,
    String? status,
    bool isRefresh = false,
    bool isPagination = false,
  }) async {
    // Prevent pagination if already paginating
    if (_isPaginationLoading && isPagination) return;
    // Prevent refresh if already refreshing
    if (_isRefreshing && isRefresh) return;
    // Prevent initial loading if already loading
    if (_isLoading && !isRefresh && !isPagination) return;

    setState(() {
      if (isRefresh) {
        _isRefreshing = true;
      } else if (isPagination) {
        _isPaginationLoading = true;
      } else {
        _isLoading = true;
      }
      _error = null;
      _currentPage = page ?? _currentPage;
      _selectedModuleId = moduleId ?? _selectedModuleId;
      _selectedOperationId = operationId ?? _selectedOperationId;
    });

    try {
      final apiStatus = status ??
          (_selectedStatus == 'All Status'
              ? null
              : _selectedStatus == 'Active'
                  ? 'ACTIVE'
                  : 'INACTIVE');

      final searchQuery = search ?? (search == null && _searchController.text.trim().isNotEmpty
          ? _searchController.text.trim()
          : null);

      final result = await _getUseCase(
        page: _currentPage,
        limit: _itemsPerPage,
        search: searchQuery,
        moduleId: moduleId ?? _selectedModuleId,
        operationId: operationId ?? _selectedOperationId,
        status: apiStatus,
      );

      setState(() {
        _privileges = result.data;
        _isLoading = false;
        _isRefreshing = false;
        _isPaginationLoading = false;
        _currentPage = result.currentPage;
        _totalPages = result.totalPages;
        _totalItems = result.totalItems;
        _itemsPerPage = result.itemsPerPage;
        _hasNextPage = result.hasNextPage;
        _hasPreviousPage = result.hasPreviousPage;
        _totalActiveValue = result.totalActiveValue;
        _totalInactiveValue = result.totalInactiveValue;
      });

      // Debug: Print activity values
      if (kDebugMode) {
        print('Activity Values - Active: $_totalActiveValue, Inactive: $_totalInactiveValue');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _isPaginationLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _filterByModule(int? moduleId) async {
    setState(() {
      _selectedModuleId = moduleId;
    });
    await _loadFunctionPrivileges(
      moduleId: moduleId,
      page: 1,
      isRefresh: false,
    );
  }

  Future<void> _filterByOperation(int? operationId) async {
    setState(() {
      _selectedOperationId = operationId;
    });
    await _loadFunctionPrivileges(
      operationId: operationId,
      page: 1,
      isRefresh: false,
    );
  }

  Future<void> _filterByStatus(String status) async {
    setState(() {
      _selectedStatus = status;
    });
    final mappedStatus = status == 'All Status'
        ? null
        : status == 'Active'
            ? 'ACTIVE'
            : 'INACTIVE';
    await _loadFunctionPrivileges(
      status: mappedStatus,
      page: 1,
      isRefresh: false,
    );
  }

  Future<void> _search(String query) async {
    await _loadFunctionPrivileges(
      search: query.trim().isEmpty ? null : query.trim(),
      page: 1,
      isRefresh: false,
    );
  }

  Future<void> _refresh() async {
    // Use isRefresh flag to show separate refresh loading state
    await _loadFunctionPrivileges(page: 1, isRefresh: true);
  }

  Future<void> _nextPage() async {
    if (_hasNextPage && !_isPaginationLoading && !_isRefreshing && !_isLoading) {
      await _loadFunctionPrivileges(page: _currentPage + 1, isPagination: true);
    }
  }

  Future<void> _previousPage() async {
    if (_hasPreviousPage && !_isPaginationLoading && !_isRefreshing && !_isLoading) {
      await _loadFunctionPrivileges(page: _currentPage - 1, isPagination: true);
    }
  }

  Future<void> _goToPage(int page) async {
    if (page >= 1 && page <= _totalPages && !_isPaginationLoading && !_isRefreshing && !_isLoading) {
      await _loadFunctionPrivileges(page: page, isPagination: true);
    }
  }

  Future<void> _createFunctionPrivilege({
    required String code,
    required String name,
    required String description,
    required int moduleId,
    required int functionId,
    required int operationId,
    required String status,
    required String createdBy,
  }) async {
    try {
      final entity = FunctionPrivilegeEntity(
        id: '',
        code: code,
        name: name,
        description: description,
        moduleId: moduleId,
        moduleName: '',
        functionId: functionId.toString(),
        functionName: '',
        operationId: operationId,
        operationName: '',
        status: status,
        usedInRoles: 0,
        createdAt: '',
        createdBy: createdBy,
        updatedAt: '',
        updatedBy: '',
      );

      await _createUseCase(entity);
      await _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create privilege: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateFunctionPrivilege({
    required String id,
    required String name,
    required String description,
    required int moduleId,
    required int functionId,
    required int operationId,
    required String status,
    required String updatedBy,
  }) async {
    try {
      final entity = FunctionPrivilegeEntity(
        id: id,
        code: '',
        name: name,
        description: description,
        moduleId: moduleId,
        moduleName: '',
        functionId: functionId.toString(),
        functionName: '',
        operationId: operationId,
        operationName: '',
        status: status,
        usedInRoles: 0,
        createdAt: '',
        createdBy: '',
        updatedAt: '',
        updatedBy: updatedBy,
      );

      await _updateUseCase(entity);
      await _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update privilege: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteFunctionPrivilege(String id) async {
    try {
      await _deleteUseCase(id);
      await _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete privilege: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  FunctionPrivilegeModel _entityToModel(FunctionPrivilegeEntity entity) {
    return FunctionPrivilegeModel.fromEntity(entity);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    final privileges = _privileges.map(_entityToModel).toList();
    final totalPrivileges = _totalItems;
    // Use values from API response activity object
    final activePrivileges = _totalActiveValue ?? 0;
    final inactivePrivileges = _totalInactiveValue ?? 0;

    return Scaffold(
      backgroundColor: isDark ? context.themeBackground : const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FunctionPrivilegesHeader(
              isMobile: isMobile,
              isLoading: _isRefreshing,
              onRefresh: _refresh,
              onCreatePrivilege: () async {
                if (!mounted) return;
                final messenger = ScaffoldMessenger.of(context);
                final result = await showDialog(
                  context: context,
                  builder: (context) => CreatePrivilegeDialog(
                    onCreate: _createFunctionPrivilege,
                  ),
                );
                if (result == true && mounted) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Privilege created successfully'),
                      backgroundColor: Color(0xFF00A63E),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            FunctionPrivilegesStatsCards(
              isDark: isDark,
              isMobile: isMobile,
              isTablet: isTablet,
              total: totalPrivileges,
              active: activePrivileges,
              inactive: inactivePrivileges,
            ),
            const SizedBox(height: 24),
            FunctionPrivilegesSearchAndFilters(
              isDark: isDark,
              isMobile: isMobile,
              searchController: _searchController,
              selectedModule: _selectedModule,
              selectedOperation: _selectedOperation,
              selectedStatus: _selectedStatus,
              onModuleChanged: (value) {
                setState(() {
                  _selectedModule = value;
                });
              },
              onOperationChanged: (value) {
                setState(() {
                  _selectedOperation = value;
                });
              },
              onStatusChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
                _filterByStatus(value);
              },
              onModuleFilter: _filterByModule,
              onOperationFilter: _filterByOperation,
            ),
            const SizedBox(height: 24),
            if (_isLoading && privileges.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (privileges.isEmpty && !_isLoading)
              FunctionPrivilegesEmptyState(isDark: isDark)
            else ...[
              isMobile
                  ? FunctionPrivilegesMobileList(
                      isDark: isDark,
                      privileges: privileges,
                      onEdit: (privilege) async {
                        if (!mounted) return;
                        final messenger = ScaffoldMessenger.of(context);
                        final result = await showDialog(
                          context: context,
                          builder: (context) => CreatePrivilegeDialog(
                            privilege: privilege,
                            onUpdate: _updateFunctionPrivilege,
                          ),
                        );
                        if (result == true && mounted) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Privilege updated successfully'),
                              backgroundColor: Color(0xFF00A63E),
                            ),
                          );
                        }
                      },
                      onDelete: _deleteFunctionPrivilege,
                    )
                  : FunctionPrivilegesDataTable(
                      isDark: isDark,
                      privileges: privileges,
                      onEdit: (privilege) async {
                        if (!mounted) return;
                        final messenger = ScaffoldMessenger.of(context);
                        final result = await showDialog(
                          context: context,
                          builder: (context) => CreatePrivilegeDialog(
                            privilege: privilege,
                            onUpdate: _updateFunctionPrivilege,
                          ),
                        );
                        if (result == true && mounted) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Privilege updated successfully'),
                              backgroundColor: Color(0xFF00A63E),
                            ),
                          );
                        }
                      },
                      onDelete: _deleteFunctionPrivilege,
                    ),
              const SizedBox(height: 16),
              FunctionPrivilegesFooter(
                isDark: isDark,
                total: totalPrivileges,
                showing: privileges.length,
                isLoading: _isPaginationLoading,
                currentPage: _currentPage,
                totalPages: _totalPages,
                hasNextPage: _hasNextPage,
                hasPreviousPage: _hasPreviousPage,
                onNextPage: _nextPage,
                onPreviousPage: _previousPage,
                onGoToPage: _goToPage,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
