import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/security_policy_model.dart';
import '../widgets/create_edit_policy_dialog.dart';

class SecurityPoliciesScreen extends StatefulWidget {
  const SecurityPoliciesScreen({super.key});

  @override
  State<SecurityPoliciesScreen> createState() => _SecurityPoliciesScreenState();
}

class _SecurityPoliciesScreenState extends State<SecurityPoliciesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<SecurityPolicyModel> _policies = [];
  List<SecurityPolicyModel> _filteredPolicies = [];

  @override
  void initState() {
    super.initState();
    _policies = SecurityPolicyModel.getSamplePolicies();
    _filteredPolicies = _policies;
    _searchController.addListener(_filterPolicies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPolicies() {
    setState(() {
      _filteredPolicies = _policies.where((policy) {
        final matchesSearch = policy.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            policy.description
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
        final matchesCategory =
            _selectedCategory == 'All' || policy.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _toggleEnforcement(String policyId) {
    setState(() {
      final index = _policies.indexWhere((p) => p.id == policyId);
      if (index != -1) {
        final policy = _policies[index];
        _policies[index] = SecurityPolicyModel(
          id: policy.id,
          name: policy.name,
          code: policy.code,
          severity: policy.severity,
          status: policy.status,
          category: policy.category,
          description: policy.description,
          isEnforced: !policy.isEnforced,
          affectedUsers: policy.affectedUsers,
          modifiedDate: policy.modifiedDate,
          modifiedBy: policy.modifiedBy,
        );
        _filterPolicies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    final totalPolicies = _policies.length;
    final activePolicies = _policies.where((p) => p.status == 'Active').length;
    final enforcedPolicies = _policies.where((p) => p.isEnforced).length;
    final criticalPolicies =
        _policies.where((p) => p.severity == 'Critical').length;

    return Scaffold(
      backgroundColor: isDark ? context.themeBackground : const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, l10n, isDark, isMobile),
            const SizedBox(height: 24),
            _buildStatsCards(
              context,
              l10n,
              isDark,
              isMobile,
              isTablet,
              totalPolicies,
              activePolicies,
              enforcedPolicies,
              criticalPolicies,
            ),
            const SizedBox(height: 24),
            _buildSearchAndFilters(context, l10n, isDark, isMobile),
            const SizedBox(height: 24),
            _buildPoliciesList(context, l10n, isDark, isMobile),
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
                  color: const Color(0xFFDDEBFE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.securityConsoleIcon.path,
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
                      'Security Policies',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.3,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Define and manage organization-wide security policies',
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
            ],
          ),
          const SizedBox(height: 16),
          _buildCreatePolicyButton(context, l10n, isDark),
        ],
      );
    }

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFDDEBFE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: SvgPicture.asset(
              Assets.icons.securityConsoleIcon.path,
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
                'Security Policies',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Define and manage organization-wide security policies',
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
        const SizedBox(width: 16),
        _buildCreatePolicyButton(context, l10n, isDark),
      ],
    );
  }

  Widget _buildCreatePolicyButton(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CreateEditPolicyDialog(),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF030213),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.icons.addIcon.path,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Create Policy',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
    bool isTablet,
    int total,
    int active,
    int enforced,
    int critical,
  ) {
    final stats = [
      {
        'label': 'Total Policies',
        'value': '$total',
        'icon': Assets.icons.accountsPayableIcon.path,
        'color': const Color(0xFF155DFC),
      },
      {
        'label': 'Active',
        'value': '$active',
        'icon': Assets.icons.workflowApprovalsIcon.path,
        'color': const Color(0xFF00A63E),
      },
      {
        'label': 'Enforced',
        'value': '$enforced',
        'icon': Assets.icons.securityConsoleIcon.path,
        'color': const Color(0xFFF54900),
      },
      {
        'label': 'Critical',
        'value': '$critical',
        'icon': Assets.icons.userManagementIcon.path,
        'color': const Color(0xFF9810FA),
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
        itemBuilder: (context, index) =>
            _buildStatCard(context, stats[index], isDark),
      );
    }

    if (isTablet) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 700) {
            return Row(
              children: stats.asMap().entries.map((entry) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: entry.key < stats.length - 1 ? 12 : 0,
                    ),
                    child: _buildStatCard(context, entry.value, isDark),
                  ),
                );
              }).toList(),
            );
          }
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
                _buildStatCard(context, stats[index], isDark),
          );
        },
      );
    }

    return Row(
      children: stats.asMap().entries.map((entry) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: entry.key < stats.length - 1 ? 16 : 0,
            ),
            child: _buildStatCard(context, entry.value, isDark),
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
            stat['icon'],
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              stat["color"],
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
                  stat['label'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
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
                    fontSize: 24,
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

  Widget _buildSearchAndFilters(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    final categories = ['All', 'Password', 'Session', 'Access', 'Data', 'API'];

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
                _buildSearchField(context, isDark),
                const SizedBox(height: 12),
                _buildCategoryFilters(context, categories, isDark, true),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildSearchField(context, isDark),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: _buildCategoryFilters(context, categories, isDark, false),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchField(BuildContext context, bool isDark) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F3F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.8,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : const Color(0xFF0F172B),
        ),
        decoration: InputDecoration(
          hintText: 'Search policies...',
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8,
            fontWeight: FontWeight.w400,
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
      ),
    );
  }

  Widget _buildCategoryFilters(
    BuildContext context,
    List<String> categories,
    bool isDark,
    bool isMobile,
  ) {
    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildCategoryButton(context, category, isDark),
            );
          }).toList(),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: categories.map((category) {
        return _buildCategoryButton(context, category, isDark);
      }).toList(),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    String category,
    bool isDark,
  ) {
    final isSelected = _selectedCategory == category;

    return IntrinsicWidth(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = category;
            _filterPolicies();
          });
        },
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF030213)
                : (isDark ? context.themeCardBackground : Colors.white),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.black.withValues(alpha: 0.1),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            category,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: category == 'All' ? 14.0 : 13.6,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white : const Color(0xFF030213)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPoliciesList(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    if (_filteredPolicies.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Center(
          child: Text(
            'No policies found',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.3,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF4A5565),
            ),
          ),
        ),
      );
    }

    return Column(
      children: _filteredPolicies.asMap().entries.map((entry) {
        final index = entry.key;
        final policy = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: index < _filteredPolicies.length - 1 ? 16 : 0),
          child: _buildPolicyCard(context, policy, isDark, isMobile),
        );
      }).toList(),
    );
  }

  Widget _buildPolicyCard(
    BuildContext context,
    SecurityPolicyModel policy,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      policy.name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.1,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                    _buildCodeBadge(policy.code, isDark),
                    _buildSeverityBadge(policy.severity, isDark),
                    _buildStatusBadge(policy.status, isDark),
                    _buildCategoryBadge(policy.category, isDark),
                  ],
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 8),
                _buildActionButton(
                  context,
                  Assets.icons.editIcon.path,
                  () {
                    showDialog(
                      context: context,
                      builder: (context) => CreateEditPolicyDialog(
                        policy: {
                          'name': policy.name,
                          'code': policy.code,
                          'description': policy.description,
                          'category': policy.category,
                          'severity': policy.severity,
                          'status': policy.status,
                          'enforced': policy.isEnforced,
                        },
                      ),
                    );
                  },
                  isDark,
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  context,
                  Assets.icons.deleteIcon.path,
                  () {
                    // Handle delete
                  },
                  isDark,
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            policy.description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF4A5565),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildEnforcementToggle(policy, isDark),
              Text.rich(
                TextSpan(
                  text: 'Affected Users: ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.7,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF4A5565),
                  ),
                  children: [
                    TextSpan(
                      text: '${policy.affectedUsers}',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  text: 'Modified: ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.7,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF4A5565),
                  ),
                  children: [
                    TextSpan(
                      text: policy.modifiedDate,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                    TextSpan(
                      text: ' by ${policy.modifiedBy}',
                      style: const TextStyle(
                        color: Color(0xFF6A7282),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    Assets.icons.editIcon.path,
                    () {
                      showDialog(
                        context: context,
                        builder: (context) => CreateEditPolicyDialog(
                          policy: {
                            'name': policy.name,
                            'code': policy.code,
                            'description': policy.description,
                            'category': policy.category,
                            'severity': policy.severity,
                            'status': policy.status,
                            'enforced': policy.isEnforced,
                          },
                        ),
                      );
                    },
                    isDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    context,
                    Assets.icons.deleteIcon.path,
                    () {
                      // Handle delete
                    },
                    isDark,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCodeBadge(String code, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF030213),
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(String severity, bool isDark) {
    Color bgColor;
    Color borderColor;
    Color textColor;
    String iconPath;

    switch (severity) {
      case 'Critical':
        bgColor = const Color(0xFFFFE2E2);
        borderColor = const Color(0xFFFFC9C9);
        textColor = const Color(0xFF9F0712);
        iconPath = Assets.icons.userManagementIcon.path;
        break;
      case 'High':
        bgColor = const Color(0xFFFFEDD4);
        borderColor = const Color(0xFFFFD6A7);
        textColor = const Color(0xFF9F2D00);
        iconPath = Assets.icons.userManagementIcon.path;
        break;
      case 'Medium':
        bgColor = const Color(0xFFFEF9C2);
        borderColor = const Color(0xFFFFF085);
        textColor = const Color(0xFF894B00);
        iconPath = Assets.icons.userManagementIcon.path;
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        borderColor = const Color(0xFFE5E7EB);
        textColor = const Color(0xFF6B7280);
        iconPath = Assets.icons.userManagementIcon.path;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 12,
            height: 12,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Text(
            severity,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    final isActive = status == 'Active';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFECFDF3)
            : const Color(0xFFF3F4F6),
        border: Border.all(
          color: isActive
              ? const Color(0xFFB9F8CF)
              : const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive
              ? const Color(0xFF008236)
              : const Color(0xFF364153),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.8,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF030213),
        ),
      ),
    );
  }

  Widget _buildEnforcementToggle(
    SecurityPolicyModel policy,
    bool isDark,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Enforcement: ',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w400,
            color: isDark
                ? const Color(0xFF9CA3AF)
                : const Color(0xFF4A5565),
          ),
        ),
        GestureDetector(
          onTap: () => _toggleEnforcement(policy.id),
          child: Container(
            width: 32,
            height: 18.4,
            decoration: BoxDecoration(
              color: policy.isEnforced
                  ? const Color(0xFF030213).withValues(alpha: 0.5)
                  : const Color(0xFFCBCED4).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16777200),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: policy.isEnforced
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          policy.isEnforced ? 'Enabled' : 'Disabled',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.6,
            fontWeight: FontWeight.w400,
            color: policy.isEnforced
                ? const Color(0xFF008236)
                : const Color(0xFF6A7282),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String iconPath,
    VoidCallback onPressed,
    bool isDark,
  ) {
    return SizedBox(
      width: 38,
      height: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? context.themeCardBackground : Colors.white,
          foregroundColor: isDark ? Colors.white : const Color(0xFF0F172B),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            isDark ? Colors.white : const Color(0xFF0F172B),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
