import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_shell.dart';
import '../../features/dashboard/presentation/screens/dashboard_home.dart';
import '../../features/security_console/security_dashboard/presentation/screens/security_dashboard.dart';
import '../../features/security_console/user_accounts/presentation/screens/user_accounts_screen.dart';
import '../../features/security_console/user_role_assignment/presentation/screens/user_role_assignment_screen.dart';
import '../../features/security_console/roles/presentation/screens/roles_screen.dart';
import '../../features/security_console/role_management/presentation/screens/create_edit_role_screen.dart';
import '../../features/security_console/role_hierarchy/presentation/screens/role_hierarchy_screen.dart';
import '../../features/security_console/role_templates/presentation/screens/role_templates_screen.dart';
import '../../features/security_console/security_policies/presentation/screens/security_policies_screen.dart';
import '../../features/security_console/data_access_sets/presentation/screens/data_access_sets_screen.dart';
import '../../features/security_console/security_profiles/presentation/screens/security_profiles_screen.dart';
import '../../features/security_console/function_privileges/presentation/screens/function_privileges_screen.dart';
import '../../features/security_console/functions/presentation/screens/functions_screen.dart';
import '../../features/security_console/duty_roles/presentation/screens/duty_roles_screen.dart';
import '../../features/security_console/job_roles/presentation/screens/job_roles_screen.dart';
import '../../features/security_console/user_accounts/presentation/screens/create_user_account_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => DashboardShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardHome(),
          ),
          GoRoute(
            path: '/dashboard/security',
            name: 'security-dashboard',
            builder: (context, state) => const SecurityDashboard(),
          ),
          GoRoute(
            path: '/dashboard/security/user-accounts',
            name: 'user-accounts',
            builder: (context, state) => const UserAccountsScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/user-accounts/create',
            name: 'create-user-account',
            builder: (context, state) => const CreateUserAccountScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/user-role-assignment',
            name: 'user-role-assignment',
            builder: (context, state) => const UserRoleAssignmentScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/role-management',
            name: 'role-management',
            builder: (context, state) => const RolesScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/role-management/create',
            name: 'create-role',
            builder: (context, state) => const CreateEditRoleScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/role-hierarchy',
            name: 'role-hierarchy',
            builder: (context, state) => const RoleHierarchyScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/role-templates',
            name: 'role-templates',
            builder: (context, state) => const RoleTemplatesScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/policies',
            name: 'security-policies',
            builder: (context, state) => const SecurityPoliciesScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/data-access-sets',
            name: 'data-access-sets',
            builder: (context, state) => const DataAccessSetsScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/security-profiles',
            name: 'security-profiles',
            builder: (context, state) => const SecurityProfilesScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/function-privileges',
            name: 'function-privileges',
            builder: (context, state) => const FunctionPrivilegesScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/functions',
            name: 'functions',
            builder: (context, state) => const FunctionsScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/duty-roles',
            name: 'duty-roles',
            builder: (context, state) => const DutyRolesScreen(),
          ),
          GoRoute(
            path: '/dashboard/security/job-roles',
            name: 'job-roles',
            builder: (context, state) => const JobRolesScreen(),
          ),
        ],
      ),
    ],
  );
});

Widget _buildPlaceholderPage(String title) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Coming Soon'),
        ],
      ),
    ),
  );
}

