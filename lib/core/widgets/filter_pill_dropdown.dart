import 'package:flutter/material.dart';

class FilterPillDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool isDark;

  const FilterPillDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor   = isDark ? const Color(0xFF111827) : Colors.white;
    final borderCol = const Color(0xFFD1D5DB);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10), // pill shape
        border: Border.all(color: borderCol, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: false,

          // ⛔ REMOVE ARROW
          icon: const SizedBox.shrink(),

          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
          dropdownColor: bgColor,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
