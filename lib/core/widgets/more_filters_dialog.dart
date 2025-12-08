import 'package:flutter/material.dart';
import '../models/filter_model.dart';
import '../theme/theme_extensions.dart';

class MoreFiltersDialog extends StatefulWidget {
  final List<FilterModel> filters;
  final List<String>? initialSelectedKeys;

  const MoreFiltersDialog({
    super.key,
    required this.filters,
    this.initialSelectedKeys,
  });

  static Future<List<String>?> show(
    BuildContext context, {
    required List<FilterModel> filters,
    List<String>? initialSelectedKeys,
  }) async {
    return showDialog<List<String>>(
      context: context,
      builder: (context) => MoreFiltersDialog(
        filters: filters,
        initialSelectedKeys: initialSelectedKeys,
      ),
    );
  }

  @override
  State<MoreFiltersDialog> createState() => _MoreFiltersDialogState();
}

class _MoreFiltersDialogState extends State<MoreFiltersDialog> {
  String? _selectedKey;

  @override
  void initState() {
    super.initState();
    // Only allow single selection - use first key if multiple provided
    _selectedKey = widget.initialSelectedKeys != null && widget.initialSelectedKeys!.isNotEmpty
        ? widget.initialSelectedKeys!.first
        : null;
  }

  void _selectFilter(String key) {
    setState(() {
      // Toggle: if already selected, deselect; otherwise select this one
      _selectedKey = _selectedKey == key ? null : key;
    });
  }

  void _applyFilters() {
    // Return list with single selected key or empty list
    Navigator.of(context).pop(_selectedKey != null ? [_selectedKey!] : []);
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'More Filters',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172B),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    onPressed: _cancel,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Filter List
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: widget.filters.map((filter) {
                    final isSelected = _selectedKey == filter.key;
                    return _buildFilterRow(
                      context,
                      filter,
                      isSelected,
                      isDark,
                    );
                  }).toList(),
                ),
              ),
            ),
            // Footer with buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 100,
                    height: 36,
                    child: OutlinedButton(
                      onPressed: _cancel,
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            isDark ? context.themeCardBackground : Colors.white,
                        foregroundColor:
                            isDark ? Colors.white : const Color(0xFF0F172B),
                        side: BorderSide(
                          color: Colors.black.withValues(alpha: 0.1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF030213),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(
    BuildContext context,
    FilterModel filter,
    bool isSelected,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => _selectFilter(filter.key),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Row(
          children: [
            // Radio button (single selection)
            SizedBox(
              width: 24,
              height: 24,
              child: Radio<String>(
                value: filter.key,
                groupValue: _selectedKey,
                onChanged: (value) => _selectFilter(filter.key),
                activeColor: const Color(0xFF030213),
              ),
            ),
            const SizedBox(width: 16),
            // Filter Key Label
            Expanded(
              flex: 2,
              child: Text(
                filter.displayLabel,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Filter Value
            Expanded(
              flex: 3,
              child: Text(
                filter.value.toString(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF4A5565),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
