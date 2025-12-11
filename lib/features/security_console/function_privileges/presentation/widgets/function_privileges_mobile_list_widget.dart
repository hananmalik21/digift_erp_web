import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/delete_confirmation_dialog.dart';
import '../../../../../core/widgets/custom_status_cell.dart';
import '../../../../../core/widgets/custom_action_cell.dart';
import '../../data/models/function_privilege_model.dart';
import 'create_privilege_dialog.dart';
import 'privilege_details_dialog.dart';

class FunctionPrivilegesMobileList extends StatelessWidget {
  final bool isDark;
  final List<FunctionPrivilegeModel> privileges;
  final Future<void> Function(FunctionPrivilegeModel)? onEdit;
  final Future<void> Function(String) onDelete;

  const FunctionPrivilegesMobileList({
    super.key,
    required this.isDark,
    required this.privileges,
    this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: privileges
          .map((privilege) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FunctionPrivilegesMobileCard(
                  privilege: privilege,
                  isDark: isDark,
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
              ))
          .toList(),
    );
  }
}

class FunctionPrivilegesMobileCard extends StatelessWidget {
  final FunctionPrivilegeModel privilege;
  final bool isDark;
  final Future<void> Function(FunctionPrivilegeModel)? onEdit;
  final Future<void> Function(String) onDelete;

  const FunctionPrivilegesMobileCard({
    super.key,
    required this.privilege,
    required this.isDark,
    this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
            privilege.code,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.33,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            privilege.name,
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
            privilege.description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF6A7282),
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
                    privilege.module,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.8,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : const Color(0xFF101828),
                    ),
                  ),
                ],
              ),
              _buildOperationBadge(privilege.operation, isDark),
              CustomStatusCell(
                status: privilege.status,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              CustomActionCell(
                onView: () => PrivilegeDetailsDialog.show(context, privilege),
                onEdit: () async {
                  if (onEdit != null) {
                    await onEdit!(privilege);
                  } else {
                    final result = await showDialog(
                      context: context,
                      builder: (context) => CreatePrivilegeDialog(privilege: privilege),
                    );
                    if (result == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Privilege updated successfully'),
                          backgroundColor: Color(0xFF00A63E),
                        ),
                      );
                    }
                  }
                },
                onDelete: () async {
                  final result = await DeleteConfirmationDialog.show(
                    context,
                    title: 'Delete Function Privilege',
                    message: 'Are you sure you want to delete this privilege? This action cannot be undone.',
                    itemName: privilege.name,
                    onConfirm: () async {
                      await onDelete(privilege.id);
                      return true;
                    },
                  );
                  if (result == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Privilege deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOperationBadge(String operation, bool isDark) {
    Color bgColor;
    Color borderColor;
    Color textColor;

    switch (operation) {
      case 'Create':
        bgColor = const Color(0xFFD1FAE5);
        borderColor = const Color(0xFFB9F8CF);
        textColor = const Color(0xFF008236);
        break;
      case 'Post':
        bgColor = const Color(0xFFFFEDD4);
        borderColor = const Color(0xFFFFD6A7);
        textColor = const Color(0xFFCA3500);
        break;
      case 'Read':
      case 'View':
        bgColor = const Color(0xFFDBEAFE);
        borderColor = const Color(0xFFBEDBFF);
        textColor = const Color(0xFF1447E6);
        break;
      case 'Update':
        bgColor = const Color(0xFFFEF9C2);
        borderColor = const Color(0xFFFFF085);
        textColor = const Color(0xFFA65F00);
        break;
      case 'Delete':
        bgColor = const Color(0xFFFFE2E2);
        borderColor = const Color(0xFFFFC9C9);
        textColor = const Color(0xFFC10007);
        break;
      case 'Approve':
        bgColor = const Color(0xFFE9D4FF);
        borderColor = const Color(0xFFE9D4FF);
        textColor = const Color(0xFF8200DB);
        break;
      case 'Export':
        bgColor = const Color(0xFFF3F4F6);
        borderColor = const Color(0xFFE5E7EB);
        textColor = const Color(0xFF364153);
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        borderColor = const Color(0xFFE5E7EB);
        textColor = const Color(0xFF6B7280);
    }

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          operation,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.8,
            fontWeight: FontWeight.w400,
            color: textColor,
            height: 1.36,
          ),
        ),
      ),
    );
  }

}
