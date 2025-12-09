import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';

class FunctionPrivilegesHeader extends StatelessWidget {
  final bool isMobile;
  final bool isLoading;
  final VoidCallback onRefresh;
  final VoidCallback? onCreatePrivilege;

  const FunctionPrivilegesHeader({
    super.key,
    required this.isMobile,
    required this.isLoading,
    required this.onRefresh,
    this.onCreatePrivilege,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.icons.keyIcon.path,
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  isDark ? Colors.white : const Color(0xFF155DFC),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Function Privileges',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.4,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Granular permissions for specific system functions',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.3,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF4A5565),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FunctionPrivilegesRefreshButton(
                  isDark: isDark,
                  isLoading: isLoading,
                  onRefresh: onRefresh,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FunctionPrivilegesCreateButton(
                  isDark: isDark,
                  onCreatePrivilege: onCreatePrivilege,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SvgPicture.asset(
            Assets.icons.keyIcon.path,
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              isDark ? Colors.white : const Color(0xFF155DFC),
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Function Privileges',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.4,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                  height: 1.56,
                ),
              ),
              Text(
                'Granular permissions for specific system functions',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF4A5565),
                  height: 1.57,
                ),
              ),
            ],
          ),
        ),
        FunctionPrivilegesRefreshButton(
          isDark: isDark,
          isLoading: isLoading,
          onRefresh: onRefresh,
        ),
        const SizedBox(width: 8),
        FunctionPrivilegesCreateButton(
          isDark: isDark,
          onCreatePrivilege: onCreatePrivilege,
        ),
      ],
    );
  }
}

class FunctionPrivilegesRefreshButton extends StatelessWidget {
  final bool isDark;
  final bool isLoading;
  final VoidCallback onRefresh;

  const FunctionPrivilegesRefreshButton({
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

class FunctionPrivilegesCreateButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onCreatePrivilege;

  const FunctionPrivilegesCreateButton({
    super.key,
    required this.isDark,
    this.onCreatePrivilege,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.8,
      height: 36,
      child: ElevatedButton(
        onPressed: onCreatePrivilege,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF030213),
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.addIcon.path,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Create Privilege',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
