import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../providers/duty_roles_provider.dart';
import '../../widgets/create_edit_duty_role_dialog.dart';
import 'duty_roles_refresh_button.dart';
import 'duty_roles_create_button.dart';

class DutyRolesHeader extends ConsumerWidget {
  final bool isDark;
  final bool isMobile;
  final DutyRolesState state;
  final AutoDisposeStateNotifierProvider<DutyRolesNotifier, DutyRolesState> dutyRolesProvider;

  const DutyRolesHeader({
    super.key,
    required this.isDark,
    required this.isMobile,
    required this.state,
    required this.dutyRolesProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF155DFC).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.icons.dutyRoleIcon.path,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF155DFC),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Duty Roles',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.7,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172B),
                    height: 1.16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Functional roles that group related privileges by business process',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF717182),
              height: 1.46,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DutyRolesRefreshButton(
                  isDark: isDark,
                  isLoading: state.isRefreshing,
                  onRefresh: () => ref.read(dutyRolesProvider.notifier).refresh(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DutyRolesCreateButton(
                  isDark: isDark,
                  onCreate: () {
                    showDialog(
                      context: context,
                      builder: (context) => const CreateEditDutyRoleDialog(),
                    ).then((result) {
                      if (context.mounted && result != null && result['success'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result['message'] ?? 'Operation successful'),
                            backgroundColor: const Color(0xFF00A63E),
                          ),
                        );
                        ref.read(dutyRolesProvider.notifier).refresh();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF155DFC).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: SvgPicture.asset(
              Assets.icons.dutyRoleIcon.path,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFF155DFC),
                BlendMode.srcIn,
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
                'Duty Roles',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20.7,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172B),
                  height: 1.16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Functional roles that group related privileges by business process',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.7,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF717182),
                  height: 1.46,
                ),
              ),
            ],
          ),
        ),
        DutyRolesRefreshButton(
          isDark: isDark,
          isLoading: state.isRefreshing,
          onRefresh: () => ref.read(dutyRolesProvider.notifier).refresh(),
        ),
        const SizedBox(width: 8),
        DutyRolesCreateButton(
          isDark: isDark,
          onCreate: () {
            showDialog(
              context: context,
              builder: (context) => const CreateEditDutyRoleDialog(),
            ).then((result) {
              if (context.mounted && result != null && result['success'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result['message'] ?? 'Operation successful'),
                    backgroundColor: const Color(0xFF00A63E),
                  ),
                );
                ref.read(dutyRolesProvider.notifier).refresh();
              }
            });
          },
        ),
      ],
    );
  }
}
