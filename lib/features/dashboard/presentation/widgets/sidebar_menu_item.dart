import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../gen/assets.gen.dart';
import '../../data/models/menu_item_model.dart';
import '../providers/sidebar_provider.dart';

class SidebarMenuItem extends ConsumerWidget {
  final MenuItemModel item;
  final bool isCollapsed;
  final int level;

  const SidebarMenuItem({
    super.key,
    required this.item,
    required this.isCollapsed,
    this.level = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sidebarState = ref.watch(sidebarProvider);
    final isExpanded = sidebarState.expandedItems.contains(item.id);
    final isSelected = sidebarState.selectedItemId == item.id;
    final hasChildren = item.children.isNotEmpty;

    // Check if any child is selected
    final isChildSelected = _isAnyChildSelected(item, sidebarState.selectedItemId);

    // Hide child items when sidebar is collapsed
    if (isCollapsed && level > 0) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMenuItem(
          context,
          ref,
          l10n,
          isSelected,
          isChildSelected,
          hasChildren,
          isExpanded,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: hasChildren && isExpanded && !isCollapsed
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: item.children.map(
                    (child) => SidebarMenuItem(
                      item: child,
                      isCollapsed: isCollapsed,
                      level: level + 1,
                    ),
                  ).toList(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    bool isSelected,
    bool isChildSelected,
    bool hasChildren,
    bool isExpanded,
  ) {
    final menuItem = InkWell(
      onTap: () {
        // If collapsed, expand the sidebar and handle the action
        if (isCollapsed) {
          ref.read(sidebarProvider.notifier).toggleCollapsed();
          
          // Also handle the item action after expanding
          if (hasChildren) {
            ref.read(sidebarProvider.notifier).toggleExpanded(item.id);
          }
          if (item.route != null) {
            ref.read(sidebarProvider.notifier).selectItem(item.id);
            // Delay navigation slightly to allow sidebar to expand first
            Future.delayed(const Duration(milliseconds: 100), () {
              context.go(item.route!);
            });
          }
          return;
        }
        
        if (hasChildren && !isCollapsed) {
          ref.read(sidebarProvider.notifier).toggleExpanded(item.id);
        }
        if (item.route != null) {
          ref.read(sidebarProvider.notifier).selectItem(item.id);
          context.go(item.route!);
        } else if (!hasChildren && !isCollapsed) {
          ref.read(sidebarProvider.notifier).selectItem(item.id);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 40,
        margin: EdgeInsets.only(
          left: isCollapsed ? 8 : (level == 0 ? 12 : 12 + (level * 16)),
          right: isCollapsed ? 8 : 12,
          bottom: 4,
        ),
        padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF155DFC)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            // Icon
            Builder(
              builder: (context) {
                final iconAsset = Assets.icons.values.firstWhere(
                  (asset) => asset.keyName == item.icon,
                  orElse: () => Assets.icons.homeIcon,
                );
                return SvgPicture.asset(
                  iconAsset.path,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : const Color(0xFFCAD5E2),
                    BlendMode.srcIn,
                  ),
                );
              },
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: isCollapsed ? 0.0 : 1.0,
                  child: Text(
                    _getLocalizedTitle(l10n, item.titleKey),
                    style: TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 20 / 14,
                      color: isSelected ? Colors.white : const Color(0xFFCAD5E2),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              if (hasChildren)
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: isExpanded ? 0.25 : 0.0,
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: isSelected ? Colors.white : const Color(0xFFCAD5E2),
                  ),
                ),
            ],
          ],
        ),
      ),
    );

    // Show tooltip when collapsed
    if (isCollapsed && level == 0) {
      return Tooltip(
        message: _getLocalizedTitle(l10n, item.titleKey),
        preferBelow: false,
        child: menuItem,
      );
    }

    return menuItem;
  }

  bool _isAnyChildSelected(MenuItemModel item, String? selectedId) {
    for (final child in item.children) {
      if (child.id == selectedId) return true;
      if (_isAnyChildSelected(child, selectedId)) return true;
    }
    return false;
  }

  String _getLocalizedTitle(AppLocalizations l10n, String titleKey) {
    switch (titleKey) {
      case 'home':
        return l10n.home;
      case 'enterpriseStructure':
        return l10n.enterpriseStructure;
      case 'generalLedger':
        return l10n.generalLedger;
      case 'chartOfAccounts':
        return l10n.chartOfAccounts;
      case 'journalEntries':
        return l10n.journalEntries;
      case 'accountBalances':
        return l10n.accountBalances;
      case 'intercompanyAccounting':
        return l10n.intercompanyAccounting;
      case 'budgetManagement':
        return l10n.budgetManagement;
      case 'financialReportSets':
        return l10n.financialReportSets;
      case 'accountsPayable':
        return l10n.accountsPayable;
      case 'accountsReceivable':
        return l10n.accountsReceivable;
      case 'cashManagement':
        return l10n.cashManagement;
      case 'fixedAssets':
        return l10n.fixedAssets;
      case 'treasury':
        return l10n.treasury;
      case 'expenseManagement':
        return l10n.expenseManagement;
      case 'financialReporting':
        return l10n.financialReporting;
      case 'periodClose':
        return l10n.periodClose;
      case 'workflowApprovals':
        return l10n.workflowApprovals;
      case 'securityConsole':
        return l10n.securityConsole;
      case 'securityDashboard':
        return l10n.securityDashboard;
      case 'userAccounts':
        return l10n.userAccounts;
      case 'userRoleAssignment':
        return l10n.userRoleAssignment;
      case 'roleManagement':
        return l10n.roleManagement;
      case 'roleHierarchy':
        return l10n.roleHierarchy;
      case 'roleTemplates':
        return l10n.roleTemplates;
      case 'functionSecurity':
        return l10n.functionPrivileges;
      case 'functionPrivileges':
        return l10n.functionPrivileges;
      case 'functions':
        return l10n.functions;
      case 'dutyRoles':
        return l10n.dutyRoles;
      case 'jobRoles':
        return l10n.jobRoles;
      case 'securityPolicies':
        return l10n.securityPolicies;
      case 'dataAccessSets':
        return l10n.dataAccessSets;
      case 'auditCompliance':
        return l10n.auditCompliance;
      case 'dataSecurityPrivacy':
        return l10n.dataSecurityPrivacy;
      case 'sessionManagement':
        return l10n.sessionManagement;
      case 'securityReportsAnalytics':
        return l10n.securityReportsAnalytics;
      default:
        return titleKey;
    }
  }
}
