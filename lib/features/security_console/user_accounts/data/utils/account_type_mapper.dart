/// Utility class for mapping account types between UI format and API format
class AccountTypeMapper {
  /// Maps API format to UI format
  /// API: "EMPLOYEE" or "Local" → UI: "Local" (for backward compatibility)
  /// API: "SSO" → UI: "SSO"
  static String toUiFormat(String? apiAccountType) {
    if (apiAccountType == null || apiAccountType.isEmpty) {
      return 'Local'; // Default
    }
    
    final normalized = apiAccountType.trim().toUpperCase();
    // Handle both "EMPLOYEE" (old format) and "Local" (new format) from API
    if (normalized == 'EMPLOYEE' || normalized == 'LOCAL') {
      return 'Local';
    } else if (normalized == 'SSO') {
      return 'SSO';
    }
    
    // Default fallback
    return 'Local';
  }
}

