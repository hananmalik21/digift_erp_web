import 'package:flutter/material.dart';
import 'paginated_dropdown.dart';

/// Simple paginated dropdown for status values (static list)
class PaginatedStatusDropdown extends StatelessWidget {
  final String? selectedStatus;
  final Function(String?) onChanged;
  final bool isDark;
  final bool enableSearch;
  final double height;
  final bool showError;
  final List<String> statuses;
  final String hintText;

  const PaginatedStatusDropdown({
    super.key,
    this.selectedStatus,
    required this.onChanged,
    required this.isDark,
    this.height = 39,
    this.showError = false,
    this.enableSearch = true,
    this.statuses = const ['Active', 'Inactive'],
    this.hintText = 'Select status',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color: showError
                  ? const Color(0xFFFB2C36)
                  : const Color(0xFFD1D5DC),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: PaginatedDropdown<String>(
            items: statuses,
            selectedValue: selectedStatus,
            getLabel: (status) => status,
            onChanged: (status) {
              onChanged(status);
            },
            onLoadMore: () async {}, // No pagination for static lists
            isLoading: false,
            hasMore: false,
            hintText: hintText,
            isDark: isDark,
            height: height,
            enableSearch: enableSearch,
            useApiSearch: false, // Local search for static lists
          ),
        ),
        if (showError)
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
