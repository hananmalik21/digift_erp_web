import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/duty_role_model.dart';
import '../widgets/create_edit_duty_role_dialog.dart';

class DutyRolesScreen extends StatefulWidget {
  const DutyRolesScreen({super.key});

  @override
  State<DutyRolesScreen> createState() => _DutyRolesScreenState();
}

class _DutyRolesScreenState extends State<DutyRolesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedModule = 'All';
  List<DutyRoleModel> _dutyRoles = [];
  List<DutyRoleModel> _filteredDutyRoles = [];

  final List<String> _modules = [
    'All',
    'General Ledger',
    'Accounts Payable',
    'Accounts Receivable',
    'Cash Management',
    'Fixed Assets',
  ];

  @override
  void initState() {
    super.initState();
    _dutyRoles = DutyRoleModel.getSampleData();
    _filteredDutyRoles = _dutyRoles;
    _searchController.addListener(_filterDutyRoles);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDutyRoles() {
    setState(() {
      _filteredDutyRoles = _dutyRoles.where((role) {
        final matchesSearch =
            _searchController.text.isEmpty ||
            role.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            role.code.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            role.description.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        final matchesModule =
            _selectedModule == 'All' || role.module == _selectedModule;

        return matchesSearch && matchesModule;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final totalDutyRoles = _dutyRoles.length;
    final activeDutyRoles = _dutyRoles.where((r) => r.status == 'Active').length;
    final totalUsers = _dutyRoles.fold<int>(0, (sum, role) => sum + role.usersAssigned);
    final avgPrivileges = _dutyRoles.isEmpty
        ? 0
        : (_dutyRoles.fold<int>(0, (sum, role) => sum + role.privileges.length) / _dutyRoles.length).round();

    return Scaffold(
      backgroundColor: isDark ? context.themeBackground : const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isDark, isMobile),
            const SizedBox(height: 24),
            _buildStatsCards(
              context,
              isDark,
              isMobile,
              totalDutyRoles,
              activeDutyRoles,
              totalUsers,
              avgPrivileges,
            ),
            const SizedBox(height: 24),
            _buildSearchAndFilters(context, isDark, isMobile),
            const SizedBox(height: 24),
            _buildDutyRolesGrid(context, isDark, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF155DFC).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.dutyRoleIcon.path,
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
              Expanded(
                child: Text(
                  'Duty Roles',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.7,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                    height: 1.16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Functional roles that group related privileges by business process',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF717182),
              height: 1.46,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: _buildCreateButton(context, isDark),
          ),
        ],
      );
    }

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF155DFC).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: SvgPicture.asset(
              Assets.icons.dutyRoleIcon.path,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Duty Roles',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20.7,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                  height: 1.16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Functional roles that group related privileges by business process',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.7,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF717182),
                  height: 1.46,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildCreateButton(context, isDark),
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 167.41,
      height: 36,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CreateEditDutyRoleDialog(),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF030213),
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.addIcon.path,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            const Text(
              'Create Duty Role',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7,
                fontWeight: FontWeight.w500,
                height: 1.21,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(
    BuildContext context,
    bool isDark,
    bool isMobile,
    int total,
    int active,
    int users,
    int avgPrivileges,
  ) {
    final stats = [
      {
        'label': 'Total Duty Roles',
        'value': '$total',
        'color': const Color(0xFF155DFC),
        'icon': Assets.icons.dutyRoleIcon.path
      },
      {
        'label': 'Active',
        'value': '$active',
        'color': const Color(0xFF00A63E),
        'icon': Assets.icons.workflowApprovalsIcon.path
      },
      {
        'label': 'Users Assigned',
        'value': '$users',
        'color': const Color(0xFF9810FA),
        'icon': Assets.icons.userManagementIcon.path
      },
      {
        'label': 'Avg Privileges',
        'value': '$avgPrivileges',
        'color': const Color(0xFF155DFC),
        'icon': Assets.icons.keyIcon.path
      },
    ];

    if (isMobile) {
      return Column(
        children: stats
            .map(
              (stat) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildStatCard(context, stat, isDark),
              ),
            )
            .toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth < 900;

        if (isTablet) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, stats[0], isDark)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, stats[1], isDark)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, stats[2], isDark)),
                  const SizedBox(width: 16),
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
                padding: EdgeInsets.only(right: stat == stats.last ? 0 : 16),
                child: _buildStatCard(context, stat, isDark),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    Map<String, dynamic> stat,
    bool isDark,
  ) {
    return Container(
      constraints: const BoxConstraints(minHeight: 86),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
      padding: const EdgeInsets.all(17),
      child: Row(
        children: [
          SvgPicture.asset(
            stat['icon'] as String,
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              stat['color'] as Color,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat['label'] as String,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.7,
                    fontWeight: FontWeight.w400,
                    color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
                    height: 1.46,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['value'] as String,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(
      BuildContext context,
      bool isDark,
      bool isMobile,
      ) {
    Widget _searchField() {
      return SizedBox(
        height: 36,
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F3F5),
            hintText: 'Search duty roles...',
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),

            // prefix search icon (inside the textfield)
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 6),
              child: Icon(
                Icons.search,
                size: 16,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),

            contentPadding: const EdgeInsets.symmetric(vertical: 9.75),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            isDense: true,
          ),
        ),
      );
    }

    // Horizontal chips row like in Figma
    final chipsRow = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _modules.map((module) {
          final isLast = module == _modules.last;
          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: _buildModuleButton(module, isDark),
          );
        }).toList(),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
      child: isMobile
      // Mobile: search on top, chips below (scrollable)
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          const SizedBox(height: 12),
          chipsRow,
        ],
      )
      // Desktop / tablet: search and chips in same row
          : Row(
        children: [
          Expanded(child: _searchField()),
          const SizedBox(width: 12),
          Flexible(child: chipsRow),
        ],
      ),
    );
  }


  Widget _buildModuleButton(String module, bool isDark) {
    final isSelected = module == _selectedModule;

    return IntrinsicWidth(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedModule = module;
            _filterDutyRoles();
          });
        },
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7.5),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF155DFC)
                : (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            module,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isSelected
                  ? Colors.white
                  : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563)),
              height: 1.21,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDutyRolesGrid(BuildContext context, bool isDark, bool isMobile) {
    if (_filteredDutyRoles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Text(
            'No duty roles found',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.3,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ),
      );
    }

    if (isMobile) {
      return Column(
        children: _filteredDutyRoles
            .map(
              (role) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildDutyRoleCard(context, role, isDark),
              ),
            )
            .toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 900 ? 1 : 2;
        final cards = <Widget>[];

        for (int i = 0; i < _filteredDutyRoles.length; i += columns) {
          final rowCards = <Widget>[];
          for (int j = 0; j < columns && i + j < _filteredDutyRoles.length; j++) {
            rowCards.add(
              Expanded(
                child: _buildDutyRoleCard(context, _filteredDutyRoles[i + j], isDark),
              ),
            );
            if (j < columns - 1 && i + j + 1 < _filteredDutyRoles.length) {
              rowCards.add(const SizedBox(width: 16));
            }
          }

          // Add extra Expanded to fill empty space if odd number of cards
          if (rowCards.length == 1 && columns == 2) {
            rowCards.add(const Expanded(child: SizedBox()));
          }

          cards.add(
            Padding(
              padding: EdgeInsets.only(
                bottom: i + columns < _filteredDutyRoles.length ? 16 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowCards,
              ),
            ),
          );
        }

        return Column(children: cards);
      },
    );
  }

  Widget _buildDutyRoleCard(BuildContext context, DutyRoleModel role, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
      padding: const EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(role, isDark),
          const SizedBox(height: 24),
          Text(
            role.name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.7,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.16,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            role.code,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.17,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            role.description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.46,
            ),
          ),
          const SizedBox(height: 24),
          _buildModuleBadge(role.module, isDark),
          const SizedBox(height: 35),
          Text(
            'Privileges (${role.privileges.length})',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.1,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.16,
            ),
          ),
          const SizedBox(height: 11),
          _buildPrivilegesList(role.privileges, isDark),
          const SizedBox(height: 26),
          _buildCardFooter(role, isDark),
        ],
      ),
    );
  }

  Widget _buildCardHeader(DutyRoleModel role, bool isDark) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.icons.dutyRoleIcon.path,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            Color(0xFF155DFC),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            border: Border.all(color: const Color(0xFFB9F8CF)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            role.status,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.1,
              fontWeight: FontWeight.w400,
              color: Color(0xFF008236),
              height: 1.16,
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CreateEditDutyRoleDialog(dutyRole: role),
            );
          },
          icon: SvgPicture.asset(
            Assets.icons.editIcon.path,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              BlendMode.srcIn,
            ),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            // TODO: Delete duty role
          },
          icon: SvgPicture.asset(
            Assets.icons.deleteIcon.path,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              BlendMode.srcIn,
            ),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  Widget _buildModuleBadge(String module, bool isDark) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          module,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.1,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
            height: 1.16,
          ),
        ),
      ),
    );
  }

  Widget _buildPrivilegesList(List<String> privileges, bool isDark) {
    final visiblePrivileges = privileges.take(3).toList();
    final remainingCount = privileges.length - 3;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...visiblePrivileges.map((privilege) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              privilege,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.1,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
                height: 1.16,
              ),
            ),
          );
        }),
        if (remainingCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '+$remainingCount more',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.1,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
                height: 1.16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCardFooter(DutyRoleModel role, bool isDark) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.people_outline,
            size: 12,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 4),
          Text(
            '${role.usersAssigned} users',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.1,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.16,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Used in ${role.jobRolesCount} job roles',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.1,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.16,
            ),
          ),
          const Spacer(),
          Text(
            role.lastModified,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.17,
            ),
          ),
        ],
      ),
    );
  }
}
