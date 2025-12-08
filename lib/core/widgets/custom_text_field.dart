import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/theme_extensions.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final bool filled;
  final TextInputAction? textInputAction;
  final bool showBorder;
  final ValueChanged<String>? onChanged;
  final bool isRequired;
  final bool hasInfoIcon;
  final String? helperText;
  final TextStyle? labelStyle;
  final TextStyle? helperTextStyle;
  final bool expands;
  final String? initialValue;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.filled = true, // default: filled (your design)
    this.textInputAction,
    this.showBorder = true,
    this.onChanged,
    this.isRequired = false,
    this.hasInfoIcon = false,
    this.helperText,
    this.labelStyle,
    this.helperTextStyle,
    this.expands = false,
    this.initialValue,
  });

  factory CustomTextField.search({
    required TextEditingController controller,
    String? hintText,
    double? height,
    bool filled = true,
    Color? fillColor,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      height: height ?? 39,                  // same height
      borderRadius: 8,                       // same radius
      fontSize: 15.3,
      filled: filled,
      fillColor: fillColor ?? Color(0xFFF3F3F5),
      borderColor: const Color(0xFFD1D5DC),
      prefixIcon: const Icon(Icons.search, size: 16),
      textInputAction: TextInputAction.search,
    );
  }

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // your default design constants
  static const double _defaultHeight = 39.0;
  static const double _defaultBorderRadius = 8.0;
  static const Color _defaultBorderColor = Color(0xFFD1D5DC);
  static const Color _defaultFillColor = Color(0xFFF3F3F5);
  static const EdgeInsets _defaultPadding =
  EdgeInsets.fromLTRB(17, 9, 29, 9);

  late TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    if (widget.controller != null && widget.initialValue != null) {
      widget.controller!.text = widget.initialValue!;
    }
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // your fixed design colors (can still override via props)
    final effectiveBorderColor =
        widget.borderColor ?? _defaultBorderColor;
    final effectiveFocusedBorderColor =
        widget.focusedBorderColor ?? AppColors.primary;

    // fill color is always your light grey by default
    final effectiveFillColor = widget.fillColor ?? _defaultFillColor;

    // Build label if provided
    Widget? labelWidget;
    if (widget.labelText != null) {
      labelWidget = SizedBox(
        height: 14,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.labelText!,
              style: widget.labelStyle ??
                  const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                    color: Color(0xFF0A0A0A),
                  ),
            ),
            if (widget.isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  color: Color(0xFFFB2C36),
                ),
              ),
            ],
            if (widget.hasInfoIcon) ...[
              const SizedBox(width: 6),
              const Icon(
                Icons.info_outline,
                size: 12,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ],
        ),
      );
    }

    // Build suffix icon for password visibility toggle
    Widget? effectiveSuffixIcon = widget.suffixIcon;
    if (widget.obscureText && widget.suffixIcon == null) {
      effectiveSuffixIcon = InkWell(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: const Icon(
          Icons.visibility_off_outlined,
          size: 16,
          color: Color(0xFF9CA3AF),
        ),
      );
    }

    Widget textField = TextFormField(
      controller: _controller,
      obscureText: widget.obscureText ? _obscureText : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.expands
          ? null
          : (widget.obscureText ? 1 : widget.maxLines),
      expands: widget.expands,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: widget.fontSize ?? 13.7,
        fontWeight: FontWeight.w400,
        color: isDark
            ? context.themeTextPrimary
            : const Color(0xFF0A0A0A),
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText == null || labelWidget != null
            ? null
            : widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: effectiveSuffixIcon,
        filled: true,
        fillColor: effectiveFillColor,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: widget.fontSize ?? 13.7,
          fontWeight: FontWeight.w400,
          color: isDark
              ? context.themeTextMuted
              : const Color(0xFF717182),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 16,
        ),
        // fixed padding to match CSS: 9px 29px 9px 17px
        contentPadding: _defaultPadding,
        border: widget.showBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              widget.borderRadius ?? _defaultBorderRadius),
          borderSide: BorderSide(color: effectiveBorderColor),
        )
            : InputBorder.none,
        enabledBorder: widget.showBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              widget.borderRadius ?? _defaultBorderRadius),
          borderSide: BorderSide(color: effectiveBorderColor),
        )
            : InputBorder.none,
        focusedBorder: widget.showBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              widget.borderRadius ?? _defaultBorderRadius),
          borderSide: BorderSide(
            color: effectiveFocusedBorderColor,
            width: 1.5,
          ),
        )
            : InputBorder.none,
        errorBorder: widget.showBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              widget.borderRadius ?? _defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.error),
        )
            : InputBorder.none,
        focusedErrorBorder: widget.showBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              widget.borderRadius ?? _defaultBorderRadius),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        )
            : InputBorder.none,
      ),
    );

    // Always enforce your default height if none is provided
    Widget field = SizedBox(
      height: widget.height ?? _defaultHeight,
      child: textField,
    );

    // Add label and helper text if provided
    if (labelWidget != null || widget.helperText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelWidget != null) ...[
            labelWidget,
            const SizedBox(height: 14),
          ],
          field,
          if (widget.helperText != null) ...[
            const SizedBox(height: 12),
            Text(
              widget.helperText!,
              style: widget.helperTextStyle ??
                  const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.8,
                    fontWeight: FontWeight.w400,
                    height: 16 / 11.8,
                    color: Color(0xFF6A7282),
                  ),
            ),
          ],
        ],
      );
    }

    return field;
  }
}
