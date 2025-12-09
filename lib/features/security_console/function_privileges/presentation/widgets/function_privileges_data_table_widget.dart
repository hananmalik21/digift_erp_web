import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../core/widgets/delete_confirmation_dialog.dart';
import '../../data/models/function_privilege_model.dart';
import 'create_privilege_dialog.dart';
import 'privilege_details_dialog.dart';

class FunctionPrivilegesDataTable extends StatelessWidget {
  final bool isDark;
  final List<FunctionPrivilegeModel> privileges;
  final Future<void> Function(FunctionPrivilegeModel)? onEdit;
  final Future<void> Function(String) onDelete;

  const FunctionPrivilegesDataTable({
    super.key,
    required this.isDark,
    required this.privileges,
    this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxTableHeight = (size.height - 500).clamp(300.0, 600.0);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1226.27,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTableHeader(isDark),
                SizedBox(
                  height: maxTableHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      children: privileges
                          .map((privilege) => FunctionPrivilegesTableRow(
                                privilege: privilege,
                                isDark: isDark,
                                onEdit: onEdit,
                                onDelete: onDelete,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(bool isDark) {
    return Container(
      height: 64.5,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF374151)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('PRIVILEGE CODE', 220),
          _buildHeaderCell('PRIVILEGE NAME', 320),
          _buildHeaderCell('MODULE', 140),
          _buildHeaderCell('FUNCTION', 110),
          _buildHeaderCell('OPERATION', 108),
          _buildHeaderCell('STATUS', 100),
          _buildHeaderCell('ACTIONS', 108),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      alignment: text == 'ACTIONS' ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: text == 'ACTIONS' ? 0 : 16,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF364153),
          letterSpacing: 0.6,
          height: 1.33,
        ),
      ),
    );
  }
}

class FunctionPrivilegesTableRow extends StatelessWidget {
  final FunctionPrivilegeModel privilege;
  final bool isDark;
  final Future<void> Function(FunctionPrivilegeModel)? onEdit;
  final Future<void> Function(String) onDelete;

  const FunctionPrivilegesTableRow({
    super.key,
    required this.privilege,
    required this.isDark,
    this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61,
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF374151)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(
            privilege.code,
            220,
            12,
            FontWeight.w400,
            isDark,
          ),
          _buildNameDescriptionCell(
            privilege.name,
            privilege.description,
            320,
            isDark,
          ),
          _buildModuleCell(privilege.module, 140, isDark),
          _buildDataCell(
            privilege.function,
            110,
            11.8,
            FontWeight.w400,
            isDark,
          ),
          _buildOperationCell(privilege.operation, 108, isDark),
          _buildStatusCell(privilege.status, 100, isDark),
          _buildActionsCell(context, privilege, 108, isDark),
        ],
      ),
    );
  }

  Widget _buildDataCell(
    String text,
    double width,
    double fontSize,
    FontWeight fontWeight,
    bool isDark,
  ) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: isDark ? Colors.white : const Color(0xFF0F172B),
          height: 1.33,
        ),
      ),
    );
  }

  Widget _buildNameDescriptionCell(
    String name,
    String description,
    double width,
    bool isDark,
  ) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.47,
            ),
          ),
          const SizedBox(height: 0.5),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF6A7282),
              height: 1.36,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCell(String module, double width, bool isDark) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Icon(
            Icons.folder_outlined,
            size: 16,
            color: isDark
                ? const Color(0xFF9CA3AF)
                : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              module,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.8,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : const Color(0xFF101828),
                height: 1.36,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationCell(String operation, double width, bool isDark) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16),
      child: _buildOperationBadge(operation, isDark),
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

  Widget _buildStatusCell(String status, double width, bool isDark) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16),
      child: _buildStatusBadge(status, isDark),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    final isActive = status == 'Active';

    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFD1FAE5)
            : const Color(0xFFF3F4F6),
        border: Border.all(
          color: isActive
              ? const Color(0xFFB9F8CF)
              : const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 12,
            color: isActive
                ? const Color(0xFF008236)
                : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isActive
                  ? const Color(0xFF008236)
                  : const Color(0xFF6B7280),
              height: 1.36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCell(
    BuildContext context,
    FunctionPrivilegeModel privilege,
    double width,
    bool isDark,
  ) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: _buildActionButtons(context, privilege, isDark),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    FunctionPrivilegeModel privilege,
    bool isDark,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: SvgPicture.asset(
            Assets.icons.visibleIcon.path,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              isDark ? Colors.white : const Color(0xFF0F172B),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            PrivilegeDetailsDialog.show(context, privilege);
          },
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
        IconButton(
          icon: SvgPicture.asset(
            Assets.icons.editIcon.path,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              isDark ? Colors.white : const Color(0xFF0F172B),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () async {
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
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
        IconButton(
          icon: SvgPicture.asset(
            Assets.icons.deleteIcon.path,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              isDark ? Colors.white : const Color(0xFF0F172B),
              BlendMode.srcIn,
            ),
          ),
          onPressed: () async {
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
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
      ],
    );
  }
}
