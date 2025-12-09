import 'dart:async';
import 'package:flutter/material.dart';

/// A generic paginated dropdown widget that supports infinite scroll
class PaginatedDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedValue;
  final String Function(T) getLabel;
  final void Function(T?) onChanged;
  final Future<void> Function() onLoadMore;
  final bool isLoading;
  final bool hasMore;
  final String hintText;
  final bool isDark;
  final double height;
  final String? error;
  final Widget Function(BuildContext, T)? itemBuilder;
  final double maxDropdownHeight;
  final bool enableSearch;
  final bool useApiSearch; // true for API search, false for local search
  final Future<void> Function(String searchQuery)? onSearch; // Callback for API search

  const PaginatedDropdown({
    super.key,
    required this.items,
    this.selectedValue,
    required this.getLabel,
    required this.onChanged,
    required this.onLoadMore,
    this.isLoading = false,
    this.hasMore = false,
    required this.hintText,
    required this.isDark,
    this.height = 39,
    this.error,
    this.itemBuilder,
    this.maxDropdownHeight = 230,
    this.enableSearch = true,
    this.useApiSearch = false,
    this.onSearch,
  });

  @override
  State<PaginatedDropdown<T>> createState() => _PaginatedDropdownState<T>();
}

class _PaginatedDropdownState<T> extends State<PaginatedDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isDropdownOpen = false;
  String _searchQuery = '';
  Timer? _searchDebounceTimer;
  bool _hasSearchText = false; // Track search text state for reactive UI

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.enableSearch) {
      _searchController.addListener(_onSearchChanged);
      _searchController.addListener(() {
        setState(() {
          _hasSearchText = _searchController.text.isNotEmpty;
        });
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      _searchQuery = query.toLowerCase();
      _hasSearchText = query.isNotEmpty;
    });
    
    if (widget.useApiSearch && widget.onSearch != null) {
      // API search with debouncing
      _searchDebounceTimer?.cancel();
      
      // If search is cleared, call immediately (no debounce)
      if (query.isEmpty) {
        widget.onSearch!(query);
      } else {
        // Debounce for non-empty queries
        _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            widget.onSearch!(query);
          }
        });
      }
    } else {
      // Local search - rebuild overlay when search changes
      if (_isDropdownOpen) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isDropdownOpen) {
            _rebuildOverlay();
          }
        });
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _hasSearchText = false;
    });
    
    // If using API search, trigger search with empty query to reload all data
    if (widget.useApiSearch && widget.onSearch != null) {
      _searchDebounceTimer?.cancel();
      widget.onSearch!('');
    } else {
      // For local search, rebuild overlay
      if (_isDropdownOpen) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isDropdownOpen) {
            _rebuildOverlay();
          }
        });
      }
    }
  }

  @override
  void didUpdateWidget(PaginatedDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If dropdown is open, always rebuild overlay when widget updates
    // This ensures new data appears immediately when fetched
    if (_isDropdownOpen) {
      // Check if items list changed (length is the most reliable indicator)
      final itemsChanged = widget.items.length != oldWidget.items.length;
      
      // Rebuild overlay if items changed, loading state changed, or error state changed
      if (itemsChanged || 
          widget.isLoading != oldWidget.isLoading ||
          widget.hasMore != oldWidget.hasMore ||
          widget.error != oldWidget.error) {
        // Schedule rebuild after current frame to avoid calling markNeedsBuild during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isDropdownOpen) {
            _rebuildOverlay();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounceTimer?.cancel();
    _closeDropdown();
    super.dispose();
  }

  void _rebuildOverlay() {
    if (_isDropdownOpen && _overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoading) {
        widget.onLoadMore();
      }
    }
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
      _searchQuery = '';
      _hasSearchText = false;
      _searchController.clear();
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _closeDropdown(),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => _closeDropdown(),
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height + 4.0),
                  child: GestureDetector(
                    onTap: () {}, // Prevent closing when clicking inside
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(10),
                      color: widget.isDark ? const Color(0xFF1F2937) : Colors.white,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: widget.maxDropdownHeight,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                        ),
                        child: _buildDropdownContent(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<T> _getFilteredItems() {
    // If using API search, return items as-is (filtering is done on server)
    if (widget.useApiSearch) {
      return widget.items;
    }
    
    // Local search - filter items client-side
    if (_searchQuery.isEmpty) {
      return widget.items;
    }
    return widget.items.where((item) {
      final label = widget.getLabel(item).toLowerCase();
      return label.contains(_searchQuery);
    }).toList();
  }

  Widget _buildDropdownContent() {
    final filteredItems = _getFilteredItems();
    
    if (widget.error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Error: ${widget.error}',
              style: TextStyle(
                color: widget.isDark ? Colors.red[300] : Colors.red,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                widget.onLoadMore();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field (only show if search is enabled)
        if (widget.enableSearch)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
            controller: _searchController,
            autofocus: true,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: widget.isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: widget.isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF717182),
                fontSize: 13,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 16,
                color: widget.isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF717182),
              ),
              suffixIcon: _hasSearchText
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 16,
                        color: widget.isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF717182),
                      ),
                      onPressed: _clearSearch,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: widget.isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.08),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: Colors.black.withValues(alpha: 0.08),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xFF155DFC),
                  width: 1.5,
                ),
              ),
            ),
          ),
          ),
        // Divider (only show if search is enabled)
        if (widget.enableSearch)
          Divider(
          height: 1,
          thickness: 1,
          color: Colors.black.withValues(alpha: 0.08),
        ),
        // Items list
        if (filteredItems.isEmpty && !widget.isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Center(
              child: Text(
                _searchController.text.isEmpty ? 'No items found' : 'No results found',
                style: TextStyle(
                  color: widget.isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF4A5565),
                  fontSize: 13,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          )
        else
          Flexible(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: filteredItems.length + (widget.hasMore && (!widget.useApiSearch || _searchController.text.isEmpty) ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == filteredItems.length) {
                  // Loading indicator at bottom (only show if not searching or using API search)
                  return Column(
                    children: [
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.black.withValues(alpha: 0.08),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.isDark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF4A5565),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                final item = filteredItems[index];
                final isSelected = widget.selectedValue == item;
                final isLast = index == filteredItems.length - 1;

                return widget.itemBuilder != null
                    ? Column(
                        children: [
                          widget.itemBuilder!(context, item),
                          if (!isLast)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.black.withValues(alpha: 0.08),
                              indent: 12,
                              endIndent: 12,
                            ),
                        ],
                      )
                    : Column(
                        children: [
                          InkWell(
                            onTap: () {
                              widget.onChanged(item);
                              _closeDropdown();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              color: isSelected
                                  ? (widget.isDark
                                      ? const Color(0xFF374151)
                                      : const Color(0xFFF3F4F6))
                                  : Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.getLabel(item),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w400,
                                        color: widget.isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172B),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Icon(
                                        Icons.check,
                                        size: 16,
                                        color: widget.isDark
                                            ? const Color(0xFF155DFC)
                                            : const Color(0xFF155DFC),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (!isLast)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.black.withValues(alpha: 0.08),
                              indent: 12,
                              endIndent: 12,
                            ),
                        ],
                      );
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DC)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    widget.selectedValue != null
                        ? widget.getLabel(widget.selectedValue as T)
                        : widget.hintText,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.4,
                      fontWeight: FontWeight.w400,
                      color: widget.selectedValue != null
                          ? (widget.isDark
                              ? Colors.white
                              : const Color(0xFF0F172B))
                          : (widget.isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF717182)),
                      height: 1.23,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  _isDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                  color: widget.isDark
                      ? Colors.white
                      : const Color(0xFF0F172B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
