import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/theme_extensions.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
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

  const CustomTextField({
    super.key,
    required this.controller,
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
    this.filled = false,
    this.textInputAction,
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
      height: height ?? 42,
      borderRadius: 10,
      fontSize: 15.3,
      filled: filled,
      fillColor: fillColor ?? Color(0xffF3F4F6),
      prefixIcon: const Icon(Icons.search, size: 16),
      textInputAction: TextInputAction.search,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderColor = borderColor ??
        (isDark ? context.themeBorderGrey : AppColors.borderGrey);
    final effectiveFocusedBorderColor =
        focusedBorderColor ?? AppColors.primary;
    final effectiveFillColor = fillColor ??
        (filled
            ? (isDark ? context.themeCardBackground : Colors.white)
            : (isDark ? context.themeCardBackground : Colors.white));

    Widget textField = TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: obscureText ? 1 : maxLines,
      textInputAction: textInputAction,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: fontSize ?? 15.3,
        fontWeight: FontWeight.w400,
        color: isDark ? context.themeTextPrimary : const Color(0xFF0A0A0A),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: effectiveFillColor,
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: fontSize ?? 15.3,
          fontWeight: FontWeight.w400,
          color: isDark
              ? context.themeTextMuted
              : const Color(0xFF0A0A0A).withOpacity(0.5),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 16,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: height != null ? (height! - 24) / 2 : 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          borderSide: BorderSide(
            color: effectiveFocusedBorderColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
      ),
    );

    if (height != null) {
      return SizedBox(
        height: height,
        child: textField,
      );
    }

    return textField;
  }
}

