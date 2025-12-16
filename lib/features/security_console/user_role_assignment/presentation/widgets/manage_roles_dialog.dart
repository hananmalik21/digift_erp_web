import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../data/models/user_role_model.dart';
import '../../../job_roles/presentation/providers/job_roles_provider.dart';
import '../../../job_roles/data/models/job_role_model.dart';
import '../../../job_roles/data/datasources/job_role_remote_datasource.dart';
import '../../../user_accounts/presentation/services/user_account_service.dart';
import '../../../user_accounts/data/datasources/user_account_remote_datasource.dart';
import '../../../user_accounts/data/models/user_account_dto.dart';

class ManageRolesDialog extends ConsumerStatefulWidget {
  final UserRoleModel user;

  const ManageRolesDialog({super.key, required this.user});

  @override
  ConsumerState<ManageRolesDialog> createState() => _ManageRolesDialogState();
}

class _ManageRolesDialogState extends ConsumerState<ManageRolesDialog> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _searchDebounceTimer;
  late List<String> _assignedRoleNames;
  late List<int> _assignedRoleIds;
  String _selectedCategory = 'All Categories';
  bool _isSaving = false;
  UserAccountDto? _cachedUserData;

  // Local provider for job roles - autoDispose ensures it's disposed when dialog is closed
  final _localJobRolesProvider = StateNotifierProvider.autoDispose<JobRolesNotifier, JobRolesState>(
    (ref) {
      final dataSource = JobRoleRemoteDataSourceImpl();
      return JobRolesNotifier(dataSource);
    },
  );

  @override
  void initState() {
    super.initState();
    // Initialize with current user's assigned roles
    _assignedRoleNames = List.from(widget.user.assignedRoles);
    _assignedRoleIds = [];
    
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(ManageRolesDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update assigned roles if user changed
    if (oldWidget.user.id != widget.user.id) {
      _assignedRoleNames = List.from(widget.user.assignedRoles);
      _assignedRoleIds = [];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Note: JobRolesNotifier constructor already calls loadJobRoles(), so we don't need to call it here
    // Scroll listener is added in initState
    
    // Fetch user data once when dialog opens
    if (_cachedUserData == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchUserData();
      });
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final userId = int.parse(widget.user.id);
      final dataSource = UserAccountRemoteDataSourceImpl();
      final service = UserAccountService(dataSource);
      
      final userData = await service.getUserAccountById(userId);
      if (userData != null && userData['data'] != null) {
        setState(() {
          _cachedUserData = userData['data'] as UserAccountDto;
        });
        
        // Populate assigned role IDs from fetched user data
        if (_assignedRoleIds.isEmpty && _assignedRoleNames.isNotEmpty && _cachedUserData!.jobRoles.isNotEmpty) {
          final roleIdMap = <String, int>{};
          for (final role in _cachedUserData!.jobRoles) {
            try {
              final id = int.parse(role.id);
              roleIdMap[role.name] = id;
            } catch (e) {
              // Skip invalid IDs
            }
          }
          
          _assignedRoleIds = _assignedRoleNames
              .where((name) => roleIdMap.containsKey(name))
              .map((name) => roleIdMap[name]!)
              .toList();
        }
      }
    } catch (e) {
      // Silently fail - we'll fetch again on save if needed
      if (mounted) {
        debugPrint('Failed to fetch user data: $e');
      }
    }
  }

  void _populateAssignedRoleIds() {
    final state = ref.read(_localJobRolesProvider);
    if (state.jobRoles.isNotEmpty && _assignedRoleNames.isNotEmpty) {
      // Map assigned role names to their IDs
      final roleIdMap = <String, int>{};
      for (final role in state.jobRoles) {
        try {
          final id = int.parse(role.id);
          roleIdMap[role.name] = id;
        } catch (e) {
          // Skip invalid IDs
        }
      }
      
      // Populate _assignedRoleIds from assigned role names
      final newRoleIds = _assignedRoleNames
          .where((name) => roleIdMap.containsKey(name))
          .map((name) => roleIdMap[name]!)
          .toList();
      
      // Only update if IDs have changed or are empty
      if (_assignedRoleIds.length != newRoleIds.length || 
          !_assignedRoleIds.every((id) => newRoleIds.contains(id))) {
        setState(() {
          _assignedRoleIds = newRoleIds;
        });
      }
    }
  }


  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      ref.read(_localJobRolesProvider.notifier).search(query);
      // Reset scroll position when search changes
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  List<JobRoleModel> get _availableJobRoles {
    final state = ref.watch(_localJobRolesProvider);
    return state.jobRoles;
  }

  List<JobRoleModel> get _filteredAvailableRoles {
    // Only filter out already assigned roles
    // Search and category filtering are handled by API
    return _availableJobRoles
        .where((role) => !_assignedRoleNames.contains(role.name))
        .toList();
  }

  List<JobRoleModel> get _assignedJobRoles {
    final state = ref.watch(_localJobRolesProvider);
    // Get assigned roles from the job roles list
    final assigned = state.jobRoles
        .where((role) => _assignedRoleNames.contains(role.name))
        .toList();
    
    // If some assigned roles are not in the loaded list (e.g., still loading),
    // create placeholder models for them
    final loadedRoleNames = state.jobRoles.map((r) => r.name).toSet();
    final missingRoles = _assignedRoleNames
        .where((name) => !loadedRoleNames.contains(name))
        .map((name) => JobRoleModel(
              id: '',
              name: name,
              code: '',
              description: 'No description',
              department: 'Unknown',
              status: 'ACTIVE',
              usersAssigned: 0,
              privilegesCount: 0,
              dutyRoles: [],
              lastModified: '',
            ))
        .toList();
    
    return [...assigned, ...missingRoles];
  }

  void _assignRole(JobRoleModel role) {
    setState(() {
      if (!_assignedRoleNames.contains(role.name)) {
        _assignedRoleNames.add(role.name);
        _assignedRoleIds.add(int.parse(role.id));
      }
    });
  }

  void _unassignRole(JobRoleModel role) {
    setState(() {
      _assignedRoleNames.remove(role.name);
      _assignedRoleIds.removeWhere((id) => id == int.parse(role.id));
    });
  }

  void _clearAll() {
    setState(() {
      _assignedRoleNames.clear();
      _assignedRoleIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Container(
        width: isMobile ? double.infinity : 1200,
        height: isMobile ? size.height * 0.9 : 700,
        constraints: BoxConstraints(
          maxWidth: 1200,
          maxHeight: size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: isMobile
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 350,
                            child: _buildAssignedRolesPanel(context, l10n, isDark),
                          ),
                          Container(
                            height: 1,
                            color: isDark
                                ? const Color(0xFF374151)
                                : Colors.black.withValues(alpha: 0.1),
                          ),
                          SizedBox(
                            height: 400,
                            child: _buildAvailableRolesPanel(context, l10n, isDark),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _buildAssignedRolesPanel(context, l10n, isDark),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildAvailableRolesPanel(context, l10n, isDark),
                          ),
                        ],
                      ),
                    ),
            ),
            _buildFooter(context, l10n, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Roles - ${widget.user.name}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.9,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'User: ${widget.user.email} • ${widget.user.department} • Not specified',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF717182),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Roles assigned count
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7,
                color: isDark ? Colors.white : const Color(0xFF4A5565),
              ),
              children: [
                TextSpan(
                  text: '${_assignedRoleNames.length}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text: ' roles assigned',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // ID Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'ID: ${widget.user.id}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6A7282),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Close button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.close,
              size: 16,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedRolesPanel(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.currentlyAssignedRoles,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.6,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),
              Row(
                children: [
                  if (_assignedRoleNames.isNotEmpty)
                    GestureDetector(
                      onTap: _clearAll,
                      child: const Text(
                        'Clear All',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFE7000B),
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  Text(
                    '${_assignedRoleNames.length} assigned',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.6,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF4A5565),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Assigned roles container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF374151).withValues(alpha: 0.3)
                    : const Color(0xFFEFF6FF).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF4B5563)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: _assignedRoleNames.isEmpty
                  ? _buildEmptyAssignedState(isDark)
                  : Consumer(
                      builder: (context, ref, child) {
                        final assignedRoles = _assignedJobRoles;
                        return ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: assignedRoles.length,
                          itemBuilder: (context, index) {
                            final role = assignedRoles[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index < assignedRoles.length - 1 ? 8 : 0,
                              ),
                              child: _buildAssignedRoleCard(role, isDark),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAssignedState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              size: 24,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No roles assigned yet',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Click on roles from the right panel to assign them',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedRoleCard(JobRoleModel role, bool isDark) {
    final isFinance = role.department == 'Finance';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? const Color(0xFF4B5563) : const Color(0xFFBEDBFF),
        ),
      ),
      child: Row(
        children: [
          // Green checkmark
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 10,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          // Role info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      role.name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.7,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF0F172B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryBadge(role.department, isDark, isFinance),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  role.description.isNotEmpty ? role.description : 'No description',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF4A5565),
                  ),
                ),
              ],
            ),
          ),
          // Remove button
          GestureDetector(
            onTap: () => _unassignRole(role),
            child: Icon(
              Icons.close,
              size: 16,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableRolesPanel(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.availableRolesToAssign,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(_localJobRolesProvider);
                  return Text(
                    '${state.totalItems} available',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.6,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF4A5565),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Search field
          CustomTextField.search(
            controller: _searchController,
            hintText: 'Search by role name or description...',
          ),
          const SizedBox(height: 12),
          // Category filter tabs
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(_localJobRolesProvider);
              // Get unique departments from job roles
              final departments = ['All Categories', ...state.jobRoles
                  .map((r) => r.department)
                  .where((d) => d.isNotEmpty && d != 'Unknown')
                  .toSet()
                  .toList()..sort()];
              
              return Row(
                children: departments.take(5).map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = category);
                        if (category != 'All Categories') {
                          ref.read(_localJobRolesProvider.notifier).filterByDepartment(category);
                        } else {
                          ref.read(_localJobRolesProvider.notifier).filterByDepartment(null);
                        }
                        // Reset scroll position when filter changes
                        _scrollController.jumpTo(0);
                      },
                      child: Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF155DFC)
                              : (isDark
                                  ? const Color(0xFF374151)
                                  : const Color(0xFFF3F4F6)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: category == 'All Categories' ? 12 : 11.8,
                              fontWeight: FontWeight.w400,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF364153)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 12),
          // Available roles container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF374151).withValues(alpha: 0.3)
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF4B5563)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(_localJobRolesProvider);
                  final filteredRoles = _filteredAvailableRoles;
                  
                  // Populate assigned role IDs when job roles are loaded
                  if (state.jobRoles.isNotEmpty && _assignedRoleNames.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _populateAssignedRoleIds();
                    });
                  }
                  
                  if (state.isLoading && state.jobRoles.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (filteredRoles.isEmpty && !state.isLoading) {
                    return _buildEmptyAvailableState(isDark);
                  }
                  
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollUpdateNotification) {
                        final metrics = notification.metrics;
                        if (metrics.pixels >= metrics.maxScrollExtent - 200 && 
                            metrics.maxScrollExtent > 0) {
                          // Load next page when user scrolls within 200px of bottom
                          final currentState = ref.read(_localJobRolesProvider);
                          if (currentState.hasNextPage && 
                              !currentState.isPaginationLoading && 
                              !currentState.isLoading) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ref.read(_localJobRolesProvider.notifier).nextPage();
                            });
                          }
                        }
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredRoles.length + (state.isPaginationLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredRoles.length) {
                          // Loading indicator at bottom
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < filteredRoles.length - 1 ? 8 : 0,
                          ),
                          child: _buildAvailableRoleCard(
                              filteredRoles[index], isDark),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAvailableState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            size: 40,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 12),
          Text(
            'All roles assigned',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableRoleCard(JobRoleModel role, bool isDark) {
    final isFinance = role.department == 'Finance';

    return GestureDetector(
      onTap: () => _assignRole(role),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isDark ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            // Empty circle
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF6B7280)
                      : const Color(0xFFD1D5DB),
                  width: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Role info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        role.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.7,
                          fontWeight: FontWeight.w500,
                          color:
                              isDark ? Colors.white : const Color(0xFF0F172B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildCategoryBadge(role.department, isDark, isFinance),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role.description.isNotEmpty ? role.description : 'No description',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF4A5565),
                    ),
                  ),
                ],
              ),
            ),
            // Add button
            Icon(
              Icons.add,
              size: 20,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category, bool isDark, bool isFinance) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isFinance
            ? (isDark ? const Color(0xFF1E3A5F) : const Color(0xFFDBEAFE))
            : (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6)),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: isFinance
              ? (isDark ? const Color(0xFF3B82F6) : const Color(0xFFBEDBFF))
              : (isDark ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB)),
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11.8,
          fontWeight: FontWeight.w400,
          color: isFinance
              ? (isDark ? const Color(0xFF60A5FA) : const Color(0xFF1447E6))
              : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF364153)),
        ),
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          // Stats section
          Expanded(
            child: Row(
              children: [
                // Assigned count
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00C950),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.7,
                      color: isDark ? Colors.white : const Color(0xFF0F172B),
                    ),
                    children: [
                      TextSpan(
                        text: '${_assignedRoleNames.length}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: ' assigned',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF364153),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Divider
                Container(
                  width: 1,
                  height: 16,
                  color: const Color(0xFFD1D5DC),
                ),
                const SizedBox(width: 16),
                // Available count
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF99A1AF),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.6,
                      color: isDark ? Colors.white : const Color(0xFF0F172B),
                    ),
                    children: [
                      TextSpan(
                        text: '${_filteredAvailableRoles.length}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: ' available',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF364153),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Divider
                Container(
                  width: 1,
                  height: 16,
                  color: const Color(0xFFD1D5DC),
                ),
                const SizedBox(width: 16),
                // Hint text
                Text(
                  '💡 Click on any role to add/remove',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.8,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6A7282),
                  ),
                ),
              ],
            ),
          ),
          // Buttons
          Row(
            children: [
              // Cancel button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF374151) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.7,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Save Changes button
              GestureDetector(
                onTap: _isSaving ? null : _handleSaveChanges,
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
                      if (_isSaving)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else
                        const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.saveChanges,
                        style: const TextStyle(
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
          ),
        ],
      ),
    );
  }

  Future<void> _handleSaveChanges() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final userId = int.parse(widget.user.id);
      
      // Get new assigned role IDs (only valid IDs, filter out empty strings)
      final newRoleIds = _assignedRoleIds.where((id) => id > 0).toList();

      // Create service instance
      final dataSource = UserAccountRemoteDataSourceImpl();
      final service = UserAccountService(dataSource);

      // Use cached user data if available, otherwise fetch it
      UserAccountDto dto;
      if (_cachedUserData != null) {
        dto = _cachedUserData!;
      } else {
        // Fallback: fetch if not cached
        final userData = await service.getUserAccountById(userId);
        if (userData == null || userData['data'] == null) {
          throw Exception('Failed to fetch user data');
        }
        dto = userData['data'] as UserAccountDto;
      }
      
      // If _assignedRoleIds is empty but we have assigned role names, populate IDs from user's current job roles
      if (_assignedRoleIds.isEmpty && _assignedRoleNames.isNotEmpty && dto.jobRoles.isNotEmpty) {
        final roleIdMap = <String, int>{};
        for (final role in dto.jobRoles) {
          try {
            final id = int.parse(role.id);
            roleIdMap[role.name] = id;
          } catch (e) {
            // Skip invalid IDs
          }
        }
        
        _assignedRoleIds = _assignedRoleNames
            .where((name) => roleIdMap.containsKey(name))
            .map((name) => roleIdMap[name]!)
            .toList();
      }

      // Update user account with job roles
      await service.updateUserAccount(
        userId: userId,
        username: dto.username,
        emailAddress: dto.emailAddress,
        password: null, // Don't update password
        accountType: dto.accountType,
        accountStatus: dto.accountStatus,
        startDate: dto.startDate,
        endDate: dto.endDate,
        mustChangePassword: dto.mustChangePwdFlag == 'Y',
        passwordNeverExpires: dto.pwdNeverExpiresFlag == 'Y',
        mfaEnabled: dto.mfaEnabledFlag == 'Y',
        preferredLanguage: dto.preferredLanguage,
        timezoneCode: dto.timezoneCode,
        dateFormat: dto.dateFormat,
        firstName: dto.firstName ?? '',
        middleName: dto.middleName,
        lastName: dto.lastName ?? '',
        displayName: dto.displayName,
        employeeNumber: dto.employeeNumber,
        departmentName: dto.departmentName,
        jobTitle: dto.jobTitle,
        phoneNumber: dto.phoneNumber,
        managerEmail: dto.managerEmail,
        descriptionNotes: dto.descriptionNotes,
        jobRoles: newRoleIds,
        updatedBy: 'ADMIN', // TODO: Get from auth state
      );

      if (mounted) {
        Navigator.of(context).pop(_assignedRoleNames);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job roles updated successfully'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update job roles: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
