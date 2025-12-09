import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/more_filters_dialog.dart';
import '../../../../../core/models/filter_model.dart';
import '../../../../../core/widgets/paginated_module_dropdown.dart';
import '../providers/functions_provider.dart';

class FunctionsSearchAndFilters extends ConsumerStatefulWidget {
  final bool isDark;
  final bool isMobile;
  final TextEditingController searchController;
  final String selectedModule;
  final String selectedStatus;
  final List<String> selectedFilterKeys;
  final Function(String) onModuleChanged;
  final Function(String) onStatusChanged;
  final Function(List<String>) onFilterKeysChanged;

  const FunctionsSearchAndFilters({
    super.key,
    required this.isDark,
    required this.isMobile,
    required this.searchController,
    required this.selectedModule,
    required this.selectedStatus,
    required this.selectedFilterKeys,
    required this.onModuleChanged,
    required this.onStatusChanged,
    required this.onFilterKeysChanged,
  });

  @override
  ConsumerState<FunctionsSearchAndFilters> createState() =>
      _FunctionsSearchAndFiltersState();
}

class _FunctionsSearchAndFiltersState
    extends ConsumerState<FunctionsSearchAndFilters> {
  String _getSearchHintText() {
    if (widget.selectedFilterKeys.isEmpty) {
      return 'Search by function name, code, or description...';
    }

    // Only one filter can be selected, so format the single key
    final filterKey = widget.selectedFilterKeys.first;
    // Convert camelCase or snake_case to readable format
    final filterLabel = filterKey
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .replaceAll('_', ' ')
        .trim()
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');

    return 'Search by ${filterLabel.toLowerCase()}...';
  }

  Future<void> _openMoreFiltersDialog() async {
    // Define available filters based on the image example
    final filters = [
      FilterModel(key: 'functionId', value: 21),
      FilterModel(key: 'moduleId', value: 2),
      FilterModel(key: 'functionCode', value: 'AP_INVOICE_CREAT'),
      FilterModel(key: 'functionName', value: 'Create'),
    ];

    final previousSelectedKeys = List<String>.from(widget.selectedFilterKeys);
    final selectedKeys = await MoreFiltersDialog.show(
      context,
      filters: filters,
      initialSelectedKeys: widget.selectedFilterKeys,
    );

    if (selectedKeys != null) {
      // Check if filter selection changed
      final filterChanged = !_listsEqual(previousSelectedKeys, selectedKeys);

      // Clear text field if filter changed
      if (filterChanged) {
        widget.searchController.clear();
      }

      widget.onFilterKeysChanged(selectedKeys);

      // Get current status from state
      final functionsState = ref.read(functionsProvider);
      final apiStatus = functionsState.selectedStatus == 'All Status'
          ? null
          : functionsState.selectedStatus == 'Active'
              ? 'ACTIVE'
              : 'INACTIVE';

      // Reload functions with new filter keys (empty search since field is cleared)
      ref.read(functionsProvider.notifier).loadFunctions(
            search: filterChanged ? '' : widget.searchController.text,
            selectedFilterKeys: selectedKeys,
            page: 1,
            status: apiStatus,
          );
    }
  }

  bool _listsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMobile) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            FunctionsSearchField(
              isDark: widget.isDark,
              controller: widget.searchController,
              selectedFilterKeys: widget.selectedFilterKeys,
              getHintText: _getSearchHintText,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FunctionsModuleFilter(
                    isDark: widget.isDark,
                    selectedModule: widget.selectedModule,
                    onChanged: widget.onModuleChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FunctionsStatusFilter(
                    isDark: widget.isDark,
                    selectedStatus: widget.selectedStatus,
                    onChanged: widget.onStatusChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FunctionsMoreFiltersButton(
              isDark: widget.isDark,
              onPressed: _openMoreFiltersDialog,
            ),
          ],
        ),
      );
    }

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
            flex: 588,
            child: FunctionsSearchField(
              isDark: widget.isDark,
              controller: widget.searchController,
              selectedFilterKeys: widget.selectedFilterKeys,
              getHintText: _getSearchHintText,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 215,
            child: FunctionsModuleFilter(
              isDark: widget.isDark,
              selectedModule: widget.selectedModule,
              onChanged: widget.onModuleChanged,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 123,
            child: FunctionsStatusFilter(
              isDark: widget.isDark,
              selectedStatus: widget.selectedStatus,
              onChanged: widget.onStatusChanged,
            ),
          ),
          const SizedBox(width: 16),
          FunctionsMoreFiltersButton(
            isDark: widget.isDark,
            onPressed: _openMoreFiltersDialog,
          ),
        ],
      ),
    );
  }
}

class FunctionsSearchField extends StatelessWidget {
  final bool isDark;
  final TextEditingController controller;
  final List<String> selectedFilterKeys;
  final String Function() getHintText;

  const FunctionsSearchField({
    super.key,
    required this.isDark,
    required this.controller,
    required this.selectedFilterKeys,
    required this.getHintText,
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
        key: ValueKey(selectedFilterKeys.join(',')),
        controller: controller,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.3,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : const Color(0xFF0F172B),
        ),
        decoration: InputDecoration(
          hintText: getHintText(),
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

class FunctionsModuleFilter extends ConsumerWidget {
  final bool isDark;
  final String selectedModule;
  final Function(String) onChanged;

  const FunctionsModuleFilter({
    super.key,
    required this.isDark,
    required this.selectedModule,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final functionsNotifier = ref.read(functionsProvider.notifier);
    
    // Handle "All Modules" option
    final isAllModules = selectedModule == 'All Modules';
    final selectedModuleName = isAllModules ? null : selectedModule;

    return PaginatedModuleDropdown(
      selectedModule: selectedModuleName,
      onChanged: (moduleName, moduleId) {
        final value = moduleName ?? 'All Modules';
        onChanged(value);
        functionsNotifier.filterByModule(value, moduleId: moduleId);
      },
      isDark: isDark,
      height: 42,
      hintText: 'All Modules',
    );
  }
}

class FunctionsStatusFilter extends ConsumerWidget {
  final bool isDark;
  final String selectedStatus;
  final Function(String) onChanged;

  const FunctionsStatusFilter({
    super.key,
    required this.isDark,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final functionsNotifier = ref.read(functionsProvider.notifier);
    return Container(
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DC)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
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
            onChanged(value!);
            functionsNotifier.filterByStatus(value);
          },
        ),
      ),
    );
  }
}

class FunctionsMoreFiltersButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const FunctionsMoreFiltersButton({
    super.key,
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 136.19,
      height: 36,
      child: OutlinedButton(
        onPressed: onPressed,
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
}
