import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/duty_roles_provider.dart';
import 'duty_role_card_widget.dart';

class DutyRolesGrid extends ConsumerWidget {
  final bool isDark;
  final bool isMobile;
  final AutoDisposeStateNotifierProvider<DutyRolesNotifier, DutyRolesState> dutyRolesProvider;

  const DutyRolesGrid({
    super.key,
    required this.isDark,
    required this.isMobile,
    required this.dutyRolesProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get updates
    final state = ref.watch(dutyRolesProvider);
    // Show error if there's an error
    if (state.error != null && state.dutyRoles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626),
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading duty roles',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Show loader during initial load
    if (state.isLoading && state.dutyRoles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? Colors.white : const Color(0xFF155DFC),
            ),
          ),
        ),
      );
    }

    // Show empty state when no data and not loading
    if (state.dutyRoles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Text(
            'No duty roles found',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.3,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ),
      );
    }

    if (isMobile) {
      return Column(
        children: state.dutyRoles
            .map(
              (role) => Padding(
                key: ValueKey(role.id),
                padding: const EdgeInsets.only(bottom: 16),
                child: DutyRoleCard(
                  role: role,
                  isDark: isDark,
                  dutyRolesProvider: dutyRolesProvider,
                ),
              ),
            )
            .toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 900 ? 1 : 2;
        final cards = <Widget>[];

        for (int i = 0; i < state.dutyRoles.length; i += columns) {
          final rowCards = <Widget>[];
          for (int j = 0; j < columns && i + j < state.dutyRoles.length; j++) {
            rowCards.add(
              Expanded(
                child: DutyRoleCard(
                  role: state.dutyRoles[i + j],
                  isDark: isDark,
                  dutyRolesProvider: dutyRolesProvider,
                ),
              ),
            );
            if (j < columns - 1 && i + j + 1 < state.dutyRoles.length) {
              rowCards.add(const SizedBox(width: 16));
            }
          }

          // Add extra Expanded to fill empty space if odd number of cards
          if (rowCards.length == 1 && columns == 2) {
            rowCards.add(const Expanded(child: SizedBox()));
          }

          cards.add(
            Padding(
              padding: EdgeInsets.only(
                bottom: i + columns < state.dutyRoles.length ? 16 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowCards,
              ),
            ),
          );
        }

        return Column(children: cards);
      },
    );
  }
}
