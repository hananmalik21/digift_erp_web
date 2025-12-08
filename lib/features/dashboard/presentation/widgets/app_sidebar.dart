import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/menu_item_model.dart';
import '../providers/sidebar_provider.dart';
import 'sidebar_header.dart';
import 'sidebar_menu_item.dart';
import 'sidebar_user_section.dart';
import 'sidebar_footer.dart';

class AppSidebar extends ConsumerWidget {
  final bool isMobileDrawer;

  const AppSidebar({
    super.key,
    required this.isMobileDrawer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidebarState = ref.watch(sidebarProvider);
    // On mobile drawer, always show expanded
    final isCollapsed = isMobileDrawer ? false : sidebarState.isCollapsed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: isCollapsed ? 80 : 248,
      decoration: BoxDecoration(
        color: const Color(0xFF1D293D),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRect(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SidebarHeader(
              isCollapsed: isCollapsed,
              isMobileDrawer: isMobileDrawer,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: menuItems.map((item) {
                    return SidebarMenuItem(
                      item: item,
                      isCollapsed: isCollapsed,
                      isMobileDrawer: isMobileDrawer,
                    );
                  }).toList(),
                ),
              ),
            ),
            SidebarUserSection(isCollapsed: isCollapsed),
            SidebarFooter(isCollapsed: isCollapsed),
          ],
        ),
      ),
    );
  }
}
