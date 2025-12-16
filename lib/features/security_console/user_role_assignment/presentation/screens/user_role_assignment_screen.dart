import 'dart:async';
import 'package:digify_erp/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/user_role_model.dart';
import '../widgets/manage_roles_dialog.dart';
import '../providers/user_role_assignment_provider.dart';
import '../../data/datasources/user_role_assignment_remote_datasource.dart';

class UserRoleAssignmentScreen extends ConsumerStatefulWidget {
  const UserRoleAssignmentScreen({super.key});

  @override
  ConsumerState<UserRoleAssignmentScreen> createState() =>
      _UserRoleAssignmentScreenState();
}

class _UserRoleAssignmentScreenState
    extends ConsumerState<UserRoleAssignmentScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _searchDebounceTimer;

  // Local provider - autoDispose ensures it's disposed when widget is removed
  final _localUserRoleAssignmentProvider =
      StateNotifierProvider.autoDispose<UserRoleAssignmentNotifier,
          UserRoleAssignmentState>((ref) {
    final dataSource = UserRoleAssignmentRemoteDataSourceImpl();
    return UserRoleAssignmentNotifier(dataSource);
  });

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
    // Load users when screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_localUserRoleAssignmentProvider.notifier).loadUsers();
    });
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load next page when user scrolls within 200px of bottom
      final state = ref.read(_localUserRoleAssignmentProvider);
      if (state.hasNextPage && !state.isPaginationLoading) {
        ref.read(_localUserRoleAssignmentProvider.notifier).nextPage();
      }
    }
  }

  void _onSearchChanged() {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      ref.read(_localUserRoleAssignmentProvider.notifier).search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_localUserRoleAssignmentProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 900;

    final totalUsers = state.totalItems;
    final usersWithRoles = state.users
        .where((u) => u.assignedRoles.isNotEmpty)
        .length;
    final totalRoles = state.users.fold<int>(
      0,
      (sum, user) => sum + user.assignedRoles.length,
    );
    final avgRolesPerUser = totalUsers > 0
        ? (totalRoles / totalUsers).toStringAsFixed(1)
        : '0';
    const availableRoles = 2; // TODO: Get from API if available

    return Scaffold(
      backgroundColor: isDark
          ? context.themeBackground
          : const Color(0xFFF9FAFB),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildLoggedInBanner(context, isDark),
                const SizedBox(height: 16),
                _buildRolesLoadedBanner(context, isDark, availableRoles),
                const SizedBox(height: 24),
                _buildHeader(context, l10n, isDark, isMobile),
                const SizedBox(height: 24),
                _buildStatsRow(
                  context,
                  l10n,
                  isDark,
                  isMobile,
                  isTablet,
                  totalUsers,
                  usersWithRoles,
                  avgRolesPerUser,
                  availableRoles,
                ),
                const SizedBox(height: 24),
                _buildSearchCard(context, l10n, isDark),
                const SizedBox(height: 24),
                if (state.isLoading && state.users.isEmpty)
                  _buildLoadingIndicator(isDark)
                else if (state.users.isEmpty && !state.isLoading)
                  _buildEmptyState(context, l10n, isDark)
                else
                  Stack(
                    children: [
                      _buildUsersList(context, l10n, isDark, isMobile, state),
                      if (state.isRefreshing)
                        Positioned.fill(
                          child: Container(
                            color: (isDark ? context.themeBackground : const Color(0xFFF9FAFB))
                                .withValues(alpha: 0.7),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (state.isPaginationLoading)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? Colors.white : const Color(0xFF0A0A0A),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                _buildFooter(context, l10n, isDark, state),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF3B82F6) : const Color(0xFFBEDBFF),
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.9,
                color: isDark ? Colors.white : const Color(0xFF0A0A0A),
              ),
              children: const [
                TextSpan(
                  text: 'Currently logged in as:',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' admin@digify.com'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFBEDBFF),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'System Administrator',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.8,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0A0A0A),
              ),
            ),
          ),
          Text(
            '(User ID: d64bc913-5402-4e36-9642-56bfe37197b4)',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.8,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF155DFC),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolesLoadedBanner(
    BuildContext context,
    bool isDark,
    int rolesCount,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF14532D) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF22C55E) : const Color(0xFFB9F8CF),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                ),
                children: [
                  TextSpan(
                    text: '$rolesCount roles',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(
                    text: ' loaded from database and available for assignment',
                  ),
                ],
              ),
            ),
          ),
        ],
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
          colorFilter: ColorFilter.mode(
            isDark ? const Color(0xFF60A5FA) : const Color(0xFF155DFC),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.userRoleAssignment,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Assign and manage security roles for users',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF4A5565),
                ),
              ),
            ],
          ),
        ),
        if (!isMobile) ...[
          const SizedBox(width: 16),
          _buildRefreshButton(context, isDark),
        ],
      ],
    );
  }

  Widget _buildRefreshButton(BuildContext context, bool isDark) {
    final state = ref.watch(_localUserRoleAssignmentProvider);
    final isRefreshing = state.isRefreshing;

    return GestureDetector(
      onTap: isRefreshing
          ? null
          : () {
              ref.read(_localUserRoleAssignmentProvider.notifier).refresh();
            },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isRefreshing)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A0A0A)),
                ),
              )
            else
              Icon(
                Icons.refresh,
                size: 16,
                color: isDark ? Colors.white : const Color(0xFF0A0A0A),
              ),
            const SizedBox(width: 8),
            Text(
              'Refresh Data',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF0A0A0A),
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
    int totalUsers,
    int usersWithRoles,
    String avgRolesPerUser,
    int availableRoles,
  ) {
    final stats = [
      {
        'label': l10n.totalUsers,
        'value': '$totalUsers',
        'valueColor': isDark ? Colors.white : const Color(0xFF0A0A0A),
        'borderColor': null,
      },
      {
        'label': 'Users with Roles',
        'value': '$usersWithRoles',
        'valueColor': const Color(0xFF155DFC),
        'borderColor': const Color(0xFF2B7FFF),
      },
      {
        'label': 'Avg Roles/User',
        'value': avgRolesPerUser,
        'valueColor': const Color(0xFF9810FA),
        'borderColor': const Color(0xFFAD46FF),
      },
      {
        'label': 'Available Roles',
        'value': '$availableRoles',
        'valueColor': const Color(0xFF00A63E),
        'borderColor': const Color(0xFF00C950),
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
        ],
      );
    }

    if (isTablet) {
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
    final borderColor = stat['borderColor'] as Color?;
    final hasBorder = borderColor != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (hasBorder) Container(width: 4, color: borderColor),
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
                    children: [
                      Text(
                        stat['label'],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.6,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF4A5565),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        stat['value'],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: stat['valueColor'],
                        ),
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

  Widget _buildSearchCard(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return CustomTextField.search(
      controller: _searchController,
      hintText: 'Search users by name, username, email, or department...',
    );
  }

  Widget _buildLoadingIndicator(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildUsersList(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
    UserRoleAssignmentState state,
  ) {
    return Column(
      children: state.users.map((user) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildUserCard(context, user, isDark, isMobile, l10n),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
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
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.themeTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tryAdjustingSearchCriteria,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: context.themeTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    UserRoleModel user,
    bool isDark,
    bool isMobile,
    AppLocalizations l10n,
  ) {
    final hasRoles = user.assignedRoles.isNotEmpty;
    final isCurrentUser = user.isCurrentUser;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDark ? const Color(0xFF1E3A5F) : const Color(0xFFEFF6FF))
            : (isDark ? context.themeCardBackground : Colors.white),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrentUser
              ? const Color(0xFF2B7FFF)
              : Colors.black.withValues(alpha: 0.1),
          width: isCurrentUser ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with avatar, name, buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? const Color(0xFFBEDBFF)
                      : const Color(0xFFDBEAFE),
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
                            fontSize: isCurrentUser ? 15.3 : 17.2,
                            fontWeight: isCurrentUser
                                ? FontWeight.w400
                                : FontWeight.w500,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172B),
                          ),
                        ),
                        if (isCurrentUser) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF155DFC),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'YOU',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${user.username} • ${user.department}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF4A5565),
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons
              if (!isMobile) ...[
                _buildManageRolesButton(isDark, user),
                const SizedBox(width: 16),
                _buildHistoryButton(isDark),
              ],
            ],
          ),
          const SizedBox(height: 16),
          // Info row
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem('Email', user.email, isDark),
                const SizedBox(height: 12),
                _buildInfoItem('Department', user.department, isDark),
                const SizedBox(height: 12),
                _buildInfoItem(
                  'Assigned Roles',
                  '${user.assignedRoles.length} roles',
                  isDark,
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildInfoItem('Email', user.email, isDark),
                ),
                Expanded(
                  flex: 2,
                  child: _buildInfoItem('Department', user.department, isDark),
                ),
                Expanded(
                  flex: 2,
                  child: _buildInfoItem(
                    'Assigned Roles',
                    '${user.assignedRoles.length} roles',
                    isDark,
                  ),
                ),
              ],
            ),
          // Current Roles
          if (hasRoles) ...[
            const SizedBox(height: 16),
            Text(
              'Current Roles:',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6A7282),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.assignedRoles.map((role) {
                return _buildRoleChip(role, isDark);
              }).toList(),
            ),
          ],
          // Mobile action buttons
          if (isMobile) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildManageRolesButton(isDark, user)),
                const SizedBox(width: 12),
                _buildHistoryButton(isDark),
              ],
            ),
          ],
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
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.6,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleChip(String role, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: isDark ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.icons.securityConsoleIcon.path,
            width: 12,
            height: 12,
            colorFilter: ColorFilter.mode(
              isDark ? const Color(0xFF9CA3AF) : const Color(0xFF364153),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            role,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF364153),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageRolesButton(bool isDark, UserRoleModel user) {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => ManageRolesDialog(user: user),
        );
        // Refresh data if dialog returned a result (update was successful)
        if (result != null && mounted) {
          ref.read(_localUserRoleAssignmentProvider.notifier).refresh();
        }
      },
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF030213),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.securityConsoleIcon.path,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Manage Roles',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryButton(bool isDark) {
    return GestureDetector(
      onTap: () {
        // TODO: Show history
      },
      child: Icon(
        Icons.history,
        size: 16,
        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    UserRoleAssignmentState state,
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
            'Showing ${state.users.length} of ${state.totalItems} users',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
            ),
          ),
        ],
      ),
    );
  }
}

