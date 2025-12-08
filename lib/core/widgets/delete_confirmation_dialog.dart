import 'package:flutter/material.dart';
import '../theme/theme_extensions.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? itemName;
  final Future<bool> Function()? onConfirm;
  final bool isLoading;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.itemName,
    this.onConfirm,
    this.isLoading = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? itemName,
    Future<bool> Function()? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: title,
        message: message,
        itemName: itemName,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 24,
      ),
      child: _DeleteConfirmationDialogContent(
        title: title,
        message: message,
        itemName: itemName,
        onConfirm: onConfirm,
        isDark: isDark,
        isMobile: isMobile,
      ),
    );
  }
}

class _DeleteConfirmationDialogContent extends StatefulWidget {
  final String title;
  final String message;
  final String? itemName;
  final Future<bool> Function()? onConfirm;
  final bool isDark;
  final bool isMobile;

  const _DeleteConfirmationDialogContent({
    required this.title,
    required this.message,
    this.itemName,
    this.onConfirm,
    required this.isDark,
    required this.isMobile,
  });

  @override
  State<_DeleteConfirmationDialogContent> createState() =>
      _DeleteConfirmationDialogContentState();
}

class _DeleteConfirmationDialogContentState
    extends State<_DeleteConfirmationDialogContent> {
  bool _isLoading = false;

  Future<void> _handleDelete() async {
    if (widget.onConfirm != null) {
      setState(() => _isLoading = true);
      try {
        final success = await widget.onConfirm!();
        if (mounted) {
          if (success) {
            Navigator.of(context).pop(true);
          } else {
            setState(() => _isLoading = false);
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isMobile ? double.infinity : 400,
      decoration: BoxDecoration(
        color: widget.isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17.3,
                      fontWeight: FontWeight.w600,
                      color: widget.isDark
                          ? Colors.white
                          : const Color(0xFF0F172B),
                      height: 1.04,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isLoading
                      ? null
                      : () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  color: widget.isDark ? Colors.white : const Color(0xFF0F172B),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Message
            Text(
              widget.message,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: widget.isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF717182),
                height: 1.47,
              ),
            ),
            if (widget.itemName != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: widget.isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.itemName!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.6,
                          fontWeight: FontWeight.w500,
                          color: widget.isDark
                              ? Colors.white
                              : const Color(0xFF0F172B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Buttons
            widget.isMobile
                ? Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: _buildDeleteButton(),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: _buildCancelButton(),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildCancelButton(),
                      const SizedBox(width: 8),
                      _buildDeleteButton(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: widget.isMobile ? double.infinity : 79.35,
      height: 36,
      child: OutlinedButton(
        onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
        style: OutlinedButton.styleFrom(
          backgroundColor:
              widget.isDark ? context.themeCardBackground : Colors.white,
          foregroundColor:
              widget.isDark ? Colors.white : const Color(0xFF0F172B),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w500,
            color: widget.isDark ? Colors.white : const Color(0xFF0F172B),
            height: 1.46,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: widget.isMobile ? double.infinity : 161.21,
      height: 36,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleDelete,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDC2626),
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Delete',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.8,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                ),
              ),
      ),
    );
  }
}

