class SecurityPolicyModel {
  final String id;
  final String name;
  final String code;
  final String severity; // Critical, High, Medium, Low
  final String status; // Active, Draft
  final String category; // Password, Session, Access, Data, API
  final String description;
  final bool isEnforced;
  final int affectedUsers;
  final String modifiedDate;
  final String modifiedBy;

  SecurityPolicyModel({
    required this.id,
    required this.name,
    required this.code,
    required this.severity,
    required this.status,
    required this.category,
    required this.description,
    required this.isEnforced,
    required this.affectedUsers,
    required this.modifiedDate,
    required this.modifiedBy,
  });

  // Sample data
  static List<SecurityPolicyModel> getSamplePolicies() {
    return [
      SecurityPolicyModel(
        id: '1',
        name: 'Password Complexity Policy',
        code: 'PWD_COMPLEX',
        severity: 'Critical',
        status: 'Active',
        category: 'Password',
        description: 'Minimum 8 characters with uppercase, lowercase, number and special character',
        isEnforced: true,
        affectedUsers: 150,
        modifiedDate: '2024-11-15',
        modifiedBy: 'Admin',
      ),
      SecurityPolicyModel(
        id: '2',
        name: 'Session Timeout Policy',
        code: 'SESSION_TIMEOUT',
        severity: 'High',
        status: 'Active',
        category: 'Session',
        description: 'Automatic logout after 30 minutes of inactivity',
        isEnforced: true,
        affectedUsers: 150,
        modifiedDate: '2024-11-20',
        modifiedBy: 'Admin',
      ),
      SecurityPolicyModel(
        id: '3',
        name: 'Multi-Factor Authentication',
        code: 'MFA_REQUIRED',
        severity: 'Critical',
        status: 'Active',
        category: 'Access',
        description: 'MFA required for all privileged users',
        isEnforced: true,
        affectedUsers: 45,
        modifiedDate: '2024-11-25',
        modifiedBy: 'Security Admin',
      ),
      SecurityPolicyModel(
        id: '4',
        name: 'API Rate Limiting',
        code: 'API_RATE_LIMIT',
        severity: 'Medium',
        status: 'Active',
        category: 'API',
        description: 'Maximum 1000 API calls per hour per user',
        isEnforced: true,
        affectedUsers: 30,
        modifiedDate: '2024-11-01',
        modifiedBy: 'IT Admin',
      ),
      SecurityPolicyModel(
        id: '5',
        name: 'Password Expiry Policy',
        code: 'PWD_EXPIRY',
        severity: 'High',
        status: 'Active',
        category: 'Password',
        description: 'Passwords must be changed every 90 days',
        isEnforced: true,
        affectedUsers: 150,
        modifiedDate: '2024-11-10',
        modifiedBy: 'Admin',
      ),
      SecurityPolicyModel(
        id: '6',
        name: 'Data Export Restrictions',
        code: 'DATA_EXPORT',
        severity: 'Critical',
        status: 'Active',
        category: 'Data',
        description: 'Approval required for exporting sensitive financial data',
        isEnforced: true,
        affectedUsers: 80,
        modifiedDate: '2024-10-30',
        modifiedBy: 'Compliance Officer',
      ),
      SecurityPolicyModel(
        id: '7',
        name: 'IP Whitelisting',
        code: 'IP_WHITELIST',
        severity: 'High',
        status: 'Draft',
        category: 'Access',
        description: 'Restrict access to approved IP addresses only',
        isEnforced: false,
        affectedUsers: 0,
        modifiedDate: '2024-11-28',
        modifiedBy: 'Security Admin',
      ),
      SecurityPolicyModel(
        id: '8',
        name: 'Failed Login Attempts',
        code: 'LOGIN_ATTEMPTS',
        severity: 'High',
        status: 'Active',
        category: 'Access',
        description: 'Lock account after 5 failed login attempts',
        isEnforced: true,
        affectedUsers: 150,
        modifiedDate: '2024-11-05',
        modifiedBy: 'Admin',
      ),
    ];
  }
}
