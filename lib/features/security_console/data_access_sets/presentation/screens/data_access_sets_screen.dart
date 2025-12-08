import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/data_access_set_model.dart';
import '../widgets/create_data_access_set_dialog.dart';

class DataAccessSetsScreen extends StatefulWidget {
  const DataAccessSetsScreen({super.key});

  @override
  State<DataAccessSetsScreen> createState() => _DataAccessSetsScreenState();
}

class _DataAccessSetsScreenState extends State<DataAccessSetsScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterDataAccessSets);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDataAccessSets() {
    setState(() {
      // Filter logic can be added here when needed
      // For now, we always show empty state
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filterDataAccessSets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
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
                _buildSearchAndFilters(context, l10n, isMobile, constraints.maxWidth),
                const SizedBox(height: 24),
                _buildDataAccessSetCard(context, l10n),
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
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            Assets.icons.dbIcon.path,
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
                l10n.dataAccessSets,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.1,
                  fontWeight: FontWeight.w400,
                  height: 24 / 15.1,
                  color: Color(0xFF0F172B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Define data security boundaries for ledgers, entities, and business units',
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
        ),
        if (!isMobile) ...[
          const SizedBox(width: 16),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const CreateDataAccessSetDialog(),
              ).then((result) {
                if (result != null && context.mounted) {
                  // Handle the created data access set
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data Access Set created successfully'),
                    ),
                  );
                }
              });
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
                    'Create Data Access Set',
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
    final totalSets = sampleDataAccessSets.length;
    final activeSets = sampleDataAccessSets.where((d) => d.status == 'Active').length;
    final totalUsers = sampleDataAccessSets.fold<int>(0, (sum, d) => sum + d.usersAssigned);
    final totalRoles = 0; // This would come from actual data

    final stats = [
      {
        'label': 'Total Sets',
        'value': '$totalSets',
        'icon': Assets.icons.dbIcon.path,
        "color":Color(0xff155DFC)
      },
      {
        'label': 'Active',
        'value': '$activeSets',
        'icon': Assets.icons.lockIcon.path,
        "color":Color(0xff00A63E)

      },
      {
        'label': 'Users Assigned',
        'value': '$totalUsers',
        'icon': Assets.icons.additionalInfoIcon.path,
        "color":Color(0xffF54900)

      },
      {
        'label': 'Roles Assigned',
        'value': '$totalRoles',
        'icon': Assets.icons.dollarIcon.path,
        "color":Color(0xff9810FA)

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

  Widget _buildStatCard(BuildContext context, Map<String, dynamic> stat)  {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: SvgPicture.asset(
              stat['icon']!,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(stat["color"], BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat['label']!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    height: 20 / 13.6,
                    color: Color(0xFF4A5565),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stat['value']!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    height: 32 / 24,
                    color: Color(0xFF0F172B),
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
    final filters = ['All', 'Ledger', 'Legal Entity', 'Business Unit', 'Multi-Dimensional'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: isMobile
          ? Column(
              children: [
                CustomTextField.search(
                  controller: _searchController,
                  hintText: 'Search data access sets...',
                  filled: true,
                  fillColor: const Color(0xFFF3F3F5),
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
                    hintText: 'Search data access sets...',
                    filled: true,
                    fillColor: const Color(0xFFF3F3F5),
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
      'All': 42.73,
      'Ledger': 72.16,
      'Legal Entity': 101.21,
      'Business Unit': 115.98,
      'Multi-Dimensional': 146.05,
    };

    return InkWell(
      onTap: () => _onFilterChanged(filter),
      child: Container(
        height: 32,
        width: filterWidths[filter],
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF030213) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black.withValues(alpha: isSelected ? 0 : 0.1),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          filter,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: filter == 'All' ? 14 : 13.7,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF0A0A0A),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDataAccessSetCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with icon, title, badges, and action buttons
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.dataAccessSetsIcon.path,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Express Data Access Set',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.1,
                    fontWeight: FontWeight.w400,
                    height: 24 / 15.1,
                    color: Color(0xFF0F172B),
                  ),
                ),
              ),
              // Code badge
              Container(
                height: 22,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Express001',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0A0A0A),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Status badge
              Container(
                height: 22,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  border: Border.all(color: const Color(0xFFB9F8CF)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Active',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF008236),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Type badge
              Container(
                height: 22,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Ledger',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0A0A0A),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Edit button
              InkWell(
                onTap: () {
                  // Handle edit
                },
                child: Container(
                  width: 38,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.icons.editIcon.path,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Delete button
              InkWell(
                onTap: () {
                  // Handle delete
                },
                child: Container(
                  width: 38,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.icons.deleteIcon.path,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFB2C36),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Details row
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Ledgers (0)',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      color: Color(0xFF6A7282),
                    ),
                  ),
                  Expanded(child: Container()),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Legal Entities (1)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12,
                          color: Color(0xFF6A7282),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 22,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'LE-006',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0A0A0A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  const Text(
                    'Business Units (0)',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      color: Color(0xFF6A7282),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          // Divider before metadata
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.black.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          // Metadata row
          Row(
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.7,
                    fontWeight: FontWeight.w400,
                    height: 20 / 13.7,
                    color: Color(0xFF4A5565),
                  ),
                  children: [
                    TextSpan(text: 'Users: '),
                    TextSpan(
                      text: '0',
                      style: TextStyle(color: Color(0xFF0F172B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 58),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w400,
                    height: 20 / 13.8,
                    color: Color(0xFF4A5565),
                  ),
                  children: [
                    TextSpan(text: 'Roles: '),
                    TextSpan(
                      text: '0',
                      style: TextStyle(color: Color(0xFF0F172B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 76),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    height: 20 / 13.5,
                    color: Color(0xFF4A5565),
                  ),
                  children: [
                    TextSpan(text: 'Created: '),
                    TextSpan(
                      text: '12/2/2025',
                      style: TextStyle(color: Color(0xFF0F172B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
