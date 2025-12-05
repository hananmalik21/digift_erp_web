class RoleHierarchyModel {
  final String id;
  final String name;
  final String code;
  final String type; // Job, Duty, Privilege
  final String status; // Active, Inactive
  final int usersAssigned;
  final List<RoleHierarchyModel> children;
  bool isExpanded;
  bool isSelected;

  RoleHierarchyModel({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.status,
    required this.usersAssigned,
    this.children = const [],
    this.isExpanded = false,
    this.isSelected = false,
  });
}

// Sample data
final List<RoleHierarchyModel> sampleRoleHierarchy = [
  RoleHierarchyModel(
    id: '1',
    name: 'Finance Manager',
    code: 'FIN_MGR',
    type: 'Job',
    status: 'Active',
    usersAssigned: 5,
    isExpanded: true,
    children: [
      RoleHierarchyModel(
        id: '1-1',
        name: 'GL Accountant',
        code: 'GL_ACC',
        type: 'Duty',
        status: 'Active',
        usersAssigned: 8,
        isExpanded: true,
        children: [
          RoleHierarchyModel(
            id: '1-1-1',
            name: 'Create Journal Entry',
            code: 'GL_JE_CREATE',
            type: 'Privilege',
            status: 'Active',
            usersAssigned: 12,
          ),
          RoleHierarchyModel(
            id: '1-1-2',
            name: 'Post Journal Entry',
            code: 'GL_JE_POST',
            type: 'Privilege',
            status: 'Active',
            usersAssigned: 8,
          ),
        ],
      ),
      RoleHierarchyModel(
        id: '1-2',
        name: 'AP Manager',
        code: 'AP_MGR',
        type: 'Duty',
        status: 'Active',
        usersAssigned: 6,
        children: [],
      ),
    ],
  ),
  RoleHierarchyModel(
    id: '2',
    name: 'AR Manager',
    code: 'AR_MGR',
    type: 'Job',
    status: 'Active',
    usersAssigned: 4,
    children: [],
  ),
];
