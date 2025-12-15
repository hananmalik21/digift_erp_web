import 'package:digify_erp/features/security_console/duty_roles/data/models/duty_role_reference.dart';
import 'package:flutter/material.dart';

class DutyRoleDialogInheritFromSection extends StatelessWidget {
  final bool isDark;
  final TextEditingController searchController;
  final List<DutyRoleReference> searchResults;
  final List<DutyRoleReference> selectedDutyRoles;
  final bool isLoading;
  final String? error;
  final ValueChanged<DutyRoleReference> onDutyRoleSelected;
  final ValueChanged<DutyRoleReference> onDutyRoleRemoved;
  final ValueChanged<String> onSearchChanged;

  const DutyRoleDialogInheritFromSection({
    super.key,
    required this.isDark,
    required this.searchController,
    required this.searchResults,
    required this.selectedDutyRoles,
    required this.isLoading,
    this.error,
    required this.onDutyRoleSelected,
    required this.onDutyRoleRemoved,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_tree_outlined,
                size: 20,
                color: const Color(0xFF155DFC),
              ),
              const SizedBox(width: 8),
              const Text(
                'Inherit from Duty Roles',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.3,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF0F172B),
                  height: 1.57,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${selectedDutyRoles.length} selected',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F172B),
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Inherit all privileges from existing duty roles',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A5565),
              height: 1.47,
            ),
          ),
          const SizedBox(height: 4),
          // Selected duty roles chips
          if (selectedDutyRoles.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedDutyRoles.map((dr) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    border: Border.all(color: const Color(0xFF90CAF9)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dr.dutyRoleName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF155DFC),
                          height: 1.33,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => onDutyRoleRemoved(dr),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Color(0xFF155DFC),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 26),
          const Text(
            'Search Duty Roles',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.8,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0F172B),
              height: 1.01,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.7,
                fontWeight: FontWeight.w400,
                color: Color(0xFF0F172B),
              ),
              decoration: const InputDecoration(
                hintText: 'Type to search duty roles...',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.7,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF717182),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8.75,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Duty roles list - only show when there are search results or loading
          if (searchController.text.trim().isNotEmpty) ...[
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (error != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading duty roles: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (searchResults.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No duty roles found',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.6,
                    color: Color(0xFF717182),
                  ),
                ),
              )
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final dutyRole = searchResults[index];
                    final isSelected = selectedDutyRoles.any(
                      (dr) => dr.dutyRoleId == dutyRole.dutyRoleId,
                    );
                    
                    return InkWell(
                      onTap: () => onDutyRoleSelected(dutyRole),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFFE3F2FD) 
                              : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                              size: 20,
                              color: isSelected 
                                  ? const Color(0xFF155DFC) 
                                  : const Color(0xFF717182),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dutyRole.dutyRoleName,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13.6,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF0F172B),
                                    ),
                                  ),
                                  Text(
                                    dutyRole.roleCode,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF717182),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ],
      ),
    );
  }
}
