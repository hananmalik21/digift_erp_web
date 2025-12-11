import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/custom_status_cell.dart';
import '../../../../../core/widgets/custom_action_cell.dart';
import '../../../../../core/widgets/delete_confirmation_dialog.dart';
import '../../data/models/function_model.dart';
import '../providers/functions_provider.dart';
import 'functions_empty_state_widget.dart';
import 'create_function_dialog.dart';
import 'function_details_dialog.dart';

class FunctionsMobileList extends StatelessWidget {
  final bool isDark;
  final List<FunctionModel> functions;

  const FunctionsMobileList({
    super.key,
    required this.isDark,
    required this.functions,
  });

  @override
  Widget build(BuildContext context) {
    if (functions.isEmpty) {
      return FunctionsEmptyState(isDark: isDark);
    }

    return Column(
      children: functions
          .map(
            (function) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: FunctionsMobileCard(
                function: function,
                isDark: isDark,
              ),
            ),
          )
          .toList(),
    );
  }
}

class FunctionsMobileCard extends ConsumerWidget {
  final FunctionModel function;
  final bool isDark;

  const FunctionsMobileCard({
    super.key,
    required this.function,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            function.code,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.67,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            function.name,
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
            function.description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6A7282),
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
                    function.module,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.8,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : const Color(0xFF101828),
                    ),
                  ),
                ],
              ),
              CustomStatusCell(
                status: function.status,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      function.description,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.8,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6A7282),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${function.updatedDate} by ${function.updatedBy}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.8,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6A7282),
                      ),
                    ),
                  ],
                ),
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
        ],
      ),
    );
  }
}
