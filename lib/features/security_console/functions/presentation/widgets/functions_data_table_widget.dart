import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/extensions/date_extensions.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/delete_confirmation_dialog.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/function_model.dart';
import '../providers/functions_provider.dart';
import 'create_function_dialog.dart';
import 'functions_empty_state_widget.dart';

class FunctionsDataTable extends StatelessWidget {
  final bool isDark;
  final List<FunctionModel> functions;

  const FunctionsDataTable({
    super.key,
    required this.isDark,
    required this.functions,
  });

  @override
  Widget build(BuildContext context) {
    if (functions.isEmpty) {
      return FunctionsEmptyState(isDark: isDark);
    }

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final minTableWidth = 1216.92;
            final tableWidth =
                availableWidth > minTableWidth ? availableWidth : minTableWidth;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FunctionsTableHeader(isDark: isDark),
                    SizedBox(
                      height: maxTableHeight,
                      child: SingleChildScrollView(
                        child: Column(
                          children: functions
                              .map(
                                (function) => FunctionsTableRow(
                                  function: function,
                                  isDark: isDark,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FunctionsTableHeader extends StatelessWidget {
  final bool isDark;

  const FunctionsTableHeader({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.5,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          FunctionsHeaderCell(text: 'FUNCTION CODE', width: 243.77),
          FunctionsHeaderCellMultiLine(text: 'FUNCTION\nNAME', width: 144.46),
          FunctionsHeaderCell(text: 'MODULE', width: 166.77),
          FunctionsHeaderCell(text: 'DESCRIPTION', width: 300),
          FunctionsHeaderCell(text: 'STATUS', width: 101.01),
          FunctionsHeaderCell(text: 'LAST UPDATED', width: 148.91),
          FunctionsHeaderCell(text: 'ACTIONS', width: 112),
        ],
      ),
    );
  }
}

class FunctionsHeaderCell extends StatelessWidget {
  final String text;
  final double width;

  const FunctionsHeaderCell({
    super.key,
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 56.5,
      alignment: text == 'ACTIONS' ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: text == 'ACTIONS' ? 0 : 24,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF364153),
          letterSpacing: 0.6,
          height: 1.17,
        ),
      ),
    );
  }
}

class FunctionsHeaderCellMultiLine extends StatelessWidget {
  final String text;
  final double width;

  const FunctionsHeaderCellMultiLine({
    super.key,
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 24),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF364153),
          letterSpacing: 0.6,
          height: 1.25,
        ),
      ),
    );
  }
}

class FunctionsTableRow extends StatelessWidget {
  final FunctionModel function;
  final bool isDark;

  const FunctionsTableRow({
    super.key,
    required this.function,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
            width: 243.77,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            isDark: isDark,
            leftPadding: 24,
          ),
          FunctionsNameCell(
            name: function.name,
            width: 144.46,
            isDark: isDark,
          ),
          FunctionsModuleCell(
            module: function.module,
            width: 166.77,
            isDark: isDark,
          ),
          FunctionsDescriptionCell(
            description: function.description,
            width: 300,
            isDark: isDark,
          ),
          FunctionsStatusCell(
            status: function.status,
            width: 101.01,
            isDark: isDark,
          ),
          FunctionsUpdatedCell(
            date: function.updatedDate,
            by: function.updatedBy,
            width: 148.91,
            isDark: isDark,
          ),
          FunctionsActionsCell(
            function: function,
            width: 112,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class FunctionsDataCell extends StatelessWidget {
  final String text;
  final double width;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isDark;
  final double leftPadding;

  const FunctionsDataCell({
    super.key,
    required this.text,
    required this.width,
    required this.fontSize,
    required this.fontWeight,
    required this.isDark,
    this.leftPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
  final double width;
  final bool isDark;

  const FunctionsNameCell({
    super.key,
    required this.name,
    required this.width,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
  final double width;
  final bool isDark;

  const FunctionsDescriptionCell({
    super.key,
    required this.description,
    required this.width,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
  final double width;
  final bool isDark;

  const FunctionsModuleCell({
    super.key,
    required this.module,
    required this.width,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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

class FunctionsStatusCell extends StatelessWidget {
  final String status;
  final double width;
  final bool isDark;

  const FunctionsStatusCell({
    super.key,
    required this.status,
    required this.width,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 4),
        child: FunctionsStatusBadge(status: status, isDark: isDark),
      ),
    );
  }
}

class FunctionsStatusBadge extends StatelessWidget {
  final String status;
  final bool isDark;

  const FunctionsStatusBadge({
    super.key,
    required this.status,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'Active';

    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(maxWidth: 73),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD1FAE5) : const Color(0xFFF3F4F6),
        border: Border.all(
          color: isActive ? const Color(0xFFB9F8CF) : const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 12,
            color: isActive ? const Color(0xFF008236) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              status,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.8,
                fontWeight: FontWeight.w400,
                color: isActive
                    ? const Color(0xFF008236)
                    : const Color(0xFF6B7280),
                height: 1.19,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class FunctionsUpdatedCell extends StatelessWidget {
  final String date;
  final String by;
  final double width;
  final bool isDark;

  const FunctionsUpdatedCell({
    super.key,
    required this.date,
    required this.by,
    required this.width,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Format the date string
    final formattedDate = date.toFormattedDate();

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : const Color(0xFF101828),
                height: 1.67,
              ),
            ),
            Text(
              'by $by',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.8,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
                height: 1.19,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FunctionsActionsCell extends StatelessWidget {
  final FunctionModel function;
  final double width;
  final bool isDark;

  const FunctionsActionsCell({
    super.key,
    required this.function,
    required this.width,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: FunctionsActionButtons(
        function: function,
        isDark: isDark,
      ),
    );
  }
}

class FunctionsActionButtons extends ConsumerWidget {
  final FunctionModel function;
  final bool isDark;

  const FunctionsActionButtons({
    super.key,
    required this.function,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
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
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CreateFunctionDialog(function: function),
            );
          },
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
            final functionsNotifier = ref.read(functionsProvider.notifier);
            final result = await DeleteConfirmationDialog.show(
              context,
              title: 'Delete Function',
              message:
                  'Are you sure you want to delete this function? This action cannot be undone.',
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
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }
}
