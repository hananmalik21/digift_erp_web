class RoleModel {
  final String id;
  final String name;
  final String code;
  final String type;
  final String status;
  final int usersAssigned;
  final int privileges;
  final String createdOn;
  final String description;

  RoleModel({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.status,
    required this.usersAssigned,
    required this.privileges,
    required this.createdOn,
    required this.description,
  });
}

// Sample data
final List<RoleModel> sampleRoles = [
  RoleModel(
    id: 'ROLE-001',
    name: 'Finance Manager',
    code: 'FIN_MGR_001',
    type: 'Job Role',
    status: 'Active',
    usersAssigned: 12,
    privileges: 45,
    createdOn: '2023-01-15',
    description: 'Full access to financial modules',
  ),
  RoleModel(
    id: 'ROLE-002',
    name: 'GL Accountant',
    code: 'GL_ACC_001',
    type: 'Duty Role',
    status: 'Active',
    usersAssigned: 25,
    privileges: 32,
    createdOn: '2023-02-10',
    description: 'General Ledger accounting functions',
  ),
  RoleModel(
    id: 'ROLE-003',
    name: 'AP Clerk',
    code: 'AP_CLK_001',
    type: 'Duty Role',
    status: 'Active',
    usersAssigned: 18,
    privileges: 22,
    createdOn: '2023-02-15',
    description: 'Accounts Payable processing',
  ),
  RoleModel(
    id: 'ROLE-004',
    name: 'AR Clerk',
    code: 'AR_CLK_001',
    type: 'Duty Role',
    status: 'Active',
    usersAssigned: 15,
    privileges: 20,
    createdOn: '2023-02-20',
    description: 'Accounts Receivable processing',
  ),
  RoleModel(
    id: 'ROLE-005',
    name: 'Treasury Manager',
    code: 'TRS_MGR_001',
    type: 'Job Role',
    status: 'Active',
    usersAssigned: 5,
    privileges: 38,
    createdOn: '2023-03-01',
    description: 'Treasury and cash management',
  ),
  RoleModel(
    id: 'ROLE-006',
    name: 'System Admin',
    code: 'SYS_ADM_001',
    type: 'Job Role',
    status: 'Active',
    usersAssigned: 3,
    privileges: 120,
    createdOn: '2023-01-01',
    description: 'Full system administration access',
  ),
  RoleModel(
    id: 'ROLE-007',
    name: 'Auditor',
    code: 'AUD_001',
    type: 'Job Role',
    status: 'Active',
    usersAssigned: 8,
    privileges: 55,
    createdOn: '2023-03-10',
    description: 'Audit and compliance review',
  ),
  RoleModel(
    id: 'ROLE-008',
    name: 'Fixed Assets Clerk',
    code: 'FA_CLK_001',
    type: 'Duty Role',
    status: 'Inactive',
    usersAssigned: 0,
    privileges: 15,
    createdOn: '2023-04-01',
    description: 'Fixed assets management',
  ),
];

