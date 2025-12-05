import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../providers/sidebar_provider.dart';
import '../widgets/app_sidebar.dart';

class DashboardShell extends ConsumerWidget {
  final Widget child;

  const DashboardShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final sidebarState = ref.watch(sidebarProvider);

    return Scaffold(
      backgroundColor: context.themeBackground,
      appBar: isMobile
          ? AppBar(
              backgroundColor: context.themeCardBackground,
              title: const Text('Digify ERP'),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              actions: [
                if (!sidebarState.isCollapsed)
                  IconButton(
                    icon: const Icon(Icons.menu_open),
                    onPressed: () {
                      ref.read(sidebarProvider.notifier).toggleCollapsed();
                    },
                  ),
              ],
            )
          : null,
      drawer: isMobile
          ? Drawer(
              child: AppSidebar(
                onClose: () => Navigator.pop(context),
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile) const AppSidebar(),
          Expanded(
            child: Column(
              children: [
                if (!isMobile)
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: context.themeCardBackground,
                      border: Border(
                        bottom: BorderSide(
                          color: context.themeCardBorder,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            sidebarState.isCollapsed
                                ? Icons.menu
                                : Icons.menu_open,
                            color: context.themeTextTertiary,
                          ),
                          onPressed: () {
                            ref.read(sidebarProvider.notifier).toggleCollapsed();
                          },
                        ),
                      ],
                    ),
                  ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
