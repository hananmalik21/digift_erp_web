class RoleTemplateModel {
  final String id;
  final String name;
  final String code;
  final String category;
  final int privilegesCount;
  final int dataSetsCount;
  final String description;
  final bool isDefault;
  final String status;
  final String type;
  final int timesUsed;
  final String createdBy;
  final bool isHighlighted;

  RoleTemplateModel({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    required this.privilegesCount,
    required this.dataSetsCount,
    required this.description,
    required this.isDefault,
    required this.status,
    required this.type,
    required this.timesUsed,
    required this.createdBy,
    this.isHighlighted = false,
  });
}

// Sample data
final List<RoleTemplateModel> sampleRoleTemplates = [
  RoleTemplateModel(
    id: 'TMPL-001',
    name: 'Finance Manager Template',
    code: 'FIN_MGR_TPL',
    category: 'Finance',
    privilegesCount: 45,
    dataSetsCount: 8,
    description: 'Complete template for Finance Manager role with GL, AP, AR access',
    isDefault: true,
    status: 'Active',
    type: 'Job',
    timesUsed: 12,
    createdBy: 'Created by Admin on 2024-01-15',
  ),
  RoleTemplateModel(
    id: 'TMPL-002',
    name: 'AP Clerk Template',
    code: 'AP_CLERK_TPL',
    category: 'Finance',
    privilegesCount: 18,
    dataSetsCount: 5,
    description: 'Standard template for Accounts Payable clerk',
    isDefault: false,
    status: 'Active',
    type: 'Duty',
    timesUsed: 25,
    createdBy: 'Created by Admin on 2024-01-20',
  ),
  RoleTemplateModel(
    id: 'TMPL-003',
    name: 'AR Specialist Template',
    code: 'AR_SPEC_TPL',
    category: 'Finance',
    privilegesCount: 22,
    dataSetsCount: 6,
    description: 'Template for Accounts Receivable specialist with customer management',
    isDefault: true,
    status: 'Active',
    type: 'Duty',
    timesUsed: 18,
    createdBy: 'Created by Admin on 2024-02-01',
    isHighlighted: true,
  ),
  RoleTemplateModel(
    id: 'TMPL-004',
    name: 'GL Accountant Template',
    code: 'GL_ACC_TPL',
    category: 'Finance',
    privilegesCount: 30,
    dataSetsCount: 7,
    description: 'General Ledger accountant with journal entry and reporting access',
    isDefault: true,
    status: 'Active',
    type: 'Duty',
    timesUsed: 20,
    createdBy: 'Created by Admin on 2024-02-10',
  ),
  RoleTemplateModel(
    id: 'TMPL-005',
    name: 'Treasury Manager Template',
    code: 'TRS_MGR_TPL',
    category: 'Treasury',
    privilegesCount: 35,
    dataSetsCount: 10,
    description: 'Treasury management with cash, banking, and forex access',
    isDefault: false,
    status: 'Active',
    type: 'Job',
    timesUsed: 5,
    createdBy: 'Created by Admin on 2024-02-15',
  ),
  RoleTemplateModel(
    id: 'TMPL-006',
    name: 'Expense Approver Template',
    code: 'EXP_APP_TPL',
    category: 'Expense',
    privilegesCount: 12,
    dataSetsCount: 4,
    description: 'Template for expense report approvers',
    isDefault: false,
    status: 'Active',
    type: 'Duty',
    timesUsed: 30,
    createdBy: 'Created by Admin on 2024-03-01',
  ),
  RoleTemplateModel(
    id: 'TMPL-007',
    name: 'Auditor Template',
    code: 'AUD_TPL',
    category: 'Audit',
    privilegesCount: 50,
    dataSetsCount: 12,
    description: 'Read-only access for internal auditors',
    isDefault: true,
    status: 'Draft',
    type: 'Job',
    timesUsed: 8,
    createdBy: 'Created by Admin on 2024-03-10',
  ),
];

