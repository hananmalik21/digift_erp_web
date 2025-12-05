import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_extensions.dart';

class CreateEditPolicyDialog extends StatefulWidget {
  final Map<String, dynamic>? policy;

  const CreateEditPolicyDialog({super.key, this.policy});

  @override
  State<CreateEditPolicyDialog> createState() =>
      _CreateEditPolicyDialogState();
}

class _CreateEditPolicyDialogState extends State<CreateEditPolicyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedType;
  String? _selectedSeverity;
  String _selectedStatus = 'Draft';
  bool _enforceImmediately = false;

  bool _isLoading = false;
  bool _typeError = false;
  bool _severityError = false;

  final List<String> _types = [
    'Access Control',
    'Password Policy',
    'Data Security',
    'Audit Policy',
    'Session Management',
  ];

  final List<String> _severities = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  final List<String> _statuses = ['Draft', 'Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    if (widget.policy != null) {
      _nameController.text = widget.policy!['name'] ?? '';
      _codeController.text = widget.policy!['code'] ?? '';
      _descriptionController.text = widget.policy!['description'] ?? '';
      _selectedType = widget.policy!['category'];
      _selectedSeverity = widget.policy!['severity'];
      _selectedStatus = widget.policy!['status'] ?? 'Draft';
      _enforceImmediately = widget.policy!['enforced'] ?? false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    setState(() {
      _typeError = _selectedType == null;
      _severityError = _selectedSeverity == null;
    });

    if (_formKey.currentState!.validate() &&
        _selectedType != null &&
        _selectedSeverity != null) {
      setState(() => _isLoading = true);

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop({
            'name': _nameController.text,
            'code': _codeController.text,
            'description': _descriptionController.text,
            'type': _selectedType,
            'severity': _selectedSeverity,
            'status': _selectedStatus,
            'enforced': _enforceImmediately,
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
    final isEdit = widget.policy != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 24,
      ),
      child: Container(
        width: isMobile ? double.infinity : 510,
        constraints: BoxConstraints(
          maxHeight: size.height - 48,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, isDark, isEdit),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameField(isDark),
                      const SizedBox(height: 16),
                      _buildCodeField(isDark),
                      const SizedBox(height: 16),
                      _buildDescriptionField(isDark),
                      const SizedBox(height: 16),
                      _buildThreeColumnDropdowns(isDark),
                      const SizedBox(height: 24),
                      _buildEnforceSwitch(isDark),
                    ],
                  ),
                ),
              ),
            ),
            _buildFooter(context, isDark, isEdit),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, bool isEdit) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Policy' : 'Create New Policy',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17.3,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172B),
                    height: 1.04,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Define a new security policy to enforce organization-wide security\nstandards.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF717182),
                    height: 1.47,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close,
              size: 16,
              color: Color(0xFF0F172B),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Policy Name *',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172B),
            height: 1.02,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 36,
          child: TextFormField(
            controller: _nameController,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF3F3F5),
              hintText: 'Enter policy name',
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: Color(0xFF717182),
              ),
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
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
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

  Widget _buildCodeField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Policy Code *',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.6,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172B),
            height: 1.03,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 36,
          child: TextFormField(
            controller: _codeController,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF3F3F5),
              hintText: 'Enter policy code',
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: Color(0xFF717182),
              ),
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
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
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
        const Text(
          'Description',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172B),
            height: 1.01,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.3,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
              height: 1.57,
            ),
            decoration: InputDecoration(
              hintText: 'Enter policy description',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.3,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThreeColumnDropdowns(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildTypeField(isDark),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSeverityField(isDark),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatusField(isDark),
        ),
      ],
    );
  }

  Widget _buildTypeField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type *',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172B),
            height: 1.04,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 39,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: _typeError
                  ? const Color(0xFFFB2C36)
                  : Colors.black.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              hint: const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  'Select type',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.3,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0F172B),
                    height: 1.24,
                  ),
                ),
              ),
              icon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Color(0xFF6B7280),
                ),
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.3,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0F172B),
                height: 1.24,
              ),
              items: _types.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(type),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                  _typeError = false;
                });
              },
            ),
          ),
        ),
        if (_typeError)
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 12),
            child: Text(
              'Required',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFFFB2C36),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSeverityField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Severity *',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.6,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172B),
            height: 1.03,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 39,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: _severityError
                  ? const Color(0xFFFB2C36)
                  : Colors.black.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSeverity,
              isExpanded: true,
              hint: const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  'Select severity',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.3,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0F172B),
                    height: 1.24,
                  ),
                ),
              ),
              icon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Color(0xFF6B7280),
                ),
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.3,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0F172B),
                height: 1.24,
              ),
              items: _severities.map((String severity) {
                return DropdownMenuItem<String>(
                  value: severity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(severity),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSeverity = value;
                  _severityError = false;
                });
              },
            ),
          ),
        ),
        if (_severityError)
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 12),
            child: Text(
              'Required',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFFFB2C36),
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
        const Text(
          'Status *',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.6,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172B),
            height: 1.03,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 39,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedStatus,
              isExpanded: true,
              icon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Color(0xFF6B7280),
                ),
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.4,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0F172B),
                height: 1.23,
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

  Widget _buildEnforceSwitch(bool isDark) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: _enforceImmediately,
            onChanged: (value) {
              setState(() {
                _enforceImmediately = value;
              });
            },
            thumbColor: WidgetStateProperty.all(Colors.white),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFF155DFC);
              }
              return const Color(0xFFCBCED4);
            }),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Enforce this policy immediately',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172B),
            height: 1.01,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark, bool isEdit) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 79.35,
            height: 36,
            child: OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0F172B),
                side: BorderSide(
                  color: Colors.black.withValues(alpha: 0.1),
                ),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.7,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172B),
                  height: 1.46,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 119.29,
            height: 36,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSave,
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
                  : Text(
                      isEdit ? 'Update Policy' : 'Create Policy',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.7,
                        fontWeight: FontWeight.w500,
                        height: 1.46,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

