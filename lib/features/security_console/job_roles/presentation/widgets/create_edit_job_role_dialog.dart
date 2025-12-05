import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/job_role_model.dart';

class CreateEditJobRoleDialog extends StatefulWidget {
  final JobRoleModel? jobRole;

  const CreateEditJobRoleDialog({super.key, this.jobRole});

  @override
  State<CreateEditJobRoleDialog> createState() =>
      _CreateEditJobRoleDialogState();
}

class _CreateEditJobRoleDialogState extends State<CreateEditJobRoleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _dutyRoleSearchController = TextEditingController();
  final _jobRoleSearchController = TextEditingController();

  String _selectedStatus = 'Active';
  int _selectedDutyRoles = 0;
  int _selectedJobRoles = 0;
  int _totalPrivileges = 0;

  bool _isLoading = false;

  final List<String> _statuses = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    if (widget.jobRole != null) {
      _nameController.text = widget.jobRole!.name;
      _codeController.text = widget.jobRole!.code;
      _descriptionController.text = widget.jobRole!.description;
      _departmentController.text = widget.jobRole!.department;
      _selectedStatus = widget.jobRole!.status;
      _selectedDutyRoles = widget.jobRole!.dutyRoles.length;
      _selectedJobRoles = widget.jobRole!.inheritsFrom?.length ?? 0;
      _totalPrivileges = widget.jobRole!.privilegesCount;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _departmentController.dispose();
    _dutyRoleSearchController.dispose();
    _jobRoleSearchController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop({
            'name': _nameController.text,
            'code': _codeController.text,
            'description': _descriptionController.text,
            'department': _departmentController.text,
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
    final isEdit = widget.jobRole != null;

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
                      _buildBasicFields(isDark),
                      const SizedBox(height: 24),
                      _buildDutyRolesSection(isDark),
                      const SizedBox(height: 24),
                      _buildInheritFromSection(isDark),
                      const SizedBox(height: 24),
                      _buildSummarySection(isDark),
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
                  isEdit ? 'Edit Job Role' : 'Create Job Role',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17.4,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172B),
                    height: 1.03,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Compose job roles from duty roles and inherit permissions from other\njob roles',
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
            icon: const Icon(Icons.close, size: 16, color: Color(0xFF0F172B)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicFields(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildNameField(isDark),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCodeField(isDark),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDescriptionField(isDark),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildDepartmentField(isDark),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatusField(isDark),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNameField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Job Role Name *',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172B),
            height: 1.02,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _nameController,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
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
          'Job Role Code *',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F172B),
            height: 1.02,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _codeController,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.8,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
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
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(8),
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
              contentPadding: EdgeInsets.all(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Department',
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
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _departmentController,
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
                vertical: 8.75,
              ),
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
            border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(8),
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

  Widget _buildDutyRolesSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.icons.dutyRoleIcon.path,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF8200DB),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Duty Roles',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.4,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF0F172B),
                  height: 1.56,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_selectedDutyRoles selected',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F172B),
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F5FF),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Search Duty Roles',
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
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _dutyRoleSearchController,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0F172B),
              ),
              decoration: const InputDecoration(
                hintText: 'Type to search duty roles...',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.6,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF717182),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8.75,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInheritFromSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_tree_outlined,
                size: 20,
                color: const Color(0xFF155DFC),
              ),
              const SizedBox(width: 8),
              const Text(
                'Inherit from Job Roles',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF0F172B),
                  height: 1.57,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_selectedJobRoles selected',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F172B),
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Inherit all duty roles and privileges from existing job roles',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A5565),
              height: 1.47,
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Search Job Roles',
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
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _jobRoleSearchController,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0F172B),
              ),
              decoration: const InputDecoration(
                hintText: 'Type to search job roles...',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.7,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF717182),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8.75,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.summarize_outlined,
                size: 20,
                color: const Color(0xFF0F172B),
              ),
              const SizedBox(width: 8),
              const Text(
                'Summary',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.4,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF0F172B),
                  height: 1.24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem('Duty Roles', '$_selectedDutyRoles'),
              ),
              Expanded(
                child: _buildSummaryItem('Inherited Job Roles', '$_selectedJobRoles'),
              ),
              Expanded(
                child: _buildSummaryItem('Total Privileges', '$_totalPrivileges'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w400,
            color: Color(0xFF4A5565),
            height: 1.46,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Color(0xFF0F172B),
            height: 1.33,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark, bool isEdit) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
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
                side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
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
            width: 140.95,
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
                      isEdit ? 'Update Job Role' : 'Create Job Role',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.8,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

