class DataAccessSetModel {
  final String id;
  final String name;
  final String code;
  final String accessType;
  final String status;
  final int usersAssigned;
  final String accessScope;
  final String description;

  DataAccessSetModel({
    required this.id,
    required this.name,
    required this.code,
    required this.accessType,
    required this.status,
    required this.usersAssigned,
    required this.accessScope,
    required this.description,
  });
}

// Sample data
final List<DataAccessSetModel> sampleDataAccessSets = [
  DataAccessSetModel(
    id: 'DAS-001',
    name: 'US Operations Data',
    code: 'US_OPS_DATA',
    accessType: 'Ledger',
    status: 'Active',
    usersAssigned: 45,
    accessScope: 'US Ledgers (3)',
    description: 'Access to all US operational ledgers and entities',
  ),
  DataAccessSetModel(
    id: 'DAS-002',
    name: 'Europe Financial Data',
    code: 'EU_FIN_DATA',
    accessType: 'Legal Entity',
    status: 'Active',
    usersAssigned: 32,
    accessScope: 'EU Entities (5)',
    description: 'European financial data including UK, France, Germany',
  ),
  DataAccessSetModel(
    id: 'DAS-003',
    name: 'APAC Region Data',
    code: 'APAC_DATA',
    accessType: 'Ledger',
    status: 'Active',
    usersAssigned: 28,
    accessScope: 'APAC Ledgers (4)',
    description: 'Asia-Pacific region operational data access',
  ),
  DataAccessSetModel(
    id: 'DAS-004',
    name: 'Global Treasury Data',
    code: 'GLB_TRS_DATA',
    accessType: 'Legal Entity',
    status: 'Active',
    usersAssigned: 8,
    accessScope: 'All Entities',
    description: 'Global treasury and cash management data',
  ),
  DataAccessSetModel(
    id: 'DAS-005',
    name: 'Audit View Only',
    code: 'AUD_VIEW',
    accessType: 'Ledger',
    status: 'Active',
    usersAssigned: 12,
    accessScope: 'All Ledgers (Read Only)',
    description: 'Read-only access to all ledgers for audit purposes',
  ),
];

