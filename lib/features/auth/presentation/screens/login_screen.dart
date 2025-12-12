import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _autoFillDemoCredentials() {
    _emailController.text = 'admin@digify.com';
    _passwordController.text = 'Admin123!';
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        final authState = ref.read(authProvider);
        if (authState.isAuthenticated) {
          context.go('/dashboard');
        } else if (authState.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authState.error!),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.all(20), // ⭐ Outer margin
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 773,
                      maxHeight: constraints.maxHeight - 40, // ⭐ Card always fits screen
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 96.5,
                        // vertical: isMobile ? 28 : 60,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),

                      // ⭐ Card content scrolls internally
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isMobile ? 28.verticalSpace : 60.verticalSpace,
                              _buildHeader(context, l10n, isMobile),
                              const SizedBox(height: 24),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    _buildEmailField(context, l10n),
                                    const SizedBox(height: 16),
                                    _buildPasswordField(context, l10n),
                                    const SizedBox(height: 24),
                                    _buildSignInButton(context, l10n, authState),
                                    const SizedBox(height: 32),
                                    _buildDivider(context, l10n),
                                    const SizedBox(height: 32),
                                    _buildCreateAccountButton(context, l10n),
                                    const SizedBox(height: 32),
                                    _buildDemoCredentialsCard(context, l10n),
                                    const SizedBox(height: 24),
                                    _buildHelpLink(context, l10n),
                                    isMobile ? 28.verticalSpace : 60.verticalSpace,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isMobile) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF9810FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.lock,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 24 : 27.7,
            fontWeight: FontWeight.w400,
            height: 36 / 27.7,
            color: const Color(0xFF0A0A0A),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to Digify ERP',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 14 : 15.3,
            fontWeight: FontWeight.w400,
            height: 24 / 15.3,
            color: const Color(0xFF4A5565),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.6,
            fontWeight: FontWeight.w400,
            height: 20 / 13.6,
            color: const Color(0xFF0A0A0A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.3,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0A0A0A),
            ),
            decoration: InputDecoration(
              hintText: 'you@company.com',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.3,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
              ),
              prefixIcon: const Icon(
                Icons.email_outlined,
                size: 20,
                color: Color(0xFF6A7282),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.fieldRequired;
              }
              if (!value.contains('@')) {
                return l10n.invalidEmail;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.3,
            fontWeight: FontWeight.w400,
            height: 20 / 13.3,
            color: const Color(0xFF0A0A0A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.1,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0A0A0A),
            ),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.1,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
              ),
              prefixIcon: const Icon(
                Icons.lock_outlined,
                size: 20,
                color: Color(0xFF6A7282),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 20,
                  color: const Color(0xFF6A7282),
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.fieldRequired;
              }
              if (value.length < 6) {
                return l10n.passwordTooShort;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(BuildContext context, AppLocalizations l10n, AuthState authState) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: ElevatedButton(
        onPressed: authState.isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF030213),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: authState.isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Sign In',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.9,
                  fontWeight: FontWeight.w500,
                  height: 20 / 13.9,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context, AppLocalizations l10n) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 1,
          color: const Color(0xFFE5E7EB),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Don't have an account?",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              height: 20 / 13.7,
              color: const Color(0xFF6A7282),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: OutlinedButton(
        onPressed: () => context.go('/signup'),
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFE9EBEF),
          side: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Create New Account',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w500,
            height: 20 / 13.7,
            color: const Color(0xFF030213),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCredentialsCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(
          color: const Color(0xFFBEDBFF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demo Credentials:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.7,
              fontWeight: FontWeight.w400,
              height: 20 / 13.7,
              color: const Color(0xFF1C398E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Email: admin@digify.com\nPassword: Admin123!',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              height: 16 / 11.8,
              color: const Color(0xFF1447E6),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 28,
            child: ElevatedButton(
              onPressed: _autoFillDemoCredentials,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF155DFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 0,
              ),
              child: Text(
                'Auto-Fill & Test Login',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Note: Demo account is auto-created on server startup. If\nlogin fails, click "Fix Demo Account" button above.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.8,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              height: 16 / 11.8,
              color: const Color(0xFF155DFC),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpLink(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline,
          size: 16,
          color: Color(0xFF4A5565),
        ),
        const SizedBox(width: 8),
        Text(
          'Having trouble logging in? Click here for help',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.7,
            fontWeight: FontWeight.w400,
            height: 20 / 13.7,
            color: const Color(0xFF4A5565),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
