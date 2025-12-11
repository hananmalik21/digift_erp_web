import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../theme/theme_extensions.dart';

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
  final bool isEditMode; // For showing edit icon instead of add icon
  final bool isDisabled; // Explicit disabled state

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
    this.isEditMode = false,
    this.isDisabled = false,
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
    final disabled = isDisabled || isLoading || onPressed == null;
    
    // Icon color based on disabled state
    final iconColor = disabled 
        ? const Color(0xFF9CA3AF) 
        : (isPrimary ? Colors.white : (isDark ? Colors.white : AppColors.textPrimary));
    
    // Text color based on disabled state
    final textColor = disabled 
        ? const Color(0xFF9CA3AF) 
        : (isPrimary ? Colors.white : (isDark ? Colors.white : AppColors.textPrimary));

    Widget buttonChild;

    if (isLoading) {
      buttonChild = SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isPrimary ? Colors.white : AppColors.primary,
          ),
        ),
      );
    } else {
      // Determine which icon to show
      String? effectiveSvgIcon = svgIcon;
      if (isEditMode && svgIcon == null && icon == null) {
        effectiveSvgIcon = Assets.icons.editIcon.path;
      } else if (!isEditMode && isPrimary && svgIcon == null && icon == null) {
        effectiveSvgIcon = Assets.icons.addIcon.path;
      }

      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 8),
          ],
          if (effectiveSvgIcon != null) ...[
            SvgPicture.asset(
              effectiveSvgIcon,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: height != null && height! <= 36 ? 13.8 : 15,
                fontWeight: FontWeight.w500,
                height: height != null && height! <= 36 ? 1.45 : null,
                color: textColor,
              ),
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
              onPressed: disabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: disabled
                    ? const Color(0xFF030213).withValues(alpha: 0.5)
                    : const Color(0xFF030213),
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: buttonChild,
            )
          : OutlinedButton(
              onPressed: disabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                backgroundColor: isDark 
                    ? context.themeCardBackground 
                    : Colors.white,
                side: BorderSide(
                  color: Colors.black.withValues(alpha: 0.1),
                ),
                padding: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: buttonChild,
            ),
    );
  }
}

