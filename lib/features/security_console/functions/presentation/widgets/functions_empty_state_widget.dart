import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_extensions.dart';

class FunctionsEmptyState extends StatelessWidget {
  final bool isDark;

  const FunctionsEmptyState({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxTableHeight = (size.height - 500).clamp(300.0, 600.0);

    return Container(
      height: maxTableHeight,
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Center(
        child: Text(
          'No functions found',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.3,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
          ),
        ),
      ),
    );
  }
}
