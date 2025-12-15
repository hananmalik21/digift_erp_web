import 'package:flutter/material.dart';
import '../theme/theme_extensions.dart';

/// A reusable custom table widget that provides consistent styling
/// across the application for data tables.
class CustomTable extends StatelessWidget {
  /// List of column definitions with width and header text
  final List<CustomTableColumn> columns;

  /// List of row data - each row is a list of widgets
  final List<List<Widget>> rows;

  /// Optional list of row heights (one per row). If provided, overrides rowHeight.
  final List<double>? rowHeights;

  /// Whether dark mode is enabled
  final bool isDark;

  /// Minimum table width (defaults to sum of column widths)
  final double? minTableWidth;

  /// Maximum table height before scrolling
  final double? maxTableHeight;

  /// Header height (default: 64.5)
  final double headerHeight;

  /// Row height (default: 61) - used if rowHeights is not provided
  final double rowHeight;

  /// Border radius (default: 14)
  final double borderRadius;

  const CustomTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.isDark,
    this.rowHeights,
    this.minTableWidth,
    this.maxTableHeight,
    this.headerHeight = 64.5,
    this.rowHeight = 61,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double effectiveMaxHeight = (maxTableHeight ??
        (size.height - 500).clamp(300.0, 600.0))
        .toDouble();

    // Base width is sum of fixed column widths
    final double totalFixedWidth =
    columns.fold<double>(0, (sum, col) => sum + col.width);

    // Respect optional minTableWidth
    final double requiredWidth =
    (minTableWidth != null && minTableWidth! > totalFixedWidth)
        ? minTableWidth!
        : totalFixedWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // If availableWidth < requiredWidth → horizontal scroll
        final bool needsScrolling = availableWidth < requiredWidth;
        final double tableWidth = needsScrolling ? requiredWidth : availableWidth;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? context.themeCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: needsScrolling
                ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                child: _buildTableContent(
                  effectiveMaxHeight,
                  tableWidth,
                  totalFixedWidth,
                ),
              ),
            )
                : _buildTableContent(
              effectiveMaxHeight,
              tableWidth,
              totalFixedWidth,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableContent(
      double maxHeight,
      double tableWidth,
      double totalFixedWidth,
      ) {
    final extraWidth =
    tableWidth > totalFixedWidth ? tableWidth - totalFixedWidth : 0.0;

    final expandableColumns = columns.where((col) =>
    col.headerText != 'ACTIONS' &&
        col.headerText != 'STATUS' &&
        col.headerText != 'OPERATION').length;

    final double widthPerExpandableColumn =
    expandableColumns > 0 ? extraWidth / expandableColumns : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTableHeader(widthPerExpandableColumn),
        SizedBox(
          height: maxHeight,
          child: SingleChildScrollView(
            child: Column(
              children: rows.asMap().entries.map((entry) {
                final index = entry.key;
                final row = entry.value;
                final height = rowHeights != null && index < rowHeights!.length
                    ? rowHeights![index]
                    : rowHeight;
                return _buildTableRow(
                  row,
                  height,
                  widthPerExpandableColumn,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(double widthPerExpandableColumn) {
    // Calculate total header width to ensure it matches exactly
    double totalHeaderWidth = 0.0;
    final cellWidths = columns.map((column) {
      final isExpandable = column.headerText != 'ACTIONS' &&
          column.headerText != 'STATUS' &&
          column.headerText != 'OPERATION';
      final double cellWidth =
          isExpandable ? column.width + widthPerExpandableColumn : column.width;
      totalHeaderWidth += cellWidth;
      return cellWidth;
    }).toList();

    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: SizedBox(
        width: totalHeaderWidth,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: columns.asMap().entries.map((entry) {
            final index = entry.key;
            final column = entry.value;
            final double cellWidth = cellWidths[index];

            return SizedBox(
              width: cellWidth,
              child: _buildHeaderCell(column, cellWidth),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(CustomTableColumn column, double cellWidth) {
    final double paddingLeft = (column.alignment == Alignment.center ||
            column.alignment == Alignment.centerRight)
        ? 0.0
        : 24.0;
    final double availableWidth = cellWidth - paddingLeft;

    return Container(
      height: headerHeight,
      alignment: column.alignment ?? Alignment.centerLeft,
      padding: EdgeInsets.only(left: paddingLeft),
      child: SizedBox(
        width: availableWidth,
        child: Text(
          column.headerText,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF364153),
            letterSpacing: 0.6,
            height: 1.33,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: _getTextAlign(column.alignment),
        ),
      ),
    );
  }

  TextAlign _getTextAlign(Alignment? alignment) {
    if (alignment == null || alignment == Alignment.centerLeft) {
      return TextAlign.left;
    }
    if (alignment == Alignment.center) {
      return TextAlign.center;
    }
    if (alignment == Alignment.centerRight) {
      return TextAlign.right;
    }
    return TextAlign.left;
  }

  Widget _buildTableRow(
      List<Widget> cells,
      double height,
      double widthPerExpandableColumn,
      ) {
    if (cells.length != columns.length) {
      throw ArgumentError(
        'Row has ${cells.length} cells but table has ${columns.length} columns',
      );
    }

    // Calculate total row width to ensure it matches exactly
    double totalRowWidth = 0.0;
    final cellWidths = columns.map((column) {
      final bool isExpandable = column.headerText != 'ACTIONS' &&
          column.headerText != 'STATUS' &&
          column.headerText != 'OPERATION';
      final double cellWidth =
          isExpandable ? column.width + widthPerExpandableColumn : column.width;
      totalRowWidth += cellWidth;
      return cellWidth;
    }).toList();

    return Container(
      constraints: BoxConstraints(minHeight: height),
      decoration: BoxDecoration(
        color: isDark ? null : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: SizedBox(
        width: totalRowWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(columns.length, (index) {
            final column = columns[index];
            final double cellWidth = cellWidths[index];

            final double paddingLeft = (column.alignment == Alignment.center ||
                    column.alignment == Alignment.centerRight)
                ? 0.0
                : 24.0;
            final double availableWidth = cellWidth - paddingLeft;

            return SizedBox(
              width: cellWidth,
              child: ClipRect(
                child: Container(
                  alignment: column.alignment ?? Alignment.centerLeft,
                  padding: EdgeInsets.only(left: paddingLeft),
                  child: SizedBox(
                    width: availableWidth,
                    child: cells[index],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Definition for a table column
class CustomTableColumn {
  final String headerText;
  final double width;
  final Alignment? alignment;

  const CustomTableColumn({
    required this.headerText,
    required this.width,
    this.alignment,
  });
}






