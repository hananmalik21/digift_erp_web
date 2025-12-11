import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../gen/assets.gen.dart';

class DutyRolesCreateButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onCreate;

  const DutyRolesCreateButton({
    super.key,
    required this.isDark,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 167.41,
      height: 36,
      child: ElevatedButton(
        onPressed: onCreate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF030213),
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.icons.addIcon.path,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Create Duty Role',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7,
                fontWeight: FontWeight.w500,
                height: 1.21,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
