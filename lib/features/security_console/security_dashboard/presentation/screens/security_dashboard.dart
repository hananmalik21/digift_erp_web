import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../gen/assets.gen.dart';

class SecurityDashboard extends StatelessWidget {
  const SecurityDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return Scaffold(
      backgroundColor: isDark
          ? context.themeBackground
          : const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, l10n, isDark, isMobile),
            const SizedBox(height: 24),
            _buildTopStatsCards(context, l10n, isDark, isMobile, isTablet),
            const SizedBox(height: 24),
            _buildMiddleSection(context, l10n, isDark, isMobile),
            const SizedBox(height: 24),
            _buildBottomSection(context, l10n, isDark, isMobile, isTablet),
            const SizedBox(height: 24),
            _buildFooterStats(context, l10n, isDark, isMobile, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.icons.securityConsoleIcon.path,
          width: 32,
          height: 32,
          colorFilter: const ColorFilter.mode(
            Color(0xFF155DFC),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.securityDashboard,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 14 : 15.3,
                  fontWeight: FontWeight.w400,
                  height: 24 / 15.3,
                  color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),
              Text(
                l10n.securityOverview,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 13 : 15.3,
                  fontWeight: FontWeight.w400,
                  height: 24 / 15.3,
                  color: const Color(0xFF4A5565),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopStatsCards(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    final stats = [
      {
        'value': '1,247',
        'label': l10n.totalUsers,
        'subText1': '1189 Active',
        'subColor1': const Color(0xFF00A63E),
        'subText2': '58 Inactive',
        'subColor2': const Color(0xFF4A5565),
        'iconBgColor': const Color(0xFFDBEAFE),
        'iconPath': Assets.icons.userManagementIcon.path,
        'iconColor': const Color(0xFF155DFC),
        'borderColor': const Color(0xFF155DFC),
      },
      {
        'value': '156',
        'label': l10n.totalRoles,
        'subText1': '89 Custom',
        'subColor1': const Color(0xFF9810FA),
        'subText2': '67 Standard',
        'subColor2': const Color(0xFF4A5565),
        'iconBgColor': const Color(0xFFF3E8FF),
        'iconPath': Assets.icons.roleTermplate.path,
        'iconColor': const Color(0xFF9810FA),
        'borderColor': const Color(0xFF9810FA),
      },
      {
        'value': '342',
        'label': l10n.activeSessions,
        'subText1': '+15% vs yesterday',
        'subColor1': const Color(0xFF00A63E),
        'subText2': '',
        'subColor2': Colors.transparent,
        'iconBgColor': const Color(0xFFDCFCE7),
        'iconPath': Assets.icons.activeSessionIcon.path,
        'iconColor': const Color(0xFF00A63E),
        'borderColor': const Color(0xFF00A63E),
        'showArrow': true,
      },
      {
        'value': '3',
        'label': l10n.securityIncidents,
        'subText1': '12 Failed Logins',
        'subColor1': const Color(0xFFE7000B),
        'subText2': '',
        'subColor2': Colors.transparent,
        'iconBgColor': const Color(0xFFFFE2E2),
        'iconPath': Assets.icons.dangerIcon.path,
        'iconColor': const Color(0xFFE7000B),
        'borderColor': const Color(0xFFE7000B),
      },
    ];

    if (isMobile) {
      return Column(
        children: stats.map((stat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildTopStatCard(context, stat, isDark),
          );
        }).toList(),
      );
    }

    if (isTablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.2,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) =>
            _buildTopStatCard(context, stats[index], isDark),
      );
    }

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: stat == stats.last ? 0 : 16),
            child: _buildTopStatCard(context, stat, isDark),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopStatCard(
    BuildContext context,
    Map<String, dynamic> stat,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                color: stat['borderColor'] as Color,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: stat['iconBgColor'] as Color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              stat['iconPath'] as String,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                stat['iconColor'] as Color,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              stat['value'] as String,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 22.7,
                                fontWeight: FontWeight.w400,
                                height: 32 / 22.7,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0A0A0A),
                              ),
                            ),
                            Text(
                              stat['label'] as String,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.6,
                                fontWeight: FontWeight.w400,
                                height: 20 / 13.6,
                                color: Color(0xFF4A5565),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (stat['showArrow'] == true) ...[
                          SvgPicture.asset(
                            Assets.icons.priceUp.path,
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              stat['subColor1'] as Color,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          stat['subText1'] as String,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.7,
                            fontWeight: FontWeight.w400,
                            height: 20 / 13.7,
                            color: stat['subColor1'] as Color,
                          ),
                        ),
                        if ((stat['subText2'] as String).isNotEmpty) ...[
                          const SizedBox(width: 8),
                          const Text(
                            '•',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF99A1AF),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            stat['subText2'] as String,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.7,
                              fontWeight: FontWeight.w400,
                              height: 20 / 13.7,
                              color: stat['subColor2'] as Color,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildMiddleSection(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    if (isMobile) {
      return Column(
        children: [
          _buildSecurityAlertsCard(context, l10n, isDark),
          const SizedBox(height: 16),
          _buildRecentActivitiesCard(context, l10n, isDark),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildSecurityAlertsCard(context, l10n, isDark)),
        const SizedBox(width: 16),
        Expanded(child: _buildRecentActivitiesCard(context, l10n, isDark)),
      ],
    );
  }

  Widget _buildSecurityAlertsCard(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final alerts = [
      {
        'title': 'Unusual Login Activity',
        'description': '5 failed login attempts from external IP',
        'time': '10 mins ago',
        'severity': 'HIGH',
        'severityColor': const Color(0xFFC10007),
        'severityBgColor': const Color(0xFFFFE2E2),
        'severityBorderColor': const Color(0xFFFFC9C9),
        'iconPath': Assets.icons.dangerIcon.path,
        'iconColor': const Color(0xFFE7000B),
      },
      {
        'title': 'Password Policy Violation',
        'description': '12 users have weak passwords',
        'time': '1 hour ago',
        'severity': 'MEDIUM',
        'severityColor': const Color(0xFFCA3500),
        'severityBgColor': const Color(0xFFFFEDD4),
        'severityBorderColor': const Color(0xFFFFD6A7),
        'iconPath': Assets.icons.orangeDangerIcon.path,
        'iconColor': const Color(0xFFCA3500),
      },
      {
        'title': 'Inactive User Accounts',
        'description': '23 users inactive for 90+ days',
        'time': '2 hours ago',
        'severity': 'LOW',
        'severityColor': const Color(0xFF1447E6),
        'severityBgColor': const Color(0xFFDBEAFE),
        'severityBorderColor': const Color(0xFFBEDBFF),
        'iconPath': Assets.icons.warningIcon.path,
        'iconColor': const Color(0xFF1447E6),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.securityAlerts,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.9,
                  fontWeight: FontWeight.w400,
                  height: 28 / 16.9,
                  color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),
              _buildViewAllButton(context, isDark),
            ],
          ),
          const SizedBox(height: 24),
          ...alerts.map((alert) => _buildAlertItem(context, alert, isDark)),
        ],
      ),
    );
  }

  Widget _buildAlertItem(
    BuildContext context,
    Map<String, dynamic> alert,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? context.themeCardBackgroundGrey
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                alert['iconPath'] as String,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  alert['iconColor'] as Color,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  alert['title'] as String,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.3,
                    fontWeight: FontWeight.w400,
                    height: 24 / 15.3,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: alert['severityBgColor'] as Color,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: alert['severityBorderColor'] as Color,
                  ),
                ),
                child: Text(
                  alert['severity'] as String,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                    color: alert['severityColor'] as Color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            alert['description'] as String,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              height: 20 / 13.6,
              color: Color(0xFF4A5565),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                alert['time'] as String,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                  color: Color(0xFF6A7282),
                ),
              ),
              _buildInvestigateButton(context, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvestigateButton(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.visibility_outlined,
            size: 16,
            color: isDark ? Colors.white : const Color(0xFF0A0A0A),
          ),
          const SizedBox(width: 8),
          Text(
            'Investigate',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w500,
              height: 20 / 13.7,
              color: isDark ? Colors.white : const Color(0xFF0A0A0A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesCard(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final activities = [
      {
        'type': 'User Created',
        'typeColor': const Color(0xFF1447E6),
        'typeBgColor': const Color(0xFFDBEAFE),
        'typeBorderColor': const Color(0xFFBEDBFF),
        'description': 'Created user account for Jane Smith',
        'actor': 'By: System Admin',
        'time': '5 mins ago',
      },
      {
        'type': 'Role Modified',
        'typeColor': const Color(0xFFCA3500),
        'typeBgColor': const Color(0xFFFFEDD4),
        'typeBorderColor': const Color(0xFFFFD6A7),
        'description': 'Updated permissions for Finance Manager role',
        'actor': 'By: Security Manager',
        'time': '15 mins ago',
      },
      {
        'type': 'Failed Login',
        'typeColor': const Color(0xFFC10007),
        'typeBgColor': const Color(0xFFFFE2E2),
        'typeBorderColor': const Color(0xFFFFC9C9),
        'description': 'Multiple failed login attempts from IP 192.168.1.105',
        'actor': 'By: Unknown',
        'time': '1 hour ago',
      },
      {
        'type': 'Data Access',
        'typeColor': const Color(0xFF1447E6),
        'typeBgColor': const Color(0xFFDBEAFE),
        'typeBorderColor': const Color(0xFFBEDBFF),
        'description': 'Accessed confidential financial reports',
        'actor': 'By: John Doe',
        'time': '2 hours ago',
      },
      {
        'type': 'Password Reset',
        'typeColor': const Color(0xFF008236),
        'typeBgColor': const Color(0xFFDCFCE7),
        'typeBorderColor': const Color(0xFFB9F8CF),
        'description': 'Password reset completed successfully',
        'actor': 'By: Mary Johnson',
        'time': '3 hours ago',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recentSecurityActivities,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.9,
                  fontWeight: FontWeight.w400,
                  height: 28 / 16.9,
                  color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),
              _buildViewAllButton(context, isDark),
            ],
          ),
          const SizedBox(height: 24),
          ...activities.map(
            (activity) => _buildActivityItem(context, activity, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    Map<String, dynamic> activity,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? context.themeCardBackgroundGrey
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: activity['typeBgColor'] as Color,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: activity['typeBorderColor'] as Color),
            ),
            child: Text(
              activity['type'] as String,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.8,
                fontWeight: FontWeight.w400,
                height: 16 / 11.8,
                color: activity['typeColor'] as Color,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            activity['description'] as String,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              height: 20 / 13.6,
              color: Color(0xFF4A5565),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                activity['actor'] as String,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.8,
                  fontWeight: FontWeight.w400,
                  height: 14 / 11.8,
                  color: Color(0xFF6A7282),
                ),
              ),
              Text(
                activity['time'] as String,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                  color: Color(0xFF6A7282),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    if (isMobile) {
      return Column(
        children: [
          _buildQuickActionsCard(context, l10n, isDark),
          const SizedBox(height: 16),
          _buildComplianceStatusCard(context, l10n, isDark),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isTablet ? 280 : 320,
          child: _buildQuickActionsCard(context, l10n, isDark),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildComplianceStatusCard(context, l10n, isDark)),
      ],
    );
  }

  Widget _buildQuickActionsCard(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quickActions,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              fontWeight: FontWeight.w400,
              height: 28 / 17,
              color: isDark ? Colors.white : const Color(0xFF0A0A0A),
            ),
          ),
          const SizedBox(height: 24),
          _buildQuickActionButton(
            context,
            l10n.createUser,
            Icons.person_add_outlined,
            true,
            isDark,
          ),
          const SizedBox(height: 8),
          _buildQuickActionButton(
            context,
            l10n.createRole,
            Icons.add_circle_outline,
            false,
            isDark,
          ),
          const SizedBox(height: 8),
          _buildQuickActionButton(
            context,
            l10n.configureDataSecurity,
            Icons.security_outlined,
            false,
            isDark,
          ),
          const SizedBox(height: 8),
          _buildQuickActionButton(
            context,
            l10n.viewAuditLogs,
            Icons.history_outlined,
            false,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    bool isPrimary,
    bool isDark,
  ) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isPrimary
            ? const Color(0xFF030213)
            : (isDark ? context.themeCardBackground : Colors.white),
        borderRadius: BorderRadius.circular(8),
        border: isPrimary
            ? null
            : Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isPrimary
                      ? Colors.white
                      : (isDark ? Colors.white : const Color(0xFF0A0A0A)),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.7,
                    fontWeight: FontWeight.w500,
                    height: 20 / 13.7,
                    color: isPrimary
                        ? Colors.white
                        : (isDark ? Colors.white : const Color(0xFF0A0A0A)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComplianceStatusCard(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final items = [
      {
        'label': l10n.passwordPolicyCompliance,
        'value': 92,
        'color': const Color(0xFF00C950),
      },
      {
        'label': l10n.multiFactorAuthentication,
        'value': 78,
        'color': const Color(0xFFF0B100),
      },
      {
        'label': l10n.activeUserReview,
        'value': 85,
        'color': const Color(0xFF00C950),
      },
      {
        'label': l10n.segregationOfDuties,
        'value': 95,
        'color': const Color(0xFF00C950),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.complianceStatus,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              fontWeight: FontWeight.w400,
              height: 28 / 17,
              color: isDark ? Colors.white : const Color(0xFF0A0A0A),
            ),
          ),
          const SizedBox(height: 24),
          ...items.map((item) => _buildComplianceItem(context, item, isDark)),
        ],
      ),
    );
  }

  Widget _buildComplianceItem(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['label'] as String,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.6,
                  fontWeight: FontWeight.w400,
                  height: 20 / 13.6,
                  color: Color(0xFF4A5565),
                ),
              ),
              Text(
                '${item['value']}%',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(999),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Container(
                      width:
                          constraints.maxWidth * (item['value'] as int) / 100,
                      decoration: BoxDecoration(
                        color: item['color'] as Color,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterStats(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    final stats = [
      {
        'label': l10n.passwordsExpiring,
        'value': '45',
        'iconPath': Assets.icons.passwordExpiringIcon.path,
        'iconColor': const Color(0xFFCA3500),
      },
      {
        'label': l10n.complianceScore,
        'value': '87%',
        'iconPath': Assets.icons.auditComplianceIcon.path,
        'iconColor': const Color(0xFF00A63E),
      },
      {
        'label': l10n.securityPolicies,
        'value': '34',
        'iconPath': Assets.icons.securityConsoleIcon.path,
        'iconColor': const Color(0xFF155DFC),
      },
      {
        'label': l10n.dataAccessSets,
        'value': '128',
        'iconPath': Assets.icons.lockIcon.path,
        'iconColor': const Color(0xFF9810FA),
      },
    ];

    if (isMobile) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.8,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) =>
            _buildFooterStatCard(context, stats[index], isDark),
      );
    }

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: stat == stats.last ? 0 : 16),
            child: _buildFooterStatCard(context, stat, isDark),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooterStatCard(
    BuildContext context,
    Map<String, dynamic> stat,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            stat['iconPath'] as String,
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              stat['iconColor'] as Color,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat['label'] as String,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    height: 20 / 13.6,
                    color: Color(0xFF4A5565),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  stat['value'] as String,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 23.3,
                    fontWeight: FontWeight.w400,
                    height: 32 / 23.3,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Text(
        'View All',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.7,
          fontWeight: FontWeight.w500,
          height: 20 / 13.7,
          color: isDark ? Colors.white : const Color(0xFF0A0A0A),
        ),
      ),
    );
  }
}
