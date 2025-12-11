import 'package:digify_erp/core/widgets/paginated_module_dropdown.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/paginated_status_dropdown.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../data/models/function_privilege_model.dart';
import 'paginated_function_dropdown.dart';
import 'paginated_operation_dropdown.dart';

class CreatePrivilegeDialog extends StatefulWidget {
  final FunctionPrivilegeModel? privilege;

  final Future<void> Function({
  required String code,
  required String name,
  required String description,
  required int moduleId,
  required int functionId,
  required int operationId,
  required String status,
  required String createdBy,
  })? onCreate;

  final Future<void> Function({
  required String id,
  required String name,
  required String description,
  required int moduleId,
  required int functionId,
  required int operationId,
  required String status,
  required String updatedBy,
  })? onUpdate;

  const CreatePrivilegeDialog({
    super.key,
    this.privilege,
    this.onCreate,
    this.onUpdate,
  });

  @override
  State<CreatePrivilegeDialog> createState() => _CreatePrivilegeDialogState();
}

class _CreatePrivilegeDialogState extends State<CreatePrivilegeDialog> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedModule;
  int? _selectedModuleId;

  String? _selectedFunction;
  int? _selectedFunctionId;

  String? _selectedOperation;
  int? _selectedOperationId;

  String _selectedStatus = "Active";
  bool _isLoading = false;

  bool get isEditMode => widget.privilege != null;

  /// ✅ Button enabled ONLY when everything is filled/selected
  bool get _isFormValid {
    return _codeController.text.trim().isNotEmpty &&
        _nameController.text.trim().isNotEmpty &&
        _selectedModuleId != null &&
        _selectedFunctionId != null &&
        _selectedOperationId != null &&
        _selectedStatus.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    if (isEditMode && widget.privilege != null) {
      final p = widget.privilege!;

      _codeController.text = p.code;
      _nameController.text = p.name;
      _descriptionController.text = p.description;

      // Pre-selected display names
      _selectedModule = p.module;
      _selectedFunction = p.function;
      _selectedOperation = p.operation;

      // Pre-selected IDs
      _selectedModuleId = p.moduleId;
      _selectedFunctionId = p.functionId;
      _selectedOperationId = p.operationId;

      _selectedStatus = p.status == "ACTIVE" ? "Active" : "Inactive";
    }

    // Rebuild on text change to refresh button state
    _codeController.addListener(() {
      if (mounted) setState(() {});
    });
    _nameController.addListener(() {
      if (mounted) setState(() {});
    });
    _descriptionController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);
    final status = _selectedStatus == "Active" ? "ACTIVE" : "INACTIVE";

    try {
      if (isEditMode && widget.onUpdate != null) {
        await widget.onUpdate!(
          id: widget.privilege!.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          moduleId: _selectedModuleId!,
          functionId: _selectedFunctionId!,
          operationId: _selectedOperationId!,
          status: status,
          updatedBy: "ADMIN",
        );
      } else if (widget.onCreate != null) {
        await widget.onCreate!(
          code: _codeController.text.trim(),
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          moduleId: _selectedModuleId!,
          functionId: _selectedFunctionId!,
          operationId: _selectedOperationId!,
          status: status,
          createdBy: "ADMIN",
        );
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // UI SECTION  (Design kept as-is)
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 24,
      ),
      child: Container(
        width: isMobile ? double.infinity : 518,
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(isDark),
                const SizedBox(height: 20),

                _row(
                  _codeField(isDark),
                  _nameField(isDark),
                  isMobile,
                ),
                const SizedBox(height: 30),

                _descriptionField(isDark),
                const SizedBox(height: 26),

                _row(
                  _moduleDropdown(isDark),
                  _functionDropdown(isDark),
                  isMobile,
                ),
                const SizedBox(height: 28),

                _row(
                  _operationDropdown(isDark),
                  _statusDropdown(isDark),
                  isMobile,
                ),
                const SizedBox(height: 40),

                _buttons(context, isDark, isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI COMPONENTS
  // ---------------------------------------------------------------------------

  Widget _header(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditMode
                    ? "Edit Function Privilege"
                    : "Create New Function Privilege",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 17.3,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isEditMode
                    ? "Update function privilege details"
                    : "Define a new function privilege",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 13.6,
                  color: isDark ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, size: 16),
        ),
      ],
    );
  }

  Widget _row(Widget left, Widget right, bool isMobile) {
    return isMobile
        ? Column(
      children: [
        left,
        const SizedBox(height: 24),
        right,
      ],
    )
        : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 24),
        Expanded(child: right),
      ],
    );
  }

  Widget _codeField(bool isDark) {
    return IgnorePointer(
      ignoring: isEditMode, // read-only in edit mode
      child: Opacity(
        opacity: isEditMode ? 0.6 : 1.0,
        child: CustomTextField(
          controller: _codeController,
          labelText: "Privilege Code",
          isRequired: true,
          hintText: "e.g., GL_JE_CREATE",
          height: 36,
        ),
      ),
    );
  }

  Widget _nameField(bool isDark) {
    return CustomTextField(
      controller: _nameController,
      labelText: "Privilege Name",
      isRequired: true,
      hintText: "e.g., Create Journal Entry",
      height: 36,
    );
  }

  Widget _descriptionField(bool isDark) {
    return CustomTextField(
      controller: _descriptionController,
      labelText: "Description",
      hintText: "Enter privilege description...",
      height: 80,
      maxLines: 4,
    );
  }

  Widget _moduleDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Module", true),
        const SizedBox(height: 6),
        PaginatedModuleDropdown(
          selectedModule: _selectedModule,
          selectedModuleId: _selectedModuleId,
          onChanged: (name, id) {
            setState(() {
              _selectedModule = name;
              _selectedModuleId = id;
            });
          },
          isDark: isDark,
          height: 39,
        ),
      ],
    );
  }

  Widget _functionDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Function", true),
        const SizedBox(height: 6),
        PaginatedFunctionDropdown(
          selectedFunction: _selectedFunction,
          selectedFunctionId: _selectedFunctionId?.toString(),
          onChanged: (name, id) {
            setState(() {
              _selectedFunction = name;
              _selectedFunctionId = id == null ? null : int.parse(id);
            });
          },
          isDark: isDark,
          height: 39,
        ),
      ],
    );
  }

  Widget _operationDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Operation", true),
        const SizedBox(height: 6),
        PaginatedOperationDropdown(
          selectedOperation: _selectedOperation,
          selectedOperationId: _selectedOperationId,
          onChanged: (name, id) {
            setState(() {
              _selectedOperation = name;
              _selectedOperationId = id;
            });
          },
          isDark: isDark,
          height: 39,
        ),
      ],
    );
  }

  Widget _statusDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Status", true),
        const SizedBox(height: 6),
        PaginatedStatusDropdown(
          selectedStatus: _selectedStatus,
          isDark: isDark,
          height: 39,
          enableSearch: false,
          statuses: const ["Active", "Inactive"],
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedStatus = value);
            }
          },
        ),
      ],
    );
  }

  Widget _label(String text, bool required) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 13.8,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (required)
          const Text(
            " *",
            style: TextStyle(color: Color(0xFFFB2C36)),
          ),
      ],
    );
  }


  Widget _buttons(BuildContext ctx, bool isDark, bool isMobile) {
    // CREATE / UPDATE
    final createBtn = CustomButton(
      text: isEditMode ? "Update Privilege" : "Create Privilege",
      isEditMode: isEditMode,
      isDisabled: !_isFormValid || _isLoading,
      isLoading: _isLoading,
      onPressed: _handleSubmit,
      width: isMobile ? double.infinity : 160.8,
      height: 36,
      isPrimary: true,
    );

    // CANCEL
    final cancelBtn = CustomButton.outlined(
      text: "Cancel",
      onPressed: _isLoading ? null : () => Navigator.pop(ctx),
      width: isMobile ? double.infinity : 90,
      height: 36,
    );

    return isMobile
        ? Column(
      children: [
        createBtn,
        const SizedBox(height: 12),
        cancelBtn,
      ],
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        cancelBtn,
        const SizedBox(width: 8),
        createBtn,
      ],
    );
  }
}
