import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/user_account_model.dart';
import 'user_account_detail_dialog.dart';

class UserAccountCard extends StatefulWidget {
  final UserAccountModel user;
  final bool isMobile;

  const UserAccountCard({
    super.key,
    required this.user,
    required this.isMobile,
  });

  @override
  State<UserAccountCard> createState() => _UserAccountCardState();
}

class _UserAccountCardState extends State<UserAccountCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isHovered
              ? context.themeCardBackground.withValues(alpha: 0.5)
              : context.themeCardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.3)
                : context.themeCardBorder,
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: widget.isMobile ? 20 : 24,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    widget.user.name[0],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: TextStyle(
                          fontSize: widget.isMobile ? 15 : 16,
                          fontWeight: FontWeight.w600,
                          color: context.themeTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${widget.user.username}',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.themeTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _HoverActionIcon(
                      icon: Assets.icons.visibleIcon.path,
                      hoverColor: AppColors.info,
                      isParentHovered: _isHovered,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => UserAccountDetailDialog(
                            user: widget.user,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _HoverActionIcon(
                      icon: Assets.icons.editIcon.path,
                      hoverColor: AppColors.success,
                      isParentHovered: _isHovered,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _HoverActionIcon(
                      icon: Assets.icons.refreshIcon.path,
                      hoverColor: AppColors.warning,
                      isParentHovered: _isHovered,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _HoverActionIcon(
                      icon: Assets.icons.lockIcon.path,
                      hoverColor: AppColors.error,
                      isParentHovered: _isHovered,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.isMobile)
              _buildMobileDetails(context, l10n)
            else
              _buildDesktopDetails(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileDetails(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailColumn(
                l10n.userID,
                "widget.user.userId",
                context,
              ),
            ),
            Expanded(
              child: _buildDetailColumn(
                l10n.department,
                widget.user.department,
                context,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDetailColumn(
                l10n.emailAddress,
                widget.user.email,
                context,
              ),
            ),
            Expanded(
              child: _buildDetailColumn(
                l10n.position,
                widget.user.position,
                context,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatusTag(widget.user.status, context)),
            const SizedBox(width: 8),
            Expanded(child: _buildMfaTag(widget.user.mfaEnabled, context, l10n)),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopDetails(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildDetailColumn(
            l10n.userID,
            "widget.user.userId",
            context,
          ),
        ),
        Expanded(
          flex: 3,
          child: _buildDetailColumn(
            l10n.emailAddress,
            widget.user.email,
            context,
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildDetailColumn(
            l10n.department,
            widget.user.department,
            context,
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildDetailColumn(
            l10n.position,
            widget.user.position,
            context,
          ),
        ),
        Expanded(
          child: _buildStatusTag(widget.user.status, context),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMfaTag(widget.user.mfaEnabled, context, l10n),
        ),
      ],
    );
  }

  Widget _buildDetailColumn(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: context.themeTextTertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.themeTextPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatusTag(String status, BuildContext context) {
    final isActive = status == 'Active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.successBg : context.themeCardBackgroundGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppColors.successBorder : context.themeBorderGrey,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive ? AppColors.successText : context.themeTextTertiary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMfaTag(bool enabled, BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: enabled ? AppColors.successBg : context.themeErrorBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? AppColors.successBorder : context.themeErrorBorder,
        ),
      ),
      child: Text(
        enabled ? 'MFA' : 'No MFA',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: enabled ? AppColors.successText : AppColors.errorText,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _HoverActionIcon extends StatefulWidget {
  final String icon;
  final Color hoverColor;
  final VoidCallback onTap;
  final bool isParentHovered;

  const _HoverActionIcon({
    required this.icon,
    required this.hoverColor,
    required this.onTap,
    required this.isParentHovered,
  });

  @override
  State<_HoverActionIcon> createState() => _HoverActionIconState();
}

class _HoverActionIconState extends State<_HoverActionIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        decoration: BoxDecoration(
          color: widget.isParentHovered
              ? widget.hoverColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: SvgPicture.asset(
            widget.icon,
            width: 16,
            height: 16,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              widget.isParentHovered
                  ? widget.hoverColor
                  : context.themeTextTertiary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}


