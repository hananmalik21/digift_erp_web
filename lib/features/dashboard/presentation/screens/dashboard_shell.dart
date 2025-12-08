import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../providers/sidebar_provider.dart';
import '../widgets/app_sidebar.dart';

class DashboardShell extends ConsumerStatefulWidget {
  final Widget child;

  const DashboardShell({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends ConsumerState<DashboardShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final sidebarState = ref.watch(sidebarProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.themeBackground,
      appBar: isMobile
          ? AppBar(
              backgroundColor: context.themeCardBackground,
              title: const Text('Digify ERP'),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            )
          : null,
      drawer: isMobile
          ? Drawer(
              backgroundColor: const Color(0xFF1D293D),
              child: const AppSidebar(isMobileDrawer: true),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile) const AppSidebar(isMobileDrawer: false),
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
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
