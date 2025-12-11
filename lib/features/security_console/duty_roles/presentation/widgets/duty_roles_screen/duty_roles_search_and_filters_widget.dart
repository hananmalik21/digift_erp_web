import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../providers/duty_roles_provider.dart';
import '../../providers/modules_provider.dart';
import '../../providers/selected_module_provider.dart';
import '../../../../functions/data/models/module_dto.dart';
import 'duty_roles_module_button.dart';

class DutyRolesSearchAndFilters extends ConsumerWidget {
  final bool isDark;
  final bool isMobile;
  final TextEditingController searchController;
  final void Function(String) onSearchChanged;
  final AutoDisposeStateNotifierProvider<DutyRolesNotifier, DutyRolesState> dutyRolesProvider;

  const DutyRolesSearchAndFilters({
    super.key,
    required this.isDark,
    required this.isMobile,
    required this.searchController,
    required this.onSearchChanged,
    required this.dutyRolesProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dutyRolesState = ref.watch(dutyRolesProvider);
    final modulesState = ref.watch(modulesProvider);
    final selectedModuleState = ref.watch(selectedModuleProvider);

    Widget searchField() {
      return SizedBox(
        height: 36,
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F3F5),
            hintText: 'Search duty roles...',
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 6),
              child: Icon(
                Icons.search,
                size: 16,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: dutyRolesState.isLoading && dutyRolesState.searchQuery != null && dutyRolesState.searchQuery!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 9.75),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            isDense: true,
          ),
        ),
      );
    }

    // Build modules list with "All" first, then API modules
    final allModules = [
      'All', // String for "All" option
      ...modulesState.modules, // ModuleDto objects from API
    ];

    final chipsRow = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: allModules.asMap().entries.map((entry) {
          final index = entry.key;
          final module = entry.value;
          final isLast = index == allModules.length - 1;
          return Padding(
            key: ValueKey(module is String ? module : (module as ModuleDto).id),
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: DutyRolesModuleButton(
              module: module,
              isDark: isDark,
              isSelected: module is String
                  ? module == selectedModuleState.selectedModule
                  : module is ModuleDto && (module.name == selectedModuleState.selectedModule ||
                      module.id == dutyRolesState.selectedModuleId),
              onTap: () {
                final String moduleName;
                final int? moduleId;

                if (module is String) {
                  moduleName = module;
                  moduleId = null;
                } else if (module is ModuleDto) {
                  moduleName = module.name;
                  moduleId = module.id;
                } else {
                  return;
                }

                ref.read(selectedModuleProvider.notifier).selectModule(moduleName);
                ref.read(dutyRolesProvider.notifier).filterByModule(moduleName, moduleId);
              },
            ),
          );
        }).toList(),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchField(),
                const SizedBox(height: 12),
                chipsRow,
              ],
            )
          : Row(
              children: [
                Expanded(child: searchField()),
                const SizedBox(width: 12),
                Flexible(child: chipsRow),
              ],
            ),
    );
  }
}
