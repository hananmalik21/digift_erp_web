import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../data/datasources/duty_role_remote_datasource.dart';
import '../providers/duty_roles_provider.dart';
import '../widgets/duty_roles_screen/duty_roles_header_widget.dart';
import '../widgets/duty_roles_screen/duty_roles_stats_cards_widget.dart';
import '../widgets/duty_roles_screen/duty_roles_search_and_filters_widget.dart';
import '../widgets/duty_roles_screen/duty_roles_grid_widget.dart';
import '../../../function_privileges/presentation/widgets/function_privileges_footer_widget.dart';

class DutyRolesScreen extends ConsumerStatefulWidget {
  const DutyRolesScreen({super.key});

  @override
  ConsumerState<DutyRolesScreen> createState() => _DutyRolesScreenState();
}

class _DutyRolesScreenState extends ConsumerState<DutyRolesScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounceTimer;

  // Local provider - autoDispose ensures it's disposed when widget is removed
  final _localDutyRolesProvider = StateNotifierProvider.autoDispose<DutyRolesNotifier, DutyRolesState>(
    (ref) {
      final dataSource = DutyRoleRemoteDataSourceImpl();
      return DutyRolesNotifier(dataSource);
    },
  );

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(_localDutyRolesProvider.notifier).search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_localDutyRolesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final totalDutyRoles = state.totalItems;
    final activeDutyRoles = state.dutyRoles.where((r) => r.status == 'Active' || r.status == 'ACTIVE').length;
    final totalUsers = state.dutyRoles.fold<int>(0, (sum, role) => sum + role.usersAssigned);
    final avgPrivileges = state.dutyRoles.isEmpty
        ? 0
        : (state.dutyRoles.fold<int>(0, (sum, role) => sum + role.privileges.length) / state.dutyRoles.length).round();

    return Scaffold(
      backgroundColor: isDark ? context.themeBackground : const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DutyRolesHeader(
              isDark: isDark,
              isMobile: isMobile,
              state: state,
              dutyRolesProvider: _localDutyRolesProvider,
            ),
            const SizedBox(height: 24),
            DutyRolesStatsCards(
              isDark: isDark,
              isMobile: isMobile,
              totalDutyRoles: totalDutyRoles,
              activeDutyRoles: activeDutyRoles,
              totalUsers: totalUsers,
              avgPrivileges: avgPrivileges,
            ),
            const SizedBox(height: 24),
            DutyRolesSearchAndFilters(
              isDark: isDark,
              isMobile: isMobile,
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              dutyRolesProvider: _localDutyRolesProvider,
            ),
            const SizedBox(height: 24),
            DutyRolesGrid(
              isDark: isDark,
              isMobile: isMobile,
              dutyRolesProvider: _localDutyRolesProvider,
            ),
            if (state.totalItems > 0) ...[
              const SizedBox(height: 16),
              FunctionPrivilegesFooter(
                isDark: isDark,
                total: state.totalItems,
                showing: state.dutyRoles.length,
                isLoading: state.isPaginationLoading,
                currentPage: state.currentPage,
                totalPages: state.totalPages,
                hasNextPage: state.hasNextPage,
                hasPreviousPage: state.hasPreviousPage,
                onNextPage: () => ref.read(_localDutyRolesProvider.notifier).nextPage(),
                onPreviousPage: () => ref.read(_localDutyRolesProvider.notifier).previousPage(),
                onGoToPage: (page) => ref.read(_localDutyRolesProvider.notifier).goToPage(page),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
