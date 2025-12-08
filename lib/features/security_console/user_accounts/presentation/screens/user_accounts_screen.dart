import 'package:digify_erp/core/widgets/custom_text_field.dart';
import 'package:digify_erp/core/widgets/filter_pill_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/user_account_model.dart';

class UserAccountsScreen extends StatefulWidget {
  const UserAccountsScreen({super.key});

  @override
  State<UserAccountsScreen> createState() => _UserAccountsScreenState();
}

class _UserAccountsScreenState extends State<UserAccountsScreen> {
  final _searchController = TextEditingController();
  String _selectedType = 'All Types';
  String _selectedStatus = 'All Status';
  late List<UserAccountModel> _filteredUsers;

  @override
  void initState() {
    super.initState();
    _filteredUsers = List.of(sampleUserAccounts);
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredUsers = sampleUserAccounts.where((user) {
        final matchesSearch =
            query.isEmpty ||
            user.name.toLowerCase().contains(query) ||
            user.username.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query);
        final matchesStatus =
            _selectedStatus == 'All Status' || user.status == _selectedStatus;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

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
            _buildStatsRow(context, l10n, isDark, isMobile, isTablet),
            const SizedBox(height: 24),
            _buildSearchAndFilters(context, l10n, isDark, isMobile),
            const SizedBox(height: 24),
            _buildUsersList(context, l10n, isDark, isMobile),
            const SizedBox(height: 24),
            _buildFooter(context, l10n, isDark),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          Assets.icons.userManagementIcon.path,
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
                l10n.userAccounts,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  height: 24 / 15.3,
                  color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),
              Text(
                'Manage user authentication and account security settings',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.1,
                  fontWeight: FontWeight.w400,
                  height: 24 / 15.1,
                  color: Color(0xFF4A5565),
                ),
              ),
            ],
          ),
        ),
        if (!isMobile) ...[
          const SizedBox(width: 16),
          _buildCreateAccountButton(context, l10n, isDark),
        ],
      ],
    );
  }

  Widget _buildCreateAccountButton(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return InkWell(
      onTap: () {
        context.push('/dashboard/security/user-accounts/create');
      },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF030213),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              l10n.createAccount,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7,
                fontWeight: FontWeight.w500,
                height: 20 / 13.7,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    final activeCount = sampleUserAccounts
        .where((u) => u.status == 'Active')
        .length;
    final lockedCount = sampleUserAccounts
        .where((u) => u.status == 'Locked')
        .length;
    final mfaCount = sampleUserAccounts.where((u) => u.mfaEnabled).length;
    final passwordIssues = 0;

    final stats = [
      {
        'label': 'Total Accounts',
        'value': '${sampleUserAccounts.length}',
        'valueColor': isDark ? Colors.white : const Color(0xFF0A0A0A),
        'borderColor': Colors.transparent,
      },
      {
        'label': l10n.active,
        'value': '$activeCount',
        'valueColor': const Color(0xFF00A63E),
        'borderColor': const Color(0xFF00A63E),
      },
      {
        'label': 'Locked',
        'value': '$lockedCount',
        'valueColor': const Color(0xFFE7000B),
        'borderColor': const Color(0xFFE7000B),
      },
      {
        'label': 'MFA Enabled',
        'value': '$mfaCount',
        'valueColor': const Color(0xFF155DFC),
        'borderColor': const Color(0xFF155DFC),
      },
      {
        'label': 'Password Issues',
        'value': '$passwordIssues',
        'valueColor': const Color(0xFFF54900),
        'borderColor': const Color(0xFFF54900),
      },
    ];

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard(context, stats[0], isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(context, stats[1], isDark)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard(context, stats[2], isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(context, stats[3], isDark)),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatCard(context, stats[4], isDark),
        ],
      );
    }

    if (isTablet) {
      return Column(
        children: [
          Row(
            children: stats.sublist(0, 3).map((stat) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: stat == stats[2] ? 0 : 12),
                  child: _buildStatCard(context, stat, isDark),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: stats.sublist(3).map((stat) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: stat == stats.last ? 0 : 12),
                  child: _buildStatCard(context, stat, isDark),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: stat == stats.last ? 0 : 12),
            child: _buildStatCard(context, stat, isDark),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    Map<String, dynamic> stat,
    bool isDark,
  ) {
    final hasBorder = stat['borderColor'] != Colors.transparent;

    return Container(
      height: 114,
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            if (hasBorder)
              Container(width: 4, color: stat['borderColor'] as Color),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: hasBorder ? 12 : 16,
                  right: 16,
                  top: 16,
                  bottom: 16,
                ),
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
                    ),
                    const SizedBox(height: 16),
                    Text(
                      stat['value'] as String,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        height: 32 / 24,
                        color: stat['valueColor'] as Color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    return Container(
      height: isMobile ? null : 76,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: isMobile
          ? Column(
              children: [
                _buildSearchField(context, isDark),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTypeDropdown(context, isDark)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatusDropdown(context, isDark)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildMoreFiltersButton(context, l10n, isDark),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildSearchField(context, isDark)),
                const SizedBox(width: 16),
                SizedBox(
                  width: 140,
                  child: _buildTypeDropdown(context, isDark),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 140,
                  child: _buildStatusDropdown(context, isDark),
                ),
                const SizedBox(width: 16),
                _buildMoreFiltersButton(context, l10n, isDark),
              ],
            ),
    );
  }

  Widget _buildSearchField(BuildContext context, bool isDark) {
    return Expanded(
      child: CustomTextField.search(
        controller: _searchController,
        hintText: 'Search accounts by username, name, or email...',
      ),
    );
  }
  Widget _buildTypeDropdown(BuildContext context, bool isDark) {
    return FilterPillDropdown(
      value: _selectedType,
      items: const ['All Types', 'Local', 'SSO'],
      isDark: isDark,
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _selectedType = value;
          _filterUsers();
        });
      },
    );
  }

  Widget _buildStatusDropdown(BuildContext context, bool isDark) {
    return FilterPillDropdown(
      value: _selectedStatus,
      items: const ['All Status', 'Active', 'Inactive', 'Locked'],
      isDark: isDark,
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _selectedStatus = value;
          _filterUsers();
        });
      },
    );
  }

  Widget _buildMoreFiltersButton(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD1D5DC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.tune,
            size: 16,
            color: isDark ? Colors.white : const Color(0xFF0A0A0A),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.moreFilters,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              color: isDark ? Colors.white : const Color(0xFF0A0A0A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    if (_filteredUsers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: context.themeTextTertiary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noUsersFound,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.themeTextPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _filteredUsers.map((user) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildUserCard(context, user, isDark, isMobile),
        );
      }).toList(),
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    UserAccountModel user,
    bool isDark,
    bool isMobile,
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
          // Top row: Avatar, name, badges, action buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFDBEAFE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.userManagementIcon.path,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF155DFC),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and username
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.3,
                            fontWeight: FontWeight.w400,
                            height: 24 / 15.3,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172B),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Badges
                        _buildBadge(
                          'Local',
                          const Color(0xFF1447E6),
                          const Color(0xFFDBEAFE),
                          const Color(0xFFBEDBFF),
                        ),
                        const SizedBox(width: 8),
                        _buildBadge(
                          user.status,
                          user.status == 'Active'
                              ? const Color(0xFF008236)
                              : const Color(0xFFC10007),
                          user.status == 'Active'
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFFE2E2),
                          user.status == 'Active'
                              ? const Color(0xFFB9F8CF)
                              : const Color(0xFFFFC9C9),
                        ),
                        const SizedBox(width: 8),
                        _buildMfaBadge(user.mfaEnabled),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${user.username}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.7,
                        fontWeight: FontWeight.w400,
                        height: 20 / 13.7,
                        color: Color(0xFF4A5565),
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons
              if (!isMobile) _buildActionButtons(context, isDark),
            ],
          ),
          const SizedBox(height: 24),
          // Info row
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem('Email', user.email, isDark),
                const SizedBox(height: 12),
                _buildPasswordStatusItem(isDark),
                const SizedBox(height: 12),
                _buildInfoItem('Failed Login Attempts', '0', isDark),
                const SizedBox(height: 12),
                _buildInfoItem('Password Expiry', '3/4/2026', isDark),
                const SizedBox(height: 16),
                _buildActionButtons(context, isDark),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildInfoItem('Email', user.email, isDark),
                ),
                Expanded(flex: 2, child: _buildPasswordStatusItem(isDark)),
                Expanded(
                  flex: 2,
                  child: _buildInfoItem('Failed Login Attempts', '0', isDark),
                ),
                Expanded(
                  flex: 2,
                  child: _buildInfoItem('Password Expiry', '3/4/2026', isDark),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(
    String text,
    Color textColor,
    Color bgColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.8,
          fontWeight: FontWeight.w400,
          height: 16 / 11.8,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildMfaBadge(bool enabled) {
    if (enabled) {
      return _buildBadge(
        'MFA',
        const Color(0xFF008236),
        const Color(0xFFDCFCE7),
        const Color(0xFFB9F8CF),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2E2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFC9C9)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.close, size: 12, color: Color(0xFFC10007)),
          const SizedBox(width: 4),
          const Text(
            'No MFA',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
              color: Color(0xFFC10007),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8,
            fontWeight: FontWeight.w400,
            height: 20 / 13.8,
            color: Color(0xFF6A7282),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w400,
            height: 20 / 13.7,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStatusItem(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password Status',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            height: 20 / 13.5,
            color: Color(0xFF6A7282),
          ),
        ),
        const SizedBox(height: 4),
        _buildBadge(
          'Valid',
          const Color(0xFF008236),
          const Color(0xFFDCFCE7),
          const Color(0xFFB9F8CF),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionIcon(Assets.icons.visibleIcon.path, isDark),
        const SizedBox(width: 24),
        _buildActionIcon(Assets.icons.editIcon.path, isDark),
        const SizedBox(width: 24),
        _buildActionIcon(Assets.icons.refreshIcon.path, isDark),
        const SizedBox(width: 24),
        _buildActionIcon(Assets.icons.deleteIcon.path, isDark),
      ],
    );
  }

  Widget _buildActionIcon(String icon, bool isDark) {
    return InkWell(
      onTap: () {},
      child: SvgPicture.asset(
        icon,
        height: 16,
        width: 16,
        // color: isDark ? const Color(0xFF90A1B9) : const Color(0xFF6A7282),
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark
            ? context.themeCardBackgroundGrey
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Text(
            'Showing ${_filteredUsers.length} of ${sampleUserAccounts.length} user accounts',
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
    );
  }
}


