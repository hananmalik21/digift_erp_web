class UserAccountModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String department;
  final String position;
  final String status;
  final bool mfaEnabled;
  final String lastLogin;
  final String accountCreated;
  final String passwordChanged;
  final List<String> roles;

  // Convenience getters for compatibility
  String get userId => id;
  String get createdDate => accountCreated;

  UserAccountModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.department,
    required this.position,
    required this.status,
    required this.mfaEnabled,
    required this.lastLogin,
    required this.accountCreated,
    required this.passwordChanged,
    required this.roles,
  });
}

// Sample data
final List<UserAccountModel> sampleUserAccounts = [
  UserAccountModel(
    id: 'USR-001',
    name: 'Ahmed Hassan',
    username: 'ahmed.hassan',
    email: 'ahmed.hassan@digify.com',
    department: 'Finance',
    position: 'Financial Controller',
    status: 'Active',
    mfaEnabled: true,
    lastLogin: '2024-12-04 09:30 AM',
    accountCreated: '2023-01-15',
    passwordChanged: '2024-10-15',
    roles: ['Finance Manager', 'GL Accountant'],
  ),
  UserAccountModel(
    id: 'USR-002',
    name: 'Sarah Ahmed',
    username: 'sarah.ahmed',
    email: 'sarah.ahmed@digify.com',
    department: 'IT',
    position: 'System Administrator',
    status: 'Active',
    mfaEnabled: true,
    lastLogin: '2024-12-04 10:15 AM',
    accountCreated: '2023-02-20',
    passwordChanged: '2024-11-01',
    roles: ['System Admin'],
  ),
  UserAccountModel(
    id: 'USR-003',
    name: 'Mohammed Ali',
    username: 'mohammed.ali',
    email: 'mohammed.ali@digify.com',
    department: 'Accounting',
    position: 'Senior Accountant',
    status: 'Active',
    mfaEnabled: false,
    lastLogin: '2024-12-03 04:45 PM',
    accountCreated: '2023-03-10',
    passwordChanged: '2024-09-22',
    roles: ['AP Clerk', 'AR Clerk'],
  ),
  UserAccountModel(
    id: 'USR-004',
    name: 'Fatima Khan',
    username: 'fatima.khan',
    email: 'fatima.khan@digify.com',
    department: 'Finance',
    position: 'Junior Accountant',
    status: 'Inactive',
    mfaEnabled: false,
    lastLogin: '2024-11-25 02:20 PM',
    accountCreated: '2023-06-01',
    passwordChanged: '2024-08-10',
    roles: ['GL Accountant'],
  ),
  UserAccountModel(
    id: 'USR-005',
    name: 'Omar Khalil',
    username: 'omar.khalil',
    email: 'omar.khalil@digify.com',
    department: 'Treasury',
    position: 'Treasury Manager',
    status: 'Active',
    mfaEnabled: true,
    lastLogin: '2024-12-04 08:00 AM',
    accountCreated: '2023-04-12',
    passwordChanged: '2024-11-20',
    roles: ['Treasury Manager', 'Cash Manager'],
  ),
  UserAccountModel(
    id: 'USR-006',
    name: 'Laila Ibrahim',
    username: 'laila.ibrahim',
    email: 'laila.ibrahim@digify.com',
    department: 'Audit',
    position: 'Internal Auditor',
    status: 'Active',
    mfaEnabled: true,
    lastLogin: '2024-12-04 09:00 AM',
    accountCreated: '2023-05-18',
    passwordChanged: '2024-10-28',
    roles: ['Auditor'],
  ),
];

