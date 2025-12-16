import 'package:flutter/material.dart';
import '../../data/models/user_account_model.dart';
import '../../data/datasources/user_account_remote_datasource.dart';
import '../services/user_account_service.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class ResetPasswordDialog extends StatefulWidget {
  final UserAccountModel user;

  const ResetPasswordDialog({
    super.key,
    required this.user,
  });

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final _passwordController = TextEditingController();
  bool _isPasswordValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final isValid = _passwordController.text.length >= 8;
    if (isValid != _isPasswordValid) {
      setState(() {
        _isPasswordValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 500,
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
              'Reset Password',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 24 / 18,
                color: Color(0xFF0A0A0A),
              ),
            ),
            const SizedBox(height: 12),
            // Instruction text
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  color: Color(0xFF0A0A0A),
                ),
                children: [
                  const TextSpan(text: 'Enter a new password for '),
                  TextSpan(
                    text: widget.user.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ':'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Password input field
            CustomTextField(
              controller: _passwordController,
              labelText: null,
              hintText: 'Enter new password (min 8 characters)',
              obscureText: true,
              isRequired: false,
              height: 40,
              fontSize: 14,
              borderRadius: 6,
              fillColor: Colors.white,
              borderColor: const Color(0xFFD1D5DC),
              showBorder: true,
              filled: true,
            ),
            const SizedBox(height: 8),
            // Password requirement hint
            const Text(
              'Password must be at least 8 characters long',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.8,
                fontWeight: FontWeight.w400,
                height: 18 / 12.8,
                color: Color(0xFF6A7282),
              ),
            ),
            const SizedBox(height: 20),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCancelButton(context),
                const SizedBox(width: 12),
                _buildResetPasswordButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFD1D5DC),
          ),
        ),
        child: const Text(
          'Cancel',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.8,
            fontWeight: FontWeight.w500,
            height: 20 / 13.8,
            color: Color(0xFF0A0A0A),
          ),
        ),
      ),
    );
  }

  Future<void> _handleResetPassword(BuildContext context) async {
    if (!_isPasswordValid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final userId = int.tryParse(widget.user.id);
      if (userId == null) {
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Invalid user ID'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final dataSource = UserAccountRemoteDataSourceImpl();
      final service = UserAccountService(dataSource);
      await service.resetPassword(
        userId: userId,
        password: _passwordController.text,
        updatedBy: 'ADMIN',
      );

      if (!mounted) return;
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully'),
          backgroundColor: Color(0xFF00A63E),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to reset password: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildResetPasswordButton(BuildContext context) {
    return InkWell(
      onTap: _isPasswordValid && !_isLoading
          ? () => _handleResetPassword(context)
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _isPasswordValid && !_isLoading
              ? const Color(0xFF030213)
              : const Color(0xFF9B9B9B),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Reset Password',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.8,
                  fontWeight: FontWeight.w500,
                  height: 20 / 13.8,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
