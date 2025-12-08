import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/security_profile_model.dart';

class SecurityProfilesScreen extends StatefulWidget {
  const SecurityProfilesScreen({super.key});

  @override
  State<SecurityProfilesScreen> createState() => _SecurityProfilesScreenState();
}

class _SecurityProfilesScreenState extends State<SecurityProfilesScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';
  late List<SecurityProfileModel> _filteredProfiles;

  @override
  void initState() {
    super.initState();
    _filteredProfiles = List.of(sampleSecurityProfiles);
    _searchController.addListener(_filterProfiles);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProfiles() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredProfiles = sampleSecurityProfiles.where((profile) {
        final matchesSearch =
            query.isEmpty ||
            profile.name.toLowerCase().contains(query) ||
            profile.code.toLowerCase().contains(query) ||
            profile.description.toLowerCase().contains(query);

        final matchesFilter =
            _selectedFilter == 'All' || profile.category == _selectedFilter;

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filterProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.securityProfilesBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, l10n, isMobile),
                const SizedBox(height: 24),
                _buildStatsRow(context, l10n, isMobile, constraints.maxWidth),
                const SizedBox(height: 24),
                _buildSearchAndFilters(
                  context,
                  l10n,
                  isMobile,
                  constraints.maxWidth,
                ),
                const SizedBox(height: 24),
                _buildProfilesGrid(context, l10n, isMobile),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    bool isMobile,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.securityProfilesIconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            Assets.icons.dataSecurityIcon.path,
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.securityProfiles,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  height: 24 / 15.3,
                  letterSpacing: 0,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Define permission sets for different functional areas',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.6,
                  fontWeight: FontWeight.w400,
                  height: 20 / 13.6,
                  letterSpacing: 0,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (!isMobile) ...[
          const SizedBox(width: 16),
          InkWell(
            onTap: () {
              // Handle create profile
            },
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.securityProfilesButtonBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Assets.icons.addIcon.path,
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      AppColors.cardBackground,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Create Profile',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.8,
                      fontWeight: FontWeight.w500,
                      height: 20 / 13.8,
                      letterSpacing: 0,
                      color: AppColors.cardBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    AppLocalizations l10n,
    bool isMobile,
    double maxWidth,
  ) {
    final totalProfiles = sampleSecurityProfiles.length;
    final activeProfiles = sampleSecurityProfiles
        .where((p) => p.status == 'Active')
        .length;
    final totalUsers = sampleSecurityProfiles.fold<int>(
      0,
      (sum, p) => sum + p.usersAssigned,
    );
    final categories = sampleSecurityProfiles
        .map((p) => p.category)
        .toSet()
        .length;

    final stats = [
      {
        'label': 'Total Profiles',
        'value': '$totalProfiles',
        'icon': Assets.icons.dataSecurityIcon.path,
        'color': AppColors.statIconBlue,
      },
      {
        'label': 'Active',
        'value': '$activeProfiles',
        'icon': Assets.icons.lockIcon.path,
        'color': AppColors.statIconGreen,
      },
      {
        'label': 'Users Assigned',
        'value': '$totalUsers',
        'icon': Assets.icons.userManagementIcon.path,
        'color': AppColors.statIconOrange,
      },
      {
        'label': 'Categories',
        'value': '$categories',
        'icon': Assets.icons.additionalInfoIcon.path,
        'color': AppColors.statIconPurple,
      },
    ];

    if (isMobile || maxWidth < 900) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) => _buildStatCard(context, stats[index]),
      );
    }

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildStatCard(context, stat),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(BuildContext context, Map<String, dynamic> stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: SvgPicture.asset(
              stat['icon'] as String,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                stat['color'] as Color,
                BlendMode.srcIn,
              ),
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
                    fontSize: stat['label'] == 'Active' ? 13.5 : 13.6,
                    fontWeight: FontWeight.w400,
                    height: 20 / (stat['label'] == 'Active' ? 13.5 : 13.6),
                    letterSpacing: 0,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stat['value'] as String,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: stat['value'] == '124' ? 22.9 : 24,
                    fontWeight: FontWeight.w400,
                    height: 32 / (stat['value'] == '124' ? 22.9 : 24),
                    letterSpacing: 0,
                    color: AppColors.textPrimary,
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
    bool isMobile,
    double maxWidth,
  ) {
    final filters = [
      'All',
      'General Ledger',
      'Accounts Payable',
      'Accounts Receivable',
      'Cash Management',
      'Fixed Assets',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: isMobile
          ? Column(
              children: [
                CustomTextField.search(
                  controller: _searchController,
                  hintText: 'Search profiles...',
                  height: 36,
                  filled: true,
                  fillColor: AppColors.securityProfilesSearchBg,
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildFilterButton(filter, isSelected),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextField.search(
                    controller: _searchController,
                    hintText: 'Search profiles...',
                    height: 36,
                    filled: true,
                    fillColor: AppColors.securityProfilesSearchBg,
                  ),
                ),
                const SizedBox(width: 12),
                ...filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterButton(filter, isSelected),
                  );
                }),
              ],
            ),
    );
  }

  Widget _buildFilterButton(String filter, bool isSelected) {
    // Define specific widths based on Figma design
    final Map<String, double> filterWidths = {
      'All': 40.73,
      'General Ledger': 127.13,
      'Accounts Payable': 143.13,
      'Accounts Receivable': 163.15,
      'Cash Management': 149.28,
      'Fixed Assets': 109.27,
    };

    return InkWell(
      onTap: () => _onFilterChanged(filter),
      child: Container(
        height: 32,
        width: filterWidths[filter],
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.securityProfilesButtonBg : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.cardBorder,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          filter,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: filter == 'All' ? 14 : 13.7,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.cardBackground : AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildProfilesGrid(
      BuildContext context,
      AppLocalizations l10n,
      bool isMobile,
      ) {
    if (_filteredProfiles.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                Assets.icons.dataSecurityIcon.path,
                width: 64,
                height: 64,
                colorFilter: const ColorFilter.mode(
                  AppColors.textPlaceholder,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'No Security Profiles Found',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  height: 24 / 15.3,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Try adjusting your search or filters',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.1,
                  fontWeight: FontWeight.w400,
                  height: 24 / 15.1,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final width = MediaQuery.of(context).size.width;

    // Treat very narrow widths as "small" even if isMobile flag is off
    final bool useListView = isMobile || width < 700;

    // 📱 SMALL SCREENS → LIST VIEW
    if (useListView) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredProfiles.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildProfileCard(context, _filteredProfiles[index]);
        },
      );
    }

    // 🖥️ LARGER SCREENS → GRID VIEW
    // Dynamic columns based on width
    int crossAxisCount;
    if (width < 1100) {
      crossAxisCount = 2; // small laptop / tablet landscape
    } else if (width < 1600) {
      crossAxisCount = 3; // normal desktop
    } else {
      crossAxisCount = 4; // big / ultra-wide
    }

    // Higher = shorter card height
    double childAspectRatio;
    if (width < 1100) {
      childAspectRatio = 1.6;  // a bit taller for smaller desktop/tablet
    } else if (width < 1600) {
      childAspectRatio = 1.2;  // balanced
    } else {
      childAspectRatio = 1.5;  // shorter, very “web-ish”
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: _filteredProfiles.length,
      itemBuilder: (context, index) {
        return _buildProfileCard(context, _filteredProfiles[index]);
      },
    );
  }




  Widget _buildProfileCard(BuildContext context, SecurityProfileModel profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title, status, category, and actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.1,
                            fontWeight: FontWeight.w400,
                            height: 24 / 15.1,
                            letterSpacing: 0,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 22,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: AppColors.activeStatusBgLight,
                            border: Border.all(color: AppColors.activeStatusBorderLight),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Active',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 16 / 12,
                                letterSpacing: 0,
                                color: AppColors.activeStatusTextLight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (profile.code.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        profile.code,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12,
                          letterSpacing: 0,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                    if (profile.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        profile.description,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.6,
                          fontWeight: FontWeight.w400,
                          height: 20 / 13.6,
                          letterSpacing: 0,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.cardBorder,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        profile.category,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 16 / 12,
                          letterSpacing: 0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons - positioned at top right
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      // Handle edit
                    },
                    child: SvgPicture.asset(
                      Assets.icons.editIcon.path,
                      width: 16,
                      height: 16,
                    ),
                  ),
                 24.horizontalSpace,
                  InkWell(
                    onTap: () {
                      // Handle delete
                    },
                    child: SvgPicture.asset(
                      Assets.icons.deleteIcon.path,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.deleteIconRed,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          48.verticalSpace,
          // Permissions section
          const Text(
            'Permissions:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
              letterSpacing: 0,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.permissions.map((permission) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.permissionBadgeBg,
                  border: Border.all(color: AppColors.permissionBadgeBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  permission,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 16 / 12,
                    letterSpacing: 0,
                    color: AppColors.permissionBadgeText,
                  ),
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          // Footer with user count and created date
          Container(
            height: 33,
            padding: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.cardBorder,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.icons.userManagementIcon.path,
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '${profile.usersAssigned} users',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.7,
                    fontWeight: FontWeight.w400,
                    height: 20 / 13.7,
                    letterSpacing: 0,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  'Created: ${profile.createdDate}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                    letterSpacing: 0,
                    color: AppColors.textSecondary,
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
