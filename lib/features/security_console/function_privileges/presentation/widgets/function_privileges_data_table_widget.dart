import 'package:flutter/material.dart';
import '../../../../../core/widgets/delete_confirmation_dialog.dart';
import '../../../../../core/widgets/custom_table.dart';
import '../../../../../core/widgets/custom_status_cell.dart';
import '../../../../../core/widgets/custom_action_cell.dart';
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
    final columns = [
      const CustomTableColumn(headerText: 'PRIVILEGE CODE', width: 220),
      const CustomTableColumn(headerText: 'PRIVILEGE NAME', width: 320),
      const CustomTableColumn(headerText: 'MODULE', width: 140),
      const CustomTableColumn(headerText: 'FUNCTION', width: 110),
      const CustomTableColumn(headerText: 'OPERATION', width: 108),
      const CustomTableColumn(headerText: 'STATUS', width: 100),
      const CustomTableColumn(headerText: 'ACTIONS', width: 200, alignment: Alignment.center),
    ];

    final rows = privileges.map((privilege) {
      return FunctionPrivilegesTableRow(
        privilege: privilege,
        isDark: isDark,
        onEdit: onEdit,
        onDelete: onDelete,
      ).buildRowCells(context);
    }).toList();

    return CustomTable(
      columns: columns,
      rows: rows,
      isDark: isDark,
      minTableWidth: 1226.27,
      headerHeight: 64.5,
      rowHeight: 61,
    );
  }
}

class FunctionPrivilegesTableRow {
  final FunctionPrivilegeModel privilege;
  final bool isDark;
  final Future<void> Function(FunctionPrivilegeModel)? onEdit;
  final Future<void> Function(String) onDelete;

  FunctionPrivilegesTableRow({
    required this.privilege,
    required this.isDark,
    this.onEdit,
    required this.onDelete,
  });

  List<Widget> buildRowCells(BuildContext context) {
    return [
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
      CustomStatusCell(
        status: privilege.status,
        isDark: isDark,
        width: 100,
      ),
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
    ];
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

}
