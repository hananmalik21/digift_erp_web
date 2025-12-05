import 'package:flutter/material.dart';
import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/theme/theme_extensions.dart';

class AddRoleToHierarchyDialog extends StatefulWidget {
  final String? parentRoleCode;
  final String? parentRoleName;

  const AddRoleToHierarchyDialog({
    super.key,
    this.parentRoleCode,
    this.parentRoleName,
  });

  @override
  State<AddRoleToHierarchyDialog> createState() => _AddRoleToHierarchyDialogState();
}

class _AddRoleToHierarchyDialogState extends State<AddRoleToHierarchyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _roleNameController = TextEditingController();
  final _roleCodeController = TextEditingController();
  
  String? _selectedType;
  bool _isLoading = false;
  bool _showDropdownError = false;

  final List<String> _roleTypes = ['Job Role', 'Duty Role', 'Privilege'];

  @override
  void dispose() {
    _roleNameController.dispose();
    _roleCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleAddRole() async {
    setState(() => _showDropdownError = true);

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_selectedType == null) {
      // Show error for dropdown
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pop({
        'roleName': _roleNameController.text,
        'roleCode': _roleCodeController.text,
        'roleType': _selectedType,
        'parentRole': widget.parentRoleCode,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isMobile ? 16 : 40),
      child: Container(
        width: isMobile ? double.infinity : 536,
        constraints: BoxConstraints(
          maxWidth: 536,
          maxHeight: size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.1),
          ),
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
            _buildHeader(context, l10n, isDark),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 16 : 24,
                  0,
                  isMobile ? 16 : 24,
                  isMobile ? 16 : 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildParentRoleField(l10n, isDark),
                      const SizedBox(height: 30),
                      _buildRoleNameField(l10n, isDark),
                      const SizedBox(height: 30),
                      _buildRoleCodeField(l10n, isDark),
                      const SizedBox(height: 30),
                      _buildRoleTypeField(l10n, isDark),
                      const SizedBox(height: 30),
                      _buildFooter(context, l10n, isDark, isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.addRoleToHierarchy,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17.4,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172B),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.close,
              size: 16,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentRoleField(AppLocalizations l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.parentRole,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.75),
          decoration: BoxDecoration(
            color: isDark 
                ? const Color(0xFF374151)
                : const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.parentRoleCode ?? 'Root Level',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.8,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleNameField(AppLocalizations l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: l10n.roleName,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          child: TextFormField(
            controller: _roleNameController,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              hintText: l10n.enterRoleName,
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF6B7280) : const Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.75),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.fieldRequired;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCodeField(AppLocalizations l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: l10n.roleCode,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          child: TextFormField(
            controller: _roleCodeController,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            decoration: InputDecoration(
              hintText: 'Enter role code',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF6B7280) : const Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.75),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.fieldRequired;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoleTypeField(AppLocalizations l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: l10n.roleType,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF0F172B),
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 39,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? context.themeCardBackground : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              hint: Text(
                l10n.selectType,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF0F172B),
                ),
              ),
              items: _roleTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.3,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : const Color(0xFF0F172B),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue;
                  _showDropdownError = false;
                });
              },
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
        if (_selectedType == null && _showDropdownError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              l10n.fieldRequired,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l10n, bool isDark, bool isMobile) {
    if (isMobile) {
      return Row(
        children: [
          Expanded(
            child: _buildCancelButton(context, l10n, isDark),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildAddButton(context, l10n, isDark),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildCancelButton(context, l10n, isDark),
        const SizedBox(width: 8),
        _buildAddButton(context, l10n, isDark),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context, AppLocalizations l10n, bool isDark) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return SizedBox(
      width: isMobile ? null : 79.35,
      height: 36,
      child: OutlinedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.white : const Color(0xFF0F172B),
          backgroundColor: isDark ? context.themeCardBackground : Colors.white,
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          l10n.cancel,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF0F172B),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, AppLocalizations l10n, bool isDark) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return SizedBox(
      width: isMobile ? null : 90.87,
      height: 36,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleAddRole,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF030213),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF030213).withValues(alpha: 0.6),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
                l10n.addRole,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.7,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

