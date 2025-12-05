import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/filter_pill_dropdown.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/role_model.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  final _searchController = TextEditingController();
  String _selectedType = 'All Types';
  String _selectedStatus = 'All Status';
  late List<RoleModel> _filteredRoles;

  @override
  void initState() {
    super.initState();
    _filteredRoles = List.of(sampleRoles);
    _searchController.addListener(_filterRoles);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRoles() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredRoles = sampleRoles.where((role) {
        final matchesSearch = query.isEmpty ||
            role.name.toLowerCase().contains(query) ||
            role.code.toLowerCase().contains(query) ||
            role.description.toLowerCase().contains(query);
        final matchesType =
            _selectedType == 'All Types' || role.type == _selectedType;
        final matchesStatus =
            _selectedStatus == 'All Status' || role.status == _selectedStatus;
        return matchesSearch && matchesType && matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 900;

    final totalRoles = sampleRoles.length;
    final activeRoles = sampleRoles.where((r) => r.status == 'Active').length;
    final inactiveRoles =
        sampleRoles.where((r) => r.status == 'Inactive').length;
    final jobRoles = sampleRoles.where((r) => r.type == 'Job').length;
    final dutyRoles = sampleRoles.where((r) => r.type == 'Duty').length;
    final standard = 0;
    final custom = 0;

    final totalUsersAssigned = sampleRoles.fold<int>(
        0, (sum, role) => sum + role.usersAssigned);

    return Scaffold(
      backgroundColor:
          isDark ? context.themeBackground : const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, l10n, isDark, isMobile),
            const SizedBox(height: 24),
            _buildStatsGrid(
              context,
              l10n,
              isDark,
              isMobile,
              isTablet,
              totalRoles,
              activeRoles,
              inactiveRoles,
              jobRoles,
              dutyRoles,
              standard,
              custom,
            ),
            const SizedBox(height: 24),
            _buildSearchAndFilters(context, l10n, isDark, isMobile),
            const SizedBox(height: 24),
            _buildRolesList(context, l10n, isDark, isMobile),
            const SizedBox(height: 24),
            _buildFooter(context, l10n, isDark, totalUsersAssigned),
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
          Assets.icons.securityConsoleIcon.path,
          width: 32,
          height: 32,
          colorFilter: ColorFilter.mode(
            Color(0xff9810FA),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.roleManagement,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage security roles and permissions',
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
          const SizedBox(width: 8),
          _buildCreateRoleButton(context, isDark),
        ],
      ],
    );
  }

  Widget _buildRefreshButton(BuildContext context, bool isDark) {
    return Container(
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
          Icon(
            Icons.refresh,
            size: 16,
            color: isDark ? Colors.white : const Color(0xFF0A0A0A),
          ),
          const SizedBox(width: 8),
          Text(
            'Refresh',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.8,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF0A0A0A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateRoleButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => context.push('/dashboard/security/role-management/create'),
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
            const Icon(
              Icons.add,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            const Text(
              'Create Role',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
    bool isTablet,
    int total,
    int active,
    int inactive,
    int jobRoles,
    int dutyRoles,
    int standard,
    int custom,
  ) {
    final stats = [
      {
        'label': l10n.totalRoles,
        'value': '$total',
        'valueColor': isDark ? Colors.white : const Color(0xFF0A0A0A),
        'borderColor': null,
      },
      {
        'label': l10n.active,
        'value': '$active',
        'valueColor': const Color(0xFF00A63E),
        'borderColor': const Color(0xFF00C950),
      },
      {
        'label': l10n.inactive,
        'value': '$inactive',
        'valueColor': isDark ? Colors.white : const Color(0xFF4A5565),
        'borderColor': const Color(0xFF9CA3AF),
      },
      {
        'label': l10n.jobRoles,
        'value': '$jobRoles',
        'valueColor': isDark ? Colors.white : const Color(0xFF0A0A0A),
        'borderColor': const Color(0xFF3B82F6),
      },
      {
        'label': 'Duty Roles',
        'value': '$dutyRoles',
        'valueColor': isDark ? Colors.white : const Color(0xFF0A0A0A),
        'borderColor': const Color(0xFFFBBF24),
      },
      {
        'label': l10n.standard,
        'value': '$standard',
        'valueColor': isDark ? Colors.white : const Color(0xFF0A0A0A),
        'borderColor': const Color(0xFF8B5CF6),
      },
      {
        'label': l10n.custom,
        'value': '$custom',
        'valueColor': isDark ? Colors.white : const Color(0xFF0A0A0A),
        'borderColor': const Color(0xFFEC4899),
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
          Row(
            children: [
              Expanded(child: _buildStatCard(context, stats[4], isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(context, stats[5], isDark)),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatCard(context, stats[6], isDark),
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
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(context, stats[2], isDark)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard(context, stats[3], isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(context, stats[4], isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(context, stats[5], isDark)),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatCard(context, stats[6], isDark),
        ],
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: stats.map((stat) => SizedBox(
        width: (screenWidth - 48 - 72) / 7,
        child: _buildStatCard(context, stat, isDark),
      )).toList(),
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

  Widget _buildSearchAndFilters(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: isMobile
          ? Column(
              children: [
                CustomTextField.search(
                  controller: _searchController,
                  hintText: 'Search roles by name, code, category, or description...',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilterPillDropdown(
                        value: _selectedType,
                        items: const ['All Types', 'Job', 'Duty'],
                        isDark: isDark,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedType = value;
                            _filterRoles();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilterPillDropdown(
                        value: _selectedStatus,
                        items: const ['All Status', 'Active', 'Inactive'],
                        isDark: isDark,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedStatus = value;
                            _filterRoles();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildMoreFiltersButton(isDark),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: CustomTextField.search(
                    controller: _searchController,
                    hintText: 'Search roles by name, code, category, or description...',
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: FilterPillDropdown(
                    value: _selectedType,
                    items: const ['All Types', 'Job', 'Duty'],
                    isDark: isDark,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedType = value;
                        _filterRoles();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 123,
                  child: FilterPillDropdown(
                    value: _selectedStatus,
                    items: const ['All Status', 'Active', 'Inactive'],
                    isDark: isDark,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedStatus = value;
                        _filterRoles();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                _buildMoreFiltersButton(isDark),
              ],
            ),
    );
  }

  Widget _buildMoreFiltersButton(bool isDark) {
    return Container(
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
          Icon(
            Icons.tune,
            size: 16,
            color: isDark ? Colors.white : const Color(0xFF0A0A0A),
          ),
          const SizedBox(width: 8),
          Text(
            'More Filters',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.8,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF0A0A0A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolesList(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    if (_filteredRoles.isEmpty) {
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
              Icon(Icons.search_off,
                  size: 64, color: context.themeTextTertiary),
              const SizedBox(height: 16),
              Text(
                l10n.noRolesFound,
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

    return Column(
      children: _filteredRoles.map((role) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildRoleCard(context, role, isDark, isMobile, l10n),
        );
      }).toList(),
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    RoleModel role,
    bool isDark,
    bool isMobile,
    AppLocalizations l10n,
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
          // Header row with avatar, name, badges, action buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.securityConsoleIcon.path,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF9333EA),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and code
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.3,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role.code,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.7,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF4A5565),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Type badge
              _buildTypeBadge(role.type, isDark),
              const SizedBox(width: 8),
              // Status badge
              _buildStatusBadge(role.status, isDark),

              const SizedBox(width: 24),
              // Action buttons
              if (!isMobile) ...[
                _buildActionButton(Assets.icons.visibleIcon.path, isDark),
                const SizedBox(width: 24),
                _buildActionButton(Assets.icons.editIcon.path, isDark),
                const SizedBox(width: 24),
                _buildActionButton(Assets.icons.copyIcon.path, isDark),
                const SizedBox(width: 24),
                _buildActionButton(Assets.icons.deleteIcon.path, isDark),
              ],
            ],
          ),
          const SizedBox(height: 16),
          // Info row
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem('Role ID', role.id, isDark),
                const SizedBox(height: 12),
                _buildInfoItem('Category', role.category, isDark),
                const SizedBox(height: 12),
                _buildInfoItem('Users Assigned', '${role.usersAssigned}', isDark, hasIcon: true),
                const SizedBox(height: 12),
                _buildInfoItem('Privileges', '${role.privileges}', isDark),
                const SizedBox(height: 12),
                _buildInfoItem('Last Modified', role.createdOn, isDark),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildInfoItem('Role ID', role.id, isDark),
                ),
                Expanded(
                  flex: 2,
                  child: _buildInfoItem('Category', role.category, isDark),
                ),
                Expanded(
                  flex: 2,
                  child: _buildInfoItem('Users Assigned', '${role.usersAssigned}', isDark, hasIcon: true),
                ),
                Expanded(
                  flex: 2,
                  child: _buildInfoItem('Privileges', '${role.privileges}', isDark),
                ),
                Expanded(
                  flex: 2,
                  child: _buildInfoItem('Last Modified', role.createdOn, isDark),
                ),
              ],
            ),
          // Mobile action buttons
          if (isMobile) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Assets.icons.visibleIcon.path, isDark),
                _buildActionButton(Assets.icons.editIcon.path, isDark),
                _buildActionButton(Assets.icons.copyIcon.path, isDark),
                _buildActionButton(Assets.icons.deleteIcon.path, isDark),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String type, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDD4),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0xFFFFD6A7)),
      ),
      child: Text(
        type,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFFCA3500),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    final isActive = status == 'Active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: isActive ? const Color(0xFFB9F8CF) : const Color(0xFFFECACA),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 12,
            color: isActive ? const Color(0xFF008236) : const Color(0xFFDC2626),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isActive ? const Color(0xFF008236) : const Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, bool isDark, {bool hasIcon = false}) {
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
        Row(
          children: [
            if (hasIcon) ...[
              Icon(
                Icons.person_outline,
                size: 12,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : const Color(0xFF0F172B),
              ),
            ),
          ],
        ),
      ],
    );
  }

    Widget _buildActionButton(String icon, bool isDark) {
    return GestureDetector(
      onTap: () {
        // TODO: Handle action
      },
      child: SvgPicture.asset(
        icon,
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    int totalUsersAssigned,
  ) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackgroundGrey : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${_filteredRoles.length} of ${sampleRoles.length} roles',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF4A5565),
            ),
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF4A5565),
              ),
              children: [
                const TextSpan(text: 'Total Users Assigned: '),
                TextSpan(
                  text: '$totalUsersAssigned',
                  style: TextStyle(
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
}
