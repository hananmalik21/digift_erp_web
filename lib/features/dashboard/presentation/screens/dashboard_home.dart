import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themeBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard,
              size: 100,
              color: context.themeTextTertiary,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Digify ERP',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: context.themeTextPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select a module from the sidebar to get started',
              style: TextStyle(
                fontSize: 16,
                color: context.themeTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

