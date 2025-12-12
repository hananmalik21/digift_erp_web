import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../data/models/job_role_model.dart';
import '../../data/models/job_role_dto.dart';
import '../../data/datasources/job_role_remote_datasource.dart';
import '../services/job_role_dialog_service.dart';

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
  List<DutyRoleReference> _availableDutyRoles = [];
  List<DutyRoleReference> _selectedDutyRoles = [];
  List<DutyRoleReference> _filteredDutyRoles = [];
  int _selectedJobRoles = 0;
  int _totalPrivileges = 0;

  bool _isLoading = false;
  bool _isLoadingDutyRoles = false;
  String? _dutyRolesError;

  final List<String> _statuses = ['Active', 'Inactive'];
  late final JobRoleDialogService _dialogService;

  @override
  void initState() {
    super.initState();
    final dataSource = JobRoleRemoteDataSourceImpl();
    _dialogService = JobRoleDialogService(dataSource);
    
    if (widget.jobRole != null) {
      _nameController.text = widget.jobRole!.name;
      _codeController.text = widget.jobRole!.code;
      _descriptionController.text = widget.jobRole!.description;
      _departmentController.text = widget.jobRole!.department;
      _selectedStatus = widget.jobRole!.status;
      _selectedJobRoles = widget.jobRole!.inheritsFrom?.length ?? 0;
      _totalPrivileges = widget.jobRole!.privilegesCount;
    }
    
    _loadDutyRoles();
    _dutyRoleSearchController.addListener(_filterDutyRoles);
  }

  Future<void> _loadDutyRoles() async {
    setState(() {
      _isLoadingDutyRoles = true;
      _dutyRolesError = null;
    });

    try {
      final dutyRoles = await _dialogService.loadDutyRoles();
      setState(() {
        _availableDutyRoles = dutyRoles;
        _filteredDutyRoles = dutyRoles;
        
        // If editing, try to match existing duty roles
        if (widget.jobRole != null) {
          _matchExistingDutyRoles();
        }
      });
    } catch (e) {
      setState(() {
        _dutyRolesError = e.toString();
      });
    } finally {
      setState(() {
        _isLoadingDutyRoles = false;
      });
    }
  }

  void _matchExistingDutyRoles() {
    if (widget.jobRole == null) return;
    
    // Try to match duty role names from the job role
    final existingDutyRoleNames = widget.jobRole!.dutyRoles;
    final matched = <DutyRoleReference>[];
    
    for (final name in existingDutyRoleNames) {
      final matchedRole = _availableDutyRoles.firstWhere(
        (dr) => dr.dutyRoleName.toLowerCase().trim() == name.toLowerCase().trim(),
        orElse: () => _availableDutyRoles.firstWhere(
          (dr) => dr.dutyRoleName.toLowerCase().contains(name.toLowerCase().trim()) ||
                 name.toLowerCase().trim().contains(dr.dutyRoleName.toLowerCase()),
          orElse: () => DutyRoleReference(dutyRoleId: 0, dutyRoleName: name, roleCode: ''),
        ),
      );
      
      if (matchedRole.dutyRoleId > 0 && !matched.any((dr) => dr.dutyRoleId == matchedRole.dutyRoleId)) {
        matched.add(matchedRole);
      }
    }
    
    setState(() {
      _selectedDutyRoles = matched;
    });
  }

  void _filterDutyRoles() {
    final query = _dutyRoleSearchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredDutyRoles = _availableDutyRoles;
      } else {
        _filteredDutyRoles = _availableDutyRoles.where((dr) {
          return dr.dutyRoleName.toLowerCase().contains(query) ||
                 dr.roleCode.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _toggleDutyRoleSelection(DutyRoleReference dutyRole) {
    setState(() {
      if (_selectedDutyRoles.any((dr) => dr.dutyRoleId == dutyRole.dutyRoleId)) {
        _selectedDutyRoles.removeWhere((dr) => dr.dutyRoleId == dutyRole.dutyRoleId);
      } else {
        _selectedDutyRoles.add(dutyRole);
      }
    });
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

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedDutyRoles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one duty role'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dutyRolesArray = _selectedDutyRoles.map((dr) => dr.dutyRoleId).toList();
      final status = _selectedStatus; // API expects "Active" or "Inactive"
      
      JobRoleModel? result;
      
      if (widget.jobRole != null) {
        // Update existing job role
        final jobRoleId = int.tryParse(widget.jobRole!.id) ?? 0;
        result = await _dialogService.updateJobRole(
          jobRoleId: jobRoleId,
          jobRoleCode: _codeController.text.trim(),
          jobRoleName: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty 
              ? null 
              : _descriptionController.text.trim(),
          department: _departmentController.text.trim().isEmpty 
              ? null 
              : _departmentController.text.trim(),
          status: status,
          isSystemRole: 'N',
          dutyRolesArray: dutyRolesArray,
          updatedBy: 'ADMIN',
          selectedDutyRoles: _selectedDutyRoles,
          originalRole: widget.jobRole,
        );
      } else {
        // Create new job role
        result = await _dialogService.createJobRole(
          jobRoleCode: _codeController.text.trim(),
          jobRoleName: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty 
              ? null 
              : _descriptionController.text.trim(),
          department: _departmentController.text.trim().isEmpty 
              ? null 
              : _departmentController.text.trim(),
          status: status,
          isSystemRole: 'N',
          dutyRolesArray: dutyRolesArray,
          createdBy: 'ADMIN',
          selectedDutyRoles: _selectedDutyRoles,
        );
      }

      if (mounted && result != null) {
        Navigator.of(context).pop(result); // Return the created/updated job role
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                  '${_selectedDutyRoles.length} selected',
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
          // Selected duty roles chips
          if (_selectedDutyRoles.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedDutyRoles.map((dr) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F5FF),
                    border: Border.all(color: const Color(0xFFE9D4FF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dr.dutyRoleName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8200DB),
                          height: 1.33,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _toggleDutyRoleSelection(dr),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Color(0xFF8200DB),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 10),
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
          const SizedBox(height: 16),
          // Duty roles list
          if (_isLoadingDutyRoles)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_dutyRolesError != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading duty roles: $_dutyRolesError',
                style: const TextStyle(color: Colors.red),
              ),
            )
          else if (_filteredDutyRoles.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No duty roles found',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.6,
                  color: Color(0xFF717182),
                ),
              ),
            )
          else
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredDutyRoles.length,
                itemBuilder: (context, index) {
                  final dutyRole = _filteredDutyRoles[index];
                  final isSelected = _selectedDutyRoles.any(
                    (dr) => dr.dutyRoleId == dutyRole.dutyRoleId,
                  );
                  
                  return InkWell(
                    onTap: () => _toggleDutyRoleSelection(dutyRole),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFFF9F5FF) 
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                            size: 20,
                            color: isSelected 
                                ? const Color(0xFF8200DB) 
                                : const Color(0xFF717182),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dutyRole.dutyRoleName,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13.6,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF0F172B),
                                  ),
                                ),
                                Text(
                                  dutyRole.roleCode,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF717182),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                child: _buildSummaryItem('Duty Roles', '${_selectedDutyRoles.length}'),
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



