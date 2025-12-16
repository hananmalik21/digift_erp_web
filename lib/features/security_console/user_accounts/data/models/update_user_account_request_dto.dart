class UpdateUserAccountRequestDto {
  // USERS table fields
  final String username;
  final String emailAddress;
  final String? password;
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
  final String updatedBy;
  
  // USER_PERSONAL_INFO table fields
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? displayName;
  
  // USER_ADDITIONAL_INFO table fields
  final String? employeeNumber;
  final String? departmentName;
  final String? jobTitle;
  final String? phoneNumber;
  final String? managerEmail;
  final String? descriptionNotes;
  
  // Job Roles
  final List<int>? jobRoles;

  UpdateUserAccountRequestDto({
    required this.username,
    required this.emailAddress,
    this.password,
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
    required this.updatedBy,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.displayName,
    this.employeeNumber,
    this.departmentName,
    this.jobTitle,
    this.phoneNumber,
    this.managerEmail,
    this.descriptionNotes,
    this.jobRoles,
  });

  Map<String, dynamic> toJson() {
    return {
      // USERS table
      'username': username,
      'emailAddress': emailAddress,
      if (password != null && password!.isNotEmpty) 'password': password,
      'accountType': accountType,
      'accountStatus': accountStatus,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      'mustChangePwdFlag': mustChangePwdFlag,
      'pwdNeverExpiresFlag': pwdNeverExpiresFlag,
      'mfaEnabledFlag': mfaEnabledFlag,
      'preferredLanguage': preferredLanguage,
      'timezoneCode': timezoneCode,
      'dateFormat': dateFormat,
      'updatedBy': updatedBy,
      
      // USER_PERSONAL_INFO table
      'firstName': firstName,
      if (middleName != null && middleName!.isNotEmpty) 'middleName': middleName,
      'lastName': lastName,
      if (displayName != null && displayName!.isNotEmpty) 'displayName': displayName,
      
      // USER_ADDITIONAL_INFO table
      if (employeeNumber != null && employeeNumber!.isNotEmpty) 'employeeNumber': employeeNumber,
      if (departmentName != null && departmentName!.isNotEmpty) 'departmentName': departmentName,
      if (jobTitle != null && jobTitle!.isNotEmpty) 'jobTitle': jobTitle,
      if (phoneNumber != null && phoneNumber!.isNotEmpty) 'phoneNumber': phoneNumber,
      if (managerEmail != null && managerEmail!.isNotEmpty) 'managerEmail': managerEmail,
      if (descriptionNotes != null && descriptionNotes!.isNotEmpty) 'descriptionNotes': descriptionNotes,
      
      // Job Roles
      if (jobRoles != null) 'jobRoles': jobRoles,
    };
  }
}
