import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../providers/duty_roles_provider.dart';
import '../../../data/models/duty_role_model.dart';
import '../../../data/datasources/duty_role_remote_datasource.dart';
import '../create_edit_duty_role_dialog.dart';
import '../../../../../../core/widgets/delete_confirmation_dialog.dart';

class DutyRoleCard extends ConsumerWidget {
  final DutyRoleModel role;
  final bool isDark;
  final AutoDisposeStateNotifierProvider<DutyRolesNotifier, DutyRolesState> dutyRolesProvider;

  const DutyRoleCard({
    super.key,
    required this.role,
    required this.isDark,
    required this.dutyRolesProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
      padding: const EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context, ref),
          const SizedBox(height: 24),
          Text(
            role.name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.7,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.16,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            role.code,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.17,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            role.description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.46,
            ),
          ),
          const SizedBox(height: 24),
          _buildModuleBadge(role.module, isDark),
          const SizedBox(height: 35),
          Text(
            'Privileges (${role.privileges.length})',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.1,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.16,
            ),
          ),
          const SizedBox(height: 11),
          _buildPrivilegesList(role.privileges, isDark),
          const SizedBox(height: 26),
          _buildCardFooter(role, isDark),
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.icons.dutyRoleIcon.path,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            Color(0xFF155DFC),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            border: Border.all(color: const Color(0xFFB9F8CF)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            role.status,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.1,
              fontWeight: FontWeight.w400,
              color: Color(0xFF008236),
              height: 1.16,
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CreateEditDutyRoleDialog(dutyRole: role),
            ).then((result) {
              if (!context.mounted) return;
              if (result != null && result['success'] == true) {
                final messenger = ScaffoldMessenger.of(context);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(result['message'] ?? 'Duty role updated successfully'),
                    backgroundColor: const Color(0xFF00A63E),
                  ),
                );
                // Update locally immediately on success
                if (result['updatedRole'] != null) {
                  final updatedRole = result['updatedRole'] as DutyRoleModel;
                  if (kDebugMode) {
                    print('Card widget: Received updated role with ID: ${updatedRole.id}');
                    print('Card widget: Current role ID: ${role.id}');
                  }
                  // Use the provider passed as parameter
                  ref.read(dutyRolesProvider.notifier).updateDutyRoleLocally(updatedRole);
                  if (kDebugMode) {
                    print('Card widget: Called updateDutyRoleLocally');
                  }
                } else {
                  if (kDebugMode) {
                    print('Card widget: No updatedRole in result, refreshing...');
                  }
                  // Fallback to refresh if updated role not provided
                  ref.read(dutyRolesProvider.notifier).refresh();
                }
              }
            });
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
          onPressed: () => _showDeleteConfirmation(context, ref),
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

  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref) async {
    final result = await DeleteConfirmationDialog.show(
      context,
      title: 'Delete Duty Role',
      message: 'Are you sure you want to delete this duty role? This action cannot be undone.',
      itemName: role.name,
      onConfirm: () => _deleteDutyRole(ref),
    );

    if (result == true && context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Duty role deleted successfully'),
          backgroundColor: Color(0xFF00A63E),
        ),
      );
    }
  }

  Future<bool> _deleteDutyRole(WidgetRef ref) async {
    final dataSource = DutyRoleRemoteDataSourceImpl();

    try {
      final roleId = int.tryParse(role.id);
      if (roleId == null) {
        return false;
      }

      await dataSource.deleteDutyRole(roleId);

      // On success, remove locally immediately
      ref.read(dutyRolesProvider.notifier).deleteDutyRoleLocally(role.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildModuleBadge(String module, bool isDark) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          module,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.1,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
            height: 1.16,
          ),
        ),
      ),
    );
  }

  Widget _buildPrivilegesList(List<String> privileges, bool isDark) {
    final visiblePrivileges = privileges.take(3).toList();
    final remainingCount = privileges.length - 3;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...visiblePrivileges.map((privilege) {
          return Container(
            key: ValueKey(privilege),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              privilege,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.1,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
                height: 1.16,
              ),
            ),
          );
        }),
        if (remainingCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '+$remainingCount more',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.1,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
                height: 1.16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCardFooter(DutyRoleModel role, bool isDark) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.people_outline,
            size: 12,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 4),
          Text(
            '${role.usersAssigned} users',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.1,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.16,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Used in ${role.jobRolesCount} job roles',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.1,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.16,
            ),
          ),
          const Spacer(),
          Text(
            role.lastModified,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
              height: 1.17,
            ),
          ),
        ],
      ),
    );
  }
}
