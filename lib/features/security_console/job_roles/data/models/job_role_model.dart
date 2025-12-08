class JobRoleModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final String department;
  final String status;
  final int usersAssigned;
  final int privilegesCount;
  final List<String> dutyRoles;
  final List<String>? inheritsFrom;
  final String lastModified;

  JobRoleModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.department,
    required this.status,
    required this.usersAssigned,
    required this.privilegesCount,
    required this.dutyRoles,
    this.inheritsFrom,
    required this.lastModified,
  });

  static List<JobRoleModel> getSampleData() {
    return [
      JobRoleModel(
        id: '1',
        name: 'Finance Manager',
        code: 'FIN_MGR',
        description: 'Oversees all financial operations including GL, AP, AR',
        department: 'Finance',
        status: 'Active',
        usersAssigned: 5,
        privilegesCount: 24,
        dutyRoles: ['GL Accountant', 'AP Manager', 'AR Specialist', 'Cash Manager'],
        lastModified: '2024-01-15',
      ),
      JobRoleModel(
        id: '2',
        name: 'Controller',
        code: 'CONTROLLER',
        description: 'Senior financial oversight and reporting',
        department: 'Finance',
        status: 'Active',
        usersAssigned: 2,
        privilegesCount: 32,
        dutyRoles: ['GL Accountant', 'Financial Reporting', 'Budget Manager', 'Period Close'],
        inheritsFrom: ['Finance Manager'],
        lastModified: '2024-01-15',
      ),
      JobRoleModel(
        id: '3',
        name: 'AP Manager',
        code: 'AP_MGR',
        description: 'Manages accounts payable operations and vendor relationships',
        department: 'Finance',
        status: 'Active',
        usersAssigned: 3,
        privilegesCount: 18,
        dutyRoles: ['AP Specialist', 'Payment Processor', 'Vendor Manager', 'AP Reporting'],
        lastModified: '2024-01-20',
      ),
      JobRoleModel(
        id: '4',
        name: 'AR Manager',
        code: 'AR_MGR',
        description: 'Manages accounts receivable and customer billing',
        department: 'Finance',
        status: 'Active',
        usersAssigned: 3,
        privilegesCount: 16,
        dutyRoles: ['AR Specialist', 'Collections Manager', 'Credit Manager', 'AR Reporting'],
        lastModified: '2024-02-01',
      ),
      JobRoleModel(
        id: '5',
        name: 'Treasury Manager',
        code: 'TREAS_MGR',
        description: 'Oversees cash management and treasury operations',
        department: 'Treasury',
        status: 'Active',
        usersAssigned: 2,
        privilegesCount: 14,
        dutyRoles: ['Cash Manager', 'Bank Reconciliation Specialist', 'FX Manager', 'Investment Manager'],
        lastModified: '2024-02-10',
      ),
      JobRoleModel(
        id: '6',
        name: 'Fixed Assets Manager',
        code: 'FA_MGR',
        description: 'Manages fixed asset lifecycle and depreciation',
        department: 'Finance',
        status: 'Active',
        usersAssigned: 2,
        privilegesCount: 12,
        dutyRoles: ['Asset Accountant', 'Depreciation Specialist'],
        lastModified: '2024-02-15',
      ),
    ];
  }
}



