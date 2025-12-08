import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class CreateDataAccessSetDialog extends StatefulWidget {
  const CreateDataAccessSetDialog({super.key});

  @override
  State<CreateDataAccessSetDialog> createState() =>
      _CreateDataAccessSetDialogState();
}

class _CreateDataAccessSetDialogState extends State<CreateDataAccessSetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedAccessType = 'Multi-Dimensional';
  String _selectedStatus = 'Active';
  String _selectedAccessCriteria = 'Ledger'; // Ledger or Business Unit

  final List<String> _accessTypes = [
    'Multi-Dimensional',
    'Ledger',
    'Legal Entity',
    'Business Unit',
  ];

  final List<String> _statuses = ['Active', 'Inactive'];

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'name': _nameController.text,
        'code': _codeController.text,
        'description': _descriptionController.text,
        'accessType': _selectedAccessType,
        'status': _selectedStatus,
        'accessCriteria': _selectedAccessCriteria,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Container(
        width: isMobile ? double.infinity : 510,
        constraints: const BoxConstraints(maxHeight: 900),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create New Data Access Set',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17.2,
                            fontWeight: FontWeight.w600,
                            height: 18 / 17.2,
                            color: Color(0xFF0A0A0A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Define data security boundaries for ledgers, legal entities, and business units',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.6,
                            fontWeight: FontWeight.w400,
                            height: 20 / 13.6,
                            color: Color(0xFF717182),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          border: Border.all(color: const Color(0xFFBEDBFF)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Creating a Data Access Set',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.7,
                                fontWeight: FontWeight.w500,
                                height: 20 / 13.7,
                                color: Color(0xFF1C398E),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Fill in the basic information below, choose your access criteria (Ledger or Business Unit), then select the specific items users will have access to. At least one selection is required.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.8,
                                fontWeight: FontWeight.w400,
                                height: 16 / 11.8,
                                color: Color(0xFF1447E6),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Set Name
                      CustomTextField(
                        labelText: 'Set Name',
                        hintText: 'Enter data access set name',
                        controller: _nameController,
                        isRequired: true,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Set name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Set Code
                      CustomTextField(
                        labelText: 'Set Code',
                        hintText: 'Enter set code',
                        controller: _codeController,
                        isRequired: true,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Set code is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.8,
                              fontWeight: FontWeight.w500,
                              height: 14 / 13.8,
                              color: Color(0xFF0A0A0A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            labelText: "",
                            hintText: 'Enter description',
                            maxLines: 7,
                            controller: _descriptionController,
                            isRequired: true,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Set code is required';
                              }
                              return null;
                            },
                          ),
                          // Container(
                          //   height: 80,
                          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //       color: Colors.black.withValues(alpha: 0.1),
                          //     ),
                          //     borderRadius: BorderRadius.circular(8),
                          //   ),
                          //   child: TextField(
                          //     controller: _descriptionController,
                          //     maxLines: null,
                          //     expands: true,
                          //     textAlignVertical: TextAlignVertical.top,
                          //     style: const TextStyle(
                          //       fontFamily: 'Inter',
                          //       fontSize: 15.3,
                          //       fontWeight: FontWeight.w400,
                          //       color: Color(0xFF0A0A0A),
                          //     ),
                          //     decoration: const InputDecoration(
                          //       hintText: 'Enter description',
                          //       hintStyle: TextStyle(
                          //         fontFamily: 'Inter',
                          //         fontSize: 15.3,
                          //         fontWeight: FontWeight.w400,
                          //         color: Color(0x800A0A0A),
                          //       ),
                          //       border: InputBorder.none,
                          //       contentPadding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Access Type and Status row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Access Type *',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13.6,
                                    fontWeight: FontWeight.w500,
                                    height: 14 / 13.6,
                                    color: Color(0xFF0A0A0A),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 39,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withValues(alpha: 0.1),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedAccessType,
                                      isExpanded: true,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15.4,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF0A0A0A),
                                      ),
                                      items: _accessTypes.map((type) {
                                        return DropdownMenuItem(
                                          value: type,
                                          child: Text(
                                            type,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
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
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status *',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13.6,
                                    fontWeight: FontWeight.w500,
                                    height: 14 / 13.6,
                                    color: Color(0xFF0A0A0A),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 39,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withValues(alpha: 0.1),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedStatus,
                                      isExpanded: true,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15.1,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF0A0A0A),
                                      ),
                                      items: _statuses.map((status) {
                                        return DropdownMenuItem(
                                          value: status,
                                          child: Text(
                                            status,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
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
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Divider
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 24),
                      // Data Access Configuration
                      const Text(
                        'Data Access Configuration',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15.3,
                          fontWeight: FontWeight.w400,
                          height: 24 / 15.3,
                          color: Color(0xFF0F172B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Access Criteria box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          border: Border.all(color: const Color(0xFFBEDBFF)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Access Criteria * (Choose One)',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.7,
                                fontWeight: FontWeight.w500,
                                height: 14 / 13.7,
                                color: Color(0xFF0A0A0A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Select whether to define access by Ledger or Business Unit. Only one can be used at a time.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.8,
                                fontWeight: FontWeight.w400,
                                height: 16 / 11.8,
                                color: Color(0xFF45556C),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                // Ledger option
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedAccessCriteria = 'Ledger';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: _selectedAccessCriteria == 'Ledger'
                                            ? const Color(0xFFE3F2FD)
                                            : Colors.white,
                                        border: Border.all(
                                          color: _selectedAccessCriteria == 'Ledger'
                                              ? const Color(0xFF2B7FFF)
                                              : const Color(0xFFCAD5E2),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: _selectedAccessCriteria == 'Ledger'
                                                    ? const Color(0xFF0075FF)
                                                    : const Color(0xFF767676),
                                                width: 1,
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: _selectedAccessCriteria == 'Ledger'
                                                ? Center(
                                                    child: Container(
                                                      width: 9.6,
                                                      height: 9.6,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(0xFF0075FF),
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Flexible(
                                            child: Text(
                                              'Ledger',
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 15.4,
                                                fontWeight: FontWeight.w500,
                                                height: 24 / 15.4,
                                                color: Color(0xFF1C398E),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Business Unit option
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedAccessCriteria = 'Business Unit';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: _selectedAccessCriteria == 'Business Unit'
                                              ? const Color(0xFF2B7FFF)
                                              : const Color(0xFFCAD5E2),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: _selectedAccessCriteria == 'Business Unit'
                                                    ? const Color(0xFF0075FF)
                                                    : const Color(0xFF767676),
                                                width: 1,
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: _selectedAccessCriteria == 'Business Unit'
                                                ? Center(
                                                    child: Container(
                                                      width: 9.6,
                                                      height: 9.6,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(0xFF0075FF),
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Flexible(
                                            child: Text(
                                              'Business Unit',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 15.5,
                                                fontWeight: FontWeight.w500,
                                                height: 24 / 15.5,
                                                color: _selectedAccessCriteria == 'Business Unit'
                                                    ? const Color(0xFF1C398E)
                                                    : const Color(0xFF0A0A0A),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Ledgers section
                      const Text(
                        'Ledgers (0 selected)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.8,
                          fontWeight: FontWeight.w500,
                          height: 14 / 13.8,
                          color: Color(0xFF0A0A0A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'No ledgers found. Please create ledgers first.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.6,
                              fontWeight: FontWeight.w400,
                              height: 20 / 13.6,
                              color: Color(0xFF6A7282),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Legal Entities section
                      const Text(
                        'Legal Entities (0 selected)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.8,
                          fontWeight: FontWeight.w500,

                          color: Color(0xFF0A0A0A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'No legal entities found. Please create legal entities first.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.6,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF6A7282),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Footer
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        minimumSize: const Size(79.35, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.7,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0A0A0A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _handleCreate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF030213),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        minimumSize: const Size(101.81, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Create Set',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.7,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

