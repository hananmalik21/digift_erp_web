import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../providers/functions_provider.dart';

class FunctionsFooter extends ConsumerWidget {
  final bool isDark;
  final int total;
  final int activeFunctions;

  const FunctionsFooter({
    super.key,
    required this.isDark,
    required this.total,
    required this.activeFunctions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final functionsState = ref.watch(functionsProvider);
    final functionsNotifier = ref.read(functionsProvider.notifier);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Showing ${functionsState.functions.length} of $total functions',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.6,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF4A5565),
                            height: 1.21,
                          ),
                        ),
                        if (functionsState.isLoading) ...[
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF4A5565),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      'Active Functions: $activeFunctions',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.6,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF4A5565),
                        height: 1.21,
                      ),
                    ),
                  ],
                ),
                if (functionsState.totalPages > 1) ...[
                  const SizedBox(height: 12),
                  FunctionsFooterPagination(
                    isDark: isDark,
                    state: functionsState,
                    notifier: functionsNotifier,
                  ),
                ],
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Showing ${functionsState.functions.length} of $total functions',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.6,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF4A5565),
                            height: 1.21,
                          ),
                        ),
                        if (functionsState.isLoading) ...[
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF4A5565),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(width: 24),
                    Text(
                      'Active Functions: $activeFunctions',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.6,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF4A5565),
                        height: 1.21,
                      ),
                    ),
                  ],
                ),
                if (functionsState.totalPages > 1)
                  FunctionsFooterPagination(
                    isDark: isDark,
                    state: functionsState,
                    notifier: functionsNotifier,
                  ),
              ],
            ),
    );
  }
}

class FunctionsFooterPagination extends StatelessWidget {
  final bool isDark;
  final FunctionsState state;
  final FunctionsNotifier notifier;

  const FunctionsFooterPagination({
    super.key,
    required this.isDark,
    required this.state,
    required this.notifier,
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
            onTap: state.hasPreviousPage && !state.isLoading
                ? () => notifier.previousPage()
                : null,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: state.hasPreviousPage && !state.isLoading
                    ? (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: state.hasPreviousPage && !state.isLoading
                    ? null
                    : Border.all(
                        color: isDark
                            ? const Color(0xFF374151)
                            : Colors.black.withValues(alpha: 0.1),
                      ),
              ),
              child: state.isLoading && state.hasPreviousPage
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
                      color: state.hasPreviousPage && !state.isLoading
                          ? (isDark ? Colors.white : const Color(0xFF374151))
                          : (isDark ? const Color(0xFF6B7280) : const Color(0xFFD1D5DB)),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Page numbers
        ..._buildFooterPageNumbers(context, isDark, state, notifier),

        const SizedBox(width: 8),
        // Next button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: state.hasNextPage && !state.isLoading
                ? () => notifier.nextPage()
                : null,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: state.hasNextPage && !state.isLoading
                    ? (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: state.hasNextPage && !state.isLoading
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
                color: state.hasNextPage && !state.isLoading
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
    FunctionsState state,
    FunctionsNotifier notifier,
  ) {
    final maxVisible = 5;
    final totalPages = state.totalPages;
    final currentPage = state.currentPage;

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
          child: FunctionsFooterPageNumber(
            isDark: isDark,
            pageNumber: 1,
            isCurrent: currentPage == 1,
            onTap: () => notifier.goToPage(1),
            isLoading: state.isLoading,
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
          child: FunctionsFooterPageNumber(
            isDark: isDark,
            pageNumber: pageNum,
            isCurrent: pageNum == currentPage,
            onTap: () => notifier.goToPage(pageNum),
            isLoading: state.isLoading,
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
          child: FunctionsFooterPageNumber(
            isDark: isDark,
            pageNumber: totalPages,
            isCurrent: currentPage == totalPages,
            onTap: () => notifier.goToPage(totalPages),
            isLoading: state.isLoading,
          ),
        ),
      );
    }

    return widgets;
  }
}

class FunctionsFooterPageNumber extends StatelessWidget {
  final bool isDark;
  final int pageNumber;
  final bool isCurrent;
  final VoidCallback onTap;
  final bool isLoading;

  const FunctionsFooterPageNumber({
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
