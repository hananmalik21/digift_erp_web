/// Utility class for mapping account types between UI format and API format
class AccountTypeMapper {
  /// Maps UI format to API format
  /// UI: "Local" or "local" → API: "EMPLOYEE"
  /// UI: "SSO" or "sso" → API: "SSO"
  static String toApiFormat(String? uiAccountType) {
    if (uiAccountType == null || uiAccountType.isEmpty) {
      return 'EMPLOYEE'; // Default
    }
    
    final normalized = uiAccountType.trim().toLowerCase();
    if (normalized == 'local') {
      return 'EMPLOYEE';
    } else if (normalized == 'sso') {
      return 'SSO';
    }
    
    // If already in API format, return as is
    if (normalized == 'employee') {
      return 'EMPLOYEE';
    }
    if (normalized == 'sso') {
      return 'SSO';
    }
    
    // Default fallback
    return 'EMPLOYEE';
  }

  /// Maps API format to UI format
  /// API: "EMPLOYEE" → UI: "Local"
  /// API: "SSO" → UI: "SSO"
  static String toUiFormat(String? apiAccountType) {
    if (apiAccountType == null || apiAccountType.isEmpty) {
      return 'Local'; // Default
    }
    
    final normalized = apiAccountType.trim().toUpperCase();
    if (normalized == 'EMPLOYEE') {
      return 'Local';
    } else if (normalized == 'SSO') {
      return 'SSO';
    }
    
    // If already in UI format, return as is
    if (normalized == 'LOCAL') {
      return 'Local';
    }
    
    // Default fallback
    return 'Local';
  }
}

