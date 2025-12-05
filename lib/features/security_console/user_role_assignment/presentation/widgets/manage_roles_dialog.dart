import 'package:flutter/material.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../data/models/user_role_model.dart';

class ManageRolesDialog extends StatefulWidget {
  final UserRoleModel user;

  const ManageRolesDialog({super.key, required this.user});

  @override
  State<ManageRolesDialog> createState() => _ManageRolesDialogState();
}

class _ManageRolesDialogState extends State<ManageRolesDialog> {
  final _searchController = TextEditingController();
  late List<String> _assignedRoles;
  late List<RoleItem> _availableRoles;
  String _selectedCategory = 'All Categories';

  final List<RoleItem> _allRoles = [
    RoleItem(
      name: 'Accounting Manager',
      category: 'General Ledger',
      description: 'No description',
    ),
    RoleItem(
      name: 'Finance Manager Test',
      category: 'Finance',
      description: 'No description',
    ),
    RoleItem(
      name: 'System Administrator',
      category: 'General Ledger',
      description: 'Full system access',
    ),
    RoleItem(
      name: 'GL Accountant',
      category: 'General Ledger',
      description: 'General ledger operations',
    ),
    RoleItem(
      name: 'Security Administrator',
      category: 'Finance',
      description: 'Security management',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _assignedRoles = List.from(widget.user.assignedRoles);
    _updateAvailableRoles();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  void _updateAvailableRoles() {
    _availableRoles = _allRoles
        .where((role) => !_assignedRoles.contains(role.name))
        .toList();
  }

  List<RoleItem> get _filteredAvailableRoles {
    var roles = _availableRoles;

    if (_selectedCategory != 'All Categories') {
      roles = roles.where((r) => r.category == _selectedCategory).toList();
    }

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      roles = roles
          .where((r) =>
              r.name.toLowerCase().contains(query) ||
              r.description.toLowerCase().contains(query))
          .toList();
    }

    return roles;
  }

  void _assignRole(RoleItem role) {
    setState(() {
      _assignedRoles.add(role.name);
      _updateAvailableRoles();
    });
  }

  void _unassignRole(String roleName) {
    setState(() {
      _assignedRoles.remove(roleName);
      _updateAvailableRoles();
    });
  }

  void _clearAll() {
    setState(() {
      _assignedRoles.clear();
      _updateAvailableRoles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  text: '${_assignedRoles.length}',
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
                  if (_assignedRoles.isNotEmpty)
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
                    '${_assignedRoles.length} assigned',
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
              child: _assignedRoles.isEmpty
                  ? _buildEmptyAssignedState(isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _assignedRoles.length,
                      itemBuilder: (context, index) {
                        final roleName = _assignedRoles[index];
                        final role = _allRoles.firstWhere(
                          (r) => r.name == roleName,
                          orElse: () => RoleItem(
                            name: roleName,
                            category: 'General Ledger',
                            description: 'No description',
                          ),
                        );
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < _assignedRoles.length - 1 ? 8 : 0,
                          ),
                          child: _buildAssignedRoleCard(role, isDark),
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

  Widget _buildAssignedRoleCard(RoleItem role, bool isDark) {
    final isFinance = role.category == 'Finance';

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
                    _buildCategoryBadge(role.category, isDark, isFinance),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  role.description,
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
            onTap: () => _unassignRole(role.name),
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
    final filteredRoles = _filteredAvailableRoles;

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
              Text(
                '${_availableRoles.length} available',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.6,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF4A5565),
                ),
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
          Row(
            children: ['All Categories', 'General Ledger', 'Finance']
                .map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
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
              child: filteredRoles.isEmpty
                  ? _buildEmptyAvailableState(isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredRoles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < filteredRoles.length - 1 ? 8 : 0,
                          ),
                          child: _buildAvailableRoleCard(
                              filteredRoles[index], isDark),
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

  Widget _buildAvailableRoleCard(RoleItem role, bool isDark) {
    final isFinance = role.category == 'Finance';

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
                      _buildCategoryBadge(role.category, isDark, isFinance),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role.description,
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
                        text: '${_assignedRoles.length}',
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
                        text: '${_availableRoles.length}',
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
                onTap: () {
                  Navigator.of(context).pop(_assignedRoles);
                },
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
}

class RoleItem {
  final String name;
  final String category;
  final String description;

  RoleItem({
    required this.name,
    required this.category,
    required this.description,
  });
}
