import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/delete_confirmation_dialog.dart';
import '../../../../../core/widgets/custom_table.dart';
import '../../../../../core/widgets/custom_status_cell.dart';
import '../../../../../core/widgets/custom_action_cell.dart';
import '../../data/models/function_model.dart';
import '../providers/functions_provider.dart';
import 'create_function_dialog.dart';
import 'function_details_dialog.dart';
import 'functions_empty_state_widget.dart';

class FunctionsDataTable extends ConsumerWidget {
  final bool isDark;
  final List<FunctionModel> functions;

  const FunctionsDataTable({
    super.key,
    required this.isDark,
    required this.functions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (functions.isEmpty) {
      return FunctionsEmptyState(isDark: isDark);
    }

    final columns = [
      const CustomTableColumn(headerText: 'FUNCTION CODE', width: 243.77),
      const CustomTableColumn(headerText: 'FUNCTION\nNAME', width: 144.46),
      const CustomTableColumn(headerText: 'MODULE', width: 166.77),
      const CustomTableColumn(headerText: 'DESCRIPTION', width: 300),
      const CustomTableColumn(headerText: 'STATUS', width: 120),
      const CustomTableColumn(headerText: 'ACTIONS', width: 140, alignment: Alignment.center),
    ];

    final rowHeights = <double>[];
    final rows = functions.map((function) {
      // Calculate row height based on content
      double rowHeight = 85;
      if (function.name.length > 25 || function.description.length > 50) {
        rowHeight = 105;
      }
      if (function.name.length > 30 || function.description.length > 60) {
        rowHeight = 121;
      }
      if (function.description.length > 70) {
        rowHeight = 137;
      }
      rowHeights.add(rowHeight);

      return [
        FunctionsDataCell(
          text: function.code,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          isDark: isDark,
          leftPadding: 24,
        ),
        FunctionsNameCell(
          name: function.name,
          isDark: isDark,
        ),
        FunctionsModuleCell(
          module: function.module,
          isDark: isDark,
        ),
        FunctionsDescriptionCell(
          description: function.description,
          isDark: isDark,
        ),
        CustomStatusCell(
          status: function.status,
          isDark: isDark,
        ),
        CustomActionCell(
          onView: () => FunctionDetailsDialog.show(context, function),
          onEdit: () {
            showDialog(
              context: context,
              builder: (context) => CreateFunctionDialog(function: function),
            );
          },
          onDelete: () async {
            final functionsNotifier = ref.read(functionsProvider.notifier);
            final result = await DeleteConfirmationDialog.show(
              context,
              title: 'Delete Function',
              message: 'Are you sure you want to delete this function? This action cannot be undone.',
              itemName: function.name,
              onConfirm: () => functionsNotifier.deleteFunction(function.id),
            );
            if (result == true && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Function deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          isDark: isDark,
        ),
      ];
    }).toList();

    return CustomTable(
      columns: columns,
      rows: rows.toList(),
      rowHeights: rowHeights,
      isDark: isDark,
      minTableWidth: 1226.27,
      headerHeight: 64.5,
      rowHeight: 61,
      // minTableWidth: totalFixedWidth,
      // headerHeight: 56.5,
      // rowHeight: 85, // Default, overridden by rowHeights
    );
  }
}

class FunctionsTableRow extends ConsumerWidget {
  final FunctionModel function;
  final bool isDark;

  const FunctionsTableRow({
    super.key,
    required this.function,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calculate row height based on content
    double rowHeight = 85; // minimum
    if (function.name.length > 25 || function.description.length > 50) {
      rowHeight = 105;
    }
    if (function.name.length > 30 || function.description.length > 60) {
      rowHeight = 121;
    }
    if (function.description.length > 70) {
      rowHeight = 137;
    }

    return Container(
      constraints: BoxConstraints(minHeight: rowHeight),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FunctionsDataCell(
            text: function.code,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            isDark: isDark,
            leftPadding: 24,
          ),
          FunctionsNameCell(
            name: function.name,
            isDark: isDark,
          ),
          FunctionsModuleCell(
            module: function.module,
            isDark: isDark,
          ),
          FunctionsDescriptionCell(
            description: function.description,
            isDark: isDark,
          ),
          CustomStatusCell(
            status: function.status,
            isDark: isDark,
          ),
          CustomActionCell(
            onView: () => FunctionDetailsDialog.show(context, function),
            onEdit: () {
              showDialog(
                context: context,
                builder: (context) => CreateFunctionDialog(function: function),
              );
            },
            onDelete: () async {
              final functionsNotifier = ref.read(functionsProvider.notifier);
              final result = await DeleteConfirmationDialog.show(
                context,
                title: 'Delete Function',
                message: 'Are you sure you want to delete this function? This action cannot be undone.',
                itemName: function.name,
                onConfirm: () => functionsNotifier.deleteFunction(function.id),
              );
              if (result == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Function deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class FunctionsDataCell extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isDark;
  final double leftPadding;

  const FunctionsDataCell({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.isDark,
    this.leftPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: leftPadding),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
            height: 1.67,
          ),
        ),
      ),
    );
  }
}

class FunctionsNameCell extends StatelessWidget {
  final String name;
  final bool isDark;

  const FunctionsNameCell({
    super.key,
    required this.name,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      child: Text(
        name,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.6,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : const Color(0xFF0F172B),
          height: 1.47,
        ),
      ),
    );
  }
}

class FunctionsDescriptionCell extends StatelessWidget {
  final String description;
  final bool isDark;

  const FunctionsDescriptionCell({
    super.key,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Text(
          description,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
            height: 1.5,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class FunctionsModuleCell extends StatelessWidget {
  final String module;
  final bool isDark;

  const FunctionsModuleCell({
    super.key,
    required this.module,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Row(
          children: [
            Icon(
              Icons.folder_outlined,
              size: 16,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                module,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF101828),
                  height: 1.67,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

