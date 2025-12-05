import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';

class CreatePrivilegeDialog extends StatefulWidget {
  const CreatePrivilegeDialog({super.key});

  @override
  State<CreatePrivilegeDialog> createState() => _CreatePrivilegeDialogState();
}

class _CreatePrivilegeDialogState extends State<CreatePrivilegeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _functionController = TextEditingController();

  String? _selectedModule;
  String? _selectedOperation;
  String _selectedStatus = 'Active';

  bool _isLoading = false;
  bool _moduleError = false;
  bool _operationError = false;

  final List<String> _modules = [
    'General Ledger',
    'Accounts Payable',
    'Accounts Receivable',
    'Cash Management',
    'Fixed Assets',
  ];

  final List<String> _operations = [
    'Create',
    'Read',
    'Update',
    'Delete',
    'Post',
    'Approve',
    'Export',
  ];

  final List<String> _statuses = ['Active', 'Inactive'];

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _functionController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    setState(() {
      _moduleError = _selectedModule == null;
      _operationError = _selectedOperation == null;
    });

    if (_formKey.currentState!.validate() &&
        _selectedModule != null &&
        _selectedOperation != null) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop({
            'code': _codeController.text,
            'name': _nameController.text,
            'description': _descriptionController.text,
            'module': _selectedModule,
            'function': _functionController.text,
            'operation': _selectedOperation,
            'status': _selectedStatus,
          });
        }
      });
    }
  }

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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context, isDark),
                  const SizedBox(height: 20),
                  _buildTwoColumnRow(
                    _buildPrivilegeCodeField(isDark),
                    _buildPrivilegeNameField(isDark),
                    isMobile,
                  ),
                  const SizedBox(height: 30),
                  _buildDescriptionField(isDark),
                  const SizedBox(height: 26),
                  _buildTwoColumnRow(
                    _buildModuleField(isDark),
                    _buildFunctionField(isDark),
                    isMobile,
                  ),
                  const SizedBox(height: 28),
                  _buildTwoColumnRow(
                    _buildOperationField(isDark),
                    _buildStatusField(isDark),
                    isMobile,
                  ),
                  const SizedBox(height: 40),
                  _buildButtons(context, isDark, isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Function Privilege',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17.3,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                  height: 1.04, // 18px / 17.3px
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Define a new function privilege',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.6,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF717182),
                  height: 1.47, // 20px / 13.6px
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, size: 16),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: isDark ? Colors.white : const Color(0xFF0F172B),
        ),
      ],
    );
  }

  Widget _buildTwoColumnRow(Widget left, Widget right, bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          left,
          const SizedBox(height: 24),
          right,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 24),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildPrivilegeCodeField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Privilege Code', true, isDark),
        const SizedBox(height: 6),
        SizedBox(
          height: 36,
          child: TextFormField(
            controller: _codeController,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              hintText: 'e.g., GL_JE_CREATE',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF717182),
              ),
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFF3F3F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF155DFC)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFFB2C36)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFFB2C36)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8.75,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPrivilegeNameField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Privilege Name', true, isDark),
        const SizedBox(height: 6),
        SizedBox(
          height: 36,
          child: TextFormField(
            controller: _nameController,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              hintText: 'e.g., Create Journal Entry',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF717182),
              ),
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFF3F3F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF155DFC)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFFB2C36)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFFB2C36)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8.75,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Description', false, isDark),
        const SizedBox(height: 6),
        Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DC)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: null,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.3,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              hintText: 'Enter privilege description...',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.3,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModuleField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Module', true, isDark),
        const SizedBox(height: 6),
        Container(
          height: 39,
          decoration: BoxDecoration(
            border: Border.all(
              color: _moduleError
                  ? const Color(0xFFFB2C36)
                  : const Color(0xFFD1D5DC),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedModule,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Select module',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.4,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                    height: 1.23, // 19px / 15.4px
                  ),
                ),
              ),
              icon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.keyboard_arrow_down, size: 20),
              ),
              dropdownColor:
                  isDark ? context.themeCardBackground : Colors.white,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.4,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : const Color(0xFF0F172B),
                height: 1.23,
              ),
              items: _modules.map((String module) {
                return DropdownMenuItem<String>(
                  value: module,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(module),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedModule = value;
                  _moduleError = false;
                });
              },
            ),
          ),
        ),
        if (_moduleError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              'Required',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFFB2C36),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFunctionField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Function', true, isDark),
        const SizedBox(height: 6),
        SizedBox(
          height: 36,
          child: TextFormField(
            controller: _functionController,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              hintText: 'e.g., Journal Entry',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF717182),
              ),
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFF3F3F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF155DFC)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFFB2C36)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFFB2C36)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8.75,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOperationField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Operation', true, isDark),
        const SizedBox(height: 6),
        Container(
          height: 39,
          decoration: BoxDecoration(
            border: Border.all(
              color: _operationError
                  ? const Color(0xFFFB2C36)
                  : const Color(0xFFD1D5DC),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedOperation,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Select operation',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.3,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                    height: 1.24, // 19px / 15.3px
                  ),
                ),
              ),
              icon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.keyboard_arrow_down, size: 20),
              ),
              dropdownColor:
                  isDark ? context.themeCardBackground : Colors.white,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.3,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : const Color(0xFF0F172B),
                height: 1.24,
              ),
              items: _operations.map((String operation) {
                return DropdownMenuItem<String>(
                  value: operation,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(operation),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOperation = value;
                  _operationError = false;
                });
              },
            ),
          ),
        ),
        if (_operationError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              'Required',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFFB2C36),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Status', true, isDark),
        const SizedBox(height: 6),
        Container(
          height: 39,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DC)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedStatus,
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.keyboard_arrow_down, size: 20),
              ),
              dropdownColor:
                  isDark ? context.themeCardBackground : Colors.white,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.1,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : const Color(0xFF0F172B),
                height: 1.26, // 19px / 15.1px
              ),
              items: _statuses.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(status),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, bool required, bool isDark) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
            height: 1.01, // 14px / 13.8px
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFB2C36),
              height: 1.0,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildButtons(BuildContext context, bool isDark, bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 36,
            child: _buildCreateButton(context, isDark),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: _buildCancelButton(context, isDark),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildCancelButton(context, isDark),
        const SizedBox(width: 8),
        _buildCreateButton(context, isDark),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 79.35,
      height: 36,
      child: OutlinedButton(
        onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? context.themeCardBackground : Colors.white,
          foregroundColor: isDark ? Colors.white : const Color(0xFF0F172B),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
            height: 1.46, // 20px / 13.7px
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 160.8,
      height: 36,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleCreate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF030213),
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.icons.addIcon.path,
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Create Privilege',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.8,
                      fontWeight: FontWeight.w500,
                      height: 1.45, // 20px / 13.8px
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

