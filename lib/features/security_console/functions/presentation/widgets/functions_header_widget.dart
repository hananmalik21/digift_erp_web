import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../providers/functions_provider.dart';
import 'create_function_dialog.dart';

class FunctionsHeader extends ConsumerWidget {
  final bool isMobile;

  const FunctionsHeader({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.icons.functionsIcon.path,
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  Color(0xFF9810FA),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Functions',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.4,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage system functions and capabilities across all modules',
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
              Expanded(child: FunctionsRefreshButton(isDark: isDark)),
              const SizedBox(width: 8),
              Expanded(child: FunctionsCreateButton(isDark: isDark)),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: SvgPicture.asset(
            Assets.icons.functionsIcon.path,
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(Color(0xFF9810FA), BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Functions',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.4,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                  height: 1.56,
                ),
              ),
              Text(
                'Manage system functions and capabilities across all modules',
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
        FunctionsRefreshButton(isDark: isDark),
        const SizedBox(width: 8),
        FunctionsCreateButton(isDark: isDark),
      ],
    );
  }
}

class FunctionsRefreshButton extends ConsumerWidget {
  final bool isDark;

  const FunctionsRefreshButton({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final functionsState = ref.watch(functionsProvider);
    final functionsNotifier = ref.read(functionsProvider.notifier);
    return SizedBox(
      width: 108.98,
      height: 36,
      child: OutlinedButton(
        onPressed: functionsState.isLoading
            ? null
            : () => functionsNotifier.refresh(),
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? context.themeCardBackground : Colors.white,
          foregroundColor: isDark ? Colors.white : const Color(0xFF0F172B),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (functionsState.isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.white : const Color(0xFF0F172B),
                  ),
                ),
              )
            else
              SvgPicture.asset(
                Assets.icons.refreshIcon.path,
                colorFilter: ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
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

class FunctionsCreateButton extends StatelessWidget {
  final bool isDark;

  const FunctionsCreateButton({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 161.21,
      height: 36,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CreateFunctionDialog(),
          );
        },
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
              'Create Function',
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
