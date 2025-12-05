import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/role_hierarchy_model.dart';
import '../widgets/add_role_to_hierarchy_dialog.dart';

class RoleHierarchyScreen extends StatefulWidget {
  const RoleHierarchyScreen({super.key});

  @override
  State<RoleHierarchyScreen> createState() => _RoleHierarchyScreenState();
}

class _RoleHierarchyScreenState extends State<RoleHierarchyScreen> {
  final _searchController = TextEditingController();
  late List<RoleHierarchyModel> _hierarchyData;
  bool _expandAll = false;

  @override
  void initState() {
    super.initState();
    _hierarchyData = sampleRoleHierarchy;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpandAll() {
    setState(() {
      _expandAll = !_expandAll;
      _setExpandedRecursive(_hierarchyData, _expandAll);
    });
  }

  void _setExpandedRecursive(List<RoleHierarchyModel> roles, bool expanded) {
    for (var role in roles) {
      role.isExpanded = expanded;
      if (role.children.isNotEmpty) {
        _setExpandedRecursive(role.children, expanded);
      }
    }
  }

  Future<void> _showAddRoleDialog(BuildContext context, {String? parentRoleCode, String? parentRoleName}) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddRoleToHierarchyDialog(
        parentRoleCode: parentRoleCode,
        parentRoleName: parentRoleName,
      ),
    );

    if (result != null) {
      // Handle the result - add the new role to hierarchy
      // This would typically involve calling an API
      debugPrint('New role added: $result');
    }
  }

  int _countRolesByType(String type) {
    int count = 0;
    void countRecursive(List<RoleHierarchyModel> roles) {
      for (var role in roles) {
        if (role.type == type) count++;
        if (role.children.isNotEmpty) countRecursive(role.children);
      }
    }

    countRecursive(_hierarchyData);
    return count;
  }

  int _getMaxDepth() {
    int maxDepth = 0;
    void calculateDepth(List<RoleHierarchyModel> roles, int depth) {
      for (var role in roles) {
        if (depth > maxDepth) maxDepth = depth;
        if (role.children.isNotEmpty) {
          calculateDepth(role.children, depth + 1);
        }
      }
    }

    calculateDepth(_hierarchyData, 1);
    return maxDepth;
  }

  int _countPrivileges() {
    int count = 0;
    void countRecursive(List<RoleHierarchyModel> roles) {
      for (var role in roles) {
        if (role.type == 'Privilege') count++;
        if (role.children.isNotEmpty) countRecursive(role.children);
      }
    }

    countRecursive(_hierarchyData);
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 900;

    final jobRoles = _countRolesByType('Job');
    final dutyRoles = _countRolesByType('Duty');
    final privileges = _countPrivileges();
    final maxDepth = _getMaxDepth();

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
            SizedBox(height: isMobile ? 16 : 24),
            _buildStatsGrid(
              context,
              l10n,
              isDark,
              isMobile,
              isTablet,
              jobRoles,
              dutyRoles,
              privileges,
              maxDepth,
            ),
            SizedBox(height: isMobile ? 16 : 24),
            _buildSearchBar(context, l10n, isDark, isMobile),
            SizedBox(height: isMobile ? 16 : 24),
            _buildHierarchyTree(context, l10n, isDark),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark
                    ? context.themeCardBackground
                    : const Color(0xFFDDEBFE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: SvgPicture.asset(
                  Assets.icons.roleHerarchyIcon.path,
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
                    l10n.roleHierarchy,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.3,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : const Color(0xFF0F172B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Visualize and manage role inheritance structure',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.6,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF4A5565),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 16),
              _buildExpandAllButton(context, isDark),
              const SizedBox(width: 12),
              _buildAddRootRoleButton(context, isDark),
            ],
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildExpandAllButton(context, isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildAddRootRoleButton(context, isDark)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildExpandAllButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: _toggleExpandAll,
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
            Icon(
              _expandAll ? Icons.unfold_less : Icons.unfold_more,
              size: 16,
              color: isDark ? Colors.white : const Color(0xFF0A0A0A),
            ),
            const SizedBox(width: 8),
            Text(
              _expandAll ? 'Collapse All' : 'Expand All',
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

  Widget _buildAddRootRoleButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => _showAddRoleDialog(context),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF030213),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Add Root Role',
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
    int jobRoles,
    int dutyRoles,
    int privileges,
    int maxDepth,
  ) {
    final stats = [
      {
        'label': l10n.jobRoles,
        'value': '$jobRoles',
        'icon': Assets.icons.securityConsoleIcon.path,
        'color': const Color(0xFF00A63E),
      },
      {
        'label': 'Duty Roles',
        'value': '$dutyRoles',
        'icon': Assets.icons.userManagementIcon.path,
        'color': const Color(0xFFF54900),
      },
      {
        'label': 'Privileges',
        'value': '$privileges',
        'icon': Assets.icons.workflowApprovalsIcon.path,
        'color': const Color(0xFF155DFC),
      },
      {
        'label': 'Max Depth',
        'value': '$maxDepth',
        'icon': Assets.icons.depthIcon.path,
        'color': const Color(0xFF9810FA),
      },
    ];

    // Mobile and Tablet: 2x2 grid
    if (isMobile || isTablet) {
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

    // Desktop: Single row
    return Row(
      children: [
        for (int i = 0; i < stats.length; i++) ...[
          Expanded(child: _buildStatCard(context, stats[i], isDark)),
          if (i < stats.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    Map<String, dynamic> stat,
    bool isDark,
  ) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            stat['icon'] as String,
            width: isMobile ? 24 : 32,
            height: isMobile ? 24 : 32,
            colorFilter: ColorFilter.mode(
              stat['color'] as Color,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: isMobile ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat['label'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isMobile ? 12 : 13.7,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF4A5565),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['value'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.w400,
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

  Widget _buildSearchBar(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: isMobile
          ? Column(
              children: [
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1F2937)
                        : const Color(0xFFF3F3F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search roles...',
                      hintStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.7,
                        color: Color(0xFF717182),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.7,
                      color: isDark ? Colors.white : const Color(0xFF0F172B),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark
                          ? context.themeCardBackground
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Filter',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.9,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172B),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFF3F3F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search roles in hierarchy...',
                        hintStyle: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.7,
                          color: Color(0xFF717182),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 16,
                          color: Color(0xFF6B7280),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.7,
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 67.56,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? context.themeCardBackground : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.9,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHierarchyTree(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: _buildRoleNodes(_hierarchyData, 0, isDark, isMobile),
      ),
    );
  }

  List<Widget> _buildRoleNodes(
    List<RoleHierarchyModel> roles,
    int level,
    bool isDark,
    bool isMobile,
  ) {
    List<Widget> widgets = [];
    for (int i = 0; i < roles.length; i++) {
      final role = roles[i];
      widgets.add(
        _buildRoleNode(role, level, isDark, i == roles.length - 1, isMobile),
      );
      if (role.isExpanded && role.children.isNotEmpty) {
        widgets.addAll(
          _buildRoleNodes(role.children, level + 1, isDark, isMobile),
        );
      }
    }
    return widgets;
  }

  Widget _buildRoleNode(
    RoleHierarchyModel role,
    int level,
    bool isDark,
    bool isLast,
    bool isMobile,
  ) {
    final hasChildren = role.children.isNotEmpty;
    final leftPadding = isMobile
        ? 12.0 + (level * 16.0)
        : 24.0 + (level * 24.0);
    final rightPadding = isMobile ? 12.0 : 24.0;

    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: level == 0 ? (isMobile ? 16 : 24) : (isMobile ? 6 : 8),
        bottom: isLast && level == 0
            ? (isMobile ? 16 : 24)
            : (level > 0 ? (isMobile ? 6 : 8) : 0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 12,
          vertical: isMobile ? 10 : 13,
        ),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: _buildRoleNodeContent(role, hasChildren, isDark, isMobile),
      ),
    );
  }

  Widget _buildRoleNodeContent(
    RoleHierarchyModel role,
    bool hasChildren,
    bool isDark,
    bool isMobile,
  ) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (hasChildren)
                GestureDetector(
                  onTap: () =>
                      setState(() => role.isExpanded = !role.isExpanded),
                  child: Icon(
                    role.isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 16,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                )
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              _buildRoleIcon(role.type, isDark),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  role.name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.3,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildCodeBadge(role.code, isDark),
                _buildTypeBadge(role.type, isDark),
                _buildStatusBadge(role.status, isDark),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              '${role.usersAssigned} users assigned${role.children.isNotEmpty ? ' • ${role.children.length} child role${role.children.length > 1 ? 's' : ''}' : ''}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF4A5565),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionButton(
                Assets.icons.addIcon.path,
                isDark,
                onTap: () => _showAddRoleDialog(context, parentRoleCode: role.code, parentRoleName: role.name),
              ),
              const SizedBox(width: 16),
              _buildActionButton(Assets.icons.editIcon.path, isDark, onTap: () {}),
              const SizedBox(width: 16),
              _buildActionButton(Assets.icons.deleteIcon.path, isDark, onTap: () {}),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasChildren)
          GestureDetector(
            onTap: () => setState(() => role.isExpanded = !role.isExpanded),
            child: Icon(
              role.isExpanded
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right,
              size: 16,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          )
        else
          const SizedBox(width: 16),
        const SizedBox(width: 12),
        _buildRoleIcon(role.type, isDark),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
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
                  const SizedBox(width: 8),
                  _buildCodeBadge(role.code, isDark),
                  const SizedBox(width: 8),
                  _buildTypeBadge(role.type, isDark),
                  const SizedBox(width: 8),
                  _buildStatusBadge(role.status, isDark),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${role.usersAssigned} users assigned${role.children.isNotEmpty ? ' • ${role.children.length} child role${role.children.length > 1 ? 's' : ''}' : ''}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.6,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF4A5565),
                ),
              ),
            ],
          ),
        ),
        _buildActionButton(
          Assets.icons.addIcon.path,
          isDark,
          onTap: () => _showAddRoleDialog(context, parentRoleCode: role.code, parentRoleName: role.name),
        ),
        const SizedBox(width: 24),
        _buildActionButton(Assets.icons.editIcon.path, isDark, onTap: () {}),
        const SizedBox(width: 24),
        _buildActionButton(Assets.icons.deleteIcon.path, isDark, onTap: () {}),
      ],
    );
  }

  Widget _buildRoleIcon(String type, bool isDark) {
    IconData iconData;
    Color iconColor;

    if (type == 'Job') {
      iconData = Icons.shield_outlined;
      iconColor = const Color(0xFF00A63E);
    } else if (type == 'Duty') {
      iconData = Icons.people_outline;
      iconColor = const Color(0xFFF54900);
    } else {
      iconData = Icons.check_circle_outline;
      iconColor = const Color(0xFF155DFC);
    }

    return SizedBox(
      width: 16,
      height: 16,
      child: Icon(iconData, size: 16, color: iconColor),
    );
  }

  Widget _buildCodeBadge(String code, bool isDark) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Center(
        child: Text(
          code,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type, bool isDark) {
    Color bgColor;
    Color textColor;

    if (type == 'Job') {
      bgColor = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF016630);
    } else if (type == 'Duty') {
      bgColor = const Color(0xFFFFEDD4);
      textColor = const Color(0xFF9F2D00);
    } else {
      bgColor = const Color(0xFFDBEAFE);
      textColor = const Color(0xFF193CB8);
    }

    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          type,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    final isActive = status == 'Active';
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFECFDF5) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(8),
        border: isActive ? Border.all(color: const Color(0xFFB9F8CF)) : null,
      ),
      child: Center(
        child: Text(
          status,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? const Color(0xFF008236) : const Color(0xFFDC2626),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String icon, bool isDark, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SvgPicture.asset(
          icon,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
