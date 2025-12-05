import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/role_model.dart';

class RoleManagementScreen extends StatefulWidget {
  const RoleManagementScreen({super.key});

  @override
  State<RoleManagementScreen> createState() => _RoleManagementScreenState();
}

class _RoleManagementScreenState extends State<RoleManagementScreen> {
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
            role.code.toLowerCase().contains(query);
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
    final isMobile = size.width < 768;

    final totalRoles = sampleRoles.length;
    final activeRoles = sampleRoles.where((r) => r.status == 'Active').length;
    final inactiveRoles = sampleRoles.where((r) => r.status == 'Inactive').length;
    final jobRoles = sampleRoles.where((r) => r.type == 'Job Role').length;
    final dutyRoles = sampleRoles.where((r) => r.type == 'Duty Role').length;
    final standard = sampleRoles.where((r) => r.id.startsWith('ROLE-0')).length;
    final custom = totalRoles - standard;

    return Scaffold(
      backgroundColor: context.themeBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, l10n, isDark, isMobile),
                SizedBox(height: isMobile ? 16 : 24),
                _buildStatsGrid(
                  context,
                  l10n,
                  isDark,
                  isMobile,
                  totalRoles,
                  activeRoles,
                  inactiveRoles,
                  jobRoles,
                  dutyRoles,
                  standard,
                  custom,
                ),
                SizedBox(height: isMobile ? 16 : 24),
                _buildSearchCard(context, l10n, isDark, isMobile),
                SizedBox(height: isMobile ? 16 : 24),
                _buildRolesList(context, l10n, isDark, isMobile),
              ],
            ),
          ),
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
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.purpleBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            Assets.icons.userManagementIcon.path,
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.roleManagement,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.w600,
                  color: context.themeTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.roleManagementSubtitle,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  color: context.themeTextSecondary,
                ),
              ),
            ],
          ),
        ),
        if (!isMobile) ...[
          const SizedBox(width: 16),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                style: IconButton.styleFrom(
                  backgroundColor: context.themeCardBackground,
                  side: BorderSide(color: context.themeCardBorder),
                ),
              ),
              const SizedBox(width: 8),
              CustomButton.primary(
                text: l10n.createRole,
                icon: Icons.add,
                onPressed: () {
                  context.go('/dashboard/security/role-management/create');
                },
                width: 140,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
    int total,
    int active,
    int inactive,
    int job,
    int duty,
    int standard,
    int custom,
  ) {
    final stats = [
      {
        'icon': Assets.icons.userManagementIcon.path,
        'label': l10n.totalRoles,
        'value': '$total',
        'color': AppColors.primary
      },
      {
        'icon': Assets.icons.accountsPayableIcon.path,
        'label': l10n.activeRoles,
        'value': '$active',
        'color': AppColors.success
      },
      {
        'icon': Assets.icons.lockIcon.path,
        'label': l10n.inactive,
        'value': '$inactive',
        'color': AppColors.error
      },
      {
        'icon': Assets.icons.userManagementIcon.path,
        'label': l10n.jobRoles,
        'value': '$job',
        'color': AppColors.info
      },
      {
        'icon': Assets.icons.accountsPayableIcon.path,
        'label': l10n.dutyRolesOnly,
        'value': '$duty',
        'color': AppColors.orange
      },
      {
        'icon': Assets.icons.boxIcon.path,
        'label': l10n.standard,
        'value': '$standard',
        'color': AppColors.purple
      },
      {
        'icon': Assets.icons.editIcon.path,
        'label': l10n.custom,
        'value': '$custom',
        'color': AppColors.warning
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
          childAspectRatio: 1.5,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return _buildStatCard(context, stats[index], isDark);
        },
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: stats.map((stat) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 72) / 4,
          child: _buildStatCard(context, stat, isDark),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    Map<String, dynamic> stat,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.themeCardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.themeCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            stat['icon'],
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              stat['color'],
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            stat['label'],
            style: TextStyle(
              fontSize: 13,
              color: context.themeTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat['value'],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: context.themeTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.themeCardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.themeCardBorder),
      ),
      child: Column(
        children: [
          CustomTextField.search(
            controller: _searchController,
            hintText: l10n.searchRolesPlaceholder,
            filled: true,
            fillColor: context.themeBackground,
          ),
          const SizedBox(height: 12),
          if (isMobile)
            Column(
              children: [
                _buildFilterDropdown(context, l10n, isDark, _selectedType, [
                  'All Types',
                  'Job Role',
                  'Duty Role'
                ], (value) {
                  setState(() {
                    _selectedType = value!;
                    _filterRoles();
                  });
                }),
                const SizedBox(height: 12),
                _buildFilterDropdown(context, l10n, isDark, _selectedStatus, [
                  'All Status',
                  'Active',
                  'Inactive'
                ], (value) {
                  setState(() {
                    _selectedStatus = value!;
                    _filterRoles();
                  });
                }),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildFilterDropdown(context, l10n, isDark, _selectedType,
                      ['All Types', 'Job Role', 'Duty Role'], (value) {
                    setState(() {
                      _selectedType = value!;
                      _filterRoles();
                    });
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFilterDropdown(
                      context, l10n, isDark, _selectedStatus, ['All Status', 'Active', 'Inactive'],
                      (value) {
                    setState(() {
                      _selectedStatus = value!;
                      _filterRoles();
                    });
                  }),
                ),
                const SizedBox(width: 12),
                CustomButton.outlined(
                  text: l10n.moreFilters,
                  icon: Icons.tune,
                  onPressed: () {},
                  width: 140,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.themeBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.themeBorderGrey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down,
              size: 20, color: context.themeTextTertiary),
          style: TextStyle(
            fontSize: 14,
            color: context.themeTextPrimary,
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
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
          color: context.themeCardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.themeCardBorder),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 64, color: context.themeTextTertiary),
              const SizedBox(height: 16),
              Text(
                l10n.noRolesFound,
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
      children: _filteredRoles.map((role) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.themeCardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.themeCardBorder,
          width: role.type == 'Job Role' ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: role.type == 'Job Role'
                      ? AppColors.jobRoleBg
                      : AppColors.dutyRoleBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  role.type,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: role.type == 'Job Role'
                        ? AppColors.infoText
                        : AppColors.orangeText,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: role.status == 'Active'
                      ? AppColors.successBg
                      : AppColors.grayBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: role.status == 'Active'
                        ? AppColors.successBorder
                        : AppColors.grayBorder,
                  ),
                ),
                child: Text(
                  role.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: role.status == 'Active'
                        ? AppColors.successText
                        : AppColors.grayText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            role.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role.code,
            style: TextStyle(
              fontSize: 13,
              color: context.themeTextSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            role.description,
            style: TextStyle(
              fontSize: 14,
              color: context.themeTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              children: [
                _buildRoleInfoRow(
                    'Users Assigned: ${role.usersAssigned}', context),
                const SizedBox(height: 8),
                _buildRoleInfoRow('${l10n.privileges}: ${role.privileges}', context),
                const SizedBox(height: 8),
                _buildRoleInfoRow('${l10n.createdOn}: ${role.createdOn}', context),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildRoleInfoRow(
                      'Users Assigned: ${role.usersAssigned}', context),
                ),
                Expanded(
                  child:
                      _buildRoleInfoRow('${l10n.privileges}: ${role.privileges}', context),
                ),
                Expanded(
                  child:
                      _buildRoleInfoRow('${l10n.createdOn}: ${role.createdOn}', context),
                ),
              ],
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.go('/dashboard/security/role-management/create');
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(l10n.edit),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Duplicate'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleInfoRow(String text, BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 6,
          color: context.themeTextTertiary,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: context.themeTextSecondary,
          ),
        ),
      ],
    );
  }
}
