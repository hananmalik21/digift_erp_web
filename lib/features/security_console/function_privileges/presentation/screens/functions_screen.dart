import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/function_model.dart';
import '../widgets/create_function_dialog.dart';

class FunctionsScreen extends StatefulWidget {
  const FunctionsScreen({super.key});

  @override
  State<FunctionsScreen> createState() => _FunctionsScreenState();
}

class _FunctionsScreenState extends State<FunctionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedModule = 'All Modules';
  String _selectedStatus = 'All Status';

  List<FunctionModel> _functions = [];
  List<FunctionModel> _filteredFunctions = [];

  @override
  void initState() {
    super.initState();
    _functions = FunctionModel.getSampleFunctions();
    _filteredFunctions = _functions;
    _searchController.addListener(_filterFunctions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFunctions() {
    setState(() {
      _filteredFunctions = _functions.where((function) {
        final matchesSearch =
            _searchController.text.isEmpty ||
            function.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            function.code.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            function.category.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            function.description.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        final matchesModule =
            _selectedModule == 'All Modules' ||
            function.module == _selectedModule;

        final matchesStatus =
            _selectedStatus == 'All Status' ||
            function.status == _selectedStatus;

        return matchesSearch && matchesModule && matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final totalFunctions = _functions.length;
    final activeFunctions = _functions
        .where((f) => f.status == 'Active')
        .length;
    final inactiveFunctions = _functions
        .where((f) => f.status == 'Inactive')
        .length;
    final glFunctions = _functions
        .where((f) => f.module == 'General Ledger')
        .length;
    final apFunctions = _functions
        .where((f) => f.module == 'Accounts Payable')
        .length;

    return Scaffold(
      backgroundColor: isDark
          ? context.themeBackground
          : const Color(0xFFF9FAFB),
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
              totalFunctions,
              activeFunctions,
              inactiveFunctions,
              glFunctions,
              apFunctions,
            ),
            const SizedBox(height: 24),
            _buildSearchAndFilters(context, isDark, isMobile),
            const SizedBox(height: 24),
            isMobile
                ? _buildMobileList(context, isDark)
                : _buildDataTable(context, isDark),
            const SizedBox(height: 16),
            _buildFooter(context, isDark, totalFunctions, activeFunctions),
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
              SvgPicture.asset(
                Assets.icons.functionsIcon.path,
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  Color(0xFF9810FA),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Functions',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.4,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage system functions and capabilities across all modules',
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
          padding: const EdgeInsets.only(top: 4),
          child: SvgPicture.asset(
            Assets.icons.functionsIcon.path,
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(Color(0xFF9810FA), BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Functions',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.4,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                  height: 1.56,
                ),
              ),
              Text(
                'Manage system functions and capabilities across all modules',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF4A5565),
                  height: 1.57,
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
            SvgPicture.asset(
              Assets.icons.refreshIcon.path,
      
              colorFilter: ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Refresh',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF0F172B),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 161.21,
      height: 36,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CreateFunctionDialog(),
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
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Create Function',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                height: 1.45,
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
    int inactive,
    int glFunctions,
    int apFunctions,
  ) {
    final stats = [
      {'label': 'Total Functions', 'value': '$total', 'hasLeftBorder': false},
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
        'label': 'GL Functions',
        'value': '$glFunctions',
        'hasLeftBorder': true,
        'leftBorderColor': const Color(0xFF155DFC),
      },
      {
        'label': 'AP Functions',
        'value': '$apFunctions',
        'hasLeftBorder': true,
        'leftBorderColor': const Color(0xFF9810FA),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        int columns;

        if (width < 480) {
          columns = 1;
        } else if (width < 800) {
          columns = 2;
        } else if (width < 1100) {
          columns = 3;
        } else if (width < 1400) {
          columns = 4;
        } else {
          columns = 5;
        }

        const spacing = 16.0;
        double cardWidth = (width - (spacing * (columns - 1))) / columns;

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
    return SizedBox(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
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
                        height: 1.47,
                      ),
                    ),
                    const SizedBox(height: 31),
                    Text(
                      stat['value'],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color:
                            stat['valueColor'] ??
                            (isDark ? Colors.white : const Color(0xFF0F172B)),
                        height: 1.33,
                      ),
                    ),
                  ],
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
    bool isDark,
    bool isMobile,
  ) {
    if (isMobile) {
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
                Expanded(child: _buildStatusFilter(context, isDark)),
              ],
            ),
            const SizedBox(height: 12),
            _buildMoreFiltersButton(context, isDark),
          ],
        ),
      );
    }

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
          Expanded(flex: 588, child: _buildSearchField(context, isDark)),
          const SizedBox(width: 16),
          SizedBox(width: 215, child: _buildModuleFilter(context, isDark)),
          const SizedBox(width: 16),
          SizedBox(width: 123, child: _buildStatusFilter(context, isDark)),
          const SizedBox(width: 16),
          _buildMoreFiltersButton(context, isDark),
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
          hintText:
              'Search by function name, code, category, or description...',
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
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
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
    return Container(
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DC)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedModule,
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
            height: 1.23,
          ),
          dropdownColor: isDark ? context.themeCardBackground : Colors.white,
          items:
              [
                'All Modules',
                'General Ledger',
                'Accounts Payable',
                'Accounts Receivable',
                'Cash Management',
                'Fixed Assets',
                'Expense Management',
                'Security',
                'Financial Reporting',
              ].map((String module) {
                return DropdownMenuItem<String>(
                  value: module,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 21),
                    child: Text(module),
                  ),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedModule = value!;
              _filterFunctions();
            });
          },
        ),
      ),
    );
  }

  Widget _buildStatusFilter(BuildContext context, bool isDark) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DC)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
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
            height: 1.23,
          ),
          dropdownColor: isDark ? context.themeCardBackground : Colors.white,
          items: ['All Status', 'Active', 'Inactive'].map((String status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Padding(
                padding: const EdgeInsets.only(left: 21),
                child: Text(status),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedStatus = value!;
              _filterFunctions();
            });
          },
        ),
      ),
    );
  }

  Widget _buildMoreFiltersButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 136.19,
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
              Icons.filter_list,
              size: 16,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            const SizedBox(width: 8),
            Text(
              'More Filters',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF0F172B),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, bool isDark) {
    if (_filteredFunctions.isEmpty) {
      return _buildEmptyState(context, isDark);
    }

    return Column(
      children: _filteredFunctions
          .map(
            (function) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildMobileCard(context, function, isDark),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMobileCard(
    BuildContext context,
    FunctionModel function,
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
            function.code,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.67,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            function.name,
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
            function.description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
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
                    function.module,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.8,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : const Color(0xFF101828),
                    ),
                  ),
                ],
              ),
              _buildAccessTypeBadge(function.accessType, isDark),
              _buildStatusBadge(function.status, isDark),
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
                      function.category,
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
                      '${function.updatedDate} by ${function.updatedBy}',
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
              _buildActionButtons(context, function, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context, bool isDark) {
    if (_filteredFunctions.isEmpty) {
      return _buildEmptyState(context, isDark);
    }

    final size = MediaQuery.of(context).size;
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
            width: 1330.91,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTableHeader(context, isDark),
                SizedBox(
                  height: maxTableHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      children: _filteredFunctions
                          .map(
                            (function) =>
                                _buildTableRow(context, function, isDark),
                          )
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
      height: 56.5,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('FUNCTION CODE', 243.77),
          _buildHeaderCellMultiLine('FUNCTION\nNAME', 144.46),
          _buildHeaderCell('MODULE', 166.77),
          _buildHeaderCell('CATEGORY', 148.88),
          _buildHeaderCellMultiLine('ACCESS\nTYPE', 82.84),
          _buildHeaderCell('STATUS', 101.01),
          _buildHeaderCell('LAST UPDATED', 148.91),
          _buildHeaderCell('ACTIONS', 112),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      alignment: text == 'ACTIONS' ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: text == 'ACTIONS'
            ? 0
            : text == 'FUNCTION CODE'
            ? 24
            : 0,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF364153),
          letterSpacing: 0.6,
          height: 1.17,
        ),
      ),
    );
  }

  Widget _buildHeaderCellMultiLine(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF364153),
          letterSpacing: 0.6,
          height: 1.25,
        ),
      ),
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    FunctionModel function,
    bool isDark,
  ) {
    // Calculate row height based on content
    double rowHeight = 85; // minimum
    if (function.name.length > 25 || function.description.length > 50) {
      rowHeight = 105;
    }
    if (function.name.length > 30 || function.description.length > 60) {
      rowHeight = 121;
    }
    if (function.description.length > 70) {
      rowHeight = 137;
    }

    return Container(
      constraints: BoxConstraints(minHeight: rowHeight),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDataCell(
            function.code,
            243.77,
            12,
            FontWeight.w400,
            isDark,
            leftPadding: 24,
          ),
          _buildNameDescriptionCell(
            function.name,
            function.description,
            144.46,
            isDark,
          ),
          _buildModuleCell(function.module, 166.77, isDark),
          _buildDataCell(
            function.category,
            148.88,
            12,
            FontWeight.w400,
            isDark,
          ),
          _buildAccessTypeCell(function.accessType, 82.84, isDark),
          _buildStatusCell(function.status, 101.01, isDark),
          _buildUpdatedCell(
            function.updatedDate,
            function.updatedBy,
            148.91,
            isDark,
          ),
          _buildActionsCell(context, function, 112, isDark),
        ],
      ),
    );
  }

  Widget _buildDataCell(
    String text,
    double width,
    double fontSize,
    FontWeight fontWeight,
    bool isDark, {
    double leftPadding = 0,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.only(left: leftPadding),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: isDark ? Colors.white : const Color(0xFF0F172B),
          height: 1.67,
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
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
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
              height: 1.47,
            ),
          ),
          const SizedBox(height: 3.5),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.36,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCell(String module, double width, bool isDark) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Icon(
            Icons.folder_outlined,
            size: 16,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              module,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : const Color(0xFF101828),
                height: 1.67,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessTypeCell(String accessType, double width, bool isDark) {
    return SizedBox(
      width: width,
      child: _buildAccessTypeBadge(accessType, isDark),
    );
  }

  Widget _buildAccessTypeBadge(String accessType, bool isDark) {
    Color bgColor;
    Color textColor;

    switch (accessType) {
      case 'Full':
        bgColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF008236);
        break;
      case 'Execute':
        bgColor = const Color(0xFFE9D4FF);
        textColor = const Color(0xFF8200DB);
        break;
      case 'View':
        bgColor = const Color(0xFFDBEAFE);
        textColor = const Color(0xFF1447E6);
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
    }

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          accessType,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.8,
            fontWeight: FontWeight.w400,
            color: textColor,
            height: 1.19,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCell(String status, double width, bool isDark) {
    return SizedBox(width: width, child: _buildStatusBadge(status, isDark));
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    final isActive = status == 'Active';

    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD1FAE5) : const Color(0xFFF3F4F6),
        border: Border.all(
          color: isActive ? const Color(0xFFB9F8CF) : const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 12,
            color: isActive ? const Color(0xFF008236) : const Color(0xFF6B7280),
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
              height: 1.19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatedCell(String date, String by, double width, bool isDark) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF101828),
              height: 1.67,
            ),
          ),
          Text(
            'by $by',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCell(
    BuildContext context,
    FunctionModel function,
    double width,
    bool isDark,
  ) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: _buildActionButtons(context, function, isDark),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    FunctionModel function,
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
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
          'No functions found',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.3,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    bool isDark,
    int total,
    int activeFunctions,
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
                  'Showing ${_filteredFunctions.length} of $total functions',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF4A5565),
                    height: 1.21,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Active Functions: $activeFunctions',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF4A5565),
                    height: 1.21,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${_filteredFunctions.length} of $total functions',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF4A5565),
                    height: 1.21,
                  ),
                ),
                Text(
                  'Active Functions: $activeFunctions',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF4A5565),
                    height: 1.21,
                  ),
                ),
              ],
            ),
    );
  }
}
