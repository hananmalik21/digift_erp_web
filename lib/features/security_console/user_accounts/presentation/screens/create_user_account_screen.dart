import 'package:digify_erp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../widgets/create_user_form_steps.dart';
import '../../data/datasources/user_account_remote_datasource.dart';
import '../../data/models/user_account_dto.dart';
import '../services/user_account_service.dart';
import '../../data/utils/account_type_mapper.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';

// State provider for form data and current step - using autoDispose for local instances
final createUserFormProvider =
StateNotifierProvider.autoDispose<CreateUserFormNotifier, CreateUserFormState>((ref) {
  return CreateUserFormNotifier();
});

class CreateUserFormState {
  final int currentStep;
  final Set<int> completedSteps;
  final Map<String, dynamic> formData;
  final Map<String, String?> errors;

  CreateUserFormState({
    this.currentStep = 0,
    this.completedSteps = const {},
    this.formData = const {},
    this.errors = const {},
  });

  CreateUserFormState copyWith({
    int? currentStep,
    Set<int>? completedSteps,
    Map<String, dynamic>? formData,
    Map<String, String?>? errors,
  }) {
    return CreateUserFormState(
      currentStep: currentStep ?? this.currentStep,
      completedSteps: completedSteps ?? this.completedSteps,
      formData: formData ?? this.formData,
      errors: errors ?? this.errors,
    );
  }
}

class CreateUserFormNotifier extends StateNotifier<CreateUserFormState> {
  CreateUserFormNotifier({bool isEditMode = false}) : super(CreateUserFormState(
    formData: {
      'accountType': 'Local',
      'accountStatus': 'Active',
      'mustChangePassword': true,
      'passwordNeverExpires': false,
      'mfaEnabled': false,
      'preferredLanguage': 'English',
      'timezoneCode': 'UTC (Coordinated Universal Time)',
      'dateFormat': 'MM/DD/YYYY (12/31/2024)',
      '_isEditMode': isEditMode,
    },
  ));

  void goToStep(int step) {
    // Disabled - tabs should not be clickable
    // Users can only navigate via Next/Previous buttons
  }

  bool _validateCurrentStep() {
    final formData = state.formData;
    
    switch (state.currentStep) {
      case 0: // Account Details
        final username = formData['username']?.toString().trim() ?? '';
        final emailAddress = formData['emailAddress']?.toString().trim() ?? '';
        final password = formData['password']?.toString() ?? '';
        final confirmPassword = formData['confirmPassword']?.toString() ?? '';
        final startDate = formData['startDate']?.toString() ?? '';
        
        if (username.isEmpty) return false;
        if (emailAddress.isEmpty || !emailAddress.contains('@')) return false;
        
        // Password validation only for create mode
        final isEditMode = formData['_isEditMode'] as bool? ?? false;
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
        // All fields are optional (checkboxes), so always valid
        return true;
        
      case 3: // Additional Information
        // All fields are optional, so always valid
        return true;
        
      case 4: // System Settings
        // All fields have defaults, so always valid
        return true;
        
      default:
        return false;
    }
  }

  void nextStep() {
    if (!_validateCurrentStep()) {
      // Show error message
      return;
    }
    
    if (state.currentStep < 4) {
      final newCompleted = Set<int>.from(state.completedSteps)
        ..add(state.currentStep);
      state = state.copyWith(
        currentStep: state.currentStep + 1,
        completedSteps: newCompleted,
      );
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void updateFormData(String key, dynamic value) {
    final newData = Map<String, dynamic>.from(state.formData);
    newData[key] = value;
    state = state.copyWith(formData: newData);
  }

  void setError(String key, String? error) {
    final newErrors = Map<String, String?>.from(state.errors);
    if (error == null) {
      newErrors.remove(key);
    } else {
      newErrors[key] = error;
    }
    state = state.copyWith(errors: newErrors);
  }

  void reset() {
    state = CreateUserFormState(
      formData: {
        'accountType': 'Local',
        'accountStatus': 'Active',
        'mustChangePassword': true,
        'passwordNeverExpires': false,
        'mfaEnabled': false,
        'preferredLanguage': 'English',
        'timezoneCode': 'UTC (Coordinated Universal Time)',
        'dateFormat': 'MM/DD/YYYY (12/31/2024)',
      },
    );
  }
}

class CreateUserAccountScreen extends ConsumerStatefulWidget {
  final int? userId; // If provided, we're in edit mode
  
  const CreateUserAccountScreen({super.key, this.userId});

  @override
  ConsumerState<CreateUserAccountScreen> createState() => _CreateUserAccountScreenState();
}

class _CreateUserAccountScreenState extends ConsumerState<CreateUserAccountScreen> {
  bool _isLoadingUserData = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.userId != null;
    // Reset form state when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createUserFormProvider.notifier).reset();
      if (_isEditMode) {
        ref.read(createUserFormProvider.notifier).updateFormData('_isEditMode', true);
        _loadUserData();
      }
    });
  }

  @override
  void dispose() {
    // Reset form data when leaving the screen - autoDispose will handle provider cleanup
    ref.read(createUserFormProvider.notifier).reset();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    if (widget.userId == null) return;
    
    setState(() {
      _isLoadingUserData = true;
    });

    try {
      final dataSource = UserAccountRemoteDataSourceImpl();
      final service = UserAccountService(dataSource);
      final result = await service.getUserAccountById(widget.userId!);
      
      if (result != null && result['data'] != null && mounted) {
        final dto = result['data'] as UserAccountDto;
        final notifier = ref.read(createUserFormProvider.notifier);
        
        // Pre-fill form with user data
        notifier.updateFormData('username', dto.username);
        notifier.updateFormData('emailAddress', dto.emailAddress);
        notifier.updateFormData('accountType', AccountTypeMapper.toUiFormat(dto.accountType));
        // Map account status from API format (ACTIVE/INACTIVE) to UI format (Active/Inactive)
        final accountStatus = dto.accountStatus.toUpperCase();
        notifier.updateFormData('accountStatus', accountStatus == 'ACTIVE' ? 'Active' : accountStatus == 'INACTIVE' ? 'Inactive' : dto.accountStatus);
        notifier.updateFormData('startDate', dto.startDate != null ? _formatDateForInput(dto.startDate!) : '');
        notifier.updateFormData('endDate', dto.endDate != null ? _formatDateForInput(dto.endDate!) : '');
        notifier.updateFormData('mustChangePassword', dto.mustChangePwdFlag.toUpperCase() == 'Y');
        notifier.updateFormData('passwordNeverExpires', dto.pwdNeverExpiresFlag.toUpperCase() == 'Y');
        notifier.updateFormData('mfaEnabled', dto.mfaEnabledFlag.toUpperCase() == 'Y');
        notifier.updateFormData('preferredLanguage', _mapLanguageCodeToName(dto.preferredLanguage));
        notifier.updateFormData('timezoneCode', _mapTimezoneCodeToName(dto.timezoneCode));
        notifier.updateFormData('dateFormat', _mapDateFormatToName(dto.dateFormat));
        notifier.updateFormData('firstName', dto.firstName ?? '');
        notifier.updateFormData('middleName', dto.middleName ?? '');
        notifier.updateFormData('lastName', dto.lastName ?? '');
        notifier.updateFormData('displayName', dto.displayName ?? '');
        notifier.updateFormData('employeeNumber', dto.employeeNumber ?? '');
        notifier.updateFormData('departmentName', dto.departmentName ?? '');
        notifier.updateFormData('jobTitle', dto.jobTitle ?? '');
        notifier.updateFormData('phoneNumber', dto.phoneNumber ?? '');
        notifier.updateFormData('managerEmail', dto.managerEmail ?? '');
        notifier.updateFormData('descriptionNotes', dto.descriptionNotes ?? '');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading user data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUserData = false;
        });
      }
    }
  }

  String _formatDateForInput(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MM/dd/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _mapLanguageCodeToName(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return 'English';
      case 'ar':
        return 'Arabic';
      default:
        return 'English';
    }
  }

  String _mapTimezoneCodeToName(String code) {
    switch (code.toUpperCase()) {
      case 'UTC':
        return 'UTC (Coordinated Universal Time)';
      case 'EST':
        return 'EST (Eastern Standard Time)';
      case 'PST':
        return 'PST (Pacific Standard Time)';
      default:
        return 'UTC (Coordinated Universal Time)';
    }
  }

  String _mapDateFormatToName(String format) {
    switch (format) {
      case 'MM/DD/YYYY':
        return 'MM/DD/YYYY (12/31/2024)';
      case 'YYYY-MM-DD':
        return 'YYYY-MM-DD (2024-12-31)';
      case 'DD/MM/YYYY':
        return 'DD/MM/YYYY (31/12/2024)';
      default:
        return 'MM/DD/YYYY (12/31/2024)';
    }
  }

  Future<void> _handleUpdateUser(BuildContext context, WidgetRef ref) async {
    await _handleCreateUser(context, ref);
  }

  Future<void> _handleCreateUser(BuildContext context, WidgetRef ref) async {
    final formState = ref.read(createUserFormProvider);
    final formData = formState.formData;

    // Validation
    final username = formData['username']?.toString().trim() ?? '';
    final emailAddress = formData['emailAddress']?.toString().trim() ?? '';
    final password = formData['password']?.toString() ?? '';
    final confirmPassword = formData['confirmPassword']?.toString() ?? '';
    final accountType = formData['accountType']?.toString() ?? 'Local';
    final accountStatus = formData['accountStatus']?.toString() ?? 'Active';
    final startDate = formData['startDate']?.toString();
    final endDate = formData['endDate']?.toString();
    final firstName = formData['firstName']?.toString().trim() ?? '';
    final middleName = formData['middleName']?.toString().trim();
    final lastName = formData['lastName']?.toString().trim() ?? '';
    final displayName = formData['displayName']?.toString().trim();
    final mustChangePassword = formData['mustChangePassword'] as bool? ?? true;
    final passwordNeverExpires = formData['passwordNeverExpires'] as bool? ?? false;
    final mfaEnabled = formData['mfaEnabled'] as bool? ?? false;
    final preferredLanguage = formData['preferredLanguage']?.toString() ?? 'English';
    final timezoneCode = formData['timezoneCode']?.toString() ?? 'UTC';
    final dateFormat = formData['dateFormat']?.toString() ?? 'MM/DD/YYYY';
    final employeeNumber = formData['employeeNumber']?.toString().trim();
    final departmentName = formData['departmentName']?.toString().trim();
    final jobTitle = formData['jobTitle']?.toString().trim();
    final phoneNumber = formData['phoneNumber']?.toString().trim();
    final managerEmail = formData['managerEmail']?.toString().trim();
    final descriptionNotes = formData['descriptionNotes']?.toString().trim();

    // Validate required fields
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username is required'), backgroundColor: Colors.red),
      );
      return;
    }
    if (emailAddress.isEmpty || !emailAddress.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valid email address is required'), backgroundColor: Colors.red),
      );
      return;
    }
    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('First name and last name are required'), backgroundColor: Colors.red),
      );
      return;
    }
    // Password validation only for create mode
    if (!_isEditMode) {
      if (password.isEmpty || password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password must be at least 6 characters'), backgroundColor: Colors.red),
        );
        return;
      }
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red),
        );
        return;
      }
    }
    
    if (startDate == null || startDate.isEmpty || startDate.contains('dd') || startDate.contains('mm') || startDate.contains('yyyy')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start date is required'), backgroundColor: Colors.red),
      );
      return;
    }

    // Show loading
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) => PopScope(
        canPop: false, // Prevent closing by back button
        child: const Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      final dataSource = UserAccountRemoteDataSourceImpl();
      final service = UserAccountService(dataSource);

      // Format dates
      String? formattedStartDate;
      String? formattedEndDate;
      try {
        if (startDate.isNotEmpty && !startDate.contains('dd') && !startDate.contains('mm') && !startDate.contains('yyyy')) {
          // Try multiple date formats
          DateTime? parsedDate;
          final formats = ['MM/dd/yyyy', 'yyyy-MM-dd', 'dd/MM/yyyy', 'MM-dd-yyyy'];
          for (final format in formats) {
            try {
              parsedDate = DateFormat(format).parse(startDate);
              break;
            } catch (_) {
              continue;
            }
          }
          if (parsedDate != null) {
            formattedStartDate = parsedDate.toIso8601String();
          } else {
            formattedStartDate = startDate; // Use as-is if parsing fails
          }
        } else if (startDate.isNotEmpty) {
          // Placeholder text, use current date or empty
          formattedStartDate = null;
        }
        
        if (endDate != null && endDate.isNotEmpty && !endDate.contains('dd') && !endDate.contains('mm') && !endDate.contains('yyyy')) {
          DateTime? parsedDate;
          final formats = ['MM/dd/yyyy', 'yyyy-MM-dd', 'dd/MM/yyyy', 'MM-dd-yyyy'];
          for (final format in formats) {
            try {
              parsedDate = DateFormat(format).parse(endDate);
              break;
            } catch (_) {
              continue;
            }
          }
          if (parsedDate != null) {
            formattedEndDate = parsedDate.toIso8601String();
          } else {
            formattedEndDate = endDate; // Use as-is if parsing fails
          }
        }
      } catch (e) {
        // If parsing fails, use as-is (assuming ISO format)
        formattedStartDate = startDate.isNotEmpty && !startDate.contains('dd') ? startDate : null;
        formattedEndDate = endDate != null && endDate.isNotEmpty && !endDate.contains('dd') ? endDate : null;
      }

      // Map language name to code
      String languageCode = 'en';
      if (preferredLanguage.toLowerCase().contains('english')) {
        languageCode = 'en';
      } else if (preferredLanguage.toLowerCase().contains('arabic')) {
        languageCode = 'ar';
      }

      // Extract timezone code from display string
      String tzCode = 'UTC';
      if (timezoneCode.contains('UTC')) {
        tzCode = 'UTC';
      } else {
        // Extract code from string like "UTC (Coordinated Universal Time)"
        final match = RegExp(r'^(\w+)').firstMatch(timezoneCode);
        if (match != null) {
          tzCode = match.group(1) ?? 'UTC';
        }
      }

      // Extract date format code
      String dateFormatCode = 'MM/DD/YYYY';
      if (dateFormat.contains('YYYY-MM-DD')) {
        dateFormatCode = 'YYYY-MM-DD';
      } else if (dateFormat.contains('DD/MM/YYYY')) {
        dateFormatCode = 'DD/MM/YYYY';
      } else {
        dateFormatCode = 'MM/DD/YYYY';
      }

      if (_isEditMode && widget.userId != null) {
        // Update existing user
        final updateResponse = await service.updateUserAccount(
          userId: widget.userId!,
          username: username,
          emailAddress: emailAddress,
          password: password.isNotEmpty ? password : null, // Only send password if provided
          accountType: accountType,
          accountStatus: accountStatus,
          startDate: formattedStartDate,
          endDate: formattedEndDate,
          mustChangePassword: mustChangePassword,
          passwordNeverExpires: passwordNeverExpires,
          mfaEnabled: mfaEnabled,
          preferredLanguage: languageCode,
          timezoneCode: tzCode,
          dateFormat: dateFormatCode,
          firstName: firstName,
          middleName: middleName?.isEmpty == true ? null : middleName,
          lastName: lastName,
          displayName: displayName?.isEmpty == true ? null : displayName,
          employeeNumber: employeeNumber?.isEmpty == true ? null : employeeNumber,
          departmentName: departmentName?.isEmpty == true ? null : departmentName,
          jobTitle: jobTitle?.isEmpty == true ? null : jobTitle,
          phoneNumber: phoneNumber?.isEmpty == true ? null : phoneNumber,
          managerEmail: managerEmail?.isEmpty == true ? null : managerEmail,
          descriptionNotes: descriptionNotes?.isEmpty == true ? null : descriptionNotes,
          updatedBy: 'ADMIN',
        );

        if (context.mounted) {
          // Close loading dialog first - use rootNavigator to ensure it's closed
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          
          // Wait a frame to ensure loading dialog is fully closed
          await Future.delayed(const Duration(milliseconds: 100));
          
          // Extract employee number from response
          String? empNumber;
          if (updateResponse.containsKey('data') && updateResponse['data'] is Map) {
            final data = updateResponse['data'] as Map<String, dynamic>;
            empNumber = data['employee_number']?.toString() ?? 
                       data['employeeNumber']?.toString();
          } else {
            empNumber = updateResponse['employee_number']?.toString() ?? 
                       updateResponse['employeeNumber']?.toString();
          }
          
          // Show success dialog - use rootNavigator to ensure it's on top
          if (context.mounted) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final size = MediaQuery.of(context).size;
            final isMobile = size.width < 600;
            final screenContext = context; // Store screen context
            
            await showDialog(
              context: context,
              barrierDismissible: false,
              useRootNavigator: true,
              builder: (dialogContext) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: 24,
                ),
                child: _buildSuccessDialogContent(
                  dialogContext: dialogContext,
                  screenContext: screenContext,
                  isDark: isDark,
                  isMobile: isMobile,
                  message: empNumber != null && empNumber.isNotEmpty
                      ? 'User with Employee no $empNumber successfully updated'
                      : 'User account successfully updated',
                  empNumber: empNumber,
                ),
              ),
            );
          }
        }
      } else {
        // Create new user
        final createResponse = await service.createUserAccount(
          username: username,
          emailAddress: emailAddress,
          password: password,
          accountType: accountType,
          accountStatus: accountStatus,
          startDate: formattedStartDate,
          endDate: formattedEndDate,
          mustChangePassword: mustChangePassword,
          passwordNeverExpires: passwordNeverExpires,
          mfaEnabled: mfaEnabled,
          preferredLanguage: languageCode,
          timezoneCode: tzCode,
          dateFormat: dateFormatCode,
          firstName: firstName,
          middleName: middleName?.isEmpty == true ? null : middleName,
          lastName: lastName,
          displayName: displayName?.isEmpty == true ? null : displayName,
          employeeNumber: employeeNumber?.isEmpty == true ? null : employeeNumber,
          departmentName: departmentName?.isEmpty == true ? null : departmentName,
          jobTitle: jobTitle?.isEmpty == true ? null : jobTitle,
          phoneNumber: phoneNumber?.isEmpty == true ? null : phoneNumber,
          managerEmail: managerEmail?.isEmpty == true ? null : managerEmail,
          descriptionNotes: descriptionNotes?.isEmpty == true ? null : descriptionNotes,
          createdBy: 'ADMIN',
        );

        if (context.mounted) {
          // Close loading dialog first - use rootNavigator to ensure it's closed
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          
          // Wait a frame to ensure loading dialog is fully closed
          await Future.delayed(const Duration(milliseconds: 100));
          
          // Extract employee number from response
          String? empNumber;
          if (createResponse.containsKey('data') && createResponse['data'] is Map) {
            final data = createResponse['data'] as Map<String, dynamic>;
            empNumber = data['employee_number']?.toString() ?? 
                       data['employeeNumber']?.toString();
          } else {
            empNumber = createResponse['employee_number']?.toString() ?? 
                       createResponse['employeeNumber']?.toString();
          }
          
          // Show success dialog - use rootNavigator to ensure it's on top
          if (context.mounted) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final size = MediaQuery.of(context).size;
            final isMobile = size.width < 600;
            final screenContext = context; // Store screen context
            
            await showDialog(
              context: context,
              barrierDismissible: false,
              useRootNavigator: true,
              builder: (dialogContext) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: 24,
                ),
                child: _buildSuccessDialogContent(
                  dialogContext: dialogContext,
                  screenContext: screenContext,
                  isDark: isDark,
                  isMobile: isMobile,
                  message: empNumber != null && empNumber.isNotEmpty
                      ? 'User with Employee no $empNumber successfully created'
                      : 'User account successfully created',
                  empNumber: empNumber,
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      // Ensure loader is closed even if there's an error
      if (context.mounted) {
        // Close loading dialog - try multiple approaches to ensure it closes
        try {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        } catch (_) {
          // If pop fails, try alternative approach
        }
        
        // Small delay to ensure dialog is closed before showing snackbar
        Future.delayed(const Duration(milliseconds: 100), () {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final formState = ref.watch(createUserFormProvider);
        final size = MediaQuery.of(context).size;
        final isMobile = size.width < 768;

        if (_isLoadingUserData) {
          return Scaffold(
            backgroundColor: context.themeBackground,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

    return Scaffold(
      backgroundColor: context.themeBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                // Cancel Button
                InkWell(
                  onTap: () {
                    // Navigate back to user accounts list
                    context.goNamed('user-accounts');
                  },
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.close,
                          size: 16,
                          color: context.themeTextPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.7,
                            fontWeight: FontWeight.w500,
                            color: context.themeTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 24,
                    color: Color(0xFF155DFC),
                  ),
                ),
                const SizedBox(width: 12),
                // Title and Subtitle
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final isEditMode = ref.watch(createUserFormProvider).formData['_isEditMode'] as bool? ?? false;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditMode ? 'Edit User Account' : 'Create User Account',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15.1,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF0F172B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isEditMode ? 'Update user account information' : 'Add a new user to the system',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF4A5565),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (!isMobile) ...[
                  // Reset Button
                  InkWell(
                    onTap: () {
                      // Reset form to initial state
                      ref.read(createUserFormProvider.notifier).reset();
                    },
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.1),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            size: 16,
                            color: context.themeTextPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Reset',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.8,
                              fontWeight: FontWeight.w500,
                              color: context.themeTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Create/Update User Button
                  InkWell(
                    onTap: () => _isEditMode 
                        ? _handleUpdateUser(context, ref)
                        : _handleCreateUser(context, ref),
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
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isEditMode ? 'Update User' : 'Create User',
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
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // Tabs Section (responsive + fixed border clipping)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(4), // prevent border cut
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    // Simple breakpoints based on available width
                    final bool isCompact = width < 420;
                    final bool isMedium = width >= 420 && width < 900;

                    final double tabHeight = isCompact
                        ? 44
                        : isMedium
                        ? 52
                        : 56;

                    final double fontSize = isCompact
                        ? 11.5
                        : isMedium
                        ? 12.8
                        : 13.6;

                    final tabs = List.generate(5, (index) {
                      final isCompleted =
                      formState.completedSteps.contains(index);
                      final isActive = formState.currentStep == index;

                      // In compact mode we'll set fixed width; otherwise Expanded
                      if (isCompact) {
                        return SizedBox(
                          width: 140,
                          height: tabHeight,
                          child: _buildTab(
                            context: context,
                            ref: ref,
                            index: index,
                            isCompleted: isCompleted,
                            isActive: isActive,
                            fontSize: fontSize,
                            onTap: null, // Disabled - tabs are not clickable
                          ),
                        );
                      } else {
                        return Expanded(
                          child: SizedBox(
                            height: tabHeight,
                            child: _buildTab(
                              context: context,
                              ref: ref,
                              index: index,
                              isCompleted: isCompleted,
                              isActive: isActive,
                              fontSize: fontSize,
                              onTap: null, // Disabled - tabs are not clickable
                            ),
                          ),
                        );
                      }
                    });

                    if (isCompact) {
                      // Horizontal scroll on very small widths
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: tabs),
                      );
                    }

                    return Row(children: tabs);
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Form Content
            CreateUserFormSteps(
              onCreateUser: () => _handleCreateUser(context, ref),
            ),

            const SizedBox(height: 24),

            // Footer Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.1),
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Color(0xFF4A5565),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.6,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4A5565),
                      ),
                      children: [
                        TextSpan(text: 'Fields marked with '),
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Color(0xFFFB2C36)),
                        ),
                        TextSpan(text: ' are required'),
                      ],
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
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required WidgetRef ref,
    required int index,
    required bool isCompleted,
    required bool isActive,
    required double fontSize,
    VoidCallback? onTap,
  }) {
    final titles = [
      'Account Details',
      'Personal Information',
      'Security Settings',
      'Additional Information',
      'System Settings',
    ];

    final icons = [
      Assets.icons.userIcon.path,
      Assets.icons.userIcon.path,
      Assets.icons.securityConsoleIcon.path,
      Assets.icons.additionalInfoIcon.path,
      Assets.icons.systemSettingIcon.path,
    ];

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    Color iconColor;

    if (isActive) {
      // Active tab: Light blue background, dark blue underline and text
      backgroundColor = const Color(0xFFEFF6FF);
      borderColor = const Color(0xFF155DFC);
      textColor = const Color(0xFF1C398E);
      iconColor = const Color(0xFF155DFC);
    } else {
      // Inactive tab: White background, gray underline and text
      backgroundColor = Colors.white;
      borderColor = const Color(0xFFE5E7EB);
      textColor = const Color(0xFF4A5565);
      iconColor = const Color(0xFF9CA3AF);
    }

    return InkWell(
      onTap: onTap, // null for disabled tabs
      child: Opacity(
        opacity: onTap != null ? 1.0 : 0.6, // Visual indication that tab is disabled
        child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(color: borderColor, width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icons[index],
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                titles[index],
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildSuccessDialogContent({
    required BuildContext dialogContext,
    required BuildContext screenContext,
    required bool isDark,
    required bool isMobile,
    required String message,
    String? empNumber,
  }) {
    return Container(
      width: isMobile ? double.infinity : 400,
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Success',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17.3,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF0F172B),
                      height: 1.04,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(dialogContext, rootNavigator: true).pop();
                    // Navigate back to listing when close button is clicked
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (screenContext.mounted) {
                        final navigator = Navigator.of(screenContext, rootNavigator: true);
                        while (navigator.canPop()) {
                          navigator.pop();
                        }
                        screenContext.goNamed('user-accounts');
                      }
                    });
                  },
                  icon: const Icon(Icons.close, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Message
            Text(
              message,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF717182),
                height: 1.47,
              ),
            ),
            if (empNumber != null && empNumber.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Employee No: $empNumber',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.6,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Button
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                  // Ensure any remaining dialogs are closed
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Close any remaining dialogs (like loading dialog)
                    if (screenContext.mounted) {
                      final navigator = Navigator.of(screenContext, rootNavigator: true);
                      while (navigator.canPop()) {
                        navigator.pop();
                      }
                      // Navigate back to listing
                      screenContext.goNamed('user-accounts');
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Okay',
                  style: TextStyle(
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
      ),
    );
  }
}
