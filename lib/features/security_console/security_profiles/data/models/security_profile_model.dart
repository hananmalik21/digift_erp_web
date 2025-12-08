class SecurityProfileModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final String category;
  final String status;
  final int usersAssigned;
  final List<String> permissions;
  final String createdDate;

  SecurityProfileModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.category,
    required this.status,
    required this.usersAssigned,
    required this.permissions,
    required this.createdDate,
  });
}

// Sample data
final List<SecurityProfileModel> sampleSecurityProfiles = [
  SecurityProfileModel(
    id: 'SP-001',
    name: 'Fixed Assets Profile',
    code: 'FA_USER',
    description: 'Asset tracking and depreciation',
    category: 'Fixed Assets',
    status: 'Active',
    usersAssigned: 10,
    permissions: ['Read', 'Create', 'Update'],
    createdDate: '2024-02-15',
  ),
  SecurityProfileModel(
    id: 'SP-002',
    name: 'GL Full Access Profile',
    code: 'GL_FULL',
    description: 'Complete access to all General Ledger functions',
    category: 'General Ledger',
    status: 'Active',
    usersAssigned: 15,
    permissions: ['Read', 'Create', 'Update', 'Delete', 'Approve'],
    createdDate: '2024-01-15',
  ),
  SecurityProfileModel(
    id: 'SP-003',
    name: 'AP Manager Profile',
    code: 'AP_MGR',
    description: 'Full access to AP with approval rights',
    category: 'Accounts Payable',
    status: 'Active',
    usersAssigned: 8,
    permissions: ['Read', 'Create', 'Update', 'Delete', 'Approve'],
    createdDate: '2024-01-20',
  ),
  SecurityProfileModel(
    id: 'SP-004',
    name: 'AP Clerk Profile',
    code: 'AP_CLERK',
    description: 'Invoice entry and basic AP operations',
    category: 'Accounts Payable',
    status: 'Active',
    usersAssigned: 25,
    permissions: ['Read', 'Create', 'Update'],
    createdDate: '2024-01-20',
  ),
  SecurityProfileModel(
    id: 'SP-005',
    name: 'Cash Manager Profile',
    code: 'CASH_MGR',
    description: 'Cash management and bank reconciliation',
    category: 'Cash Management',
    status: 'Active',
    usersAssigned: 5,
    permissions: ['Read', 'Create', 'Update', 'Delete', 'Approve'],
    createdDate: '2024-02-10',
  ),
  SecurityProfileModel(
    id: 'SP-006',
    name: 'GL Manager',
    code: 'GLMAN001',
    description: '',
    category: 'General Ledger',
    status: 'Active',
    usersAssigned: 0,
    permissions: ['Read', 'Create', 'Update', 'Delete', 'Approve'],
    createdDate: '2025-12-02',
  ),
  SecurityProfileModel(
    id: 'SP-007',
    name: 'GL Read Only Profile',
    code: 'GL_READ',
    description: 'Read-only access to General Ledger',
    category: 'General Ledger',
    status: 'Active',
    usersAssigned: 35,
    permissions: ['Read'],
    createdDate: '2024-01-15',
  ),
  SecurityProfileModel(
    id: 'SP-008',
    name: 'AR Specialist Profile',
    code: 'AR_SPEC',
    description: 'Invoice and receipt processing',
    category: 'Accounts Receivable',
    status: 'Active',
    usersAssigned: 20,
    permissions: ['Read', 'Create', 'Update'],
    createdDate: '2024-02-01',
  ),
  SecurityProfileModel(
    id: 'SP-009',
    name: 'AR Manager Profile',
    code: 'AR_MGR',
    description: 'Full access to AR with approval rights',
    category: 'Accounts Receivable',
    status: 'Active',
    usersAssigned: 6,
    permissions: ['Read', 'Create', 'Update', 'Delete', 'Approve'],
    createdDate: '2024-02-01',
  ),
];


