import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

extension ThemeColorsExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Background colors
  Color get themeBackground =>
      isDark ? AppColors.backgroundDark : AppColors.background;

  Color get themeCardBackground =>
      isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;

  Color get themeCardBackgroundGrey => isDark
      ? AppColors.cardBackgroundGreyDark
      : AppColors.cardBackgroundGrey;

  // Text colors
  Color get themeTextPrimary =>
      isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

  Color get themeTextSecondary =>
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

  Color get themeTextTertiary =>
      isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;

  Color get themeTextMuted =>
      isDark ? AppColors.textMutedDark : AppColors.textMuted;

  Color get themeTextPlaceholder =>
      isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder;

  // Border colors
  Color get themeBorderGrey =>
      isDark ? AppColors.borderGreyDark : AppColors.borderGrey;

  Color get themeCardBorder =>
      isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

  // State colors backgrounds
  Color get themeSuccessBg =>
      isDark ? AppColors.successBgDark : AppColors.successBg;

  Color get themeWarningBg =>
      isDark ? AppColors.warningBgDark : AppColors.warningBg;

  Color get themeErrorBg =>
      isDark ? AppColors.errorBgDark : AppColors.errorBg;

  Color get themeInfoBg => isDark ? AppColors.infoBgDark : AppColors.infoBg;

  Color get themePurpleBg =>
      isDark ? AppColors.purpleBgDark : AppColors.purpleBg;

  // State colors borders
  Color get themeSuccessBorder =>
      isDark ? AppColors.successBorderDark : AppColors.successBorder;

  Color get themeWarningBorder =>
      isDark ? AppColors.warningBorderDark : AppColors.warningBorder;

  Color get themeErrorBorder =>
      isDark ? AppColors.errorBorderDark : AppColors.errorBorder;

  Color get themeInfoBorder =>
      isDark ? AppColors.infoBorderDark : AppColors.infoBorder;

  Color get themePurpleBorder =>
      isDark ? AppColors.purpleBorderDark : AppColors.purpleBorder;

  // State colors text
  Color get themeSuccessText =>
      isDark ? AppColors.successTextDark : AppColors.successText;

  Color get themeWarningText =>
      isDark ? AppColors.warningTextDark : AppColors.warningText;

  Color get themeErrorText =>
      isDark ? AppColors.errorTextDark : AppColors.errorText;

  Color get themeInfoText =>
      isDark ? AppColors.infoTextDark : AppColors.infoText;

  Color get themePurpleText =>
      isDark ? AppColors.purpleTextDark : AppColors.purpleText;

  // Specific UI colors
  Color get themeBlueBg =>
      isDark ? AppColors.infoBgDark : AppColors.infoBg;
}

