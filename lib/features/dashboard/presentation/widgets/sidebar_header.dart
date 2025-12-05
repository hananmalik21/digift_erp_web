import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sidebar_provider.dart';

class SidebarHeader extends ConsumerWidget {
  final bool isCollapsed;
  final VoidCallback? onClose;

  const SidebarHeader({
    super.key,
    required this.isCollapsed,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 77,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF314158),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isCollapsed)
            Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: isCollapsed ? 0.0 : 1.0,
                child: Column(
                  key: const ValueKey('expanded'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Digify ERP',
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                        color: const Color(0xFFE7000B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Financial Management',
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                        color: const Color(0xFF90A1B9),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          if (onClose != null && !isCollapsed)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isCollapsed ? 0.0 : 1.0,
              child: IconButton(
                onPressed: onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.close,
                  size: 20,
                  color: Color(0xFFCAD5E2),
                ),
              ),
            ),
          IconButton(
            onPressed: () {
              ref.read(sidebarProvider.notifier).toggleCollapsed();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              isCollapsed ? Icons.menu : Icons.close,
              size: 20,
              color: const Color(0xFFCAD5E2),
            ),
          ),
        ],
      ),
    );
  }
}
