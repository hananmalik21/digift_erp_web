import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/data_access_set_model.dart';

class DataAccessSetsScreen extends StatefulWidget {
  const DataAccessSetsScreen({super.key});

  @override
  State<DataAccessSetsScreen> createState() => _DataAccessSetsScreenState();
}

class _DataAccessSetsScreenState extends State<DataAccessSetsScreen> {
  final _searchController = TextEditingController();
  late List<DataAccessSetModel> _filteredDataAccessSets;

  @override
  void initState() {
    super.initState();
    _filteredDataAccessSets = List.of(sampleDataAccessSets);
    _searchController.addListener(_filterDataAccessSets);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDataAccessSets() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredDataAccessSets = sampleDataAccessSets.where((das) {
        return query.isEmpty ||
            das.name.toLowerCase().contains(query) ||
            das.code.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

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
                _buildStatsRow(context, l10n, isDark, isMobile),
                SizedBox(height: isMobile ? 16 : 24),
                _buildSearchCard(context, l10n, isDark, isMobile),
                SizedBox(height: isMobile ? 16 : 24),
                _buildDataAccessSetsList(context, l10n, isDark, isMobile),
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
            color: AppColors.successBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            Assets.icons.dataSecurityIcon.path,
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
                l10n.dataAccessSets,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.w600,
                  color: context.themeTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.dataAccessSetsSubtitle,
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
          CustomButton.primary(
            text: l10n.createDataAccessSet,
            icon: Icons.add,
            onPressed: () {},
            width: 190,
          ),
        ],
      ],
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    final stats = [
      {
        'label': l10n.totalDataAccessSets,
        'value': '${sampleDataAccessSets.length}',
        'icon': Assets.icons.dataSecurityIcon.path,
        'color': AppColors.primary,
      },
      {
        'label': l10n.ledgerBased,
        'value': '${sampleDataAccessSets.where((d) => d.accessType == "Ledger").length}',
        'icon': Assets.icons.boxIcon.path,
        'color': AppColors.info,
      },
      {
        'label': l10n.entityBased,
        'value': '${sampleDataAccessSets.where((d) => d.accessType == "Legal Entity").length}',
        'icon': Assets.icons.accountsPayableIcon.path,
        'color': AppColors.success,
      },
      {
        'label': 'Users Assigned',
        'value': '${sampleDataAccessSets.fold<int>(0, (sum, d) => sum + d.usersAssigned)}',
        'icon': Assets.icons.userManagementIcon.path,
        'color': AppColors.warning,
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
        itemBuilder: (context, index) => _buildStatCard(context, stats[index], isDark),
      );
    }

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
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
            colorFilter: ColorFilter.mode(stat['color'], BlendMode.srcIn),
          ),
          const SizedBox(height: 12),
          Text(
            stat['label'],
            style: TextStyle(fontSize: 13, color: context.themeTextSecondary),
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
      child: CustomTextField.search(
        controller: _searchController,
        hintText: l10n.searchDataAccessSets,
        filled: true,
        fillColor: context.themeBackground,
      ),
    );
  }

  Widget _buildDataAccessSetsList(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    if (_filteredDataAccessSets.isEmpty) {
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
                l10n.noDataAccessSetsFound,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.themeTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.tryAdjustingFilters,
                style: TextStyle(color: context.themeTextSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _filteredDataAccessSets.map((das) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildDataAccessSetCard(context, das, isDark, isMobile, l10n),
        );
      }).toList(),
    );
  }

  Widget _buildDataAccessSetCard(
    BuildContext context,
    DataAccessSetModel das,
    bool isDark,
    bool isMobile,
    AppLocalizations l10n,
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: das.accessType == 'Ledger'
                      ? AppColors.infoBg
                      : AppColors.successBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  das.accessType,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: das.accessType == 'Ledger'
                        ? AppColors.infoText
                        : AppColors.successText,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.successBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.successBorder),
                ),
                child: Text(
                  das.status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.successText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            das.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.themeTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            das.code,
            style: TextStyle(fontSize: 13, color: context.themeTextSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            das.description,
            style: TextStyle(fontSize: 14, color: context.themeTextSecondary),
          ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              children: [
                _buildInfoRow('${l10n.accessScope}: ${das.accessScope}', context),
                const SizedBox(height: 8),
                _buildInfoRow('Users Assigned: ${das.usersAssigned}', context),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child:
                      _buildInfoRow('${l10n.accessScope}: ${das.accessScope}', context),
                ),
                Expanded(
                  child: _buildInfoRow('Users Assigned: ${das.usersAssigned}', context),
                ),
              ],
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
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
                  icon: const Icon(Icons.visibility, size: 16),
                  label: Text(l10n.view),
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

  Widget _buildInfoRow(String text, BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 6, color: context.themeTextTertiary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: context.themeTextSecondary),
          ),
        ),
      ],
    );
  }
}
