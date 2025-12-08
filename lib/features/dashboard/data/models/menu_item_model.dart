import 'package:digify_erp/gen/assets.gen.dart';

class MenuItemModel {
  final String id;
  final String titleKey;
  final String icon;
  final String? route;
  final List<MenuItemModel> children;

  MenuItemModel({
    required this.id,
    required this.titleKey,
    required this.icon,
    this.route,
    this.children = const [],
  });
}

final List<MenuItemModel> menuItems = [
  MenuItemModel(
    id: 'home',
    titleKey: 'home',
    icon: Assets.icons.homeIcon.keyName,
    route: '/dashboard',
  ),
  MenuItemModel(
    id: 'security_console',
    titleKey: 'securityConsole',
    icon: Assets.icons.securityConsoleIcon.keyName,
    children: [
      MenuItemModel(
        id: 'security_dashboard',
        titleKey: 'securityDashboard',
        icon: Assets.icons.securityDashboard.keyName,
        route: '/dashboard/security',
      ),
      MenuItemModel(
        id: 'user_accounts',
        titleKey: 'userAccounts',
        icon: Assets.icons.userManagementIcon.keyName,
        route: '/dashboard/security/user-accounts',
      ),
      MenuItemModel(
        id: 'user_role_assignment',
        titleKey: 'userRoleAssignment',
        icon: Assets.icons.userManagementIcon.keyName,
        route: '/dashboard/security/user-role-assignment',
      ),
      MenuItemModel(
        id: 'role_management',
        titleKey: 'roleManagement',
        icon: Assets.icons.userManagementIcon.keyName,
        children: [
          MenuItemModel(
            id: 'roles',
            titleKey: 'roles',
            icon: Assets.icons.userManagementIcon.keyName,
            route: '/dashboard/security/role-management',
          ),
          MenuItemModel(
            id: 'role_hierarchy',
            titleKey: 'roleHierarchy',
            icon: Assets.icons.roleHerarchyIcon.keyName,
            route: '/dashboard/security/role-hierarchy',
          ),
          MenuItemModel(
            id: 'role_templates',
            titleKey: 'roleTemplates',
            icon: Assets.icons.roleTermplate.keyName,
            route: '/dashboard/security/role-templates',
          ),
        ],
      ),
      MenuItemModel(
        id: 'data_security',
        titleKey: 'dataSecurity',
        icon: Assets.icons.dataSecurityIcon.keyName,
        children: [
          MenuItemModel(
            id: 'security_policies',
            titleKey: 'securityPolicies',
            icon: Assets.icons.securityPoliciesIcon.keyName,
            route: '/dashboard/security/policies',
          ),
          MenuItemModel(
            id: 'data_access_sets',
            titleKey: 'dataAccessSets',
            icon: Assets.icons.dataAccessSetsIcon.keyName,
            route: '/dashboard/security/data-access-sets',
          ),
          MenuItemModel(
            id: 'security_profiles',
            titleKey: 'securityProfiles',
            icon: Assets.icons.securityPoliciesIcon.keyName,
            route: '/dashboard/security/security-profiles',
          ),
        ],
      ),

      MenuItemModel(
        id: 'function_security',
        titleKey: 'functionSecurity',
        icon: Assets.icons.lockIcon.keyName,
        children: [
          MenuItemModel(
            id: 'functions',
            titleKey: 'functions',
            icon: Assets.icons.functionsIcon.keyName,
            route: '/dashboard/security/functions',
          ),
          MenuItemModel(
            id: 'function_privileges',
            titleKey: 'functionPrivileges',
            icon: Assets.icons.workflowApprovalsIcon.keyName,
            route: '/dashboard/security/function-privileges',
          ),
          MenuItemModel(
            id: 'duty_roles',
            titleKey: 'dutyRoles',
            icon: Assets.icons.accountsPayableIcon.keyName,
            route: '/dashboard/security/duty-roles',
          ),
          MenuItemModel(
            id: 'job_roles',
            titleKey: 'jobRoles',
            icon: Assets.icons.userManagementIcon.keyName,
            route: '/dashboard/security/job-roles',
          ),
        ],
      ),
      MenuItemModel(
        id: 'audit_compliance',
        titleKey: 'auditCompliance',
        icon: Assets.icons.auditComplianceIcon.keyName,
        children: [
          MenuItemModel(
            id: 'audit_logs',
            titleKey: 'auditLogs',
            icon: Assets.icons.auditComplianceIcon.keyName,
            route: '/dashboard/security/audit-logs',
          ),
          MenuItemModel(
            id: 'login_history',
            titleKey: 'loginHistory',
            icon: Assets.icons.sessionManagementIcon.keyName,
            route: '/dashboard/security/login-history',
          ),
          MenuItemModel(
            id: 'access_reports',
            titleKey: 'accessReports',
            icon: Assets.icons.securityReportsIcons.keyName,
            route: '/dashboard/security/access-reports',
          ),
          MenuItemModel(
            id: 'compliance_reports',
            titleKey: 'complianceReports',
            icon: Assets.icons.auditComplianceIcon.keyName,
            route: '/dashboard/security/compliance-reports',
          ),
        ],
      ),
      MenuItemModel(
        id: 'security_policies_main',
        titleKey: 'securityPolicies',
        icon: Assets.icons.securityPoliciesIcon.keyName,
        route: '/dashboard/security/policies',
      ),
      MenuItemModel(
        id: 'session_management',
        titleKey: 'sessionManagement',
        icon: Assets.icons.sessionManagementIcon.keyName,
        route: '/dashboard/security/session-management',
      ),
      MenuItemModel(
        id: 'security_reports',
        titleKey: 'securityReports',
        icon: Assets.icons.securityReportsIcons.keyName,
        route: '/dashboard/security/security-reports',
      ),
    ],
  ),
];

