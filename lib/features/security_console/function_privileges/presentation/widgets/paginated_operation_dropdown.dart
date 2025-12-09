import 'package:flutter/material.dart';
import '../../../../../core/widgets/paginated_dropdown.dart';
import '../../data/models/operation_dto.dart';
import '../../data/datasources/operation_remote_datasource.dart';

class PaginatedOperationDropdown extends StatefulWidget {
  final String? selectedOperation;       // Operation name
  final int? selectedOperationId;        // Operation ID
  final Function(String?, int?) onChanged;
  final bool isDark;
  final double height;
  final bool showError;
  final String hintText;

  const PaginatedOperationDropdown({
    super.key,
    this.selectedOperation,
    this.selectedOperationId,
    required this.onChanged,
    required this.isDark,
    this.height = 39,
    this.showError = false,
    this.hintText = 'Select operation',
  });

  @override
  State<PaginatedOperationDropdown> createState() =>
      _PaginatedOperationDropdownState();
}

class _PaginatedOperationDropdownState
    extends State<PaginatedOperationDropdown> {
  OperationDto? _selectedOperationDto;
  List<OperationDto> _allOperations = [];
  List<OperationDto> _displayedOperations = [];

  bool _isLoading = false;
  bool _hasMore = false;
  String? _error;

  final int _itemsPerPage = 10;

  late final OperationRemoteDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = OperationRemoteDataSourceImpl();

    _loadOperations();

    // Resolve after loading page 1
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolveSelectedOperation();
    });
  }

  @override
  void didUpdateWidget(PaginatedOperationDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedOperationId != oldWidget.selectedOperationId ||
        widget.selectedOperation != oldWidget.selectedOperation) {
      _resolveSelectedOperation();
    }
  }

  // -------------------------------------------------------------
  // LOAD OPERATIONS
  // -------------------------------------------------------------
  Future<void> _loadOperations({bool append = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final operations = await _dataSource.getOperations();
      _allOperations = operations;

      if (append) {
        final start = _displayedOperations.length;
        final end = start + _itemsPerPage;
        final nextPage = operations.sublist(
          start,
          end > operations.length ? operations.length : end,
        );

        setState(() {
          _displayedOperations = [..._displayedOperations, ...nextPage];
          _hasMore = end < operations.length;
          _isLoading = false;
        });
      } else {
        final firstPage = operations.length > _itemsPerPage
            ? operations.sublist(0, _itemsPerPage)
            : operations;

        setState(() {
          _displayedOperations = firstPage;
          _hasMore = operations.length > _itemsPerPage;
          _isLoading = false;
        });
      }

      _resolveSelectedOperation();

    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadMore() async {
    if (_hasMore && !_isLoading) {
      await _loadOperations(append: true);
    }
  }

  // -------------------------------------------------------------
  // SELECT OPERATION CORRECTLY (BEST FIX)
  // -------------------------------------------------------------
  void _resolveSelectedOperation() {
    if (_allOperations.isEmpty) return;

    OperationDto? match;

    // ⭐ 1. Try match by OPERATION ID first
    if (widget.selectedOperationId != null) {
      match = _allOperations.firstWhere(
            (o) => o.id == widget.selectedOperationId,
        orElse: () => _allOperations.first,
      );
    }

    // ⭐ 2. Fallback: match by name
    if (match == null && widget.selectedOperation != null) {
      match = _allOperations.firstWhere(
            (o) => o.name.toLowerCase() ==
            widget.selectedOperation!.toLowerCase(),
        orElse: () => _allOperations.first,
      );
    }

    // ⭐ 3. If hint is "All Operations" and no selection → treat as ALL
    if ((widget.selectedOperation == null ||
        widget.selectedOperation == 'All Operations') &&
        widget.selectedOperationId == null) {
      setState(() => _selectedOperationDto = null);
      return;
    }

    // ⭐ 4. Apply selection
    setState(() {
      _selectedOperationDto = match;
    });

    // ⭐ 5. If ID not provided from parent, notify parent
    if (widget.selectedOperationId == null) {
      widget.onChanged(match?.name, match?.id);
    }
  }

  // -------------------------------------------------------------
  // UI
  // -------------------------------------------------------------
  Widget _buildDropdown() {
    final supportsAll =
        widget.hintText.trim().toLowerCase() == 'all operations';

    if (supportsAll) {
      final allItem = const _AllOperationsItem();
      final items = <dynamic>[allItem, ..._displayedOperations];

      dynamic selectedValue =
          _selectedOperationDto ?? allItem;

      return PaginatedDropdown<dynamic>(
        items: items,
        selectedValue: selectedValue,
        getLabel: (item) => item is _AllOperationsItem
            ? 'All Operations'
            : (item as OperationDto).name,
        onChanged: (item) {
          if (item is _AllOperationsItem) {
            setState(() => _selectedOperationDto = null);
            // Defer to avoid setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onChanged(null, null);
            });
          } else if (item is OperationDto) {
            setState(() => _selectedOperationDto = item);
            // Defer to avoid setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onChanged(item.name, item.id);
            });
          }
        },
        onLoadMore: _loadMore,
        isLoading: _isLoading,
        hasMore: _hasMore,
        hintText: widget.hintText,
        isDark: widget.isDark,
        height: widget.height,
        error: _error,
        enableSearch: true,
        useApiSearch: false,
      );
    }

    // Normal dropdown (no "All Operations")
    return PaginatedDropdown<OperationDto>(
      items: _displayedOperations,
      selectedValue: _selectedOperationDto,
      getLabel: (op) => op.name,
        onChanged: (op) {
          setState(() => _selectedOperationDto = op);
          // Defer to avoid setState during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onChanged(op?.name, op?.id);
          });
        },
      onLoadMore: _loadMore,
      isLoading: _isLoading,
      hasMore: _hasMore,
      hintText: widget.hintText,
      isDark: widget.isDark,
      height: widget.height,
      error: _error,
      enableSearch: true,
      useApiSearch: false,
    );
  }

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
          child: _buildDropdown(),
        ),
        if (widget.showError)
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 12),
            child: Text(
              'Required',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFFFB2C36),
              ),
            ),
          ),
      ],
    );
  }
}

class _AllOperationsItem {
  const _AllOperationsItem();
}
