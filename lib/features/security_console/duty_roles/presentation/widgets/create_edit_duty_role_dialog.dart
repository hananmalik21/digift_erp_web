import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/duty_role_model.dart';

class CreateEditDutyRoleDialog extends StatefulWidget {
  final DutyRoleModel? dutyRole;

  const CreateEditDutyRoleDialog({super.key, this.dutyRole});

  @override
  State<CreateEditDutyRoleDialog> createState() =>
      _CreateEditDutyRoleDialogState();
}

class _CreateEditDutyRoleDialogState extends State<CreateEditDutyRoleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _currentTabIndex = 0;
  String? _selectedModule;
  String _selectedStatus = 'Active';
  int _privilegesCount = 0;

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

  final List<String> _statuses = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    if (widget.dutyRole != null) {
      _nameController.text = widget.dutyRole!.name;
      _codeController.text = widget.dutyRole!.code;
      _descriptionController.text = widget.dutyRole!.description;
      _selectedModule = widget.dutyRole!.module;
      _selectedStatus = widget.dutyRole!.status;
      _privilegesCount = widget.dutyRole!.privileges.length;
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
      _moduleError = _selectedModule == null;
    });

    if (_formKey.currentState!.validate() && _selectedModule != null) {
      setState(() => _isLoading = true);

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop({
            'name': _nameController.text,
            'code': _codeController.text,
            'description': _descriptionController.text,
            'module': _selectedModule,
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
    final isEdit = widget.dutyRole != null;

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
          minHeight: 600,
        ),
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
        child: Column(
          children: [
            _buildHeader(context, isDark, isEdit),
            Expanded(
              child: Column(
                children: [
                  _buildTabs(context, isDark),
                  Expanded(
                    child: Container(
                      color: isDark
                          ? context.themeBackground
                          : const Color(0xFFF8FAFC),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: _currentTabIndex == 0
                            ? _buildBasicDetailsTab(context, isDark)
                            : _buildAssignPrivilegesTab(context, isDark),
                      ),
                    ),
                  ),
                ],
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.icons.dutyRoleIcon.path,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF155DFC),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Duty Role' : 'Create Duty Role',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.9,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172B),
                    height: 1.48,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEdit
                      ? 'Update duty role information and privilege assignments'
                      : 'Create a new duty role with privileges',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF45556C),
                    height: 1.47,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF0F172B)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context, bool isDark) {
    return Container(
      color: isDark ? context.themeBackground : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.all(24),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildTab(
                context,
                isDark,
                0,
                'Basic Details',
                Assets.icons.securityConsoleIcon.path,
              ),
            ),
            Expanded(
              child: _buildTab(
                context,
                isDark,
                1,
                'Assign Privileges',
                Assets.icons.keyIcon.path,
                badge: _privilegesCount > 0 ? '$_privilegesCount' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    bool isDark,
    int index,
    String label,
    String iconPath, {
    String? badge,
  }) {
    final isSelected = _currentTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Color(0xFF0F172B),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F172B),
                height: 1.45,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  border: Border.all(color: const Color(0xFFBEDBFF)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF193CB8),
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBasicDetailsTab(BuildContext context, bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            context,
            isDark,
            'Role Information',
            'Provide basic information about this duty role',
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildNameField(isDark),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildCodeField(isDark),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildDescriptionField(isDark),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildModuleField(isDark),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildStatusField(isDark),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoBox(isDark),
        ],
      ),
    );
  }

  Widget _buildAssignPrivilegesTab(BuildContext context, bool isDark) {
    return Center(
      child: Text(
        'Assign Privileges - Coming Soon',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.3,
          fontWeight: FontWeight.w400,
          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    bool isDark,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.icons.userManagementIcon.path,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF155DFC),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.4,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0F172B),
                    height: 1.56,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF45556C),
                    height: 1.47,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Duty Role Name', true, isDark),
        const SizedBox(height: 8),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            border: Border.all(color: const Color(0xFFCAD5E2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _nameController,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12.75,
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
        const SizedBox(height: 8),
        const Text(
          'Enter a descriptive name for the\nduty role',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.8,
            fontWeight: FontWeight.w400,
            color: Color(0xFF62748E),
            height: 1.36,
          ),
        ),
      ],
    );
  }

  Widget _buildCodeField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Role Code', true, isDark),
        const SizedBox(height: 8),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            border: Border.all(color: const Color(0xFFCAD5E2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _codeController,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12.75,
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
        const SizedBox(height: 8),
        const Text(
          'Unique code for system\nidentification',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.8,
            fontWeight: FontWeight.w400,
            color: Color(0xFF62748E),
            height: 1.36,
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
        const SizedBox(height: 8),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFCAD5E2)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.1,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
              height: 1.59,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Provide details about what this role does',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.8,
            fontWeight: FontWeight.w400,
            color: Color(0xFF62748E),
            height: 1.36,
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
        const SizedBox(height: 8),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: _moduleError
                  ? const Color(0xFFFB2C36)
                  : const Color(0xFFCAD5E2),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedModule,
              isExpanded: true,
              hint: const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Select Module',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.1,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0F172B),
                    height: 1.26,
                  ),
                ),
              ),
              icon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.keyboard_arrow_down, size: 20),
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.1,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0F172B),
                height: 1.26,
              ),
              items: _modules.map((String module) {
                return DropdownMenuItem<String>(
                  value: module,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
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
        const SizedBox(height: 8),
        const Text(
          'Primary functional module',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF62748E),
            height: 1.33,
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
        const SizedBox(height: 8),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFCAD5E2)),
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
              dropdownColor: Colors.white,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.1,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0F172B),
                height: 1.26,
              ),
              items: _statuses.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
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
        const SizedBox(height: 8),
        const Text(
          'Role availability status',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.8,
            fontWeight: FontWeight.w400,
            color: Color(0xFF62748E),
            height: 1.36,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: const Color(0xFFBEDBFF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: Color(0xFF1C398E),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'About Duty Roles',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C398E),
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Duty roles represent a set of privileges required to perform a specific business function. They are used to compose Job Roles and ensure consistent security assignments across your organization.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF193CB8),
                    height: 1.47,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, bool required, bool isDark) {
    return Text.rich(
      TextSpan(
        text: text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.8,
          fontWeight: FontWeight.w500,
          color: Color(0xFF0F172B),
          height: 1.45,
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

  Widget _buildFooter(BuildContext context, bool isDark, bool isEdit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          if (_privilegesCount > 0) ...[
            const Icon(
              Icons.check_circle_outline,
              size: 16,
              color: Color(0xFF45556C),
            ),
            const SizedBox(width: 8),
            Text(
              '$_privilegesCount privileges assigned',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: Color(0xFF45556C),
                height: 1.21,
              ),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: 95.35,
            height: 36,
            child: OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0F172B),
                side: const BorderSide(color: Color(0xFFCAD5E2)),
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
          const SizedBox(width: 12),
          SizedBox(
            width: 171.66,
            height: 36,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF155DFC),
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
                        const Icon(Icons.check_circle_outline, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          isEdit ? 'Update Duty Role' : 'Create Duty Role',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.8,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
