import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/function_privilege_model.dart';
import '../widgets/create_privilege_dialog.dart';

class FunctionPrivilegesScreen extends StatefulWidget {
  const FunctionPrivilegesScreen({super.key});

  @override
  State<FunctionPrivilegesScreen> createState() =>
      _FunctionPrivilegesScreenState();
}

class _FunctionPrivilegesScreenState extends State<FunctionPrivilegesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedModule = 'All Modules';
  String _selectedOperation = 'All Operations';
  String _selectedStatus = 'All Status';
  
  List<FunctionPrivilegeModel> _privileges = [];
  List<FunctionPrivilegeModel> _filteredPrivileges = [];

  @override
  void initState() {
    super.initState();
    _privileges = FunctionPrivilegeModel.getSamplePrivileges();
    _filteredPrivileges = _privileges;
    _searchController.addListener(_filterPrivileges);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPrivileges() {
    setState(() {
      _filteredPrivileges = _privileges.where((privilege) {
        final matchesSearch = _searchController.text.isEmpty ||
            privilege.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            privilege.code
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            privilege.function
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            privilege.description
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        final matchesModule = _selectedModule == 'All Modules' ||
            privilege.module == _selectedModule;

        final matchesOperation = _selectedOperation == 'All Operations' ||
            privilege.operation == _selectedOperation;

        final matchesStatus = _selectedStatus == 'All Status' ||
            privilege.status == _selectedStatus;

        return matchesSearch &&
            matchesModule &&
            matchesOperation &&
            matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    final totalPrivileges = _privileges.length;
    final activePrivileges =
        _privileges.where((p) => p.status == 'Active').length;
    final inactivePrivileges =
        _privileges.where((p) => p.status == 'Inactive').length;
    final totalRoleUsage =
        _privileges.fold<int>(0, (sum, p) => sum + p.usedInRoles);
    final uniqueModules = _privileges.map((p) => p.module).toSet().length;

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
              isDark,
              isMobile,
              isTablet,
              totalPrivileges,
              activePrivileges,
              inactivePrivileges,
              totalRoleUsage,
              uniqueModules,
            ),
            const SizedBox(height: 24),
            _buildSearchAndFilters(context, isDark, isMobile),
            const SizedBox(height: 24),
            isMobile
                ? _buildMobileList(context, isDark)
                : _buildDataTable(context, isDark),
            const SizedBox(height: 16),
            _buildFooter(context, isDark, totalPrivileges, totalRoleUsage),
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
              SvgPicture.asset(
                Assets.icons.keyIcon.path,
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  isDark ? Colors.white : const Color(0xFF155DFC),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Function Privileges',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.4,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Granular permissions for specific system functions',
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
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildRefreshButton(context, isDark)),
              const SizedBox(width: 8),
              Expanded(child: _buildCreateButton(context, isDark)),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SvgPicture.asset(
            Assets.icons.keyIcon.path,
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              isDark ? Colors.white : const Color(0xFF155DFC),
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Function Privileges',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.4,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                  height: 1.56, // 24px line height / 15.4px font = 1.56
                ),
              ),
              Text(
                'Granular permissions for specific system functions',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF4A5565),
                  height: 1.57, // 24px line height / 15.3px font
                ),
              ),
            ],
          ),
        ),
        _buildRefreshButton(context, isDark),
        const SizedBox(width: 8),
        _buildCreateButton(context, isDark),
      ],
    );
  }

  Widget _buildRefreshButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 108.98,
      height: 36,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? context.themeCardBackground : Colors.white,
          foregroundColor: isDark ? Colors.white : const Color(0xFF0F172B),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh,
              size: 16,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            const SizedBox(width: 8),
            Text(
              'Refresh',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF0F172B),
                height: 1.45, // 20px / 13.8px
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 160.8,
      height: 36,
      child: ElevatedButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => const CreatePrivilegeDialog(),
          );
          if (result != null && context.mounted) {
            // Handle the created privilege data
            // You can add it to your list or refresh the data
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Privilege "${result['name']}" created successfully'),
                  backgroundColor: const Color(0xFF00A63E),
                ),
              );
            }
          }
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
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Create Privilege',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                height: 1.45, // 20px / 13.8px
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
      bool isTablet,
      int total,
      int active,
      int inactive,
      int roleUsage,
      int modules,
      ) {
    final stats = [
      {
        'label': 'Total Privileges',
        'value': '$total',
        'hasLeftBorder': false,
      },
      {
        'label': 'Active',
        'value': '$active',
        'hasLeftBorder': true,
        'leftBorderColor': const Color(0xFF00A63E),
        'valueColor': const Color(0xFF00A63E),
      },
      {
        'label': 'Inactive',
        'value': '$inactive',
        'hasLeftBorder': true,
        'leftBorderColor': const Color(0xFF4A5565),
      },
      {
        'label': 'Role Usage',
        'value': '$roleUsage',
        'hasLeftBorder': true,
        'leftBorderColor': const Color(0xFF155DFC),
      },
      {
        'label': 'Modules',
        'value': '$modules',
        'hasLeftBorder': true,
        'leftBorderColor': const Color(0xFF9810FA),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        // RESPONSIVE BREAKPOINTS
        int columns;

        if (width < 480) {
          columns = 1; // small mobile
        } else if (width < 800) {
          columns = 2; // small desktop (this fixes your screenshot)
        } else if (width < 1100) {
          columns = 3;
        } else if (width < 1400) {
          columns = 4;
        } else {
          columns = 5;
        }

        const spacing = 16.0;
        double cardWidth =
            (width - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: stats.map((stat) {
            return SizedBox(
              width: cardWidth,
              child: _buildStatCard(context, stat, isDark),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        // constraints: const BoxConstraints(minHeight: 114),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Stack(
          children: [
            if (stat['hasLeftBorder'] == true)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: stat['leftBorderColor'] ?? Colors.transparent,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 17,
                right: 17,
                bottom: 17,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                      height: 1.47, // 20px / 13.6px
                    ),
                  ),
                  const SizedBox(height: 31),
                  Text(
                    stat['value'],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: stat['valueColor'] ??
                          (isDark ? Colors.white : const Color(0xFF0F172B)),
                      height: 1.33, // 32px / 24px
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(
    BuildContext context,
    bool isDark,
    bool isMobile,
  ) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600 && size.width < 1024;

    if (isMobile) {
      // Mobile: Stack vertically
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            _buildSearchField(context, isDark),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildModuleFilter(context, isDark)),
                const SizedBox(width: 8),
                Expanded(child: _buildOperationFilter(context, isDark)),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusFilter(context, isDark),
          ],
        ),
      );
    }

    if (isTablet) {
      // Tablet: Stack vertically with wrapped filters
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            _buildSearchField(context, isDark),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildModuleFilter(context, isDark)),
                const SizedBox(width: 12),
                Expanded(child: _buildOperationFilter(context, isDark)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatusFilter(context, isDark)),
              ],
            ),
          ],
        ),
      );
    }

    // Desktop: Single row
    return Container(
      padding: const EdgeInsets.all(16),
      height: 76,
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 577,
            child: _buildSearchField(context, isDark),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 205,
            child: _buildModuleFilter(context, isDark),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 156.5,
            child: _buildOperationFilter(context, isDark),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 123,
            child: _buildStatusFilter(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, bool isDark) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DC)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.3,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : const Color(0xFF0F172B),
        ),
        decoration: InputDecoration(
          hintText: 'Search by privilege name, code, function, or description...',
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.3,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Icon(
              Icons.search,
              size: 16,
              color: isDark
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF6B7280),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 42,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 11.5,
          ),
        ),
      ),
    );
  }

  Widget _buildModuleFilter(BuildContext context, bool isDark) {
    return _buildDropdownFilter(
      context,
      isDark,
      _selectedModule,
      [
        'All Modules',
        'General Ledger',
        'Accounts Payable',
        'Accounts Receivable',
        'Cash Management',
        'Fixed Assets'
      ],
      (value) {
        setState(() {
          _selectedModule = value!;
          _filterPrivileges();
        });
      },
    );
  }

  Widget _buildOperationFilter(BuildContext context, bool isDark) {
    return _buildDropdownFilter(
      context,
      isDark,
      _selectedOperation,
      [
        'All Operations',
        'Create',
        'Read',
        'Update',
        'Delete',
        'Post',
        'Approve',
        'Export'
      ],
      (value) {
        setState(() {
          _selectedOperation = value!;
          _filterPrivileges();
        });
      },
    );
  }

  Widget _buildStatusFilter(BuildContext context, bool isDark) {
    return _buildDropdownFilter(
      context,
      isDark,
      _selectedStatus,
      ['All Status', 'Active', 'Inactive'],
      (value) {
        setState(() {
          _selectedStatus = value!;
          _filterPrivileges();
        });
      },
    );
  }

  Widget _buildDropdownFilter(
    BuildContext context,
    bool isDark,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DC)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.keyboard_arrow_down, size: 20),
          ),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.4,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
            height: 1.23, // 19px / 15.4px
          ),
          dropdownColor: isDark ? context.themeCardBackground : Colors.white,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.only(left: 21),
                child: Text(item),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, bool isDark) {
    if (_filteredPrivileges.isEmpty) {
      return _buildEmptyState(context, isDark);
    }

    return Column(
      children: _filteredPrivileges
          .map((privilege) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildMobileCard(context, privilege, isDark),
              ))
          .toList(),
    );
  }

  Widget _buildMobileCard(
    BuildContext context,
    FunctionPrivilegeModel privilege,
    bool isDark,
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
          Text(
            privilege.code,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.33,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            privilege.name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.47,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            privilege.description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF6A7282),
              height: 1.36,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 16,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    privilege.module,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.8,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : const Color(0xFF101828),
                    ),
                  ),
                ],
              ),
              _buildOperationBadge(privilege.operation, isDark),
              _buildStatusBadge(privilege.status, isDark),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Used in ${privilege.usedInRoles} roles',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.8,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6A7282),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${privilege.updatedDate} by ${privilege.updatedBy}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.8,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6A7282),
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButtons(context, privilege, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, bool isDark) {
    if (_filteredPrivileges.isEmpty) {
      return _buildEmptyState(context, isDark);
    }

    final size = MediaQuery.of(context).size;
    // Calculate max height: screen height - header - stats - search - footer - padding
    // Leave space for approximately 6-8 rows to be visible
    final maxTableHeight = (size.height - 500).clamp(300.0, 600.0);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1358, // Total width from all column widths
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTableHeader(context, isDark),
                SizedBox(
                  height: maxTableHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      children: _filteredPrivileges
                          .map((privilege) => _buildTableRow(
                                context,
                                privilege,
                                isDark,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, bool isDark) {
    return Container(
      height: 64.5,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF374151)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('PRIVILEGE CODE', 153.27),
          _buildHeaderCell('PRIVILEGE NAME', 335.23),
          _buildHeaderCell('MODULE', 141.37),
          _buildHeaderCell('FUNCTION', 111.04),
          _buildHeaderCell('OPERATION', 108.95),
          _buildHeaderCellMultiLine('USED\nIN\nROLES', 70.47),
          _buildHeaderCell('STATUS', 101.01),
          _buildHeaderCell('UPDATED', 128.66),
          _buildHeaderCell('ACTIONS', 108),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      alignment: text == 'ACTIONS' ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: text == 'ACTIONS' ? 0 : 16,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF364153),
          letterSpacing: 0.6,
          height: 1.33, // 16px / 12px
        ),
      ),
    );
  }

  Widget _buildHeaderCellMultiLine(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF364153),
          letterSpacing: 0.6,
          height: 1.33, // 16px / 12px
        ),
      ),
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    FunctionPrivilegeModel privilege,
    bool isDark,
  ) {
    return Container(
      height: 61,
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF374151)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(
            privilege.code,
            153.27,
            12,
            FontWeight.w400,
            isDark,
          ),
          _buildNameDescriptionCell(
            privilege.name,
            privilege.description,
            335.23,
            isDark,
          ),
          _buildModuleCell(privilege.module, 141.37, isDark),
          _buildDataCell(
            privilege.function,
            111.04,
            11.8,
            FontWeight.w400,
            isDark,
          ),
          _buildOperationCell(privilege.operation, 108.95, isDark),
          _buildUsedInRolesCell(privilege.usedInRoles, 70.47, isDark),
          _buildStatusCell(privilege.status, 101.01, isDark),
          _buildUpdatedCell(
            privilege.updatedDate,
            privilege.updatedBy,
            128.66,
            isDark,
          ),
          _buildActionsCell(context, privilege, 108, isDark),
        ],
      ),
    );
  }

  Widget _buildDataCell(
    String text,
    double width,
    double fontSize,
    FontWeight fontWeight,
    bool isDark,
  ) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: isDark ? Colors.white : const Color(0xFF0F172B),
          height: 1.33,
        ),
      ),
    );
  }

  Widget _buildNameDescriptionCell(
    String name,
    String description,
    double width,
    bool isDark,
  ) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.47, // 20px / 13.6px
            ),
          ),
          const SizedBox(height: 0.5),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF6A7282),
              height: 1.36, // 16px / 11.8px
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCell(String module, double width, bool isDark) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Icon(
            Icons.folder_outlined,
            size: 16,
            color: isDark
                ? const Color(0xFF9CA3AF)
                : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              module,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.8,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : const Color(0xFF101828),
                height: 1.36,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationCell(String operation, double width, bool isDark) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16),
      child: _buildOperationBadge(operation, isDark),
    );
  }

  Widget _buildOperationBadge(String operation, bool isDark) {
    Color bgColor;
    Color borderColor;
    Color textColor;

    switch (operation) {
      case 'Create':
        bgColor = const Color(0xFFD1FAE5); // green-100
        borderColor = const Color(0xFFB9F8CF);
        textColor = const Color(0xFF008236);
        break;
      case 'Post':
        bgColor = const Color(0xFFFFEDD4);
        borderColor = const Color(0xFFFFD6A7);
        textColor = const Color(0xFFCA3500);
        break;
      case 'Read':
        bgColor = const Color(0xFFDBEAFE); // blue-100
        borderColor = const Color(0xFFBEDBFF);
        textColor = const Color(0xFF1447E6);
        break;
      case 'Update':
        bgColor = const Color(0xFFFEF9C2);
        borderColor = const Color(0xFFFFF085);
        textColor = const Color(0xFFA65F00);
        break;
      case 'Delete':
        bgColor = const Color(0xFFFFE2E2);
        borderColor = const Color(0xFFFFC9C9);
        textColor = const Color(0xFFC10007);
        break;
      case 'Approve':
        bgColor = const Color(0xFFE9D4FF); // purple-100
        borderColor = const Color(0xFFE9D4FF);
        textColor = const Color(0xFF8200DB);
        break;
      case 'Export':
        bgColor = const Color(0xFFF3F4F6); // gray-100
        borderColor = const Color(0xFFE5E7EB);
        textColor = const Color(0xFF364153);
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        borderColor = const Color(0xFFE5E7EB);
        textColor = const Color(0xFF6B7280);
    }

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          operation,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.8,
            fontWeight: FontWeight.w400,
            color: textColor,
            height: 1.36, // 16px / 11.8px
          ),
        ),
      ),
    );
  }

  Widget _buildUsedInRolesCell(int count, double width, bool isDark) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.8,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : const Color(0xFF101828),
          height: 1.45, // 20px / 13.8px
        ),
      ),
    );
  }

  Widget _buildStatusCell(String status, double width, bool isDark) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16),
      child: _buildStatusBadge(status, isDark),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    final isActive = status == 'Active';

    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFD1FAE5)
            : const Color(0xFFF3F4F6),
        border: Border.all(
          color: isActive
              ? const Color(0xFFB9F8CF)
              : const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 12,
            color: isActive
                ? const Color(0xFF008236)
                : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isActive
                  ? const Color(0xFF008236)
                  : const Color(0xFF6B7280),
              height: 1.36, // 16px / 11.8px
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatedCell(
    String date,
    String by,
    double width,
    bool isDark,
  ) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF101828),
              height: 1.36,
            ),
          ),
          Text(
            by,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF6A7282),
              height: 1.36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCell(
    BuildContext context,
    FunctionPrivilegeModel privilege,
    double width,
    bool isDark,
  ) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: _buildActionButtons(context, privilege, isDark),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    FunctionPrivilegeModel privilege,
    bool isDark,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: SvgPicture.asset(
            Assets.icons.visibleIcon.path,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              isDark ? Colors.white : const Color(0xFF0F172B),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {},
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
        IconButton(
          icon: SvgPicture.asset(
            Assets.icons.editIcon.path,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              isDark ? Colors.white : const Color(0xFF0F172B),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {},
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
        IconButton(
          icon: SvgPicture.asset(
            Assets.icons.deleteIcon.path,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              isDark ? Colors.white : const Color(0xFF0F172B),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {},
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final size = MediaQuery.of(context).size;
    final maxTableHeight = (size.height - 500).clamp(300.0, 600.0);
    
    return Container(
      height: maxTableHeight,
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Center(
        child: Text(
          'No privileges found',
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

  Widget _buildFooter(
    BuildContext context,
    bool isDark,
    int total,
    int totalRoleUsage,
  ) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Showing ${_filteredPrivileges.length} of $total privileges',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF4A5565),
                    height: 1.47,
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    text: 'Total Role Usage: ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.6,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF4A5565),
                      height: 1.47,
                    ),
                    children: [
                      TextSpan(
                        text: '$totalRoleUsage',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF0F172B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${_filteredPrivileges.length} of $total privileges',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF4A5565),
                    height: 1.47,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: 'Total Role Usage: ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.6,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF4A5565),
                      height: 1.47,
                    ),
                    children: [
                      TextSpan(
                        text: '$totalRoleUsage',
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
