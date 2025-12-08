import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/create_user_account_screen.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class CreateUserFormSteps extends ConsumerWidget {
  const CreateUserFormSteps({super.key});

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
        stepContent = _SystemSettingsStep();
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
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Email Address',
                  hint: 'user@company.com',
                  isRequired: true,
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
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(
                    label: 'Email Address',
                    hint: 'user@company.com',
                    isRequired: true,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Password and Confirm Password row
          if (isMobile)
            Column(
              children: [
                _buildTextField(
                  label: 'Password',
                  hint: 'Enter password',
                  isRequired: true,
                  isPassword: true,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Confirm Password',
                  hint: 'Re-enter password',
                  isRequired: true,
                  isPassword: true,
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Password',
                    hint: 'Enter password',
                    isRequired: true,
                    isPassword: true,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(
                    label: 'Confirm Password',
                    hint: 'Re-enter password',
                    isRequired: true,
                    isPassword: true,
                  ),
                ),
              ],
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
                ),
                const SizedBox(height: 24),
                _buildDropdown(
                  label: 'Account Status',
                  value: 'Active',
                  isRequired: true,
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
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildDropdown(
                    label: 'Account Status',
                    value: 'Active',
                    isRequired: true,
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
                ),
                const SizedBox(height: 24),
                _buildDateField(
                  label: 'End Date',
                  value: 'dd/mm/yyyy',
                  helperText: 'Leave blank for no expiration',
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
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildDateField(
                    label: 'End Date',
                    value: 'dd/mm/yyyy',
                    helperText: 'Leave blank for no expiration',
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
  }) {
    return CustomTextField(
      labelText: label,
      hintText: hint,
      isRequired: isRequired,
      hasInfoIcon: hasInfo,
      helperText: helperText,
      obscureText: isPassword,
      onChanged: fieldKey != null
          ? (value) {
              // Update form state if fieldKey is provided
            }
          : null,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    bool isRequired = false,
    String? helperText,
  }) {
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
          child: Row(
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
  }) {
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
      onChanged: fieldKey != null
          ? (val) {
              // Update form state if fieldKey is provided
            }
          : null,
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
          InkWell(
            onTap: () => ref.read(createUserFormProvider.notifier).nextStep(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF030213),
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
                _buildTextField(label: 'First Name', hint: 'John', isRequired: true),
                const SizedBox(height: 24),
                _buildTextField(label: 'Middle Name', hint: 'Robert'),
                const SizedBox(height: 24),
                _buildTextField(label: 'Last Name', hint: 'Doe', isRequired: true),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildTextField(label: 'First Name', hint: 'John', isRequired: true),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(label: 'Middle Name', hint: 'Robert'),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(label: 'Last Name', hint: 'Doe', isRequired: true),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Display Name
          _buildTextField(
            label: 'Display Name',
            hint: 'Auto-generated from first and last name',
            helperText: 'Display name: Not set',
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
  }) {
    return CustomTextField(
      labelText: label,
      hintText: hint,
      isRequired: isRequired,
      helperText: helperText,
      onChanged: fieldKey != null
          ? (value) {
              // Update form state if fieldKey is provided
            }
          : null,
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
          InkWell(
            onTap: () => ref.read(createUserFormProvider.notifier).nextStep(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF030213),
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
            onChanged: (val) => setState(() => mustChangePassword = val ?? false),
          ),
          const SizedBox(height: 16),
          _buildCheckbox(
            label: 'Password Never Expires',
            description: 'Disable automatic password expiration (default: 90 days)',
            value: passwordNeverExpires,
            onChanged: (val) => setState(() => passwordNeverExpires = val ?? false),
          ),
          const SizedBox(height: 16),
          _buildCheckbox(
            label: 'Enable Multi-Factor Authentication (MFA)',
            description: 'Require additional verification method for enhanced security',
            value: enableMFA,
            onChanged: (val) => setState(() => enableMFA = val ?? false),
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
          InkWell(
            onTap: () => ref.read(createUserFormProvider.notifier).nextStep(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF030213),
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
          // Employee Number and Department
          if (isMobile)
            Column(
              children: [
                _buildTextField(label: 'Employee Number', hint: 'EMP-12345'),
                const SizedBox(height: 24),
                _buildTextField(label: 'Department', hint: 'Finance & Accounting'),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildTextField(label: 'Employee Number', hint: 'EMP-12345'),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(label: 'Department', hint: 'Finance & Accounting'),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Job Title and Phone Number
          if (isMobile)
            Column(
              children: [
                _buildTextField(label: 'Job Title', hint: 'Senior Accountant'),
                const SizedBox(height: 24),
                _buildTextField(label: 'Phone Number', hint: '+1 (555) 123-4567'),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildTextField(label: 'Job Title', hint: 'Senior Accountant'),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTextField(label: 'Phone Number', hint: '+1 (555) 123-4567'),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Manager Email
          _buildTextField(
            label: 'Manager Email',
            hint: 'manager@company.com',
            helperText: 'Email address of direct manager/supervisor',
          ),
          const SizedBox(height: 24),
          // Description / Notes
          CustomTextField(
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
    String? helperText,
    String? fieldKey,
  }) {
    return CustomTextField(
      labelText: label,
      hintText: hint,
      helperText: helperText,
      onChanged: fieldKey != null
          ? (value) {
              // Update form state if fieldKey is provided
            }
          : null,
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
          InkWell(
            onTap: () => ref.read(createUserFormProvider.notifier).nextStep(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF030213),
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
          ),
        ],
      ),
    );
  }
}

// Step 5: System Settings
class _SystemSettingsStep extends ConsumerWidget {
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
                _buildDropdown(label: 'Preferred Language', value: 'English'),
                const SizedBox(height: 24),
                _buildDropdown(label: 'Timezone', value: 'UTC (Coordinated Universal Time)'),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(label: 'Preferred Language', value: 'English'),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildDropdown(label: 'Timezone', value: 'UTC (Coordinated Universal Time)'),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // Date Format
          _buildDropdown(label: 'Date Format', value: 'YYYY-MM-DD (2024-12-31)'),
          const SizedBox(height: 24),
          _buildNavigationButtons(context, ref, formState),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
  }) {
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
          child: Row(
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
          // Create User button for final step
          InkWell(
            onTap: () {
              // TODO: Handle final submission - create user account
            },
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF030213),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.check, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Create User',
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
