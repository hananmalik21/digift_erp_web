import 'user_account_model.dart';
import '../../../job_roles/data/models/job_role_model.dart';

class UserAccountDto {
  final int userId;
  final String username;
  final String emailAddress;
  final String? passwordHash;
  final String accountType;
  final String accountStatus;
  final String? startDate;
  final String? endDate;
  final String mustChangePwdFlag;
  final String pwdNeverExpiresFlag;
  final String mfaEnabledFlag;
  final String preferredLanguage;
  final String timezoneCode;
  final String dateFormat;
  final String? creationDate;
  final String? createdBy;
  final String? lastUpdateDate;
  final String? lastUpdatedBy;
  
  // Personal Info fields
  final int? userPersonalId;
  final String? lastName;
  final String? displayName;
  final String? firstName;
  final String? middleName;
  
  // Additional Info fields
  final int? userAdditionalId;
  final String? employeeNumber;
  final String? departmentName;
  final String? jobTitle;
  final String? phoneNumber;
  final String? managerEmail;
  final String? descriptionNotes;
  
  // Job Roles
  final List<JobRoleModel> jobRoles;

  UserAccountDto({
    required this.userId,
    required this.username,
    required this.emailAddress,
    this.passwordHash,
    required this.accountType,
    required this.accountStatus,
    this.startDate,
    this.endDate,
    required this.mustChangePwdFlag,
    required this.pwdNeverExpiresFlag,
    required this.mfaEnabledFlag,
    required this.preferredLanguage,
    required this.timezoneCode,
    required this.dateFormat,
    this.creationDate,
    this.createdBy,
    this.lastUpdateDate,
    this.lastUpdatedBy,
    this.userPersonalId,
    this.lastName,
    this.displayName,
    this.firstName,
    this.middleName,
    this.userAdditionalId,
    this.employeeNumber,
    this.departmentName,
    this.jobTitle,
    this.phoneNumber,
    this.managerEmail,
    this.descriptionNotes,
    this.jobRoles = const [],
  });

  factory UserAccountDto.fromJson(Map<String, dynamic> json) {
    return UserAccountDto(
      userId: json['user_id'] as int? ?? 
              int.tryParse(json['userId']?.toString() ?? '') ?? 
              int.tryParse(json['id']?.toString() ?? '') ?? 
              0,
      username: json['username']?.toString() ?? '',
      emailAddress: json['email_address']?.toString() ?? 
                   json['emailAddress']?.toString() ?? 
                   json['email']?.toString() ?? 
                   '',
      passwordHash: json['password_hash']?.toString() ?? 
                   json['passwordHash']?.toString(),
      accountType: json['account_type']?.toString() ?? 
                  json['accountType']?.toString() ?? 
                  'EMPLOYEE',
      accountStatus: json['account_status']?.toString() ?? 
                    json['accountStatus']?.toString() ?? 
                    json['status']?.toString() ?? 
                    'ACTIVE',
      startDate: json['start_date']?.toString() ?? 
                json['startDate']?.toString(),
      endDate: json['end_date']?.toString() ?? 
              json['endDate']?.toString(),
      mustChangePwdFlag: json['must_change_pwd_flag']?.toString() ?? 
                        json['mustChangePwdFlag']?.toString() ?? 
                        'N',
      pwdNeverExpiresFlag: json['pwd_never_expires_flag']?.toString() ?? 
                          json['pwdNeverExpiresFlag']?.toString() ?? 
                          'N',
      mfaEnabledFlag: json['mfa_enabled_flag']?.toString() ?? 
                     json['mfaEnabledFlag']?.toString() ?? 
                     'N',
      preferredLanguage: json['preferred_language']?.toString() ?? 
                        json['preferredLanguage']?.toString() ?? 
                        'en',
      timezoneCode: json['timezone_code']?.toString() ?? 
                   json['timezoneCode']?.toString() ?? 
                   'UTC',
      dateFormat: json['date_format']?.toString() ?? 
                 json['dateFormat']?.toString() ?? 
                 'MM/DD/YYYY',
      creationDate: json['creation_date']?.toString() ?? 
                   json['creationDate']?.toString() ?? 
                   json['created_at']?.toString(),
      createdBy: json['created_by']?.toString() ?? 
                json['createdBy']?.toString(),
      lastUpdateDate: json['last_update_date']?.toString() ?? 
                     json['lastUpdateDate']?.toString() ?? 
                     json['updated_at']?.toString(),
      lastUpdatedBy: json['last_updated_by']?.toString() ?? 
                    json['lastUpdatedBy']?.toString(),
      userPersonalId: json['user_personal_id'] as int? ?? 
                     int.tryParse(json['userPersonalId']?.toString() ?? ''),
      lastName: json['last_name']?.toString() ?? 
               json['lastName']?.toString(),
      displayName: json['display_name']?.toString() ?? 
                  json['displayName']?.toString(),
      firstName: json['first_name']?.toString() ?? 
                json['firstName']?.toString(),
      middleName: json['middle_name']?.toString() ?? 
                 json['middleName']?.toString(),
      userAdditionalId: json['user_additional_id'] as int? ?? 
                       int.tryParse(json['userAdditionalId']?.toString() ?? ''),
      employeeNumber: json['employee_number']?.toString() ?? 
                     json['employeeNumber']?.toString(),
      departmentName: json['department_name']?.toString() ?? 
                     json['departmentName']?.toString(),
      jobTitle: json['job_title']?.toString() ?? 
               json['jobTitle']?.toString(),
      phoneNumber: json['phone_number']?.toString() ?? 
                  json['phoneNumber']?.toString(),
      managerEmail: json['manager_email']?.toString() ?? 
                   json['managerEmail']?.toString(),
      descriptionNotes: json['description_notes']?.toString() ?? 
                       json['descriptionNotes']?.toString(),
      jobRoles: _parseJobRoles(json['job_roles'] ?? json['jobRoles']),
    );
  }

  /// Parses job_roles array from JSON
  static List<JobRoleModel> _parseJobRoles(dynamic jobRolesData) {
    if (jobRolesData == null) return [];
    if (jobRolesData is! List) return [];
    
    return jobRolesData.map((item) {
      // If item is a Map, try to parse it as a job role object
      if (item is Map<String, dynamic>) {
        // Try to create a minimal JobRoleModel from the data
        return JobRoleModel(
          id: item['job_role_id']?.toString() ?? 
              item['jobRoleId']?.toString() ?? 
              item['id']?.toString() ?? 
              '',
          name: item['job_role_name']?.toString() ?? 
                item['jobRoleName']?.toString() ?? 
                item['name']?.toString() ?? 
                '',
          code: item['job_role_code']?.toString() ?? 
                item['jobRoleCode']?.toString() ?? 
                item['code']?.toString() ?? 
                '',
          description: item['description']?.toString() ?? '',
          department: item['department']?.toString() ?? 'Unknown',
          status: item['status']?.toString() ?? 'ACTIVE',
          usersAssigned: 0,
          privilegesCount: 0,
          dutyRoles: [],
          lastModified: item['updated_at']?.toString() ?? 
                      item['updatedAt']?.toString() ?? 
                      item['created_at']?.toString() ?? 
                      item['createdAt']?.toString() ?? 
                      '',
        );
      }
      // If item is just an ID (int or string), create a minimal model
      else if (item is int || item is String) {
        return JobRoleModel(
          id: item.toString(),
          name: '',
          code: '',
          description: '',
          department: 'Unknown',
          status: 'ACTIVE',
          usersAssigned: 0,
          privilegesCount: 0,
          dutyRoles: [],
          lastModified: '',
        );
      }
      return null;
    }).where((role) => role != null).cast<JobRoleModel>().toList();
  }

  UserAccountModel toModel() {
    // Format account status for display
    final displayStatus = accountStatus.toUpperCase() == 'ACTIVE' 
        ? 'Active' 
        : accountStatus.toUpperCase() == 'INACTIVE' 
            ? 'Inactive' 
            : accountStatus.toUpperCase() == 'LOCKED'
                ? 'Locked'
                : accountStatus;
    
    // Build display name from first and last name if not provided
    final name = displayName ?? 
                (firstName != null && lastName != null 
                    ? '$firstName $lastName' 
                    : username);
    
    // Convert flags to boolean
    final mfaEnabled = mfaEnabledFlag.toUpperCase() == 'Y';
    
    return UserAccountModel(
      id: userId.toString(),
      name: name,
      username: username,
      email: emailAddress,
      department: departmentName ?? '',
      position: jobTitle ?? '',
      status: displayStatus,
      mfaEnabled: mfaEnabled,
      lastLogin: '', // Not in API response
      accountCreated: creationDate ?? '',
      passwordChanged: '', // Not in API response
      roles: [], // Not in API response
      jobRoles: jobRoles,
    );
  }
}
