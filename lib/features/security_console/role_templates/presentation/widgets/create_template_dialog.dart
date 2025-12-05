import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_extensions.dart';

class CreateTemplateDialog extends StatefulWidget {
  const CreateTemplateDialog({super.key});

  @override
  State<CreateTemplateDialog> createState() => _CreateTemplateDialogState();
}

class _CreateTemplateDialogState extends State<CreateTemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _templateNameController = TextEditingController();
  final _templateCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedCategory;
  String? _selectedType;
  String _selectedStatus = 'Draft';
  
  bool _isLoading = false;
  bool _categoryTouched = false;
  bool _typeTouched = false;

  @override
  void dispose() {
    _templateNameController.dispose();
    _templateCodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateTemplate() async {
    setState(() {
      _categoryTouched = true;
      _typeTouched = true;
    });

    if (!_formKey.currentState!.validate() ||
        _selectedCategory == null ||
        _selectedType == null) {
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.of(context).pop({
        'name': _templateNameController.text,
        'code': _templateCodeController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'type': _selectedType,
        'status': _selectedStatus,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? context.themeCardBackground : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 522,
        decoration: BoxDecoration(
          color: isDark ? context.themeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 15,
              offset: Offset(0, 10),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Create New Template',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 17.3,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF030213),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Template Name', true, isDark),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _templateNameController,
                      hintText: 'Enter template name',
                      isDark: isDark,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Template name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Template Code', true, isDark),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _templateCodeController,
                      hintText: 'Enter template code',
                      isDark: isDark,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Template code is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Description', false, isDark),
                    const SizedBox(height: 6),
                    _buildTextArea(
                      controller: _descriptionController,
                      hintText: 'Enter template description',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Category', true, isDark),
                              const SizedBox(height: 6),
                              _buildDropdown(
                                value: _selectedCategory,
                                hintText: 'Select category',
                                items: const [
                                  'Finance',
                                  'Treasury',
                                  'Expense',
                                  'Audit',
                                  'Security',
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value;
                                    _categoryTouched = true;
                                  });
                                },
                                isDark: isDark,
                                showError: _categoryTouched && _selectedCategory == null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Type', true, isDark),
                              const SizedBox(height: 6),
                              _buildDropdown(
                                value: _selectedType,
                                hintText: 'Select type',
                                items: const [
                                  'Job Role',
                                  'Duty Role',
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value;
                                    _typeTouched = true;
                                  });
                                },
                                isDark: isDark,
                                showError: _typeTouched && _selectedType == null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Status', false, isDark),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      value: _selectedStatus,
                      hintText: 'Select status',
                      items: const [
                        'Draft',
                        'Active',
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                      isDark: isDark,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildCancelButton(isDark),
                        const SizedBox(width: 8),
                        _buildCreateButton(isDark),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, size: 16),
                color: isDark ? Colors.white : const Color(0xFF030213),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool required, bool isDark) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: text == 'Description' ? 13.8 : (text == 'Type' ? 13.5 : 13.6),
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF030213),
        ),
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      height: 36,
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.6,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : const Color(0xFF030213),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.6,
            fontWeight: FontWeight.w400,
            color: Color(0xFF717182),
          ),
          filled: true,
          fillColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F3F5),
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
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.75),
          errorStyle: const TextStyle(fontSize: 11, height: 0.8),
        ),
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15.3,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : const Color(0xFF030213),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.3,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
          ),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hintText,
    required List<String> items,
    required void Function(String?) onChanged,
    required bool isDark,
    bool showError = false,
  }) {
    return Container(
      height: 39,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: showError 
              ? Colors.red 
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              hintText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.3,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white : const Color(0xFF030213),
              ),
            ),
          ),
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.keyboard_arrow_down, size: 20),
          ),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.3,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white : const Color(0xFF030213),
          ),
          dropdownColor: isDark ? context.themeCardBackground : Colors.white,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(item),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildCancelButton(bool isDark) {
    return SizedBox(
      width: 79.35,
      height: 36,
      child: OutlinedButton(
        onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? context.themeCardBackground : Colors.white,
          foregroundColor: isDark ? Colors.white : const Color(0xFF030213),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          'Cancel',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton(bool isDark) {
    return SizedBox(
      width: 140.49,
      height: 36,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleCreateTemplate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF030213),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
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
            : const Text(
                'Create Template',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.7,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}

