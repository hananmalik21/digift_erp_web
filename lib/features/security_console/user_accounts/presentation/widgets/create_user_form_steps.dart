import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../screens/create_user_account_screen.dart';
import '../../../../../core/widgets/custom_text_field.dart';

bool _isCurrentStepValid(CreateUserFormState formState) {
  final formData = formState.formData;
  final isEditMode = formData['_isEditMode'] as bool? ?? false;
  
  switch (formState.currentStep) {
    case 0: // Account Details
      final username = formData['username']?.toString().trim() ?? '';
      final emailAddress = formData['emailAddress']?.toString().trim() ?? '';
      final password = formData['password']?.toString() ?? '';
      final confirmPassword = formData['confirmPassword']?.toString() ?? '';
      final startDate = formData['startDate']?.toString() ?? '';
      
      if (username.isEmpty) return false;
      if (emailAddress.isEmpty || !emailAddress.contains('@')) return false;
      
      // Password validation - required in create mode, optional in edit mode
      if (!isEditMode) {
        if (password.isEmpty || password.length < 6) return false;
        if (password != confirmPassword) return false;
      } else {
        // In edit mode, if password is provided, it must be valid
        if (password.isNotEmpty && password.length < 6) return false;
        if (password.isNotEmpty && password != confirmPassword) return false;
      }
      
      if (startDate.isEmpty || startDate.contains('dd') || startDate.contains('mm') || startDate.contains('yyyy')) return false;
      return true;
      
    case 1: // Personal Information
      final firstName = formData['firstName']?.toString().trim() ?? '';
      final lastName = formData['lastName']?.toString().trim() ?? '';
      return firstName.isNotEmpty && lastName.isNotEmpty;
      
    case 2: // Security Settings
    case 3: // Additional Information
    case 4: // System Settings
      return true; // All optional or have defaults
      
    default:
      return false;
  }
}

String _getValidationErrorMessage(int step, CreateUserFormState formState) {
  switch (step) {
    case 0:
      final isEditMode = formState.formData['_isEditMode'] as bool? ?? false;
      if (isEditMode) {
        return 'Please fill all required fields: Username, Email, and Start Date';
      } else {
        return 'Please fill all required fields: Username, Email, Password, Confirm Password, and Start Date';
      }
    case 1:
      return 'Please fill all required fields: First Name and Last Name';
    default:
      return 'Please complete all required fields';
  }
}

class CreateUserFormSteps extends ConsumerWidget {
  final VoidCallback? onCreateUser;
  
  const CreateUserFormSteps({super.key, this.onCreateUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createUserFormProvider);

    Widget stepContent;
    switch (formState.currentStep) {
      case 0:
        stepContent = _AccountDetailsStep();
        break;
      case 1:
        stepContent = _PersonalInformationStep();
        break;
      case 2:
        stepContent = _SecuritySettingsStep();
        break;
      case 3:
        stepContent = _AdditionalInformationStep();
        break;
      case 4:
        stepContent = _SystemSettingsStep(onCreateUser: onCreateUser);
        break;
      default:
        stepContent = _AccountDetailsStep();
    }

    return stepContent;
  }
}

// Step 1: Account Details
class _AccountDetailsStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createUserFormProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Details',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.9,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter basic account credentials and authentication details',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A5565),
            ),
          ),
          const SizedBox(height: 24),
          // Username and Email row
          if (isMobile)
            Column(
              children: [
                _buildTextField(
                  label: 'Username',
                  hint: 'Enter username (e.g., jdoe)',
                  isRequired: true,
                  hasInfo: true,
                  helperText: 'Username must be unique and at least 3 characters',
                  fieldKey: 'username',
                  ref: ref,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Email Address',
                  hint: 'user@company.com',
                  isRequired: true,
                  fieldKey: 'emailAddress',
                  ref: ref,
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Username',
                    hint: 'Enter username (e.g., jdoe)',
                    isRequired: true,
                    hasInfo: true,
                    helperText: 'Username must be unique and at least 3 characters',
                    fieldKey: 'username',
                    ref: ref,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(
                    label: 'Email Address',
                    hint: 'user@company.com',
                    isRequired: true,
                    fieldKey: 'emailAddress',
                    ref: ref,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Password and Confirm Password row - only show in create mode
          Consumer(
            builder: (context, ref, child) {
              final isEditMode = ref.watch(createUserFormProvider).formData['_isEditMode'] as bool? ?? false;
              
              // Hide password fields in edit mode
              if (isEditMode) {
                return const SizedBox.shrink();
              }
              
              // Show password fields only in create mode
              if (isMobile) {
                return Column(
                  children: [
                    _buildTextField(
                      label: 'Password',
                      hint: 'Enter password',
                      isRequired: true,
                      isPassword: true,
                      fieldKey: 'password',
                      ref: ref,
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      label: 'Confirm Password',
                      hint: 'Re-enter password',
                      isRequired: true,
                      isPassword: true,
                      fieldKey: 'confirmPassword',
                      ref: ref,
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Password',
                        hint: 'Enter password',
                        isRequired: true,
                        isPassword: true,
                        fieldKey: 'password',
                        ref: ref,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildTextField(
                        label: 'Confirm Password',
                        hint: 'Re-enter password',
                        isRequired: true,
                        isPassword: true,
                        fieldKey: 'confirmPassword',
                        ref: ref,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 24),
          // Account Type and Account Status row
          if (isMobile)
            Column(
              children: [
                _buildDropdown(
                  label: 'Account Type',
                  value: 'Local',
                  isRequired: true,
                  helperText: 'Standard local authentication',
                  fieldKey: 'accountType',
                  ref: ref,
                  items: const ['Local', 'SSO'],
                ),
                const SizedBox(height: 24),
                _buildDropdown(
                  label: 'Account Status',
                  value: 'Active',
                  isRequired: true,
                  fieldKey: 'accountStatus',
                  ref: ref,
                  items: const ['Active', 'Inactive'],
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Account Type',
                    value: 'Local',
                    isRequired: true,
                    helperText: 'Standard local authentication',
                    fieldKey: 'accountType',
                    ref: ref,
                    items: const ['Local', 'SSO'],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildDropdown(
                    label: 'Account Status',
                    value: 'Active',
                    isRequired: true,
                    fieldKey: 'accountStatus',
                    ref: ref,
                    items: const ['Active', 'Inactive'],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Start Date and End Date row
          if (isMobile)
            Column(
              children: [
                _buildDateField(
                  label: 'Start Date',
                  value: '04/12/2025',
                  isRequired: true,
                  helperText: 'Account becomes active on this date',
                  fieldKey: 'startDate',
                  ref: ref,
                ),
                const SizedBox(height: 24),
                _buildDateField(
                  label: 'End Date',
                  value: 'dd/mm/yyyy',
                  helperText: 'Leave blank for no expiration',
                  fieldKey: 'endDate',
                  ref: ref,
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'Start Date',
                    value: '04/12/2025',
                    isRequired: true,
                    helperText: 'Account becomes active on this date',
                    fieldKey: 'startDate',
                    ref: ref,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildDateField(
                    label: 'End Date',
                    value: 'dd/mm/yyyy',
                    helperText: 'Leave blank for no expiration',
                    fieldKey: 'endDate',
                    ref: ref,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          _buildNavigationButtons(context, ref, formState),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    bool isRequired = false,
    bool hasInfo = false,
    String? helperText,
    bool isPassword = false,
    String? fieldKey,
    WidgetRef? ref,
  }) {
    if (fieldKey != null && ref != null) {
      return Consumer(
        builder: (context, ref, child) {
          final formState = ref.watch(createUserFormProvider);
          final value = formState.formData[fieldKey]?.toString() ?? '';
          return CustomTextField(
            labelText: label,
            hintText: hint,
            isRequired: isRequired,
            hasInfoIcon: hasInfo,
            helperText: helperText,
            obscureText: isPassword,
            initialValue: value.isEmpty ? null : value,
            onChanged: (newValue) {
              ref.read(createUserFormProvider.notifier).updateFormData(fieldKey, newValue);
            },
          );
        },
      );
    }
    return CustomTextField(
      labelText: label,
      hintText: hint,
      isRequired: isRequired,
      hasInfoIcon: hasInfo,
      helperText: helperText,
      obscureText: isPassword,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    bool isRequired = false,
    String? helperText,
    String? fieldKey,
    WidgetRef? ref,
    List<String>? items,
  }) {
    if (fieldKey != null && ref != null) {
      return Consumer(
        builder: (context, ref, child) {
          final formState = ref.watch(createUserFormProvider);
          final formValue = formState.formData[fieldKey]?.toString() ?? value;
          final dropdownItems = items ?? [value];
          
          // Ensure the current value matches one of the dropdown items
          String currentValue = formValue;
          if (dropdownItems.isNotEmpty && !dropdownItems.contains(formValue)) {
            // Try case-insensitive match
            try {
              final matchedItem = dropdownItems.firstWhere(
                (item) => item.toLowerCase() == formValue.toLowerCase(),
                orElse: () => value,
              );
              currentValue = matchedItem;
              // Update form data with the correct case if different
              if (matchedItem != formValue) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(createUserFormProvider.notifier).updateFormData(fieldKey, matchedItem);
                });
              }
            } catch (e) {
              // If no match found, use default value
              currentValue = value;
            }
          }
          
          return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 14,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.8,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  color: Color(0xFF0A0A0A),
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                    color: Color(0xFFFB2C36),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 39,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DC)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: dropdownItems.length > 1
              ? DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currentValue,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.3,
                      fontWeight: FontWeight.w400,
                      height: 19 / 15.3,
                      color: Color(0xFF0A0A0A),
                    ),
                    items: dropdownItems.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        ref.read(createUserFormProvider.notifier).updateFormData(fieldKey, newValue);
                      }
                    },
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentValue,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15.3,
                          fontWeight: FontWeight.w400,
                          height: 19 / 15.3,
                          color: Color(0xFF0A0A0A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 12),
          Text(
            helperText,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              height: 16 / 11.8,
              color: Color(0xFF6A7282),
            ),
          ),
        ],
      ],
    );
        },
      );
    }
    
    final dropdownItems = items ?? [value];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 14,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.8,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  color: Color(0xFF0A0A0A),
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                    color: Color(0xFFFB2C36),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 39,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DC)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: dropdownItems.length > 1
              ? DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.3,
                      fontWeight: FontWeight.w400,
                      height: 19 / 15.3,
                      color: Color(0xFF0A0A0A),
                    ),
                    items: dropdownItems.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: null,
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15.3,
                          fontWeight: FontWeight.w400,
                          height: 19 / 15.3,
                          color: Color(0xFF0A0A0A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 12),
          Text(
            helperText,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              height: 16 / 11.8,
              color: Color(0xFF6A7282),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    bool isRequired = false,
    String? helperText,
    String? fieldKey,
    WidgetRef? ref,
  }) {
    if (fieldKey != null && ref != null) {
      return Consumer(
        builder: (context, ref, child) {
          final formState = ref.watch(createUserFormProvider);
          final formValue = formState.formData[fieldKey]?.toString() ?? value;
          final isPlaceholder = formValue.contains('dd') || formValue.contains('mm') || formValue.contains('yyyy');
          final currentValue = isPlaceholder ? null : formValue;
          
          // Parse current date if available
          DateTime? currentDate;
          if (currentValue != null && currentValue.isNotEmpty) {
            try {
              final formats = ['MM/dd/yyyy', 'yyyy-MM-dd', 'dd/MM/yyyy', 'MM-dd-yyyy'];
              for (final format in formats) {
                try {
                  currentDate = DateFormat(format).parse(currentValue);
                  break;
                } catch (_) {
                  continue;
                }
              }
            } catch (_) {
              currentDate = null;
            }
          }
          
          return CustomTextField(
            labelText: label,
            hintText: isPlaceholder ? formValue : null,
            initialValue: currentValue,
            isRequired: isRequired,
            helperText: helperText,
            suffixIcon: const Icon(
              Icons.calendar_today,
              size: 18,
              color: Color(0xFF9CA3AF),
            ),
            onChanged: null, // Disable manual input, only allow date picker
            readOnly: true, // Make field read-only to force date picker usage
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: currentDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: const Color(0xFF155DFC),
                        onPrimary: Colors.white,
                        onSurface: const Color(0xFF0A0A0A),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              
              if (picked != null && context.mounted) {
                final formattedDate = DateFormat('MM/dd/yyyy').format(picked);
                ref.read(createUserFormProvider.notifier).updateFormData(fieldKey, formattedDate);
              }
            },
          );
        },
      );
    }
    
    final isPlaceholder = value.contains('dd') || value.contains('mm') || value.contains('yyyy');
    return CustomTextField(
      labelText: label,
      hintText: isPlaceholder ? value : null,
      initialValue: isPlaceholder ? null : value,
      isRequired: isRequired,
      helperText: helperText,
      suffixIcon: const Icon(
        Icons.calendar_today,
        size: 18,
        color: Color(0xFF9CA3AF),
      ),
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    WidgetRef ref,
    CreateUserFormState formState,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          Opacity(
            opacity: formState.currentStep > 0 ? 1.0 : 0.5,
            child: InkWell(
              onTap: formState.currentStep > 0
                  ? () => ref.read(createUserFormProvider.notifier).previousStep()
                  : null,
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Previous',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.8,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0A0A0A),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Next button
          Consumer(
            builder: (context, ref, child) {
              final formState = ref.watch(createUserFormProvider);
              final notifier = ref.read(createUserFormProvider.notifier);
              final isValid = _isCurrentStepValid(formState);
              
              return InkWell(
                onTap: isValid
                    ? () {
                        notifier.nextStep();
                      }
                    : () {
                        // Show validation error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_getValidationErrorMessage(formState.currentStep, formState)),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isValid
                        ? const Color(0xFF030213)
                        : const Color(0xFF9B9B9B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.7,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Step 2: Personal Information
class _PersonalInformationStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createUserFormProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.9,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Provide personal information for the user',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A5565),
            ),
          ),
          const SizedBox(height: 24),
          // First, Middle, Last Name row
          if (isMobile)
            Column(
              children: [
                _buildTextField(
                  label: 'First Name',
                  hint: 'John',
                  isRequired: true,
                  fieldKey: 'firstName',
                  ref: ref,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Middle Name',
                  hint: 'Robert',
                  fieldKey: 'middleName',
                  ref: ref,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Last Name',
                  hint: 'Doe',
                  isRequired: true,
                  fieldKey: 'lastName',
                  ref: ref,
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'First Name',
                    hint: 'John',
                    isRequired: true,
                    fieldKey: 'firstName',
                    ref: ref,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(
                    label: 'Middle Name',
                    hint: 'Robert',
                    fieldKey: 'middleName',
                    ref: ref,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(
                    label: 'Last Name',
                    hint: 'Doe',
                    isRequired: true,
                    fieldKey: 'lastName',
                    ref: ref,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Display Name - Auto-generated and disabled
          Consumer(
            builder: (context, ref, child) {
              final formState = ref.watch(createUserFormProvider);
              final firstName = formState.formData['firstName']?.toString().trim() ?? '';
              final middleName = formState.formData['middleName']?.toString().trim() ?? '';
              final lastName = formState.formData['lastName']?.toString().trim() ?? '';
              
              // Auto-generate display name from first, middle, and last name
              String displayName = '';
              if (firstName.isNotEmpty || middleName.isNotEmpty || lastName.isNotEmpty) {
                final parts = <String>[];
                if (firstName.isNotEmpty) parts.add(firstName);
                if (middleName.isNotEmpty) parts.add(middleName);
                if (lastName.isNotEmpty) parts.add(lastName);
                displayName = parts.join(' ');
              }
              
              // Update form data with calculated display name
              if (displayName.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(createUserFormProvider.notifier).updateFormData('displayName', displayName);
                });
              }
              
              return CustomTextField(
                labelText: 'Display Name',
                hintText: 'Auto-generated from first, middle, and last name',
                initialValue: displayName.isNotEmpty ? displayName : null,
                readOnly: true,
                fillColor: const Color(0xFFF3F3F5),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildNavigationButtons(context, ref, formState),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    bool isRequired = false,
    String? helperText,
    String? fieldKey,
    WidgetRef? ref,
  }) {
    if (fieldKey != null && ref != null) {
      return Consumer(
        builder: (context, ref, child) {
          final formState = ref.watch(createUserFormProvider);
          final value = formState.formData[fieldKey]?.toString() ?? '';
          return CustomTextField(
            labelText: label,
            hintText: hint,
            isRequired: isRequired,
            helperText: helperText,
            initialValue: value.isEmpty ? null : value,
            onChanged: (newValue) {
              ref.read(createUserFormProvider.notifier).updateFormData(fieldKey, newValue);
            },
          );
        },
      );
    }
    return CustomTextField(
      labelText: label,
      hintText: hint,
      isRequired: isRequired,
      helperText: helperText,
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    WidgetRef ref,
    CreateUserFormState formState,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => ref.read(createUserFormProvider.notifier).previousStep(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final formState = ref.watch(createUserFormProvider);
              final notifier = ref.read(createUserFormProvider.notifier);
              final isValid = _isCurrentStepValid(formState);
              
              return InkWell(
                onTap: isValid
                    ? () {
                        notifier.nextStep();
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_getValidationErrorMessage(formState.currentStep, formState)),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isValid
                        ? const Color(0xFF030213)
                        : const Color(0xFF9B9B9B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.7,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Step 3: Security Settings
class _SecuritySettingsStep extends ConsumerStatefulWidget {
  @override
  ConsumerState<_SecuritySettingsStep> createState() => _SecuritySettingsStepState();
}

class _SecuritySettingsStepState extends ConsumerState<_SecuritySettingsStep> {
  bool mustChangePassword = true;
  bool passwordNeverExpires = false;
  bool enableMFA = false;

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createUserFormProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Security Settings',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.9,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Configure security and authentication settings',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A5565),
            ),
          ),
          const SizedBox(height: 24),
          // Info box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              border: Border.all(color: const Color(0xFFBEDBFF)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Color(0xFF155DFC),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Security & Authentication Settings',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.7,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1C398E),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Configure password policies and multi-factor authentication for this user account',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.8,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1447E6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Checkboxes
          _buildCheckbox(
            label: 'User Must Change Password at Next Sign In',
            description: 'User will be forced to change their password upon first login',
            value: mustChangePassword,
            onChanged: (val) {
              setState(() => mustChangePassword = val ?? false);
              ref.read(createUserFormProvider.notifier).updateFormData('mustChangePassword', val ?? false);
            },
          ),
          const SizedBox(height: 16),
          _buildCheckbox(
            label: 'Password Never Expires',
            description: 'Disable automatic password expiration (default: 90 days)',
            value: passwordNeverExpires,
            onChanged: (val) {
              setState(() => passwordNeverExpires = val ?? false);
              ref.read(createUserFormProvider.notifier).updateFormData('passwordNeverExpires', val ?? false);
            },
          ),
          const SizedBox(height: 16),
          _buildCheckbox(
            label: 'Enable Multi-Factor Authentication (MFA)',
            description: 'Require additional verification method for enhanced security',
            value: enableMFA,
            onChanged: (val) {
              setState(() => enableMFA = val ?? false);
              ref.read(createUserFormProvider.notifier).updateFormData('mfaEnabled', val ?? false);
            },
          ),
          const SizedBox(height: 24),
          _buildNavigationButtons(context, ref, formState),
        ],
      ),
    );
  }

  Widget _buildCheckbox({
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 13,
            height: 13,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: value ? const Color(0xFF0075FF) : Colors.white,
              border: Border.all(
                color: value ? const Color(0xFF0075FF) : const Color(0xFF767676),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2.5),
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: 10,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.7,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0A0A0A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.8,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4A5565),
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

  Widget _buildNavigationButtons(
    BuildContext context,
    WidgetRef ref,
    CreateUserFormState formState,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => ref.read(createUserFormProvider.notifier).previousStep(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final formState = ref.watch(createUserFormProvider);
              final notifier = ref.read(createUserFormProvider.notifier);
              final isValid = _isCurrentStepValid(formState);
              
              return InkWell(
                onTap: isValid
                    ? () {
                        notifier.nextStep();
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_getValidationErrorMessage(formState.currentStep, formState)),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isValid
                        ? const Color(0xFF030213)
                        : const Color(0xFF9B9B9B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.7,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Step 4: Additional Information
class _AdditionalInformationStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createUserFormProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Information',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.9,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add organizational and contact information',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A5565),
            ),
          ),
          const SizedBox(height: 24),
          // Department (Employee Number is auto-generated by backend)
          _buildTextField(
            label: 'Department',
            hint: 'Finance & Accounting',
            fieldKey: 'departmentName',
            ref: ref,
          ),
          const SizedBox(height: 24),
          // Job Title and Phone Number
          if (isMobile)
            Column(
              children: [
                _buildTextField(
                  label: 'Job Title',
                  hint: 'Senior Accountant',
                  fieldKey: 'jobTitle',
                  ref: ref,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Phone Number',
                  hint: '+1 (555) 123-4567',
                  fieldKey: 'phoneNumber',
                  ref: ref,
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Job Title',
                    hint: 'Senior Accountant',
                    fieldKey: 'jobTitle',
                    ref: ref,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(
                    label: 'Phone Number',
                    hint: '+1 (555) 123-4567',
                    fieldKey: 'phoneNumber',
                    ref: ref,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Manager Email
          _buildTextField(
            label: 'Manager Email',
            hint: 'manager@company.com',
            helperText: 'Email address of direct manager/supervisor',
            fieldKey: 'managerEmail',
            ref: ref,
          ),
          const SizedBox(height: 24),
          // Description / Notes
          Consumer(
            builder: (context, ref, child) {
              final formState = ref.watch(createUserFormProvider);
              final value = formState.formData['descriptionNotes']?.toString() ?? '';
              return CustomTextField(
                labelText: 'Description / Notes',
                hintText: 'Additional notes or comments about this user account',
                height: 100,
                fontSize: 15.3,
                borderRadius: 8,
                fillColor: Colors.white,
                borderColor: const Color(0xFFD1D5DC),
                showBorder: true,
                filled: true,
                maxLines: null,
                expands: true,
                initialValue: value.isEmpty ? null : value,
                onChanged: (newValue) {
                  ref.read(createUserFormProvider.notifier).updateFormData('descriptionNotes', newValue);
                },
              );
            },
          ),
          const SizedBox(height: 24),
          _buildNavigationButtons(context, ref, formState),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    bool isRequired = false,
    String? helperText,
    String? fieldKey,
    WidgetRef? ref,
  }) {
    if (fieldKey != null && ref != null) {
      return Consumer(
        builder: (context, ref, child) {
          final formState = ref.watch(createUserFormProvider);
          final value = formState.formData[fieldKey]?.toString() ?? '';
          return CustomTextField(
            labelText: label,
            hintText: hint,
            isRequired: isRequired,
            helperText: helperText,
            initialValue: value.isEmpty ? null : value,
            onChanged: (newValue) {
              ref.read(createUserFormProvider.notifier).updateFormData(fieldKey, newValue);
            },
          );
        },
      );
    }
    return CustomTextField(
      labelText: label,
      hintText: hint,
      isRequired: isRequired,
      helperText: helperText,
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    WidgetRef ref,
    CreateUserFormState formState,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => ref.read(createUserFormProvider.notifier).previousStep(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final formState = ref.watch(createUserFormProvider);
              final notifier = ref.read(createUserFormProvider.notifier);
              final isValid = _isCurrentStepValid(formState);
              
              return InkWell(
                onTap: isValid
                    ? () {
                        notifier.nextStep();
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_getValidationErrorMessage(formState.currentStep, formState)),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isValid
                        ? const Color(0xFF030213)
                        : const Color(0xFF9B9B9B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.7,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Step 5: System Settings
class _SystemSettingsStep extends ConsumerWidget {
  final VoidCallback? onCreateUser;
  
  const _SystemSettingsStep({this.onCreateUser});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createUserFormProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Settings',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.9,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Set system preferences and regional settings',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A5565),
            ),
          ),
          const SizedBox(height: 24),
          // Preferred Language and Timezone
          if (isMobile)
            Column(
              children: [
                _buildSystemDropdown(
                  label: 'Preferred Language',
                  value: 'English',
                  fieldKey: 'preferredLanguage',
                  ref: ref,
                  items: const ['English', 'Arabic'],
                ),
                const SizedBox(height: 24),
                _buildSystemDropdown(
                  label: 'Timezone',
                  value: 'UTC (Coordinated Universal Time)',
                  fieldKey: 'timezoneCode',
                  ref: ref,
                  items: const ['UTC (Coordinated Universal Time)', 'EST (Eastern Standard Time)', 'PST (Pacific Standard Time)'],
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildSystemDropdown(
                    label: 'Preferred Language',
                    value: 'English',
                    fieldKey: 'preferredLanguage',
                    ref: ref,
                    items: const ['English', 'Arabic'],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildSystemDropdown(
                    label: 'Timezone',
                    value: 'UTC (Coordinated Universal Time)',
                    fieldKey: 'timezoneCode',
                    ref: ref,
                    items: const ['UTC (Coordinated Universal Time)', 'EST (Eastern Standard Time)', 'PST (Pacific Standard Time)'],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Date Format
          _buildSystemDropdown(
            label: 'Date Format',
            value: 'MM/DD/YYYY (12/31/2024)',
            fieldKey: 'dateFormat',
            ref: ref,
            items: const ['MM/DD/YYYY (12/31/2024)', 'YYYY-MM-DD (2024-12-31)', 'DD/MM/YYYY (31/12/2024)'],
          ),
          const SizedBox(height: 24),
          _buildNavigationButtons(context, ref, formState, onCreateUser),
        ],
      ),
    );
  }

  Widget _buildSystemDropdown({
    required String label,
    required String value,
    String? fieldKey,
    WidgetRef? ref,
    List<String>? items,
  }) {
    if (fieldKey != null && ref != null) {
      return Consumer(
        builder: (context, ref, child) {
          final formState = ref.watch(createUserFormProvider);
          final currentValue = formState.formData[fieldKey]?.toString() ?? value;
          final dropdownItems = items ?? [value];
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.8,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0A0A0A),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 39,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD1D5DC)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: dropdownItems.length > 1
                    ? DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: currentValue,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                            color: Color(0xFF9CA3AF),
                          ),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.3,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF0A0A0A),
                          ),
                          items: dropdownItems.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              ref.read(createUserFormProvider.notifier).updateFormData(fieldKey, newValue);
                            }
                          },
                        ),
                      )
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15.3,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF0A0A0A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
        ),
      ],
    );
  },
      );
    }
    
    final dropdownItems = items ?? [value];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0A0A0A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 39,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DC)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: dropdownItems.length > 1
              ? DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.3,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF0A0A0A),
                    ),
                    items: dropdownItems.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: null,
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15.3,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF0A0A0A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    WidgetRef ref,
    CreateUserFormState formState,
    VoidCallback? onCreateUser,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => ref.read(createUserFormProvider.notifier).previousStep(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
              ),
            ),
          ),
          // Create/Update User button for final step
          Consumer(
            builder: (context, ref, child) {
              final formState = ref.watch(createUserFormProvider);
              final isEditMode = formState.formData['_isEditMode'] as bool? ?? false;
              final buttonText = isEditMode ? 'Update User Account' : 'Create User';
              
              return InkWell(
                onTap: onCreateUser,
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
                      const Icon(Icons.check, size: 16, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        buttonText,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.8,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
