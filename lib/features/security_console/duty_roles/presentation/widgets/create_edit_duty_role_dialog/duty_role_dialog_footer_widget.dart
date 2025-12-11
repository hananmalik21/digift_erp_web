import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_button.dart';

class DutyRoleDialogFooter extends StatelessWidget {
  final bool isEdit;
  final int privilegesCount;
  final bool isLoading;
  final bool isFormValid;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const DutyRoleDialogFooter({
    super.key,
    required this.isEdit,
    required this.privilegesCount,
    required this.isLoading,
    required this.isFormValid,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          if (privilegesCount > 0) ...[
            const Icon(
              Icons.check_circle_outline,
              size: 16,
              color: Color(0xFF45556C),
            ),
            const SizedBox(width: 8),
            Text(
              '$privilegesCount privileges assigned',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                color: Color(0xFF45556C),
                height: 1.21,
              ),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: 95.35,
            height: 36,
            child: OutlinedButton(
              onPressed: isLoading ? null : onCancel,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0F172B),
                side: const BorderSide(color: Color(0xFFCAD5E2)),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.7,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172B),
                  height: 1.46,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CustomButton(
            text: isEdit ? 'Update Duty Role' : 'Create Duty Role',
            onPressed: isFormValid ? onSave : null,
            isLoading: isLoading,
            isEditMode: isEdit,
            width: 171.66,
            height: 36,
          ),
        ],
      ),
    );
  }
}
