import 'package:flutter/material.dart';
import '../../../../../core/widgets/paginated_dropdown.dart';
import 'package:digify_erp/features/security_console/functions/domain/entities/function_entity.dart';
import 'package:digify_erp/features/security_console/functions/data/datasources/function_remote_datasource.dart';

class PaginatedFunctionDropdown extends StatefulWidget {
  final String? selectedFunction;      // Function name (for display)
  final String? selectedFunctionId;    // Function ID (for selection)
  final Function(String?, String?) onChanged;
  final bool isDark;
  final double height;
  final bool showError;

  const PaginatedFunctionDropdown({
    super.key,
    this.selectedFunction,
    this.selectedFunctionId,
    required this.onChanged,
    required this.isDark,
    this.height = 39,
    this.showError = false,
  });

  @override
  State<PaginatedFunctionDropdown> createState() =>
      _PaginatedFunctionDropdownState();
}

class _PaginatedFunctionDropdownState extends State<PaginatedFunctionDropdown> {
  FunctionEntity? _selectedFunctionEntity;
  List<FunctionEntity> _functions = [];

  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  String? _error;
  String? _currentSearchQuery;

  final int _itemsPerPage = 10;

  late final FunctionRemoteDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = FunctionRemoteDataSourceImpl();

    _loadFunctions();

    // Resolve selection after data loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolveSelectedFunction();
    });
  }

  @override
  void didUpdateWidget(PaginatedFunctionDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-select if parent updated function or ID
    if (widget.selectedFunctionId != oldWidget.selectedFunctionId ||
        widget.selectedFunction != oldWidget.selectedFunction) {
      _resolveSelectedFunction();
    }
  }

  // ---------------------------------------------
  // LOADING DATA
  // ---------------------------------------------

  Future<void> _loadFunctions({bool append = false, String? search, bool isClearing = false}) async {
    if (_isLoading && !append) return;

    // Update search query state
    if (isClearing || search != null) {
      _currentSearchQuery =
      (isClearing || search == null || search.isEmpty) ? null : search.trim();
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Build dynamic filters
      final Map<String, String>? dynamicFilters =
      (_currentSearchQuery != null && _currentSearchQuery!.isNotEmpty)
          ? {'functionName': _currentSearchQuery!}
          : null;

      final pageToLoad =
      (isClearing || _currentSearchQuery != null || !append) ? 1 : (_currentPage + 1);

      final response = await _dataSource.getFunctions(
        page: pageToLoad,
        limit: _itemsPerPage,
        dynamicFilters: dynamicFilters,
      );

      final loaded = response.data.map((dto) => dto.toEntity()).toList();

      setState(() {
        if (append && _currentSearchQuery == null) {
          _functions = [..._functions, ...loaded];
        } else {
          _functions = loaded;
        }

        _currentPage = response.meta.currentPage;
        _hasMore = response.meta.hasNextPage;
        _isLoading = false;
      });

      // After loading, resolve pre-selection
      _resolveSelectedFunction();

    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadMore() async {
    if (_hasMore && !_isLoading && _currentSearchQuery == null) {
      await _loadFunctions(append: true);
    }
  }

  Future<void> _handleSearch(String search) async {
    final query = search.trim();
    if (query.isEmpty) {
      await _loadFunctions(search: null, isClearing: true);
    } else {
      await _loadFunctions(search: query);
    }
  }

  // ---------------------------------------------
  // CORRECT FIX: PRE-SELECT FUNCTION
  // ---------------------------------------------
  void _resolveSelectedFunction() {
    if (_functions.isEmpty) return;

    FunctionEntity? match;

    // 1️⃣ MATCH BY FUNCTION ID FIRST (MOST ACCURATE)
    if (widget.selectedFunctionId != null) {
      match = _functions.firstWhere(
            (f) => f.id.toString() == widget.selectedFunctionId,
        orElse: () => _functions.first,
      );
    }

    // 2️⃣ FALLBACK TO MATCHING NAME (CASE-INSENSITIVE)
    if (match == null && widget.selectedFunction != null) {
      match = _functions.firstWhere(
            (f) => f.name.toLowerCase() == widget.selectedFunction!.toLowerCase(),
        orElse: () => _functions.first,
      );
    }

    // 3️⃣ Apply selection
    setState(() {
      _selectedFunctionEntity = match;
    });

    // 4️⃣ Only notify parent if ID NOT PROVIDED (edit mode passes ID)
    if (widget.selectedFunctionId == null) {
      widget.onChanged(match?.name, match?.id);
    }
  }

  // ---------------------------------------------
  // UI
  // ---------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.showError
                  ? const Color(0xFFFB2C36)
                  : const Color(0xFFD1D5DC),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: PaginatedDropdown<FunctionEntity>(
            items: _functions,
            selectedValue: _selectedFunctionEntity,
            getLabel: (func) => func.name,
            onChanged: (func) {
              setState(() => _selectedFunctionEntity = func);
              widget.onChanged(func?.name, func?.id);
            },
            onLoadMore: _loadMore,
            isLoading: _isLoading,
            hasMore: _hasMore,
            hintText: 'Select function',
            isDark: widget.isDark,
            height: widget.height,
            error: _error,
            enableSearch: true,
            useApiSearch: true,
            onSearch: _handleSearch,
          ),
        ),

        if (widget.showError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              'Required',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFFB2C36),
              ),
            ),
          ),
      ],
    );
  }
}
