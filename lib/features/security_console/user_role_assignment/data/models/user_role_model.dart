class UserRoleModel {
  final String id;
  final String name;
  final String username;
  final String department;
  final String email;
  final List<String> assignedRoles;
  final String avatarUrl;
  final bool isCurrentUser;

  UserRoleModel({
    required this.id,
    required this.name,
    required this.username,
    required this.department,
    required this.email,
    required this.assignedRoles,
    required this.avatarUrl,
    this.isCurrentUser = false,
  });
}

// Sample data matching Figma design
final List<UserRoleModel> sampleUserRoles = [
  UserRoleModel(
    id: 'USR-001',
    name: 'khruam shahzad',
    username: 'khuram',
    department: 'Not specified',
    email: 'khruampwc@gmail.com',
    assignedRoles: [],
    avatarUrl: '',
  ),
  UserRoleModel(
    id: 'USR-002',
    name: 'hanankhal84',
    username: 'hanankhal84',
    department: 'Not specified',
    email: 'hanankhal84@gmail.com',
    assignedRoles: ['User'],
    avatarUrl: '',
  ),
  UserRoleModel(
    id: 'USR-003',
    name: 'finance',
    username: 'finance',
    department: 'Not specified',
    email: 'finance@digify.com',
    assignedRoles: ['User', 'System Administrator', 'GL Manager', 'GL Accountant', 'Finance Manager'],
    avatarUrl: '',
  ),
  UserRoleModel(
    id: 'd64bc913-5402-4e36-9642-56bfe37197b4',
    name: 'Admin User',
    username: 'admin',
    department: 'Not specified',
    email: 'admin@digify.com',
    assignedRoles: [
      'System Administrator',
      'Security Administrator',
      'Finance Manager',
      'User Administrator',
      'GL Accountant',
      'GL Manager',
      'Accounting Manager'
    ],
    avatarUrl: '',
    isCurrentUser: true,
  ),
  UserRoleModel(
    id: 'USR-005',
    name: 'khuram',
    username: 'khurampwc',
    department: 'Not specified',
    email: 'khurampwc@gmail.com',
    assignedRoles: ['System Administrator', 'Finance Manager', 'GL Manager', 'Accounting Manager'],
    avatarUrl: '',
  ),
];
