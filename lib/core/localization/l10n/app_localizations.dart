import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Digify ERP'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneHint;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful!'**
  String get signupSuccess;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @enterpriseStructure.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Structure'**
  String get enterpriseStructure;

  /// No description provided for @generalLedger.
  ///
  /// In en, this message translates to:
  /// **'General Ledger'**
  String get generalLedger;

  /// No description provided for @chartOfAccounts.
  ///
  /// In en, this message translates to:
  /// **'Chart of Accounts'**
  String get chartOfAccounts;

  /// No description provided for @journalEntries.
  ///
  /// In en, this message translates to:
  /// **'Journal Entries'**
  String get journalEntries;

  /// No description provided for @accountBalances.
  ///
  /// In en, this message translates to:
  /// **'Account Balances'**
  String get accountBalances;

  /// No description provided for @intercompanyAccounting.
  ///
  /// In en, this message translates to:
  /// **'Intercompany Accounting'**
  String get intercompanyAccounting;

  /// No description provided for @budgetManagement.
  ///
  /// In en, this message translates to:
  /// **'Budget Management'**
  String get budgetManagement;

  /// No description provided for @financialReportSets.
  ///
  /// In en, this message translates to:
  /// **'Financial Report Sets'**
  String get financialReportSets;

  /// No description provided for @accountsPayable.
  ///
  /// In en, this message translates to:
  /// **'Accounts Payable'**
  String get accountsPayable;

  /// No description provided for @accountsReceivable.
  ///
  /// In en, this message translates to:
  /// **'Accounts Receivable'**
  String get accountsReceivable;

  /// No description provided for @cashManagement.
  ///
  /// In en, this message translates to:
  /// **'Cash Management'**
  String get cashManagement;

  /// No description provided for @fixedAssets.
  ///
  /// In en, this message translates to:
  /// **'Fixed Assets'**
  String get fixedAssets;

  /// No description provided for @treasury.
  ///
  /// In en, this message translates to:
  /// **'Treasury'**
  String get treasury;

  /// No description provided for @expenseManagement.
  ///
  /// In en, this message translates to:
  /// **'Expense Management'**
  String get expenseManagement;

  /// No description provided for @financialReporting.
  ///
  /// In en, this message translates to:
  /// **'Financial Reporting'**
  String get financialReporting;

  /// No description provided for @periodClose.
  ///
  /// In en, this message translates to:
  /// **'Period Close'**
  String get periodClose;

  /// No description provided for @workflowApprovals.
  ///
  /// In en, this message translates to:
  /// **'Workflow Approvals'**
  String get workflowApprovals;

  /// No description provided for @securityConsole.
  ///
  /// In en, this message translates to:
  /// **'Security Console'**
  String get securityConsole;

  /// No description provided for @securityDashboard.
  ///
  /// In en, this message translates to:
  /// **'Security Dashboard'**
  String get securityDashboard;

  /// No description provided for @userAccounts.
  ///
  /// In en, this message translates to:
  /// **'User Accounts'**
  String get userAccounts;

  /// No description provided for @userAccountsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage user accounts and permissions'**
  String get userAccountsSubtitle;

  /// No description provided for @userRoleAssignment.
  ///
  /// In en, this message translates to:
  /// **'User Role Assignment'**
  String get userRoleAssignment;

  /// No description provided for @roleManagement.
  ///
  /// In en, this message translates to:
  /// **'Role Management'**
  String get roleManagement;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @roleHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Role Hierarchy'**
  String get roleHierarchy;

  /// No description provided for @roleTemplates.
  ///
  /// In en, this message translates to:
  /// **'Role Templates'**
  String get roleTemplates;

  /// No description provided for @securityPolicies.
  ///
  /// In en, this message translates to:
  /// **'Security Policies'**
  String get securityPolicies;

  /// No description provided for @dataAccessSets.
  ///
  /// In en, this message translates to:
  /// **'Data Access Sets'**
  String get dataAccessSets;

  /// No description provided for @functionPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Function Privileges'**
  String get functionPrivileges;

  /// No description provided for @dutyRoles.
  ///
  /// In en, this message translates to:
  /// **'Duty Roles'**
  String get dutyRoles;

  /// No description provided for @jobRoles.
  ///
  /// In en, this message translates to:
  /// **'Job Roles'**
  String get jobRoles;

  /// No description provided for @auditCompliance.
  ///
  /// In en, this message translates to:
  /// **'Audit & Compliance'**
  String get auditCompliance;

  /// No description provided for @dataSecurityPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data Security & Privacy'**
  String get dataSecurityPrivacy;

  /// No description provided for @sessionManagement.
  ///
  /// In en, this message translates to:
  /// **'Session Management'**
  String get sessionManagement;

  /// No description provided for @securityReportsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Security Reports & Analytics'**
  String get securityReportsAnalytics;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @securityOverview.
  ///
  /// In en, this message translates to:
  /// **'Security Overview'**
  String get securityOverview;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;

  /// No description provided for @inactiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Inactive Users'**
  String get inactiveUsers;

  /// No description provided for @pendingApprovals.
  ///
  /// In en, this message translates to:
  /// **'Pending Approvals'**
  String get pendingApprovals;

  /// No description provided for @totalRoles.
  ///
  /// In en, this message translates to:
  /// **'Total Roles'**
  String get totalRoles;

  /// No description provided for @activeRoles.
  ///
  /// In en, this message translates to:
  /// **'Active Roles'**
  String get activeRoles;

  /// No description provided for @customRoles.
  ///
  /// In en, this message translates to:
  /// **'Custom Roles'**
  String get customRoles;

  /// No description provided for @standardRoles.
  ///
  /// In en, this message translates to:
  /// **'Standard Roles'**
  String get standardRoles;

  /// No description provided for @totalPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Total Privileges'**
  String get totalPrivileges;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @roleUsage.
  ///
  /// In en, this message translates to:
  /// **'Role Usage'**
  String get roleUsage;

  /// No description provided for @modules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modules;

  /// No description provided for @recentSecurityAlerts.
  ///
  /// In en, this message translates to:
  /// **'Recent Security Alerts'**
  String get recentSecurityAlerts;

  /// No description provided for @failedLoginAttempts.
  ///
  /// In en, this message translates to:
  /// **'Failed Login Attempts'**
  String get failedLoginAttempts;

  /// No description provided for @unauthorizedAccess.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized Access Attempt'**
  String get unauthorizedAccess;

  /// No description provided for @passwordExpiringUsers.
  ///
  /// In en, this message translates to:
  /// **'Password Expiring for Multiple Users'**
  String get passwordExpiringUsers;

  /// No description provided for @unusualActivity.
  ///
  /// In en, this message translates to:
  /// **'Unusual Activity Detected'**
  String get unusualActivity;

  /// No description provided for @investigateAll.
  ///
  /// In en, this message translates to:
  /// **'Investigate All'**
  String get investigateAll;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @userCreated.
  ///
  /// In en, this message translates to:
  /// **'User account created'**
  String get userCreated;

  /// No description provided for @roleModified.
  ///
  /// In en, this message translates to:
  /// **'Role permissions modified'**
  String get roleModified;

  /// No description provided for @policyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Security policy updated'**
  String get policyUpdated;

  /// No description provided for @privilegesRevoked.
  ///
  /// In en, this message translates to:
  /// **'Privileges revoked'**
  String get privilegesRevoked;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// No description provided for @assignRole.
  ///
  /// In en, this message translates to:
  /// **'Assign Role'**
  String get assignRole;

  /// No description provided for @reviewAccess.
  ///
  /// In en, this message translates to:
  /// **'Review Access'**
  String get reviewAccess;

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get generateReport;

  /// No description provided for @systemComplianceStatus.
  ///
  /// In en, this message translates to:
  /// **'System Compliance Status'**
  String get systemComplianceStatus;

  /// No description provided for @userAuthentication.
  ///
  /// In en, this message translates to:
  /// **'User Authentication'**
  String get userAuthentication;

  /// No description provided for @dataEncryption.
  ///
  /// In en, this message translates to:
  /// **'Data Encryption'**
  String get dataEncryption;

  /// No description provided for @accessControl.
  ///
  /// In en, this message translates to:
  /// **'Access Control'**
  String get accessControl;

  /// No description provided for @auditLogging.
  ///
  /// In en, this message translates to:
  /// **'Audit Logging'**
  String get auditLogging;

  /// No description provided for @activeSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get activeSessions;

  /// No description provided for @pendingReviews.
  ///
  /// In en, this message translates to:
  /// **'Pending Reviews'**
  String get pendingReviews;

  /// No description provided for @criticalAlerts.
  ///
  /// In en, this message translates to:
  /// **'Critical Alerts'**
  String get criticalAlerts;

  /// No description provided for @searchAccounts.
  ///
  /// In en, this message translates to:
  /// **'Search accounts...'**
  String get searchAccounts;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypes;

  /// No description provided for @allStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatus;

  /// No description provided for @moreFilters.
  ///
  /// In en, this message translates to:
  /// **'More Filters'**
  String get moreFilters;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @standardUser.
  ///
  /// In en, this message translates to:
  /// **'Standard User'**
  String get standardUser;

  /// No description provided for @financeUser.
  ///
  /// In en, this message translates to:
  /// **'Finance User'**
  String get financeUser;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @active2FA.
  ///
  /// In en, this message translates to:
  /// **'Active (2FA)'**
  String get active2FA;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @lock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lock;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @showingResults.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} of {total} accounts'**
  String showingResults(int count, int total);

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// No description provided for @userInformation.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInformation;

  /// No description provided for @userID.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userID;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get accountStatus;

  /// No description provided for @mfaStatus.
  ///
  /// In en, this message translates to:
  /// **'MFA Status'**
  String get mfaStatus;

  /// No description provided for @securityInformation.
  ///
  /// In en, this message translates to:
  /// **'Security Information'**
  String get securityInformation;

  /// No description provided for @assignedRoles.
  ///
  /// In en, this message translates to:
  /// **'Assigned Roles'**
  String get assignedRoles;

  /// No description provided for @lastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last Login'**
  String get lastLogin;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account Created'**
  String get accountCreated;

  /// No description provided for @passwordLastChanged.
  ///
  /// In en, this message translates to:
  /// **'Password Last Changed'**
  String get passwordLastChanged;

  /// No description provided for @failedAttempts.
  ///
  /// In en, this message translates to:
  /// **'Failed Attempts'**
  String get failedAttempts;

  /// No description provided for @sessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session History (Last 7 days)'**
  String get sessionHistory;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @manageRoles.
  ///
  /// In en, this message translates to:
  /// **'Manage Roles'**
  String get manageRoles;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsers;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @refreshUser.
  ///
  /// In en, this message translates to:
  /// **'Refresh User'**
  String get refreshUser;

  /// No description provided for @manageUserRoles.
  ///
  /// In en, this message translates to:
  /// **'Manage User Roles'**
  String get manageUserRoles;

  /// No description provided for @loggedInUser.
  ///
  /// In en, this message translates to:
  /// **'Logged In User'**
  String get loggedInUser;

  /// No description provided for @rolesLoadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{count} roles loaded successfully'**
  String rolesLoadedSuccessfully(int count);

  /// No description provided for @currentlyAssignedRoles.
  ///
  /// In en, this message translates to:
  /// **'Currently Assigned Roles'**
  String get currentlyAssignedRoles;

  /// No description provided for @availableRolesToAssign.
  ///
  /// In en, this message translates to:
  /// **'Available Roles to Assign'**
  String get availableRolesToAssign;

  /// No description provided for @searchRoles.
  ///
  /// In en, this message translates to:
  /// **'Search roles...'**
  String get searchRoles;

  /// No description provided for @assignSelected.
  ///
  /// In en, this message translates to:
  /// **'Assign Selected'**
  String get assignSelected;

  /// No description provided for @removeSelected.
  ///
  /// In en, this message translates to:
  /// **'Remove Selected'**
  String get removeSelected;

  /// No description provided for @noRolesAssigned.
  ///
  /// In en, this message translates to:
  /// **'No roles assigned'**
  String get noRolesAssigned;

  /// No description provided for @noRolesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No available roles'**
  String get noRolesAvailable;

  /// No description provided for @rolesAssignedLabel.
  ///
  /// In en, this message translates to:
  /// **'Roles Assigned'**
  String get rolesAssignedLabel;

  /// No description provided for @rolesAvailableLabel.
  ///
  /// In en, this message translates to:
  /// **'Roles Available'**
  String get rolesAvailableLabel;

  /// No description provided for @roleAssignmentHistory.
  ///
  /// In en, this message translates to:
  /// **'Role Assignment History'**
  String get roleAssignmentHistory;

  /// No description provided for @assignedBy.
  ///
  /// In en, this message translates to:
  /// **'Assigned By'**
  String get assignedBy;

  /// No description provided for @assignedOn.
  ///
  /// In en, this message translates to:
  /// **'Assigned On'**
  String get assignedOn;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saveUpdates.
  ///
  /// In en, this message translates to:
  /// **'Save Updates'**
  String get saveUpdates;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChanges;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @userRoleAssignmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Assign and manage security roles for users'**
  String get userRoleAssignmentSubtitle;

  /// No description provided for @usersWithRoles.
  ///
  /// In en, this message translates to:
  /// **'Users with Roles'**
  String get usersWithRoles;

  /// No description provided for @avgRolesPerUser.
  ///
  /// In en, this message translates to:
  /// **'Avg Roles/User'**
  String get avgRolesPerUser;

  /// No description provided for @availableRoles.
  ///
  /// In en, this message translates to:
  /// **'Available Roles'**
  String get availableRoles;

  /// No description provided for @refreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// No description provided for @totalAssignments.
  ///
  /// In en, this message translates to:
  /// **'Total Assignments'**
  String get totalAssignments;

  /// No description provided for @rolesInUse.
  ///
  /// In en, this message translates to:
  /// **'Roles in Use'**
  String get rolesInUse;

  /// No description provided for @usersWithMultipleRoles.
  ///
  /// In en, this message translates to:
  /// **'Users with Multiple Roles'**
  String get usersWithMultipleRoles;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @currentRoles.
  ///
  /// In en, this message translates to:
  /// **'Current Roles'**
  String get currentRoles;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @roleManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage roles, permissions, and access levels'**
  String get roleManagementSubtitle;

  /// No description provided for @dutyRolesOnly.
  ///
  /// In en, this message translates to:
  /// **'Duty Roles'**
  String get dutyRolesOnly;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @allTypesFilter.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypesFilter;

  /// No description provided for @allStatusFilter.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatusFilter;

  /// No description provided for @searchRolesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search roles by name or code...'**
  String get searchRolesPlaceholder;

  /// No description provided for @roleType.
  ///
  /// In en, this message translates to:
  /// **'Role Type'**
  String get roleType;

  /// No description provided for @usersAssigned.
  ///
  /// In en, this message translates to:
  /// **'Users Assigned ({count})'**
  String usersAssigned(int count);

  /// No description provided for @privileges.
  ///
  /// In en, this message translates to:
  /// **'Privileges'**
  String get privileges;

  /// No description provided for @createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created On'**
  String get createdOn;

  /// No description provided for @createRole.
  ///
  /// In en, this message translates to:
  /// **'Create Role'**
  String get createRole;

  /// No description provided for @createNewRole.
  ///
  /// In en, this message translates to:
  /// **'Create New Role'**
  String get createNewRole;

  /// No description provided for @editRole.
  ///
  /// In en, this message translates to:
  /// **'Edit Role'**
  String get editRole;

  /// No description provided for @roleInformation.
  ///
  /// In en, this message translates to:
  /// **'Role Information'**
  String get roleInformation;

  /// No description provided for @roleName.
  ///
  /// In en, this message translates to:
  /// **'Role Name'**
  String get roleName;

  /// No description provided for @enterRoleName.
  ///
  /// In en, this message translates to:
  /// **'Enter role name'**
  String get enterRoleName;

  /// No description provided for @roleCode.
  ///
  /// In en, this message translates to:
  /// **'Role Code'**
  String get roleCode;

  /// No description provided for @enterRoleCode.
  ///
  /// In en, this message translates to:
  /// **'Enter role code (e.g., FIN_MGR_001)'**
  String get enterRoleCode;

  /// No description provided for @roleDescription.
  ///
  /// In en, this message translates to:
  /// **'Role Description'**
  String get roleDescription;

  /// No description provided for @enterRoleDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter role description'**
  String get enterRoleDescription;

  /// No description provided for @roleConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Role Configuration'**
  String get roleConfiguration;

  /// No description provided for @selectRoleType.
  ///
  /// In en, this message translates to:
  /// **'Select Role Type'**
  String get selectRoleType;

  /// No description provided for @jobRole.
  ///
  /// In en, this message translates to:
  /// **'Job Role'**
  String get jobRole;

  /// No description provided for @dutyRole.
  ///
  /// In en, this message translates to:
  /// **'Duty Role'**
  String get dutyRole;

  /// No description provided for @effectiveDates.
  ///
  /// In en, this message translates to:
  /// **'Effective Dates'**
  String get effectiveDates;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @setActiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Set Active Status'**
  String get setActiveStatus;

  /// No description provided for @setStatus.
  ///
  /// In en, this message translates to:
  /// **'Set Status'**
  String get setStatus;

  /// No description provided for @privilegesAndAccess.
  ///
  /// In en, this message translates to:
  /// **'Privileges & Access'**
  String get privilegesAndAccess;

  /// No description provided for @functionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Function Security'**
  String get functionSecurity;

  /// No description provided for @function.
  ///
  /// In en, this message translates to:
  /// **'Function'**
  String get function;

  /// No description provided for @accessLevel.
  ///
  /// In en, this message translates to:
  /// **'Access Level'**
  String get accessLevel;

  /// No description provided for @addPrivilege.
  ///
  /// In en, this message translates to:
  /// **'Add Privilege'**
  String get addPrivilege;

  /// No description provided for @dataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get dataSecurity;

  /// No description provided for @dataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Data Access Set'**
  String get dataAccessSet;

  /// No description provided for @assignDataSets.
  ///
  /// In en, this message translates to:
  /// **'Assign Data Sets'**
  String get assignDataSets;

  /// No description provided for @roleCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Role created successfully'**
  String get roleCreatedSuccessfully;

  /// No description provided for @roleUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Role updated successfully'**
  String get roleUpdatedSuccessfully;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @roleHierarchySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage role hierarchy structure'**
  String get roleHierarchySubtitle;

  /// No description provided for @totalNodes.
  ///
  /// In en, this message translates to:
  /// **'Total Nodes'**
  String get totalNodes;

  /// No description provided for @maxDepth.
  ///
  /// In en, this message translates to:
  /// **'Max Depth'**
  String get maxDepth;

  /// No description provided for @parentRoles.
  ///
  /// In en, this message translates to:
  /// **'Parent Roles'**
  String get parentRoles;

  /// No description provided for @parentRole.
  ///
  /// In en, this message translates to:
  /// **'Parent Role'**
  String get parentRole;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get selectType;

  /// No description provided for @childRoles.
  ///
  /// In en, this message translates to:
  /// **'Child Roles'**
  String get childRoles;

  /// No description provided for @searchHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Search hierarchy...'**
  String get searchHierarchy;

  /// No description provided for @expandAll.
  ///
  /// In en, this message translates to:
  /// **'Expand All'**
  String get expandAll;

  /// No description provided for @collapseAll.
  ///
  /// In en, this message translates to:
  /// **'Collapse All'**
  String get collapseAll;

  /// No description provided for @createRootRole.
  ///
  /// In en, this message translates to:
  /// **'Create Root Role'**
  String get createRootRole;

  /// No description provided for @usersAssignedLabel.
  ///
  /// In en, this message translates to:
  /// **'Users Assigned'**
  String get usersAssignedLabel;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryAdjustingSearchCriteria.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria'**
  String get tryAdjustingSearchCriteria;

  /// No description provided for @addRoleToHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Add Role to Hierarchy'**
  String get addRoleToHierarchy;

  /// No description provided for @selectParentRole.
  ///
  /// In en, this message translates to:
  /// **'Select Parent Role (Optional)'**
  String get selectParentRole;

  /// No description provided for @selectParent.
  ///
  /// In en, this message translates to:
  /// **'Select parent role...'**
  String get selectParent;

  /// No description provided for @noParentRole.
  ///
  /// In en, this message translates to:
  /// **'No Parent (Root Level)'**
  String get noParentRole;

  /// No description provided for @existingRole.
  ///
  /// In en, this message translates to:
  /// **'Existing Role'**
  String get existingRole;

  /// No description provided for @selectExistingRole.
  ///
  /// In en, this message translates to:
  /// **'Select existing role'**
  String get selectExistingRole;

  /// No description provided for @newRoleName.
  ///
  /// In en, this message translates to:
  /// **'New Role Name'**
  String get newRoleName;

  /// No description provided for @enterNewRoleName.
  ///
  /// In en, this message translates to:
  /// **'Enter new role name'**
  String get enterNewRoleName;

  /// No description provided for @roleTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Role Type'**
  String get roleTypeLabel;

  /// No description provided for @addRole.
  ///
  /// In en, this message translates to:
  /// **'Add Role'**
  String get addRole;

  /// No description provided for @roleTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-configured role templates for quick setup'**
  String get roleTemplatesSubtitle;

  /// No description provided for @totalTemplates.
  ///
  /// In en, this message translates to:
  /// **'Total Templates'**
  String get totalTemplates;

  /// No description provided for @industrySpecific.
  ///
  /// In en, this message translates to:
  /// **'Industry Specific'**
  String get industrySpecific;

  /// No description provided for @recentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'Recently Used'**
  String get recentlyUsed;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @operations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get operations;

  /// No description provided for @hr.
  ///
  /// In en, this message translates to:
  /// **'HR'**
  String get hr;

  /// No description provided for @it.
  ///
  /// In en, this message translates to:
  /// **'IT'**
  String get it;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @createTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get createTemplate;

  /// No description provided for @useTemplate.
  ///
  /// In en, this message translates to:
  /// **'Use Template'**
  String get useTemplate;

  /// No description provided for @includes.
  ///
  /// In en, this message translates to:
  /// **'Includes'**
  String get includes;

  /// No description provided for @privilegesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Privileges'**
  String privilegesCount(int count);

  /// No description provided for @dataSetsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Data Sets'**
  String dataSetsCount(int count);

  /// No description provided for @createNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create New Template'**
  String get createNewTemplate;

  /// No description provided for @creatingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Creating Template'**
  String get creatingTemplate;

  /// No description provided for @templateInstructions.
  ///
  /// In en, this message translates to:
  /// **'Create a reusable role template with pre-configured permissions and access settings'**
  String get templateInstructions;

  /// No description provided for @templateName.
  ///
  /// In en, this message translates to:
  /// **'Template Name'**
  String get templateName;

  /// No description provided for @enterTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Enter template name'**
  String get enterTemplateName;

  /// No description provided for @templateCode.
  ///
  /// In en, this message translates to:
  /// **'Template Code'**
  String get templateCode;

  /// No description provided for @enterTemplateCode.
  ///
  /// In en, this message translates to:
  /// **'Enter unique template code'**
  String get enterTemplateCode;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @templateDescription.
  ///
  /// In en, this message translates to:
  /// **'Template Description'**
  String get templateDescription;

  /// No description provided for @enterTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter template description'**
  String get enterTemplateDescription;

  /// No description provided for @includedPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Included Privileges'**
  String get includedPrivileges;

  /// No description provided for @selectPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Select Privileges'**
  String get selectPrivileges;

  /// No description provided for @selectedPrivileges.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedPrivileges(int count);

  /// No description provided for @includedDataSets.
  ///
  /// In en, this message translates to:
  /// **'Included Data Sets'**
  String get includedDataSets;

  /// No description provided for @selectDataSets.
  ///
  /// In en, this message translates to:
  /// **'Select Data Sets'**
  String get selectDataSets;

  /// No description provided for @selectedDataSets.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedDataSets(int count);

  /// No description provided for @makeDefaultTemplate.
  ///
  /// In en, this message translates to:
  /// **'Make Default Template'**
  String get makeDefaultTemplate;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default for this category'**
  String get setAsDefault;

  /// No description provided for @createTemplateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get createTemplateButton;

  /// No description provided for @securityPoliciesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure and manage security policies'**
  String get securityPoliciesSubtitle;

  /// No description provided for @activePolicies.
  ///
  /// In en, this message translates to:
  /// **'Active Policies'**
  String get activePolicies;

  /// No description provided for @pendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get pendingReview;

  /// No description provided for @expiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get expiringSoon;

  /// No description provided for @searchPolicies.
  ///
  /// In en, this message translates to:
  /// **'Search policies...'**
  String get searchPolicies;

  /// No description provided for @createPolicy.
  ///
  /// In en, this message translates to:
  /// **'Create Policy'**
  String get createPolicy;

  /// No description provided for @policyType.
  ///
  /// In en, this message translates to:
  /// **'Policy Type'**
  String get policyType;

  /// No description provided for @enforcementLevel.
  ///
  /// In en, this message translates to:
  /// **'Enforcement Level'**
  String get enforcementLevel;

  /// No description provided for @lastModified.
  ///
  /// In en, this message translates to:
  /// **'Last Modified'**
  String get lastModified;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @createNewPolicy.
  ///
  /// In en, this message translates to:
  /// **'Create New Policy'**
  String get createNewPolicy;

  /// No description provided for @editPolicy.
  ///
  /// In en, this message translates to:
  /// **'Edit Policy'**
  String get editPolicy;

  /// No description provided for @creatingPolicy.
  ///
  /// In en, this message translates to:
  /// **'Creating Policy'**
  String get creatingPolicy;

  /// No description provided for @policyInstructions.
  ///
  /// In en, this message translates to:
  /// **'Define security policies to enforce access control and compliance'**
  String get policyInstructions;

  /// No description provided for @policyName.
  ///
  /// In en, this message translates to:
  /// **'Policy Name'**
  String get policyName;

  /// No description provided for @enterPolicyName.
  ///
  /// In en, this message translates to:
  /// **'Enter policy name'**
  String get enterPolicyName;

  /// No description provided for @policyCode.
  ///
  /// In en, this message translates to:
  /// **'Policy Code'**
  String get policyCode;

  /// No description provided for @enterPolicyCode.
  ///
  /// In en, this message translates to:
  /// **'Enter policy code'**
  String get enterPolicyCode;

  /// No description provided for @policyDescription.
  ///
  /// In en, this message translates to:
  /// **'Policy Description'**
  String get policyDescription;

  /// No description provided for @enterPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter policy description'**
  String get enterPolicyDescription;

  /// No description provided for @selectPolicyType.
  ///
  /// In en, this message translates to:
  /// **'Select Policy Type'**
  String get selectPolicyType;

  /// No description provided for @passwordPolicy.
  ///
  /// In en, this message translates to:
  /// **'Password Policy'**
  String get passwordPolicy;

  /// No description provided for @accessPolicy.
  ///
  /// In en, this message translates to:
  /// **'Access Policy'**
  String get accessPolicy;

  /// No description provided for @compliancePolicy.
  ///
  /// In en, this message translates to:
  /// **'Compliance Policy'**
  String get compliancePolicy;

  /// No description provided for @selectEnforcementLevel.
  ///
  /// In en, this message translates to:
  /// **'Select Enforcement Level'**
  String get selectEnforcementLevel;

  /// No description provided for @mandatory.
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get mandatory;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @enterExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Enter expiry date'**
  String get enterExpiryDate;

  /// No description provided for @policyRules.
  ///
  /// In en, this message translates to:
  /// **'Policy Rules'**
  String get policyRules;

  /// No description provided for @addRule.
  ///
  /// In en, this message translates to:
  /// **'Add Rule'**
  String get addRule;

  /// No description provided for @createPolicyButton.
  ///
  /// In en, this message translates to:
  /// **'Create Policy'**
  String get createPolicyButton;

  /// No description provided for @dataAccessSetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage data access sets and permissions'**
  String get dataAccessSetsSubtitle;

  /// No description provided for @totalDataAccessSets.
  ///
  /// In en, this message translates to:
  /// **'Total Data Access Sets'**
  String get totalDataAccessSets;

  /// No description provided for @ledgerBased.
  ///
  /// In en, this message translates to:
  /// **'Ledger Based'**
  String get ledgerBased;

  /// No description provided for @entityBased.
  ///
  /// In en, this message translates to:
  /// **'Entity Based'**
  String get entityBased;

  /// No description provided for @searchDataAccessSets.
  ///
  /// In en, this message translates to:
  /// **'Search data access sets...'**
  String get searchDataAccessSets;

  /// No description provided for @createDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Create Data Access Set'**
  String get createDataAccessSet;

  /// No description provided for @accessScope.
  ///
  /// In en, this message translates to:
  /// **'Access Scope'**
  String get accessScope;

  /// No description provided for @createNewDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Create New Data Access Set'**
  String get createNewDataAccessSet;

  /// No description provided for @creatingDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Creating Data Access Set'**
  String get creatingDataAccessSet;

  /// No description provided for @dataAccessSetInstructions.
  ///
  /// In en, this message translates to:
  /// **'Define data access boundaries for controlling which data users can view and modify'**
  String get dataAccessSetInstructions;

  /// No description provided for @setName.
  ///
  /// In en, this message translates to:
  /// **'Set Name'**
  String get setName;

  /// No description provided for @enterDataAccessSetName.
  ///
  /// In en, this message translates to:
  /// **'Enter data access set name'**
  String get enterDataAccessSetName;

  /// No description provided for @setCode.
  ///
  /// In en, this message translates to:
  /// **'Set Code'**
  String get setCode;

  /// No description provided for @enterSetCode.
  ///
  /// In en, this message translates to:
  /// **'Enter set code'**
  String get enterSetCode;

  /// No description provided for @accessType.
  ///
  /// In en, this message translates to:
  /// **'Access Type'**
  String get accessType;

  /// No description provided for @dataAccessConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Data Access Configuration'**
  String get dataAccessConfiguration;

  /// No description provided for @accessCriteriaChooseOne.
  ///
  /// In en, this message translates to:
  /// **'Access Criteria (Choose One)'**
  String get accessCriteriaChooseOne;

  /// No description provided for @selectAccessCriteria.
  ///
  /// In en, this message translates to:
  /// **'Select access criteria'**
  String get selectAccessCriteria;

  /// No description provided for @ledgersSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} Ledgers Selected'**
  String ledgersSelected(int count);

  /// No description provided for @noLedgersFound.
  ///
  /// In en, this message translates to:
  /// **'No ledgers found'**
  String get noLedgersFound;

  /// No description provided for @legalEntitiesSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} Legal Entities Selected'**
  String legalEntitiesSelected(int count);

  /// No description provided for @noLegalEntitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No legal entities found'**
  String get noLegalEntitiesFound;

  /// No description provided for @createSet.
  ///
  /// In en, this message translates to:
  /// **'Create Set'**
  String get createSet;

  /// No description provided for @editDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Edit Data Access Set'**
  String get editDataAccessSet;

  /// No description provided for @updateSet.
  ///
  /// In en, this message translates to:
  /// **'Update Set'**
  String get updateSet;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get enterDescription;

  /// No description provided for @noDataAccessSetsFound.
  ///
  /// In en, this message translates to:
  /// **'No data access sets found'**
  String get noDataAccessSetsFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search criteria'**
  String get tryAdjustingFilters;

  /// No description provided for @noPoliciesFound.
  ///
  /// In en, this message translates to:
  /// **'No policies found'**
  String get noPoliciesFound;

  /// No description provided for @noTemplatesFound.
  ///
  /// In en, this message translates to:
  /// **'No templates found'**
  String get noTemplatesFound;

  /// No description provided for @noRolesFound.
  ///
  /// In en, this message translates to:
  /// **'No roles found'**
  String get noRolesFound;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @noPrivilegesFound.
  ///
  /// In en, this message translates to:
  /// **'No privileges found'**
  String get noPrivilegesFound;

  /// No description provided for @functionPrivilegesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage function-level security privileges'**
  String get functionPrivilegesSubtitle;

  /// No description provided for @createPrivilege.
  ///
  /// In en, this message translates to:
  /// **'Create Privilege'**
  String get createPrivilege;

  /// No description provided for @searchPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Search privileges...'**
  String get searchPrivileges;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @usedInRolesCount.
  ///
  /// In en, this message translates to:
  /// **'Used in {count} roles'**
  String usedInRolesCount(int count);

  /// No description provided for @functionArea.
  ///
  /// In en, this message translates to:
  /// **'Function'**
  String get functionArea;

  /// No description provided for @actionType.
  ///
  /// In en, this message translates to:
  /// **'Operation'**
  String get actionType;

  /// No description provided for @selectActionType.
  ///
  /// In en, this message translates to:
  /// **'Select Operation'**
  String get selectActionType;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Status'**
  String get selectStatus;

  /// No description provided for @createPrivilegeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Function Privilege'**
  String get createPrivilegeTitle;

  /// No description provided for @editPrivilegeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Function Privilege'**
  String get editPrivilegeTitle;

  /// No description provided for @privilegeName.
  ///
  /// In en, this message translates to:
  /// **'Privilege Name'**
  String get privilegeName;

  /// No description provided for @enterPrivilegeName.
  ///
  /// In en, this message translates to:
  /// **'Enter privilege name'**
  String get enterPrivilegeName;

  /// No description provided for @privilegeCode.
  ///
  /// In en, this message translates to:
  /// **'Privilege Code'**
  String get privilegeCode;

  /// No description provided for @enterPrivilegeCode.
  ///
  /// In en, this message translates to:
  /// **'Enter privilege code'**
  String get enterPrivilegeCode;

  /// No description provided for @privilegeDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get privilegeDescription;

  /// No description provided for @selectModule.
  ///
  /// In en, this message translates to:
  /// **'Select Module'**
  String get selectModule;

  /// No description provided for @privilegeCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Privilege created successfully'**
  String get privilegeCreatedSuccessfully;

  /// No description provided for @privilegeUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Privilege updated successfully'**
  String get privilegeUpdatedSuccessfully;

  /// No description provided for @module.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get module;

  /// No description provided for @privilege.
  ///
  /// In en, this message translates to:
  /// **'Privilege'**
  String get privilege;

  /// No description provided for @rootRoles.
  ///
  /// In en, this message translates to:
  /// **'Root Roles'**
  String get rootRoles;

  /// No description provided for @hierarchyStructure.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy Structure'**
  String get hierarchyStructure;

  /// No description provided for @saveRole.
  ///
  /// In en, this message translates to:
  /// **'Save Role'**
  String get saveRole;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @pleaseEnterRoleName.
  ///
  /// In en, this message translates to:
  /// **'Please enter role name'**
  String get pleaseEnterRoleName;

  /// No description provided for @pleaseEnterRoleCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter role code'**
  String get pleaseEnterRoleCode;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @activeRole.
  ///
  /// In en, this message translates to:
  /// **'Active Role'**
  String get activeRole;

  /// No description provided for @assignPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Assign Privileges'**
  String get assignPrivileges;

  /// No description provided for @functions.
  ///
  /// In en, this message translates to:
  /// **'Functions'**
  String get functions;

  /// No description provided for @securityIncidents.
  ///
  /// In en, this message translates to:
  /// **'Security Incidents'**
  String get securityIncidents;

  /// No description provided for @securityAlerts.
  ///
  /// In en, this message translates to:
  /// **'Security Alerts'**
  String get securityAlerts;

  /// No description provided for @recentSecurityActivities.
  ///
  /// In en, this message translates to:
  /// **'Recent Security Activities'**
  String get recentSecurityActivities;

  /// No description provided for @configureDataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Configure Data Security'**
  String get configureDataSecurity;

  /// No description provided for @viewAuditLogs.
  ///
  /// In en, this message translates to:
  /// **'View Audit Logs'**
  String get viewAuditLogs;

  /// No description provided for @passwordPolicyCompliance.
  ///
  /// In en, this message translates to:
  /// **'Password Policy Compliance'**
  String get passwordPolicyCompliance;

  /// No description provided for @multiFactorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Multi-Factor Authentication'**
  String get multiFactorAuthentication;

  /// No description provided for @activeUserReview.
  ///
  /// In en, this message translates to:
  /// **'Active User Review'**
  String get activeUserReview;

  /// No description provided for @segregationOfDuties.
  ///
  /// In en, this message translates to:
  /// **'Segregation of Duties'**
  String get segregationOfDuties;

  /// No description provided for @complianceStatus.
  ///
  /// In en, this message translates to:
  /// **'Compliance Status'**
  String get complianceStatus;

  /// No description provided for @passwordsExpiring.
  ///
  /// In en, this message translates to:
  /// **'Passwords Expiring'**
  String get passwordsExpiring;

  /// No description provided for @complianceScore.
  ///
  /// In en, this message translates to:
  /// **'Compliance Score'**
  String get complianceScore;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
