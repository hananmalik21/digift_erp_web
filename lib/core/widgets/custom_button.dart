import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final IconData? icon;
  final String? svgIcon;
  final double? width;
  final double? height;
  final String? loadingText;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.icon,
    this.svgIcon,
    this.width,
    this.height,
    this.loadingText,
  });

  factory CustomButton.primary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgIcon,
    double? width,
    double? height,
    String? loadingText,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isPrimary: true,
      icon: icon,
      svgIcon: svgIcon,
      width: width,
      height: height,
      loadingText: loadingText,
    );
  }

  factory CustomButton.outlined({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgIcon,
    double? width,
    double? height,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isPrimary: false,
      icon: icon,
      svgIcon: svgIcon,
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonHeight = height ?? 42.0;

    Widget buttonChild;

    if (isLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isPrimary ? Colors.white : AppColors.primary,
              ),
            ),
          ),
          if (loadingText != null) ...[
            const SizedBox(width: 8),
            Text(
              loadingText ?? '',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isPrimary ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ],
      );
    } else {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 8),
          ],
          if (svgIcon != null) ...[
            SvgPicture.asset(
              svgIcon!,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                isPrimary ? Colors.white : AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: isPrimary
          ? ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: buttonChild,
            )
          : OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : AppColors.textPrimary,
                backgroundColor: isDark
                    ? AppColors.cardBackgroundDark
                    : Colors.white,
                side: BorderSide(
                  color: isDark
                      ? AppColors.borderGreyDark
                      : AppColors.borderGrey,
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: buttonChild,
            ),
    );
  }
}

