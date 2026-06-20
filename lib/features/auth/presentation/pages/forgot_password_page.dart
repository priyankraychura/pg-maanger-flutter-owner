import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Forgot Password Flow'),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
