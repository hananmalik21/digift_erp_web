import 'package:flutter/material.dart';

class FunctionPrivilegesFooterPagination extends StatelessWidget {
  final bool isDark;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final bool isLoading;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final Function(int) onGoToPage;

  const FunctionPrivilegesFooterPagination({
    super.key,
    required this.isDark,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.isLoading,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.onGoToPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: hasPreviousPage && !isLoading ? onPreviousPage : null,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: hasPreviousPage && !isLoading
                    ? (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: hasPreviousPage && !isLoading
                    ? null
                    : Border.all(
                        color: isDark
                            ? const Color(0xFF374151)
                            : Colors.black.withValues(alpha: 0.1),
                      ),
              ),
              child: isLoading && hasPreviousPage
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
                      Icons.chevron_left,
                      size: 20,
                      color: hasPreviousPage && !isLoading
                          ? (isDark ? Colors.white : const Color(0xFF374151))
                          : (isDark ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB)),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Page numbers
        ..._buildFooterPageNumbers(context, isDark),

        const SizedBox(width: 8),
        // Next button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: hasNextPage && !isLoading ? onNextPage : null,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: hasNextPage && !isLoading
                    ? (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: hasNextPage && !isLoading
                    ? null
                    : Border.all(
                        color: isDark
                            ? const Color(0xFF374151)
                            : Colors.black.withValues(alpha: 0.1),
                      ),
              ),
              child: Icon(
                Icons.chevron_right,
                size: 20,
                color: hasNextPage && !isLoading
                    ? (isDark ? Colors.white : const Color(0xFF374151))
                    : (isDark ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFooterPageNumbers(
    BuildContext context,
    bool isDark,
  ) {
    final maxVisible = 5;

    List<int> pageNumbers = [];

    if (totalPages <= maxVisible) {
      // Show all pages
      pageNumbers = List.generate(totalPages, (i) => i + 1);
    } else {
      // Show pages with ellipsis
      if (currentPage <= 3) {
        // Show first pages
        pageNumbers = [1, 2, 3, 4, 5];
      } else if (currentPage >= totalPages - 2) {
        // Show last pages
        pageNumbers = List.generate(5, (i) => totalPages - 4 + i);
      } else {
        // Show pages around current
        pageNumbers = [
          currentPage - 2,
          currentPage - 1,
          currentPage,
          currentPage + 1,
          currentPage + 2,
        ];
      }
    }

    List<Widget> widgets = [];

    // First page
    if (pageNumbers.first > 1) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: FunctionPrivilegesFooterPageNumber(
            isDark: isDark,
            pageNumber: 1,
            isCurrent: currentPage == 1,
            onTap: () => onGoToPage(1),
            isLoading: isLoading,
          ),
        ),
      );
      if (pageNumbers.first > 2) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              '...',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              ),
            ),
          ),
        );
      }
    }

    // Page numbers
    for (var pageNum in pageNumbers) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: FunctionPrivilegesFooterPageNumber(
            isDark: isDark,
            pageNumber: pageNum,
            isCurrent: pageNum == currentPage,
            onTap: () => onGoToPage(pageNum),
            isLoading: isLoading,
          ),
        ),
      );
    }

    // Last page
    if (pageNumbers.last < totalPages) {
      if (pageNumbers.last < totalPages - 1) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              '...',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              ),
            ),
          ),
        );
      }
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: FunctionPrivilegesFooterPageNumber(
            isDark: isDark,
            pageNumber: totalPages,
            isCurrent: currentPage == totalPages,
            onTap: () => onGoToPage(totalPages),
            isLoading: isLoading,
          ),
        ),
      );
    }

    return widgets;
  }
}

class FunctionPrivilegesFooterPageNumber extends StatelessWidget {
  final bool isDark;
  final int pageNumber;
  final bool isCurrent;
  final VoidCallback onTap;
  final bool isLoading;

  const FunctionPrivilegesFooterPageNumber({
    super.key,
    required this.isDark,
    required this.pageNumber,
    required this.isCurrent,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          constraints: const BoxConstraints(minWidth: 32),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                fontSize: 13.6,
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
}
