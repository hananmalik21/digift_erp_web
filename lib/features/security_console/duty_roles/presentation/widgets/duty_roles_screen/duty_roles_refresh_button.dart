import 'package:flutter/material.dart';
import '../../../../../../core/theme/theme_extensions.dart';

class DutyRolesRefreshButton extends StatelessWidget {
  final bool isDark;
  final bool isLoading;
  final VoidCallback onRefresh;

  const DutyRolesRefreshButton({
    super.key,
    required this.isDark,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108.98,
      height: 36,
      child: OutlinedButton(
        onPressed: isLoading ? null : onRefresh,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? context.themeCardBackground : Colors.white,
          foregroundColor: isDark ? Colors.white : const Color(0xFF0F172B),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.white : const Color(0xFF0F172B),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh,
                    size: 16,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Refresh',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.8,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0F172B),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
