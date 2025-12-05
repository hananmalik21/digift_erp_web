import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/user_account_model.dart';

class UserAccountDetailDialog extends StatelessWidget {
  final UserAccountModel user;

  const UserAccountDetailDialog({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: isMobile ? size.width * 0.9 : 700,
        constraints: BoxConstraints(
          maxHeight: size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: context.themeCardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.themeCardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, l10n, isMobile),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfo(context, l10n, isMobile),
                    const SizedBox(height: 24),
                    _buildSecurityInfo(context, l10n, isMobile),
                    const SizedBox(height: 24),
                    _buildSessionHistory(context, l10n),
                  ],
                ),
              ),
            ),
            _buildFooter(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.themeCardBorder),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              Assets.icons.userManagementIcon.path,
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.accountDetails,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: context.themeTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.themeTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: context.themeTextTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, AppLocalizations l10n, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.themeCardBackgroundGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.themeBorderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.userInformation,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              children: [
                _buildInfoRow(l10n.userID, user.userId, context),
                const SizedBox(height: 12),
                _buildInfoRow(l10n.emailAddress, user.email, context),
                const SizedBox(height: 12),
                _buildInfoRow(l10n.department, user.department, context),
                const SizedBox(height: 12),
                _buildInfoRow(l10n.position, user.position, context),
                const SizedBox(height: 12),
                _buildInfoRow(l10n.accountStatus, user.status, context),
                const SizedBox(height: 12),
                _buildInfoRow(
                  l10n.mfaStatus,
                  user.mfaEnabled ? l10n.enabled : l10n.disabled,
                  context,
                ),
              ],
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(l10n.userID, user.userId, context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoRow(l10n.emailAddress, user.email, context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(l10n.department, user.department, context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoRow(l10n.position, user.position, context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(l10n.accountStatus, user.status, context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoRow(
                        l10n.mfaStatus,
                        user.mfaEnabled ? l10n.enabled : l10n.disabled,
                        context,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSecurityInfo(BuildContext context, AppLocalizations l10n, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.themeCardBackgroundGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.themeBorderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.securityInformation,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(l10n.assignedRoles, user.roles.join(', '), context),
          const SizedBox(height: 12),
          if (isMobile)
            Column(
              children: [
                _buildInfoRow(l10n.lastLogin, user.lastLogin, context),
                const SizedBox(height: 12),
                _buildInfoRow(l10n.accountCreated, user.createdDate, context),
                const SizedBox(height: 12),
                _buildInfoRow(l10n.passwordLastChanged, user.passwordChanged, context),
                const SizedBox(height: 12),
                _buildInfoRow(l10n.failedAttempts, '0', context),
              ],
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(l10n.lastLogin, user.lastLogin, context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoRow(l10n.accountCreated, user.createdDate, context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(l10n.passwordLastChanged, user.passwordChanged, context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoRow(l10n.failedAttempts, '0', context),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSessionHistory(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.sessionHistory,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.themeTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildSessionRow('2024-03-15 14:30', '192.168.1.1', 'Windows', 'Dubai', '2h 15m', context, l10n),
        const SizedBox(height: 8),
        _buildSessionRow('2024-03-14 09:15', '192.168.1.5', 'iPhone', 'Dubai', '45m', context, l10n),
        const SizedBox(height: 8),
        _buildSessionRow('2024-03-13 16:45', '192.168.1.1', 'Windows', 'Dubai', '3h 20m', context, l10n),
      ],
    );
  }

  Widget _buildSessionRow(
    String date,
    String ip,
    String device,
    String location,
    String duration,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.themeCardBackgroundGrey,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.themeBorderGrey),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildSmallInfoColumn(l10n.date, date, context),
          ),
          Expanded(
            flex: 2,
            child: _buildSmallInfoColumn(l10n.ipAddress, ip, context),
          ),
          Expanded(
            child: _buildSmallInfoColumn(l10n.device, device, context),
          ),
          Expanded(
            child: _buildSmallInfoColumn(l10n.location, location, context),
          ),
          Expanded(
            child: _buildSmallInfoColumn(l10n.duration, duration, context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context) {
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
        ),
      ],
    );
  }

  Widget _buildSmallInfoColumn(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: context.themeTextTertiary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: context.themeTextPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: context.themeCardBorder),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(l10n.close),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(l10n.edit),
          ),
        ],
      ),
    );
  }
}


