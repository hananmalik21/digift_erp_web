import 'package:flutter/material.dart';
import '../../data/models/user_account_model.dart';
import '../../data/utils/account_type_mapper.dart';
import 'package:intl/intl.dart';

class UserAccountDetailsDialog extends StatelessWidget {
  final UserAccountModel user;

  const UserAccountDetailsDialog({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Account Details',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.9,
                fontWeight: FontWeight.w600,
                height: 24 / 16.9,
                color: Color(0xFF0A0A0A),
              ),
            ),
            const SizedBox(height: 24),
            // Grid of details
            _buildDetailsGrid(),
            const SizedBox(height: 24),
            // Close button - positioned at bottom right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCloseButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return Column(
      children: [
        // Row 1
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDetailItem('Username', user.username)),
            const SizedBox(width: 24),
            Expanded(child: _buildDetailItem('Display Name', user.displayName ?? user.name)),
            const SizedBox(width: 24),
            Expanded(child: _buildDetailItem('Email', user.email)),
            const SizedBox(width: 24),
            Expanded(child: _buildDetailItemWithBadge(
              'Account Type',
              AccountTypeMapper.toUiFormat(user.accountType),
              _buildAccountTypeBadge(),
            )),
          ],
        ),
        const SizedBox(height: 16),
        // Row 2
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDetailItemWithBadge(
              'Status',
              user.status,
              _buildStatusBadge(user.status),
            )),
            const SizedBox(width: 24),
            Expanded(child: _buildDetailItemWithBadge(
              'MFA Enabled',
              user.mfaEnabled ? 'MFA' : 'No MFA',
              _buildMfaBadge(user.mfaEnabled),
            )),
            const SizedBox(width: 24),
            Expanded(child: _buildDetailItemWithBadge(
              'Password Status',
              _getPasswordStatus(),
              _buildPasswordStatusBadge(),
            )),
            const SizedBox(width: 24),
            Expanded(child: _buildDetailItem('Failed Login Attempts', '0')),
          ],
        ),
        const SizedBox(height: 16),
        // Row 3
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDetailItem('Password Expiry', _formatPasswordExpiry())),
            const SizedBox(width: 24),
            Expanded(child: _buildDetailItem('Account Expiry', user.endDate ?? 'N/A')),
            const SizedBox(width: 24),
            Expanded(child: _buildDetailItem('Created Date', _formatDate(user.accountCreated))),
            const SizedBox(width: 24),
            Expanded(child: _buildDetailItem('Last Modified', _formatDate(user.accountCreated))),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.8,
            fontWeight: FontWeight.w400,
            height: 18 / 12.8,
            color: Color(0xFF6A7282),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w500,
            height: 20 / 13.7,
            color: Color(0xFF0A0A0A),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItemWithBadge(String label, String value, Widget badge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.8,
            fontWeight: FontWeight.w400,
            height: 18 / 12.8,
            color: Color(0xFF6A7282),
          ),
        ),
        const SizedBox(height: 6),
        badge,
      ],
    );
  }

  Widget _buildAccountTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFBEDBFF)),
      ),
      child: const Text(
        'Local',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 16 / 12,
          color: Color(0xFF1447E6),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFFE2E2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isActive ? const Color(0xFFB9F8CF) : const Color(0xFFFFC9C9),
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 16 / 12,
          color: isActive ? const Color(0xFF008236) : const Color(0xFFC10007),
        ),
      ),
    );
  }

  Widget _buildMfaBadge(bool enabled) {
    if (enabled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFB9F8CF)),
        ),
        child: const Text(
          'MFA',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
            color: Color(0xFF008236),
          ),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2E2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFFFC9C9)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFFC10007),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              size: 8,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'No MFA',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
              color: Color(0xFFC10007),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFB9F8CF)),
      ),
      child: const Text(
        'Valid',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 16 / 12,
          color: Color(0xFF008236),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Close',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8,
            fontWeight: FontWeight.w500,
            height: 20 / 13.8,
            color: Color(0xFF4A5565),
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      // Try parsing ISO format
      final date = DateTime.parse(dateString);
      return DateFormat('M/d/yyyy').format(date);
    } catch (e) {
      // If parsing fails, try other formats or return as-is
      return dateString;
    }
  }

  String _formatPasswordExpiry() {
    // Calculate password expiry (90 days from password changed date, or use a default)
    final passwordChanged = user.passwordChanged;
    if (passwordChanged.isNotEmpty) {
      try {
        final changedDate = DateTime.parse(passwordChanged);
        final expiryDate = changedDate.add(const Duration(days: 90));
        return DateFormat('M/d/yyyy').format(expiryDate);
      } catch (e) {
        return 'N/A';
      }
    }
    return 'N/A';
  }

  String _getPasswordStatus() {
    // Calculate if password is valid based on expiry
    final expiry = _formatPasswordExpiry();
    if (expiry == 'N/A') return 'Valid';
    try {
      final expiryDate = DateFormat('M/d/yyyy').parse(expiry);
      if (expiryDate.isAfter(DateTime.now())) {
        return 'Valid';
      }
      return 'Expired';
    } catch (e) {
      return 'Valid';
    }
  }
}
