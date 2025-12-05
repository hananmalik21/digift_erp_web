import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SidebarUserSection extends ConsumerWidget {
  final bool isCollapsed;

  const SidebarUserSection({
    super.key,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: isCollapsed
          ? _buildCollapsedView(context, ref)
          : _buildExpandedView(context, ref),
    );
  }

  Widget _buildCollapsedView(BuildContext context, WidgetRef ref) {
    return Container(
      key: const ValueKey('collapsed'),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFF314158),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF155DFC),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'A',
                style: TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: 'Sign Out',
            child: InkWell(
              onTap: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
              child: Container(
                width: 48,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF314158),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout,
                  size: 16,
                  color: Color(0xFFCAD5E2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedView(BuildContext context, WidgetRef ref) {
    return Container(
      key: const ValueKey('expanded'),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFF314158),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // User info section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF155DFC),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin User',
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Financial Controller',
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 16 / 12,
                          color: const Color(0xFF90A1B9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Sign Out button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: InkWell(
              onTap: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF314158),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout,
                      size: 16,
                      color: Color(0xFFCAD5E2),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        color: const Color(0xFFCAD5E2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
