import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../gen/assets.gen.dart';

/// A reusable action buttons widget for table cells
/// Supports view, edit, and delete actions
class CustomActionCell extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isDark;
  final double? width;
  final bool showView;
  final bool showEdit;
  final bool showDelete;

  const CustomActionCell({
    super.key,
    this.onView,
    this.onEdit,
    this.onDelete,
    required this.isDark,
    this.width,
    this.showView = true,
    this.showEdit = true,
    this.showDelete = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = _buildActionButtons(context);
    
    // Always wrap in ClipRect to prevent overflow
    return ClipRect(
      child: width != null
          ? SizedBox(
              width: width!,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: width!,
                  ),
                  child: buttons,
                ),
              ),
            )
          : Center(child: buttons),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttonList = <Widget>[];
    
    if (showView) {
      buttonList.add(
        SizedBox(
          width: 28,
          height: 28,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onView,
              borderRadius: BorderRadius.circular(4),
              child: Center(
                child: SvgPicture.asset(
                  Assets.icons.visibleIcon.path,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    isDark ? Colors.white : const Color(0xFF0F172B),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    if (showEdit) {
      buttonList.add(
        SizedBox(
          width: 28,
          height: 28,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(4),
              child: Center(
                child: SvgPicture.asset(
                  Assets.icons.editIcon.path,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    isDark ? Colors.white : const Color(0xFF0F172B),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    if (showDelete) {
      buttonList.add(
        SizedBox(
          width: 28,
          height: 28,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(4),
              child: Center(
                child: SvgPicture.asset(
                  Assets.icons.deleteIcon.path,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    isDark ? Colors.white : const Color(0xFF0F172B),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: buttonList,
    );
  }
}



