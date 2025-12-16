import 'dart:async';
import 'package:digify_erp/core/widgets/custom_text_field.dart';
import 'package:digify_erp/core/widgets/filter_pill_dropdown.dart';
import 'package:digify_erp/core/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/user_account_model.dart';
import '../../data/datasources/user_account_remote_datasource.dart';
import '../../data/utils/account_type_mapper.dart';
import '../providers/user_accounts_provider.dart';
import '../services/user_account_service.dart';
import '../../../function_privileges/presentation/widgets/function_privileges_footer_widget.dart';
import '../widgets/user_account_details_dialog.dart';
import '../widgets/reset_password_dialog.dart';

class UserAccountsScreen extends ConsumerStatefulWidget {
  const UserAccountsScreen({super.key});

  @override
  ConsumerState<UserAccountsScreen> createState() => _UserAccountsScreenState();
}

class _UserAccountsScreenState extends ConsumerState<UserAccountsScreen> {
  final _searchController = TextEditingController();
  Timer? _searchDebounceTimer;
  String _selectedType = 'All Types';
  String _selectedStatus = 'All Status';

  // Local provider - autoDispose ensures it's disposed when widget is removed
  final _localUserAccountsProvider = StateNotifierProvider.autoDispose<UserAccountsNotifier, UserAccountsState>(
    (ref) {
      final dataSource = UserAccountRemoteDataSourceImpl();
      return UserAccountsNotifier(dataSource);
    },
  );

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Load users when screen is first displayed or when returning to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_localUserAccountsProvider.notifier).loadUsers();
    });
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      ref.read(_localUserAccountsProvider.notifier).search(query);
    });
  }

  void _onStatusChanged(String? status) {
    if (status == null) return;
    setState(() {
      _selectedStatus = status;
    });
    ref.read(_localUserAccountsProvider.notifier).filterByStatus(
      status == 'All Status' ? null : status,
    );
  }

  void _onTypeChanged(String? type) {
    if (type == null) return;
    setState(() {
      _selectedType = type;
    });
    ref.read(_localUserAccountsProvider.notifier).filterByType(
      type == 'All Types' ? null : type,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_localUserAccountsProvider);
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
            _buildStatsRow(context, l10n, isDark, isMobile, isTablet, state),
            const SizedBox(height: 24),
            _buildSearchAndFilters(context, l10n, isDark, isMobile),
            const SizedBox(height: 24),
            _buildUsersList(context, l10n, isDark, isMobile, state),
            if (state.totalItems > 0) ...[
              const SizedBox(height: 16),
              FunctionPrivilegesFooter(
                isDark: isDark,
                total: state.totalItems,
                showing: state.users.length,
                isLoading: state.isPaginationLoading,
                currentPage: state.currentPage,
                totalPages: state.totalPages,
                hasNextPage: state.hasNextPage,
                hasPreviousPage: state.hasPreviousPage,
                onNextPage: () => ref.read(_localUserAccountsProvider.notifier).nextPage(),
                onPreviousPage: () => ref.read(_localUserAccountsProvider.notifier).previousPage(),
                onGoToPage: (page) => ref.read(_localUserAccountsProvider.notifier).goToPage(page),
              ),
            ],
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
        const SizedBox(width: 16),
        _buildRefreshButton(context, isDark),
        const SizedBox(width: 8),
        if (!isMobile)
          _buildCreateAccountButton(context, l10n, isDark),
      ],
    );
  }

  Widget _buildRefreshButton(
    BuildContext context,
    bool isDark,
  ) {
    final state = ref.watch(_localUserAccountsProvider);
    final isRefreshing = state.isRefreshing;
    
    return InkWell(
      onTap: isRefreshing
          ? null
          : () {
              ref.read(_localUserAccountsProvider.notifier).refresh();
            },
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: isRefreshing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A0A0A)),
                  ),
                )
              : const Icon(
                  Icons.refresh,
                  size: 18,
                  color: Color(0xFF0A0A0A),
                ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return InkWell(
      onTap: () {
        context.goNamed('create-user-account');
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
    UserAccountsState state,
  ) {
    final activeCount = state.activeCount ?? 
                       state.users.where((u) => u.status == 'Active').length;
    final inactiveCount = state.inactiveCount ?? 
                         state.users.where((u) => u.status == 'Inactive').length;
    final mfaCount = state.users.where((u) => u.mfaEnabled).length;
    final passwordIssues = 0;

    final stats = [
      {
        'label': 'Total Accounts',
        'value': '${state.totalItems}',
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
        'label': 'Inactive',
        'value': '$inactiveCount',
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
        _onTypeChanged(value);
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
        _onStatusChanged(value);
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
    UserAccountsState state,
  ) {
    if (state.isLoading && state.users.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? Colors.white : const Color(0xFF155DFC),
            ),
          ),
        ),
      );
    }

    if (state.error != null && state.users.isEmpty) {
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
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading users',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.themeTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                style: TextStyle(
                  fontSize: 14,
                  color: context.themeTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state.users.isEmpty) {
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
      children: state.users.map((user) {
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
                          AccountTypeMapper.toUiFormat(user.accountType),
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
              if (!isMobile) _buildActionButtons(context, isDark, user),
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
                _buildActionButtons(context, isDark, user),
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

  Widget _buildActionButtons(BuildContext context, bool isDark, UserAccountModel? user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionIcon(
          Assets.icons.visibleIcon.path,
          isDark,
          onTap: user != null
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) => UserAccountDetailsDialog(user: user),
                  );
                }
              : null,
        ),
        const SizedBox(width: 24),
        _buildActionIcon(
          Assets.icons.editIcon.path,
          isDark,
          onTap: user != null
              ? () {
                  // Navigate to edit route - URL will update with user ID
                  final userId = user.id; // This is a String from the model
                  context.goNamed(
                    'edit-user-account',
                    pathParameters: {'id': userId},
                  );
                }
              : null,
        ),
        const SizedBox(width: 24),
        _buildActionIcon(
          Assets.icons.refreshIcon.path,
          isDark,
          onTap: user != null
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) => ResetPasswordDialog(user: user),
                  );
                }
              : null,
        ),
        const SizedBox(width: 24),
        _buildActionIcon(
          Assets.icons.deleteIcon.path,
          isDark,
          onTap: user != null
              ? () => _handleDeleteUser(context, user)
              : null,
        ),
      ],
    );
  }

  Future<void> _handleDeleteUser(BuildContext context, UserAccountModel user) async {
    final userId = int.tryParse(user.id);
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid user ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await DeleteConfirmationDialog.show(
      context,
      title: 'Delete User Account',
      message: 'Are you sure you want to delete this user account? This action cannot be undone.',
      itemName: user.name.isNotEmpty ? user.name : user.username,
      onConfirm: () async {
        try {
          final dataSource = UserAccountRemoteDataSourceImpl();
          final service = UserAccountService(dataSource);
          await service.deleteUserAccount(userId);
          return true;
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete user: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return false;
        }
      },
    );

    if (confirmed == true && context.mounted) {
      // Delete locally from the list for better UX
      ref.read(_localUserAccountsProvider.notifier).deleteUserLocally(user.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User account deleted successfully'),
          backgroundColor: Color(0xFF00A63E),
        ),
      );
    }
  }

  Widget _buildActionIcon(String icon, bool isDark, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      child: SvgPicture.asset(
        icon,
        height: 16,
        width: 16,
        // color: isDark ? const Color(0xFF90A1B9) : const Color(0xFF6A7282),
      ),
    );
  }

}


