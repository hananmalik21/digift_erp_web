import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/function_model.dart';
import 'create_function_dialog.dart';

class FunctionDetailsDialog extends StatelessWidget {
  final FunctionModel function;

  const FunctionDetailsDialog({
    super.key,
    required this.function,
  });

  static Future<bool?> show(
    BuildContext context,
    FunctionModel function,
  ) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => FunctionDetailsDialog(function: function),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, isDark),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildSubtitle(isDark),
                    const SizedBox(height: 24),
                    _buildCoreInfo(context, isDark),
                    const SizedBox(height: 24),
                    _buildDescription(isDark),
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),
                    _buildAuditInfo(isDark),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildFooter(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Function Details',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.02,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.2,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(false),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(bool isDark) {
    return Text(
      'View detailed information about this function',
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF717182),
        height: 1.43,
      ),
    );
  }

  Widget _buildCoreInfo(BuildContext context, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                context,
                isDark,
                'Function Code',
                function.code,
                showIcon: false,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                isDark,
                'Module',
                function.module,
                showIcon: true,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Right Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                context,
                isDark,
                'Function Name',
                function.name,
                showIcon: false,
              ),
              const SizedBox(height: 16),
              _buildStatusRow(context, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    bool isDark,
    String label,
    String value, {
    bool showIcon = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF717182),
            height: 1.38,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (showIcon) ...[
              SvgPicture.asset(
                Assets.icons.boxIcon.path,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  isDark ? const Color(0xFF9CA3AF) : const Color(0xFF717182),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.01,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                  height: 1.43,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF717182),
            height: 1.38,
          ),
        ),
        const SizedBox(height: 4),
        _buildBadge(
          isDark,
          function.status,
        ),
      ],
    );
  }

  Widget _buildBadge(bool isDark, String text) {
    final isActive = text == 'Active' || text == 'ACTIVE';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFE6FFEE) // Light green background (matching Figma)
            : (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6)),
        borderRadius: BorderRadius.circular(16),
        border: isActive
            ? Border.all(
                color: const Color(0xFF28A745), // Green border
                width: 1,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive) ...[
            Icon(
              Icons.check_circle,
              size: 14,
              color: const Color(0xFF28A745), // Green icon
            ),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
              color: isActive
                  ? const Color(0xFF28A745) // Green text (matching Figma)
                  : (isDark ? Colors.white : const Color(0xFF0F172B)),
              height: 1.23,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF717182),
            height: 1.38,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          function.description,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
            height: 1.43,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark
          ? const Color(0xFF374151)
          : Colors.black.withValues(alpha: 0.1),
    );
  }

  Widget _buildAuditInfo(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAuditRow(isDark, 'Last Updated By', function.updatedBy),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Right Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAuditRow(isDark, 'Last Updated Date', _formatDate(function.updatedDate)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuditRow(bool isDark, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF717182),
            height: 1.38,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.01,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
            height: 1.43,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark
                ? const Color(0xFF374151)
                : Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              side: BorderSide(
                color: isDark
                    ? const Color(0xFF374151)
                    : Colors.black.withValues(alpha: 0.1),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.transparent,
            ),
            child: Text(
              'Close',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                color: isDark ? Colors.white : const Color(0xFF0F172B),
                height: 1.43,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(false);
              final result = await showDialog(
                context: context,
                builder: (context) => CreateFunctionDialog(function: function),
              );
              if (result == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Function updated successfully'),
                    backgroundColor: Color(0xFF00A63E),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF030213),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'Edit Function',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                    color: Colors.white,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    // Try to parse and format the date
    // If the date is already in a good format, return it as is
    // Otherwise, try to parse common formats
    if (dateString.isEmpty) return 'N/A';
    
    // If it's already in a readable format like "1/15/2024", return as is
    if (dateString.contains('/')) {
      return dateString;
    }
    
    // Try to parse ISO format or other common formats
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      // If parsing fails, return the original string
      return dateString;
    }
  }
}
