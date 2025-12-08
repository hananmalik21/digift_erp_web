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
  final String category;

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
    this.category = 'General Ledger',
  });
}

// Sample data
final List<RoleModel> sampleRoles = [
  RoleModel(
    id: 'acc001_1764675185911',
    name: 'Accounting Manager',
    code: 'acc001',
    type: 'Duty',
    status: 'Active',
    usersAssigned: 0,
    privileges: 1,
    createdOn: '12/2/2025',
    description: 'Manage accounting operations',
    category: 'General Ledger',
  ),
];




