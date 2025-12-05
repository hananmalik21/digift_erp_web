import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/role_template_model.dart';
import '../widgets/create_template_dialog.dart';

class RoleTemplatesScreen extends StatefulWidget {
  const RoleTemplatesScreen({super.key});

  @override
  State<RoleTemplatesScreen> createState() => _RoleTemplatesScreenState();
}

class _RoleTemplatesScreenState extends State<RoleTemplatesScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  late List<RoleTemplateModel> _filteredTemplates;

  @override
  void initState() {
    super.initState();
    _filteredTemplates = List.of(sampleRoleTemplates);
    _searchController.addListener(_filterTemplates);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTemplates() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredTemplates = sampleRoleTemplates.where((template) {
        final matchesSearch =
            query.isEmpty ||
            template.name.toLowerCase().contains(query) ||
            template.code.toLowerCase().contains(query);
        final matchesCategory =
            _selectedCategory == 'All' ||
            template.category == _selectedCategory;
        return matchesSearch && matchesCategory;
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
            SizedBox(height: isMobile ? 16 : 20),
            _buildStatsCards(context, l10n, isDark, isMobile, isTablet),
            SizedBox(height: isMobile ? 16 : 20),
            _buildSearchAndFilter(context, l10n, isDark, isMobile),
            SizedBox(height: isMobile ? 16 : 24),
            _buildTemplatesGrid(context, l10n, isDark, isMobile, isTablet),
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
                  color: isDark
                      ? context.themeCardBackground
                      : const Color(0xFFDDEBFE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.roleTermplate.path,
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
                      l10n.roleTemplates,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.3,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.roleTemplatesSubtitle,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildImportButton(context, l10n, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _buildCreateTemplateButton(context, l10n, isDark)),
            ],
          ),
        ],
      );
    }

    return Row(
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
              Assets.icons.roleTermplate.path,
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
                l10n.roleTemplates,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.roleTemplatesSubtitle,
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
        _buildImportButton(context, l10n, isDark),
        const SizedBox(width: 8),
        _buildCreateTemplateButton(context, l10n, isDark),
      ],
    );
  }

  Widget _buildImportButton(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return SizedBox(
      height: 36,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? context.themeCardBackground : Colors.white,
          foregroundColor: isDark ? Colors.white : const Color(0xFF0F172B),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.icons.importIcon.path,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                isDark ? Colors.white : const Color(0xFF0F172B),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.import,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateTemplateButton(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => const CreateTemplateDialog(),
          );
          if (result != null) {
            // Handle the created template
            // You can add it to the list or refresh data here
          }
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
            Text(
              l10n.createTemplate,
              style: const TextStyle(
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
  ) {
    final stats = [
      {
        'label': l10n.totalTemplates,
        'value': '7',
        'icon': Assets.icons.accountsPayableIcon.path,
        'color': const Color(0xFF155DFC),
      },
      {
        'label': 'Active',
        'value': '6',
        'icon': Assets.icons.workflowApprovalsIcon.path,
        'color': const Color(0xFF00A63E),
      },
      {
        'label': 'Draft',
        'value': '1',
        'icon': Assets.icons.clockIcon.path,
        'color': const Color(0xFFF54900),
      },
      {
        'label': 'Times Used',
        'value': '118',
        'icon': Assets.icons.copyIcon.path,
        'color': const Color(0xFF9810FA),
      },
    ];

    // Mobile: 2x2 grid
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

    // Tablet: 2x2 grid or single row based on width
    if (isTablet) {
      return LayoutBuilder(
        builder: (context, constraints) {
          // If width is sufficient, show single row, otherwise 2x2 grid
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

    // Desktop: Single row
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
            colorFilter:  ColorFilter.mode(
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

  Widget _buildSearchAndFilter(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    final categories = [
      'All',
      'Finance',
      'Treasury',
      'Expense',
      'Audit',
      'Security',
    ];

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
                  flex: 5,
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
          fontSize: 13.7,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : const Color(0xFF0F172B),
        ),
        decoration: InputDecoration(
          hintText: 'Search templates...',
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF6B7280) : const Color(0xFF717182),
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
            _filterTemplates();
          });
        },
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              fontSize: 13.7,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white : const Color(0xFF0F172B)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplatesGrid(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    // Use ListView for mobile and tablet, GridView for desktop
    if (isMobile || isTablet) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredTemplates.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < _filteredTemplates.length - 1 ? 24 : 0,
            ),
            child: _buildTemplateCard(
              context,
              _filteredTemplates[index],
              isDark,
            ),
          );
        },
      );
    }

    // Desktop: Use LayoutBuilder for responsive grid
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate optimal card width (between 350-400px)
        final cardWidth = 370.0;
        final spacing = 24.0;
        
        // Calculate how many columns can fit
        int crossAxisCount = ((constraints.maxWidth + spacing) / (cardWidth + spacing)).floor();
        crossAxisCount = crossAxisCount.clamp(2, 3); // Minimum 2, maximum 3 columns
        
        // Calculate actual card width based on available space
        final totalSpacing = spacing * (crossAxisCount - 1);
        final availableWidth = constraints.maxWidth - totalSpacing;
        final actualCardWidth = availableWidth / crossAxisCount;
        
        // Reduced card height for more compact display
        final cardHeight = 390.0;
        final childAspectRatio = actualCardWidth / cardHeight;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: _filteredTemplates.length,
          itemBuilder: (context, index) {
            return _buildTemplateCard(
              context,
              _filteredTemplates[index],
              isDark,
            );
          },
        );
      },
    );
  }

  Widget _buildTemplateCard(
    BuildContext context,
    RoleTemplateModel template,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        boxShadow: template.isHighlighted
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTemplateHeader(template, isDark),
                const SizedBox(height: 18),
                _buildTemplateName(template, isDark),
                const SizedBox(height: 16),
                _buildTemplateCode(template, isDark),
                const SizedBox(height: 16),
                _buildTemplateDescription(template, isDark),
                const SizedBox(height: 20),
                _buildTemplateDetails(template, isDark),
                const SizedBox(height: 20),
                _buildTemplateButtons(context, template, isDark),
              ],
            ),
          ),
          _buildTemplateFooter(template, isDark),
        ],
      ),
    );
  }

  Widget _buildTemplateHeader(RoleTemplateModel template, bool isDark) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.icons.roleTermplate.path,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            Color(0xFF155DFC),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        _buildStatusBadge(template.status, isDark),
        const Spacer(),
        _buildTypeBadge(template.type, isDark),
      ],
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    final isActive = status == 'Active';

    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFECFDF5)
            : (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6)),
        border: Border.all(
          color: isActive ? const Color(0xFFB9F8CF) : const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        status,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive
              ? const Color(0xFF008236)
              : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF364153)),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type, bool isDark) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        type,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF0F172B),
        ),
      ),
    );
  }

  Widget _buildTemplateName(RoleTemplateModel template, bool isDark) {
    return Text(
      template.name,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 15.3,
        fontWeight: FontWeight.w400,
        color: isDark ? Colors.white : const Color(0xFF0F172B),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTemplateCode(RoleTemplateModel template, bool isDark) {
    return Text(
      template.code,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
      ),
    );
  }

  Widget _buildTemplateDescription(RoleTemplateModel template, bool isDark) {
    return Text(
      template.description,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13.6,
        fontWeight: FontWeight.w400,
        height: 1.47,
        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTemplateDetails(RoleTemplateModel template, bool isDark) {
    return Column(
      children: [
        _buildDetailRow('Category:', template.category, isDark),
        const SizedBox(height: 8),
        _buildDetailRow('Privileges:', '${template.privilegesCount}', isDark),
        const SizedBox(height: 8),
        _buildDetailRow('Used:', '${template.timesUsed} times', isDark),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.6,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.6,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateButtons(
    BuildContext context,
    RoleTemplateModel template,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF030213),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.icons.visibleIcon.path,
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Use Template',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.7,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildIconButton(Assets.icons.copyIcon.path, () {}, isDark),
        const SizedBox(width: 8),
        _buildIconButton(Assets.icons.downloadIcon.path, () {}, isDark),
        const SizedBox(width: 8),
        _buildIconButton(Assets.icons.editIcon.path, () {}, isDark),
      ],
    );
  }

  Widget _buildIconButton(String iconPath, VoidCallback onPressed, bool isDark) {
    return SizedBox(
      width: 38,
      height: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? context.themeCardBackground : Colors.white,
          foregroundColor: isDark ? Colors.white : const Color(0xFF0F172B),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildTemplateFooter(RoleTemplateModel template, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Text(
        template.createdBy,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.8,
          fontWeight: FontWeight.w400,
          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
        ),
      ),
    );
  }
}
