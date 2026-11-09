import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import 'widgets/login_form.dart';

/// Login page.
class LoginScreen extends StatelessWidget {
  /// Creates the login screen.
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.loginMaxWidth),
            child: const LoginForm(),
          ),
        ),
      ),
    ),
  );
}
