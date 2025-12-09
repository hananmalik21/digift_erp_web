import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/paginated_module_dropdown.dart';
import '../../../../../core/widgets/paginated_status_dropdown.dart';
import 'paginated_operation_dropdown.dart';

class FunctionPrivilegesSearchAndFilters extends ConsumerStatefulWidget {
  final bool isDark;
  final bool isMobile;
  final TextEditingController searchController;
  final String selectedModule;
  final String selectedOperation;
  final String selectedStatus;
  final Function(String) onModuleChanged;
  final Function(String) onOperationChanged;
  final Function(String) onStatusChanged;
  final Function(int?) onModuleFilter;
  final Function(int?) onOperationFilter;

  const FunctionPrivilegesSearchAndFilters({
    super.key,
    required this.isDark,
    required this.isMobile,
    required this.searchController,
    required this.selectedModule,
    required this.selectedOperation,
    required this.selectedStatus,
    required this.onModuleChanged,
    required this.onOperationChanged,
    required this.onStatusChanged,
    required this.onModuleFilter,
    required this.onOperationFilter,
  });

  @override
  ConsumerState<FunctionPrivilegesSearchAndFilters> createState() =>
      _FunctionPrivilegesSearchAndFiltersState();
}

class _FunctionPrivilegesSearchAndFiltersState
    extends ConsumerState<FunctionPrivilegesSearchAndFilters> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600 && size.width < 1024;

    if (widget.isMobile) {
      // Mobile: Stack vertically
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            FunctionPrivilegesSearchField(
              isDark: widget.isDark,
              controller: widget.searchController,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FunctionPrivilegesModuleFilter(
                    isDark: widget.isDark,
                    selectedModule: widget.selectedModule,
                    onChanged: widget.onModuleChanged,
                    onFilter: widget.onModuleFilter,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FunctionPrivilegesOperationFilter(
                    isDark: widget.isDark,
                    selectedOperation: widget.selectedOperation,
                    onChanged: widget.onOperationChanged,
                    onFilter: widget.onOperationFilter,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FunctionPrivilegesStatusFilter(
              isDark: widget.isDark,
              selectedStatus: widget.selectedStatus,
              onChanged: widget.onStatusChanged,
            ),
          ],
        ),
      );
    }

    if (isTablet) {
      // Tablet: Stack vertically with wrapped filters
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            FunctionPrivilegesSearchField(
              isDark: widget.isDark,
              controller: widget.searchController,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FunctionPrivilegesModuleFilter(
                    isDark: widget.isDark,
                    selectedModule: widget.selectedModule,
                    onChanged: widget.onModuleChanged,
                    onFilter: widget.onModuleFilter,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FunctionPrivilegesOperationFilter(
                    isDark: widget.isDark,
                    selectedOperation: widget.selectedOperation,
                    onChanged: widget.onOperationChanged,
                    onFilter: widget.onOperationFilter,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FunctionPrivilegesStatusFilter(
                    isDark: widget.isDark,
                    selectedStatus: widget.selectedStatus,
                    onChanged: widget.onStatusChanged,
                  ),
                ),
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
        color: widget.isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 577,
            child: FunctionPrivilegesSearchField(
              isDark: widget.isDark,
              controller: widget.searchController,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 205,
            child: FunctionPrivilegesModuleFilter(
              isDark: widget.isDark,
              selectedModule: widget.selectedModule,
              onChanged: widget.onModuleChanged,
              onFilter: widget.onModuleFilter,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 156.5,
            child: FunctionPrivilegesOperationFilter(
              isDark: widget.isDark,
              selectedOperation: widget.selectedOperation,
              onChanged: widget.onOperationChanged,
              onFilter: widget.onOperationFilter,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 123,
            child: FunctionPrivilegesStatusFilter(
              isDark: widget.isDark,
              selectedStatus: widget.selectedStatus,
              onChanged: widget.onStatusChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class FunctionPrivilegesSearchField extends StatelessWidget {
  final bool isDark;
  final TextEditingController controller;

  const FunctionPrivilegesSearchField({
    super.key,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DC)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.3,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : const Color(0xFF0F172B),
        ),
        decoration: InputDecoration(
          hintText:
              'Search by privilege name, code, function, or description...',
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
}

class FunctionPrivilegesModuleFilter extends ConsumerWidget {
  final bool isDark;
  final String selectedModule;
  final Function(String) onChanged;
  final Function(int?) onFilter;

  const FunctionPrivilegesModuleFilter({
    super.key,
    required this.isDark,
    required this.selectedModule,
    required this.onChanged,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Handle "All Modules" option
    final isAllModules = selectedModule == 'All Modules';
    final selectedModuleName = isAllModules ? null : selectedModule;

    return PaginatedModuleDropdown(
      selectedModule: selectedModuleName,
      onChanged: (moduleName, moduleId) {
        // Defer state updates to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final value = moduleName ?? 'All Modules';
          onChanged(value);
          onFilter(moduleId);
        });
      },
      isDark: isDark,
      height: 42,
      hintText: 'All Modules',
    );
  }
}

class FunctionPrivilegesOperationFilter extends ConsumerWidget {
  final bool isDark;
  final String selectedOperation;
  final Function(String) onChanged;
  final Function(int?) onFilter;

  const FunctionPrivilegesOperationFilter({
    super.key,
    required this.isDark,
    required this.selectedOperation,
    required this.onChanged,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Handle "All Operations" option
    final isAllOperations = selectedOperation == 'All Operations';
    final selectedOperationName = isAllOperations ? null : selectedOperation;

    return PaginatedOperationDropdown(
      selectedOperation: selectedOperationName,
      onChanged: (operationName, operationId) {
        // Defer state updates to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final value = operationName ?? 'All Operations';
          onChanged(value);
          onFilter(operationId);
        });
      },
      isDark: isDark,
      height: 42,
      hintText: 'All Operations',
    );
  }
}

class FunctionPrivilegesStatusFilter extends StatelessWidget {
  final bool isDark;
  final String selectedStatus;
  final Function(String) onChanged;

  const FunctionPrivilegesStatusFilter({
    super.key,
    required this.isDark,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedStatusDropdown(
      selectedStatus: selectedStatus,
      enableSearch: false,
      onChanged: (value) => onChanged(value ?? 'All Status'),
      isDark: isDark,
      height: 42,
      statuses: const ['All Status', 'Active', 'Inactive'],
      hintText: 'All Status',
    );
  }
}
