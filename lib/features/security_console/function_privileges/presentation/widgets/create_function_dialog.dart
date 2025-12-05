import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';

class CreateFunctionDialog extends StatefulWidget {
  const CreateFunctionDialog({super.key});

  @override
  State<CreateFunctionDialog> createState() => _CreateFunctionDialogState();
}

class _CreateFunctionDialogState extends State<CreateFunctionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedModule;
  String _selectedAccessType = 'View';
  String _selectedStatus = 'Active';

  bool _isLoading = false;
  bool _moduleError = false;

  final List<String> _modules = [
    'General Ledger',
    'Accounts Payable',
    'Accounts Receivable',
    'Cash Management',
    'Fixed Assets',
    'Expense Management',
    'Security',
    'Financial Reporting',
  ];

  final List<String> _accessTypes = ['View', 'Execute', 'Full'];
  final List<String> _statuses = ['Active', 'Inactive'];

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    setState(() {
      _moduleError = _selectedModule == null;
    });

    if (_formKey.currentState!.validate() && _selectedModule != null) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop({
            'code': _codeController.text,
            'name': _nameController.text,
            'module': _selectedModule,
            'category': _categoryController.text,
            'accessType': _selectedAccessType,
            'status': _selectedStatus,
            'description': _descriptionController.text,
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
                  const SizedBox(height: 28),
                  _buildTwoColumnRow(
                    _buildFunctionCodeField(isDark),
                    _buildFunctionNameField(isDark),
                    isMobile,
                  ),
                  const SizedBox(height: 26),
                  _buildTwoColumnRow(
                    _buildModuleField(isDark),
                    _buildCategoryField(isDark),
                    isMobile,
                  ),
                  const SizedBox(height: 26),
                  _buildTwoColumnRow(
                    _buildAccessTypeField(isDark),
                    _buildStatusField(isDark),
                    isMobile,
                  ),
                  const SizedBox(height: 26),
                  _buildDescriptionField(isDark),
                  const SizedBox(height: 46),
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
                'Create New Function',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17.3,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                  height: 1.04,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Define a new system function',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.6,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF717182),
                  height: 1.47,
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

  Widget _buildFunctionCodeField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Function Code', true, isDark),
        const SizedBox(height: 6),
        Container(
          height: 42,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DC)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: _codeController,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.8,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              hintText: 'e.g., GL_JOURNAL_CREATE',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.8,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10.5,
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

  Widget _buildFunctionNameField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Function Name', true, isDark),
        const SizedBox(height: 6),
        Container(
          height: 42,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DC)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: _nameController,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.3,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              hintText: 'e.g., Create Journal Entry',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.3,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10.5,
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
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Select Module',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.3,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                    height: 1.24,
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
              items: _modules.map((String module) {
                return DropdownMenuItem<String>(
                  value: module,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
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

  Widget _buildCategoryField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Category', true, isDark),
        const SizedBox(height: 6),
        Container(
          height: 42,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DC)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: _categoryController,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.3,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              hintText: 'e.g., Journal Management',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.3,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10.5,
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

  Widget _buildAccessTypeField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Access Type', true, isDark),
        const SizedBox(height: 6),
        Container(
          height: 39,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DC)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedAccessType,
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
                height: 1.26,
              ),
              items: _accessTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(type),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAccessType = value!;
                });
              },
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
                height: 1.26,
              ),
              items: _statuses.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
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

  Widget _buildDescriptionField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Description', false, isDark),
        const SizedBox(height: 6),
        Container(
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DC)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.4,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
              height: 1.56,
            ),
            decoration: InputDecoration(
              hintText: 'Enter function description...',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.4,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                height: 1.56,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, bool required, bool isDark) {
    return Text.rich(
      TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.6,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : const Color(0xFF364153),
          height: 1.47,
        ),
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Color(0xFFFB2C36),
              ),
            ),
        ],
      ),
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
            height: 1.46,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: 161.21,
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
                    'Create Function',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.8,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

