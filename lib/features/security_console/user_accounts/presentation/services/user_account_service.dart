import '../../data/models/create_user_account_request_dto.dart';
import '../../data/models/update_user_account_request_dto.dart';
import '../../data/datasources/user_account_remote_datasource.dart';

class UserAccountService {
  final UserAccountRemoteDataSource dataSource;

  UserAccountService(this.dataSource);

  /// Creates a new user account (inserts into 3 tables)
  Future<Map<String, dynamic>> createUserAccount({
    required String username,
    required String emailAddress,
    required String password,
    required String accountType,
    required String accountStatus,
    String? startDate,
    String? endDate,
    required bool mustChangePassword,
    required bool passwordNeverExpires,
    required bool mfaEnabled,
    required String preferredLanguage,
    required String timezoneCode,
    required String dateFormat,
    required String firstName,
    String? middleName,
    required String lastName,
    String? displayName,
    String? employeeNumber,
    String? departmentName,
    String? jobTitle,
    String? phoneNumber,
    String? managerEmail,
    String? descriptionNotes,
    required String createdBy,
  }) async {
    // Send account type as-is from UI (Local or SSO)
    final apiAccountType = accountType;

    // Map account status from UI to API format
    String apiAccountStatus = accountStatus.toUpperCase();
    if (apiAccountStatus == 'ACTIVE') {
      apiAccountStatus = 'ACTIVE';
    } else if (apiAccountStatus == 'INACTIVE') {
      apiAccountStatus = 'INACTIVE';
    }

    final request = CreateUserAccountRequestDto(
      username: username.trim(),
      emailAddress: emailAddress.trim(),
      password: password,
      accountType: apiAccountType,
      accountStatus: apiAccountStatus,
      startDate: startDate,
      endDate: endDate?.isEmpty == true ? null : endDate,
      mustChangePwdFlag: mustChangePassword ? 'Y' : 'N',
      pwdNeverExpiresFlag: passwordNeverExpires ? 'Y' : 'N',
      mfaEnabledFlag: mfaEnabled ? 'Y' : 'N',
      preferredLanguage: preferredLanguage,
      timezoneCode: timezoneCode,
      dateFormat: dateFormat,
      createdBy: createdBy,
      firstName: firstName.trim(),
      middleName: middleName?.trim().isEmpty == true ? null : middleName?.trim(),
      lastName: lastName.trim(),
      displayName: displayName?.trim().isEmpty == true ? null : displayName?.trim(),
      employeeNumber: employeeNumber?.trim().isEmpty == true ? null : employeeNumber?.trim(),
      departmentName: departmentName?.trim().isEmpty == true ? null : departmentName?.trim(),
      jobTitle: jobTitle?.trim().isEmpty == true ? null : jobTitle?.trim(),
      phoneNumber: phoneNumber?.trim().isEmpty == true ? null : phoneNumber?.trim(),
      managerEmail: managerEmail?.trim().isEmpty == true ? null : managerEmail?.trim(),
      descriptionNotes: descriptionNotes?.trim().isEmpty == true ? null : descriptionNotes?.trim(),
    );

    return await dataSource.createUserAccount(request);
  }

  /// Updates an existing user account
  Future<Map<String, dynamic>> updateUserAccount({
    required int userId,
    required String username,
    required String emailAddress,
    String? password,
    required String accountType,
    required String accountStatus,
    String? startDate,
    String? endDate,
    required bool mustChangePassword,
    required bool passwordNeverExpires,
    required bool mfaEnabled,
    required String preferredLanguage,
    required String timezoneCode,
    required String dateFormat,
    required String firstName,
    String? middleName,
    required String lastName,
    String? displayName,
    String? employeeNumber,
    String? departmentName,
    String? jobTitle,
    String? phoneNumber,
    String? managerEmail,
    String? descriptionNotes,
    List<int>? jobRoles,
    required String updatedBy,
  }) async {
    // Send account type as-is from UI (Local or SSO)
    final apiAccountType = accountType;

    // Map account status from UI to API format
    String apiAccountStatus = accountStatus.toUpperCase();
    if (apiAccountStatus == 'ACTIVE') {
      apiAccountStatus = 'ACTIVE';
    } else if (apiAccountStatus == 'INACTIVE') {
      apiAccountStatus = 'INACTIVE';
    }

    final request = UpdateUserAccountRequestDto(
      username: username.trim(),
      emailAddress: emailAddress.trim(),
      password: password?.isNotEmpty == true ? password : null,
      accountType: apiAccountType,
      accountStatus: apiAccountStatus,
      startDate: startDate,
      endDate: endDate?.isEmpty == true ? null : endDate,
      mustChangePwdFlag: mustChangePassword ? 'Y' : 'N',
      pwdNeverExpiresFlag: passwordNeverExpires ? 'Y' : 'N',
      mfaEnabledFlag: mfaEnabled ? 'Y' : 'N',
      preferredLanguage: preferredLanguage,
      timezoneCode: timezoneCode,
      dateFormat: dateFormat,
      updatedBy: updatedBy,
      firstName: firstName.trim(),
      middleName: middleName?.trim().isEmpty == true ? null : middleName?.trim(),
      lastName: lastName.trim(),
      displayName: displayName?.trim().isEmpty == true ? null : displayName?.trim(),
      employeeNumber: employeeNumber?.trim().isEmpty == true ? null : employeeNumber?.trim(),
      departmentName: departmentName?.trim().isEmpty == true ? null : departmentName?.trim(),
      jobTitle: jobTitle?.trim().isEmpty == true ? null : jobTitle?.trim(),
      phoneNumber: phoneNumber?.trim().isEmpty == true ? null : phoneNumber?.trim(),
      managerEmail: managerEmail?.trim().isEmpty == true ? null : managerEmail?.trim(),
      descriptionNotes: descriptionNotes?.trim().isEmpty == true ? null : descriptionNotes?.trim(),
      jobRoles: jobRoles,
    );

    return await dataSource.updateUserAccount(userId, request);
  }

  /// Fetches a single user account by ID
  Future<Map<String, dynamic>?> getUserAccountById(int userId) async {
    try {
      final dto = await dataSource.getUserAccountById(userId);
      if (dto != null) {
        return {
          'success': true,
          'data': dto,
        };
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user account: ${e.toString()}');
    }
  }

  /// Deletes a user account
  Future<Map<String, dynamic>> deleteUserAccount(int userId) async {
    return await dataSource.deleteUserAccount(userId);
  }

  /// Resets a user's password
  Future<Map<String, dynamic>> resetPassword({
    required int userId,
    required String password,
    required String updatedBy,
  }) async {
    return await dataSource.resetPassword(userId, password, updatedBy);
  }

}
