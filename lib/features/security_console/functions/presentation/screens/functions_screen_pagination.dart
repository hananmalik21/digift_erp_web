import 'package:flutter/material.dart';
import '../providers/functions_provider.dart';

Widget buildPagination(
  BuildContext context,
  bool isDark,
  FunctionsState state,
  FunctionsNotifier notifier, {
  int? activeFunctions,
}) {
  if (state.totalPages <= 1) {
    return const SizedBox.shrink();
  }

  final startItem = ((state.currentPage - 1) * state.itemsPerPage) + 1;
  final endItem = state.currentPage * state.itemsPerPage > state.totalItems
      ? state.totalItems
      : state.currentPage * state.itemsPerPage;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isDark
            ? const Color(0xFF374151)
            : Colors.black.withValues(alpha: 0.1),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side: Items info
        Row(
          children: [
            Text(
              'Showing $startItem to $endItem of ${state.totalItems} entries',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              ),
            ),
            if (activeFunctions != null) ...[
              const SizedBox(width: 24),
              Text(
                'Active Functions: $activeFunctions',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                ),
              ),
            ],
            if (state.isLoading) ...[
              const SizedBox(width: 12),
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ],
        ),

        // Right side: Pagination controls
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Previous button
            _buildPageButton(
              context: context,
              isDark: isDark,
              icon: Icons.chevron_left,
              onPressed: state.hasPreviousPage && !state.isLoading
                  ? () => notifier.previousPage()
                  : null,
              isEnabled: state.hasPreviousPage && !state.isLoading,
              isLoading: state.isLoading,
            ),
            const SizedBox(width: 8),

            // Page numbers
            _buildPageNumbers(
              context: context,
              isDark: isDark,
              state: state,
              notifier: notifier,
            ),

            const SizedBox(width: 8),
            // Next button
            _buildPageButton(
              context: context,
              isDark: isDark,
              icon: Icons.chevron_right,
              onPressed: state.hasNextPage && !state.isLoading
                  ? () => notifier.nextPage()
                  : null,
              isEnabled: state.hasNextPage && !state.isLoading,
              isLoading: state.isLoading,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildPageButton({
  required BuildContext context,
  required bool isDark,
  required IconData icon,
  required VoidCallback? onPressed,
  required bool isEnabled,
  required bool isLoading,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isEnabled && !isLoading
              ? (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isEnabled && !isLoading
              ? null
              : Border.all(
                  color: isDark
                      ? const Color(0xFF374151)
                      : Colors.black.withValues(alpha: 0.1),
                ),
        ),
        child: isLoading && isEnabled
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              )
            : Icon(
                icon,
                size: 20,
                color: isEnabled && !isLoading
                    ? (isDark ? Colors.white : const Color(0xFF374151))
                    : (isDark ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB)),
              ),
      ),
    ),
  );
}

Widget _buildPageNumbers({
  required BuildContext context,
  required bool isDark,
  required FunctionsState state,
  required FunctionsNotifier notifier,
}) {
  final maxVisible = 7;
  final totalPages = state.totalPages;
  final currentPage = state.currentPage;

  List<int> pageNumbers = [];

  if (totalPages <= maxVisible) {
    // Show all pages
    pageNumbers = List.generate(totalPages, (i) => i + 1);
  } else {
    // Show pages with ellipsis
    if (currentPage <= 4) {
      // Show first pages
      pageNumbers = [1, 2, 3, 4, 5, 6, 7];
    } else if (currentPage >= totalPages - 3) {
      // Show last pages
      pageNumbers = List.generate(
        7,
        (i) => totalPages - 6 + i,
      );
    } else {
      // Show pages around current
      pageNumbers = [
        currentPage - 3,
        currentPage - 2,
        currentPage - 1,
        currentPage,
        currentPage + 1,
        currentPage + 2,
        currentPage + 3,
      ];
    }
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // First page
      if (pageNumbers.first > 1) ...[
        _buildPageNumber(
          context: context,
          isDark: isDark,
          pageNumber: 1,
          isCurrent: currentPage == 1,
          onTap: () => notifier.goToPage(1),
          isLoading: state.isLoading,
        ),
        if (pageNumbers.first > 2) ...[
          const SizedBox(width: 4),
          _buildEllipsis(isDark),
          const SizedBox(width: 4),
        ] else
          const SizedBox(width: 4),
      ],

      // Page numbers
      ...pageNumbers.map((pageNum) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: _buildPageNumber(
            context: context,
            isDark: isDark,
            pageNumber: pageNum,
            isCurrent: pageNum == currentPage,
            onTap: () => notifier.goToPage(pageNum),
            isLoading: state.isLoading,
          ),
        );
      }),

      // Last page
      if (pageNumbers.last < totalPages) ...[
        if (pageNumbers.last < totalPages - 1) ...[
          const SizedBox(width: 4),
          _buildEllipsis(isDark),
          const SizedBox(width: 4),
        ] else
          const SizedBox(width: 4),
        _buildPageNumber(
          context: context,
          isDark: isDark,
          pageNumber: totalPages,
          isCurrent: currentPage == totalPages,
          onTap: () => notifier.goToPage(totalPages),
          isLoading: state.isLoading,
        ),
      ],
    ],
  );
}

Widget _buildPageNumber({
  required BuildContext context,
  required bool isDark,
  required int pageNumber,
  required bool isCurrent,
  required VoidCallback onTap,
  required bool isLoading,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        constraints: const BoxConstraints(minWidth: 36),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isCurrent
              ? const Color(0xFF030213)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isCurrent
              ? null
              : Border.all(
                  color: isDark
                      ? const Color(0xFF374151)
                      : Colors.black.withValues(alpha: 0.1),
                ),
        ),
        child: Center(
          child: Text(
            '$pageNumber',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
              color: isCurrent
                  ? Colors.white
                  : (isDark ? Colors.white : const Color(0xFF374151)),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildEllipsis(bool isDark) {
  return Text(
    '...',
    style: TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
    ),
  );
}

