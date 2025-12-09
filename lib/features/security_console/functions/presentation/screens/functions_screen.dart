import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../data/models/function_model.dart';
import '../../domain/entities/function_entity.dart';
import '../providers/functions_provider.dart';
import '../widgets/functions_header_widget.dart';
import '../widgets/functions_stats_widget.dart';
import '../widgets/functions_search_filters_widget.dart';
import '../widgets/functions_mobile_list_widget.dart';
import '../widgets/functions_data_table_widget.dart';
import '../widgets/functions_footer_widget.dart';
import '../widgets/functions_empty_state_widget.dart';

class FunctionsScreen extends ConsumerStatefulWidget {
  const FunctionsScreen({super.key});

  @override
  ConsumerState<FunctionsScreen> createState() => _FunctionsScreenState();
}

class _FunctionsScreenState extends ConsumerState<FunctionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedModule = 'All Modules';
  String _selectedStatus = 'All Status';
  Timer? _debounceTimer;
  List<String> _selectedFilterKeys = ['functionName']; // Default to functionName

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load with default status (All Status = null) and default filter (functionName)
      ref.read(functionsProvider.notifier).loadFunctions(
        status: null,
        selectedFilterKeys: _selectedFilterKeys,
      );
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(functionsProvider.notifier).search(
        _searchController.text,
        selectedFilterKeys: _selectedFilterKeys,
      );
    });
  }

  FunctionModel _entityToModel(FunctionEntity entity) {
    return FunctionModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      description: entity.description,
      module: entity.module,
      status: entity.status,
      updatedDate: entity.updatedDate,
      updatedBy: entity.updatedBy,
    );
  }

  @override
  Widget build(BuildContext context) {
    final functionsState = ref.watch(functionsProvider);
    final functionsNotifier = ref.read(functionsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final functions = functionsState.functions.map(_entityToModel).toList();
    final totalFunctions = functionsState.totalItems;

    // Debug: Check if we have data
    if (kDebugMode && functionsState.functions.isNotEmpty) {
      print('Functions loaded: ${functionsState.functions.length}');
      print('Total items: ${functionsState.totalItems}');
      print('First function: ${functionsState.functions.first.category}');
      print('total pages: ${functionsState.totalPages}');
      print('Total Active: ${functionsState.totalActiveValue}');
      print('Total Inactive: ${functionsState.totalInactiveValue}');
    }
    
    // Use API values if available, otherwise calculate from local data
    final activeFunctions = functionsState.totalActiveValue ??
        functions.where((f) => f.status.toLowerCase() == 'Active'.toLowerCase()).length;
    final inactiveFunctions = functionsState.totalInactiveValue ??
        functions.where((f) => f.status.toLowerCase() == 'Inactive'.toLowerCase()).length;
    final glFunctions =
        functions.where((f) => f.module == 'General Ledger').length;
    final apFunctions =
        functions.where((f) => f.module == 'Accounts Payable').length;

    return Scaffold(
      backgroundColor: isDark
          ? context.themeBackground
          : const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FunctionsHeader(isMobile: isMobile),
            const SizedBox(height: 24),
            FunctionsStatsCards(
              isDark: isDark,
              isMobile: isMobile,
              total: totalFunctions,
              active: activeFunctions,
              inactive: inactiveFunctions,
              glFunctions: glFunctions,
              apFunctions: apFunctions,
            ),
            const SizedBox(height: 24),
            FunctionsSearchAndFilters(
              isDark: isDark,
              isMobile: isMobile,
              searchController: _searchController,
              selectedModule: _selectedModule,
              selectedStatus: _selectedStatus,
              selectedFilterKeys: _selectedFilterKeys,
              onModuleChanged: (value) {
                setState(() {
                  _selectedModule = value;
                });
              },
              onStatusChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
              onFilterKeysChanged: (value) {
                setState(() {
                  _selectedFilterKeys = value;
                });
              },
            ),
            const SizedBox(height: 24),
            if (functionsState.isLoading && functionsState.functions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (functionsState.error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Text(
                        'Error: ${functionsState.error}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => functionsNotifier.refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (functions.isEmpty && !functionsState.isLoading)
              FunctionsEmptyState(isDark: isDark)
            else ...[
              isMobile
                  ? FunctionsMobileList(
                      isDark: isDark,
                      functions: functions,
                    )
                  : FunctionsDataTable(
                      isDark: isDark,
                      functions: functions,
                    ),
              const SizedBox(height: 16),
              FunctionsFooter(
                isDark: isDark,
                total: totalFunctions,
                activeFunctions: activeFunctions,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
