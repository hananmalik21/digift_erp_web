import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../gen/assets.gen.dart';

class PrivilegeRow {
  final TextEditingController moduleController;
  final TextEditingController functionController;
  String accessLevel;

  PrivilegeRow({
    String? module,
    String? function,
    this.accessLevel = 'Full Access',
  })  : moduleController = TextEditingController(text: module ?? ''),
        functionController = TextEditingController(text: function ?? '');

  void dispose() {
    moduleController.dispose();
    functionController.dispose();
  }
}

class CreateEditRoleScreen extends StatefulWidget {
  const CreateEditRoleScreen({super.key});

  @override
  State<CreateEditRoleScreen> createState() => _CreateEditRoleScreenState();
}

class _CreateEditRoleScreenState extends State<CreateEditRoleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roleNameController = TextEditingController();
  final _roleCodeController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _roleType = 'Duty Role';
  String _category = 'General Ledger';
  String _status = 'Active';

  DateTime? _startDate;
  DateTime? _endDate;

  final List<PrivilegeRow> _privileges = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with sample data for "Edit" mode
    _roleNameController.text = 'Accounting Manager';
    _roleCodeController.text = 'acc001';
    _startDate = DateTime(2025, 1, 1);

    // Add one initial privilege
    _privileges.add(PrivilegeRow(
      module: 'General Ledger',
      function: '',
    ));
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    _roleCodeController.dispose();
    _descriptionController.dispose();
    for (var privilege in _privileges) {
      privilege.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _addPrivilege() {
    setState(() {
      _privileges.add(PrivilegeRow());
    });
  }

  void _removePrivilege(int index) {
    setState(() {
      _privileges[index].dispose();
      _privileges.removeAt(index);
    });
  }

  Future<void> _saveRole() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate save operation
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Role saved successfully!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 900;

    return Scaffold(
      backgroundColor:
          isDark ? context.themeBackground : const Color(0xFFF9FAFB),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, l10n, isDark, isMobile),
              const SizedBox(height: 24),
              _buildRoleInformationCard(context, l10n, isDark, isMobile, isTablet),
              const SizedBox(height: 24),
              _buildRolePrivilegesCard(context, l10n, isDark, isMobile),
              const SizedBox(height: 24),
              _buildFooter(context, l10n, isDark, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          Assets.icons.securityConsoleIcon.path,
          width: 32,
          height: 32,
          colorFilter: const ColorFilter.mode(
            Color(0xFF9810FA),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Role',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Modify role details and privileges',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF4A5565),
                ),
              ),
            ],
          ),
        ),
        if (!isMobile) ...[
          const SizedBox(width: 16),
          _buildBackButton(context, isDark),
        ],
      ],
    );
  }

  Widget _buildBackButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back,
              size: 16,
              color: isDark ? Colors.white : const Color(0xFF0A0A0A),
            ),
            const SizedBox(width: 8),
            Text(
              'Back to Roles',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.8,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF0A0A0A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleInformationCard(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                Assets.icons.securityConsoleIcon.path,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  Color(0xFF9810FA),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Role Information',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Role Name and Role Code
          if (isMobile)
            Column(
              children: [
                _buildTextField(
                  context: context,
                  controller: _roleNameController,
                  label: 'Role Name',
                  hintText: 'Accounting Manager',
                  isRequired: true,
                  isDark: isDark,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter role name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  context: context,
                  controller: _roleCodeController,
                  label: 'Role Code',
                  hintText: 'acc001',
                  isRequired: true,
                  isDark: isDark,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter role code';
                    }
                    return null;
                  },
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    context: context,
                    controller: _roleNameController,
                    label: 'Role Name',
                    hintText: 'Accounting Manager',
                    isRequired: true,
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter role name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(
                    context: context,
                    controller: _roleCodeController,
                    label: 'Role Code',
                    hintText: 'acc001',
                    isRequired: true,
                    isDark: isDark,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter role code';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Role Type and Category
          if (isMobile)
            Column(
              children: [
                _buildDropdownField(context, 'Role Type', _roleType, ['Job Role', 'Duty Role'], isDark, (value) {
                  setState(() => _roleType = value!);
                }, isRequired: true),
                const SizedBox(height: 16),
                _buildDropdownField(context, 'Category', _category, ['General Ledger', 'Accounts Payable', 'Accounts Receivable'], isDark, (value) {
                  setState(() => _category = value!);
                }, isRequired: true),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(context, 'Role Type', _roleType, ['Job Role', 'Duty Role'], isDark, (value) {
                    setState(() => _roleType = value!);
                  }, isRequired: true),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildDropdownField(context, 'Category', _category, ['General Ledger', 'Accounts Payable', 'Accounts Receivable'], isDark, (value) {
                    setState(() => _category = value!);
                  }, isRequired: true),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Description
          _buildTextField(
            context: context,
            controller: _descriptionController,
            label: 'Description',
            hintText: 'Enter role description...',
            isRequired: false,
            isDark: isDark,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          // Status, Start Date, End Date
          if (isMobile)
            Column(
              children: [
                _buildDropdownField(context, 'Status', _status, ['Active', 'Inactive'], isDark, (value) {
                  setState(() => _status = value!);
                }, isRequired: true),
                const SizedBox(height: 16),
                _buildDateField(context, 'Start Date', _startDate, true, isDark, isRequired: true),
                const SizedBox(height: 16),
                _buildDateField(context, 'End Date', _endDate, false, isDark, isRequired: false),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(context, 'Status', _status, ['Active', 'Inactive'], isDark, (value) {
                    setState(() => _status = value!);
                  }, isRequired: true),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(context, 'Start Date', _startDate, true, isDark, isRequired: true),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(context, 'End Date', _endDate, false, isDark, isRequired: false),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF374151),
            ),
          ),
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFFEF4444),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool isDark,
    bool isRequired = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired: isRequired),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: Color(0xFF9CA3AF),
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 12 : 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF155DFC),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    String label,
    String value,
    List<String> items,
    bool isDark,
    ValueChanged<String?> onChanged,
    {bool isRequired = false}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired: isRequired),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            ),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: isDark ? const Color(0xFF1F2937) : Colors.white,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? date,
    bool isStartDate,
    bool isDark,
    {bool isRequired = false}
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired: isRequired),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context, isStartDate),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null
                        ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
                        : 'dd/mm/yyyy',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: date != null
                          ? (isDark ? Colors.white : const Color(0xFF111827))
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRolePrivilegesCard(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.securityConsoleIcon.path,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      isDark ? Colors.white : const Color(0xFF0A0A0A),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Role Privileges',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.3,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _addPrivilege,
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF030213),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Add Privilege',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.8,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          if (isMobile)
            _buildMobilePrivilegesView(context, isDark)
          else
            _buildTablePrivilegesView(context, isDark),
        ],
      ),
    );
  }

  Widget _buildTablePrivilegesView(BuildContext context, bool isDark) {
    return Column(
      children: [
        // Table Header
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark
                ? context.themeCardBackgroundGrey
                : const Color(0xFFF9FAFB),
            border: Border(
              bottom: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
            ),
          ),
          child: Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Module',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              const Expanded(
                flex: 3,
                child: Text(
                  'Function',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              const Expanded(
                flex: 2,
                child: Text(
                  'Access Level',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              const SizedBox(
                width: 60,
                child: Text(
                  'Actions',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Table Rows
        ..._privileges.asMap().entries.map((entry) {
          final index = entry.key;
          final privilege = entry.value;
          return _buildTableRow(context, index, privilege, isDark);
        }),
      ],
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    int index,
    PrivilegeRow privilege,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD1D5DC)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: privilege.moduleController.text.isEmpty
                    ? null
                    : privilege.moduleController.text,
                hint: const Text(
                  'Select module',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                isExpanded: true,
                underline: const SizedBox(),
                items: [
                  'General Ledger',
                  'Accounts Payable',
                  'Accounts Receivable',
                  'Fixed Assets',
                ].map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    privilege.moduleController.text = value ?? '';
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: TextField(
              controller: privilege.functionController,
              decoration: InputDecoration(
                hintText: 'e.g., Create Journal',
                hintStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DC)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF155DFC)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF0A0A0A),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD1D5DC)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: privilege.accessLevel,
                isExpanded: true,
                underline: const SizedBox(),
                items: [
                  'Full Access',
                  'Read Only',
                  'Limited Access',
                ].map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    privilege.accessLevel = value ?? 'Full Access';
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 60,
            child: IconButton(
              onPressed: () => _removePrivilege(index),
              icon: const Icon(
                Icons.delete_outline,
                size: 16,
                color: Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePrivilegesView(BuildContext context, bool isDark) {
    return Column(
      children: _privileges.asMap().entries.map((entry) {
        final index = entry.key;
        final privilege = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.themeBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privilege #${index + 1}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.themeTextPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removePrivilege(index),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                context,
                'Module *',
                privilege.moduleController.text.isEmpty
                    ? 'General Ledger'
                    : privilege.moduleController.text,
                ['General Ledger', 'Accounts Payable', 'Accounts Receivable', 'Fixed Assets'],
                isDark,
                (value) {
                  setState(() {
                    privilege.moduleController.text = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: privilege.functionController,
                labelText: 'Function *',
                hintText: 'e.g., Create Journal',
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                context,
                'Access Level *',
                privilege.accessLevel,
                ['Full Access', 'Read Only', 'Limited Access'],
                isDark,
                (value) {
                  setState(() {
                    privilege.accessLevel = value ?? 'Full Access';
                  });
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    bool isMobile,
  ) {
    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      decoration: BoxDecoration(
        color: isDark ? context.themeCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? context.themeCardBackground : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.close,
                    size: 16,
                    color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.8,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF0A0A0A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _isLoading ? null : _saveRole,
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _isLoading
                    ? const Color(0xFF6B7280)
                    : const Color(0xFF030213),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    const Icon(
                      Icons.save,
                      size: 16,
                      color: Colors.white,
                    ),
                  const SizedBox(width: 8),
                  const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.8,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
