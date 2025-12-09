import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_extensions.dart';
import 'function_privileges_footer_pagination.dart';

class FunctionPrivilegesFooter extends StatelessWidget {
  final bool isDark;
  final int total;
  final int showing;
  final bool isLoading;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final Function(int) onGoToPage;

  const FunctionPrivilegesFooter({
    super.key,
    required this.isDark,
    required this.total,
    required this.showing,
    required this.isLoading,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.onGoToPage,
  });

  @override
  Widget build(BuildContext context) {
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
                          'Showing $showing of $total privileges',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.6,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF4A5565),
                            height: 1.47,
                          ),
                        ),
                        if (isLoading) ...[
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
                  ],
                ),
                if (totalPages > 1) ...[
                  const SizedBox(height: 12),
                  FunctionPrivilegesFooterPagination(
                    isDark: isDark,
                    currentPage: currentPage,
                    totalPages: totalPages,
                    hasNextPage: hasNextPage,
                    hasPreviousPage: hasPreviousPage,
                    isLoading: isLoading,
                    onNextPage: onNextPage,
                    onPreviousPage: onPreviousPage,
                    onGoToPage: onGoToPage,
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
                          'Showing $showing of $total privileges',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.6,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF4A5565),
                            height: 1.47,
                          ),
                        ),
                        if (isLoading) ...[
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
                  ],
                ),
                if (totalPages > 1)
                  FunctionPrivilegesFooterPagination(
                    isDark: isDark,
                    currentPage: currentPage,
                    totalPages: totalPages,
                    hasNextPage: hasNextPage,
                    hasPreviousPage: hasPreviousPage,
                    isLoading: isLoading,
                    onNextPage: onNextPage,
                    onPreviousPage: onPreviousPage,
                    onGoToPage: onGoToPage,
                  ),
              ],
            ),
    );
  }
}
