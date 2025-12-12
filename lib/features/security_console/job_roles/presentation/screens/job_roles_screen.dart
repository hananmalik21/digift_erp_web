import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/job_role_model.dart';
import '../../data/datasources/job_role_remote_datasource.dart';
import '../providers/job_roles_provider.dart';
import '../widgets/create_edit_job_role_dialog.dart';
import '../../../function_privileges/presentation/widgets/function_privileges_footer_widget.dart';

class JobRolesScreen extends ConsumerStatefulWidget {
  const JobRolesScreen({super.key});

  @override
  ConsumerState<JobRolesScreen> createState() => _JobRolesScreenState();
}

class _JobRolesScreenState extends ConsumerState<JobRolesScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounceTimer;

  // Local provider - autoDispose ensures it's disposed when widget is removed
  // Data will be loaded every time the tab is visited
  final _localJobRolesProvider = StateNotifierProvider.autoDispose<JobRolesNotifier, JobRolesState>(
    (ref) {
      final dataSource = JobRoleRemoteDataSourceImpl();
      return JobRolesNotifier(dataSource);
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
      ref.read(_localJobRolesProvider.notifier).search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_localJobRolesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final totalJobRoles = state.totalItems;
    final activeJobRoles = state.jobRoles.where((r) => r.status == 'Active' || r.status == 'ACTIVE').length;
    final totalUsers = state.jobRoles.fold<int>(
      0,
      (sum, role) => sum + role.usersAssigned,
    );
    final avgDutyRoles = state.jobRoles.isEmpty
        ? 0
        : (state.jobRoles.fold<int>(0, (sum, role) => sum + role.dutyRoles.length) /
                  state.jobRoles.length)
              .round();

    return Scaffold(
      backgroundColor: isDark
          ? context.themeBackground
          : const Color(0xFFF9FAFB),
      body: state.isLoading && state.jobRoles.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: isDark ? Colors.white : const Color(0xFF030213),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isDark, isMobile, state),
                  const SizedBox(height: 24),
                  _buildStatsCards(
                    context,
                    isDark,
                    isMobile,
                    totalJobRoles,
                    activeJobRoles,
                    totalUsers,
                    avgDutyRoles,
                  ),
                  const SizedBox(height: 24),
                  _buildSearchAndFilters(context, isDark, isMobile),
                  const SizedBox(height: 24),
                  _buildJobRolesGrid(context, isDark, isMobile, state),
                  if (state.totalItems > 0) ...[
                    const SizedBox(height: 16),
                    FunctionPrivilegesFooter(
                      isDark: isDark,
                      total: state.totalItems,
                      showing: state.jobRoles.length,
                      isLoading: state.isPaginationLoading,
                      currentPage: state.currentPage,
                      totalPages: state.totalPages,
                      hasNextPage: state.hasNextPage,
                      hasPreviousPage: state.hasPreviousPage,
                      onNextPage: () => ref.read(_localJobRolesProvider.notifier).nextPage(),
                      onPreviousPage: () => ref.read(_localJobRolesProvider.notifier).previousPage(),
                      onGoToPage: (page) => ref.read(_localJobRolesProvider.notifier).goToPage(page),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile, JobRolesState state) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF00A63E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.jobRoleIcon.path,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF00A63E),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Job Roles',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.3,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                    height: 1.57,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Compose job roles from duty roles and other job roles',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
              height: 1.47,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: _buildCreateButton(context, isDark),
          ),
        ],
      );
    }

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF00A63E).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: SvgPicture.asset(
              Assets.icons.jobRoleIcon.path,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFF00A63E),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Job Roles',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                  height: 1.57,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Compose job roles from duty roles and other job roles',
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
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildCreateButton(context, isDark),
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 160.69,
      height: 36,
      child: ElevatedButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => const CreateEditJobRoleDialog(),
          );
          if (result != null && result is JobRoleModel && mounted) {
            // Add locally after successful create
            ref.read(_localJobRolesProvider.notifier).addJobRoleLocally(result);
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
              'Create Job Role',
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
    int users,
    int avgDutyRoles,
  ) {
    final stats = [
      {
        'label': 'Total Job Roles',
        'value': '$total',
        'color': const Color(0xFF00A63E),
        'icon': Assets.icons.userManagementIcon.path,
      },
      {
        'label': 'Active',
        'value': '$active',
        'color': const Color(0xFF00A63E),
        'icon': Assets.icons.workflowApprovalsIcon.path,
      },
      {
        'label': 'Users Assigned',
        'value': '$users',
        'color': const Color(0xFF9810FA),
        'icon': Assets.icons.userManagementIcon.path,
      },
      {
        'label': 'Avg Duty Roles',
        'value': '$avgDutyRoles',
        'color': const Color(0xFF155DFC),
        'icon': Assets.icons.dutyRoleIcon.path,
      },
    ];

    if (isMobile) {
      return Column(
        children: stats
            .map(
              (stat) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildStatCard(context, stat, isDark),
              ),
            )
            .toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth < 900;

        if (isTablet) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, stats[0], isDark)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, stats[1], isDark)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, stats[2], isDark)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, stats[3], isDark)),
                ],
              ),
            ],
          );
        }

        return Row(
          children: stats.map((stat) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: stat == stats.last ? 0 : 16),
                child: _buildStatCard(context, stat, isDark),
              ),
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
    return Container(
      constraints: const BoxConstraints(minHeight: 86),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? const Color(0xFF374151)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SvgPicture.asset(
            stat['icon'] as String,
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              stat['color'] as Color,
              BlendMode.srcIn,
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
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF4A5565),
                    height: 1.47,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  stat['value'] as String,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                    height: 1.33,
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
    bool isDark,
    bool isMobile,
  ) {
    final state = ref.watch(_localJobRolesProvider);
    final departments = ['All', 'Finance', 'Treasury', 'Audit'];

    Widget _searchField() {
      return SizedBox(
        height: 36,
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark
                ? const Color(0xFF374151)
                : const Color(0xFFF3F3F5),
            hintText: 'Search job roles...',
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF717182),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 6),
              child: Icon(
                Icons.search,
                size: 16,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
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

    final chipsRow = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: departments.map((department) {
          final isLast = department == departments.last;
          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: _buildDepartmentButton(department, isDark, state),
          );
        }).toList(),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? const Color(0xFF374151)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_searchField(), const SizedBox(height: 12), chipsRow],
            )
          : Row(
              children: [
                Expanded(child: _searchField()),
                const SizedBox(width: 12),
                Flexible(child: chipsRow),
              ],
            ),
    );
  }

  Widget _buildDepartmentButton(String department, bool isDark, JobRolesState state) {
    final isSelected = department == (state.selectedDepartment ?? 'All');

    return IntrinsicWidth(
      child: GestureDetector(
        onTap: () {
          ref.read(_localJobRolesProvider.notifier).filterByDepartment(
            department == 'All' ? null : department,
          );
        },
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7.5),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF030213)
                : (isDark ? const Color(0xFF374151) : Colors.white),
            border: isSelected
                ? null
                : Border.all(
                    color: isDark
                        ? const Color(0xFF374151)
                        : Colors.black.withValues(alpha: 0.1),
                  ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            department,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isSelected ? 14 : 13.7,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF0F172B)),
              height: 1.43,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobRolesGrid(BuildContext context, bool isDark, bool isMobile, JobRolesState state) {
    if (state.jobRoles.isEmpty && !state.isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Text(
            'No job roles found',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.3,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ),
      );
    }

    if (isMobile) {
      return Column(
        children: state.jobRoles
            .map(
              (role) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildJobRoleCard(context, role, isDark, state),
              ),
            )
            .toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 900 ? 1 : 3;
        final cards = <Widget>[];

        for (int i = 0; i < state.jobRoles.length; i += columns) {
          final rowCards = <Widget>[];
          for (
            int j = 0;
            j < columns && i + j < state.jobRoles.length;
            j++
          ) {
            rowCards.add(
              Expanded(
                child: _buildJobRoleCard(
                  context,
                  state.jobRoles[i + j],
                  isDark,
                  state,
                ),
              ),
            );
            if (j < columns - 1 && i + j + 1 < state.jobRoles.length) {
              rowCards.add(const SizedBox(width: 16));
            }
          }

          // Add extra Expanded widgets to fill empty space
          while (rowCards.length < columns * 2 - 1) {
            if (rowCards.length % 2 == 0) {
              rowCards.add(const Expanded(child: SizedBox()));
            } else {
              rowCards.add(const SizedBox(width: 16));
            }
          }

          cards.add(
            Padding(
              padding: EdgeInsets.only(
                bottom: i + columns < state.jobRoles.length ? 16 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowCards,
              ),
            ),
          );
        }

        return Column(children: cards);
      },
    );
  }

  Widget _buildJobRoleCard(
    BuildContext context,
    JobRoleModel role,
    bool isDark,
    JobRolesState state,
  ) {
    final hasInherits =
        role.inheritsFrom != null && role.inheritsFrom!.isNotEmpty;
    final cardHeight = hasInherits ? 501.0 : 473.0;

    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? const Color(0xFF374151)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(role, isDark),
          const SizedBox(height: 38),
          Text(
            role.name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.3,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.57,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            role.code,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.33,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: hasInherits ? 20 : 40,
            child: Text(
              role.description,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF4A5565),
                height: 1.47,
              ),
              maxLines: hasInherits ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          _buildDepartmentBadge(role.department, isDark),
          const SizedBox(height: 46),
          _buildDutyRolesSection(role.dutyRoles, isDark),
          if (hasInherits) ...[
            const SizedBox(height: 20),
            _buildInheritsFromSection(role.inheritsFrom!, isDark),
          ],
          const Spacer(),
          _buildCardFooter(role, isDark),
        ],
      ),
    );
  }

  Widget _buildCardHeader(JobRoleModel role, bool isDark) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.icons.jobRoleIcon.path,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            Color(0xFF00A63E),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            border: Border.all(color: const Color(0xFFB9F8CF)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            role.status,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF008236),
              height: 1.33,
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () async {
            final result = await showDialog(
              context: context,
              builder: (context) => CreateEditJobRoleDialog(jobRole: role),
            );
            if (result != null && result is JobRoleModel && mounted) {
              // Update locally after successful edit
              ref.read(_localJobRolesProvider.notifier).updateJobRoleLocally(result);
            }
          },
          icon: SvgPicture.asset(
            Assets.icons.editIcon.path,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              BlendMode.srcIn,
            ),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            // TODO: Delete job role
          },
          icon: SvgPicture.asset(
            Assets.icons.deleteIcon.path,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              BlendMode.srcIn,
            ),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  Widget _buildDepartmentBadge(String department, bool isDark) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark
                ? const Color(0xFF374151)
                : Colors.black.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          department,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF0F172B),
            height: 1.33,
          ),
        ),
      ),
    );
  }

  Widget _buildDutyRolesSection(List<String> dutyRoles, bool isDark) {
    final visibleRoles = dutyRoles.take(3).toList();
    final remainingCount = dutyRoles.length - 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.layers_outlined,
              size: 12,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
            ),
            const SizedBox(width: 4),
            Text(
              'Duty Roles (${dutyRoles.length})',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6A7282),
                height: 1.33,
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            ...visibleRoles.map((role) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F5FF),
                  border: Border.all(color: const Color(0xFFE9D4FF)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  role,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8200DB),
                    height: 1.33,
                  ),
                ),
              );
            }),
            if (remainingCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F5FF),
                  border: Border.all(color: const Color(0xFFE9D4FF)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+$remainingCount more',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8200DB),
                    height: 1.33,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInheritsFromSection(List<String> inheritsFrom, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 12,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
            ),
            const SizedBox(width: 4),
            Text(
              'Inherits from (${inheritsFrom.length})',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6A7282),
                height: 1.33,
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: inheritsFrom.map((role) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                border: Border.all(color: const Color(0xFFBEDBFF)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                role,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1447E6),
                  height: 1.33,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCardFooter(JobRoleModel role, bool isDark) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark
                ? const Color(0xFF374151)
                : Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.people_outline,
            size: 12,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
          ),
          const SizedBox(width: 4),
          Text(
            '${role.usersAssigned}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
              height: 1.33,
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.vpn_key_outlined,
            size: 12,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
          ),
          const SizedBox(width: 4),
          Text(
            '${role.privilegesCount}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
              height: 1.33,
            ),
          ),
          const Spacer(),
          Text(
            role.lastModified,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4A5565),
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}
