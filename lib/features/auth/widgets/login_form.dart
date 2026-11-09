import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/feedback.dart';
import '../../../core/utils/validators.dart';
import '../../../services/demo_auth_service.dart';

/// Login form with inline validation and a loading state.
class LoginForm extends StatefulWidget {
  /// Creates a login form.
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _authService = DemoAuthService();
  bool _isLoading = false;
  String? _authError;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      _authError = null;
    });
    try {
      final authenticated = await _authService.authenticate(
        username: _username.text,
        password: _password.text,
      );
      if (!mounted) return;
      if (!authenticated) {
        setState(() => _authError = AppStrings.invalidCredentials);
        return;
      }
      Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
    } catch (error, stackTrace) {
      debugPrint('TIKTOKTOK login failed: $error\n$stackTrace');
      if (!mounted) return;
      AppFeedback.showError(context, AppStrings.genericError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _BrandPanel(),
            const SizedBox(height: AppSizes.sectionGap),
            Text(
              AppStrings.loginTitle,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            const Text(AppStrings.loginSubtitle),
            const SizedBox(height: AppSizes.sectionGap),
            TextFormField(
              key: const ValueKey('username-field'),
              controller: _username,
              textInputAction: TextInputAction.next,
              validator: AppValidators.username,
              onChanged: (_) {
                if (_authError != null) setState(() => _authError = null);
              },
              decoration: const InputDecoration(
                labelText: AppStrings.username,
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: AppSizes.cardGap),
            TextFormField(
              key: const ValueKey('password-field'),
              controller: _password,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              onChanged: (_) {
                if (_authError != null) setState(() => _authError = null);
              },
              validator: AppValidators.password,
              decoration: const InputDecoration(
                labelText: AppStrings.password,
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
            ),
            if (_authError != null) ...[
              const SizedBox(height: AppSizes.smallGap),
              Text(
                _authError!,
                key: const ValueKey('login-auth-error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSizes.sectionGap),
            FilledButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      key: ValueKey('login-progress'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(AppStrings.login),
            ),
            const SizedBox(height: AppSizes.cardGap),
            Text(
              AppStrings.demoCredentials,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
  );
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSizes.pagePadding),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
    ),
    child: const Column(
      children: [
        Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 48),
        SizedBox(height: 8),
        Text(
          AppStrings.appName,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppSizes.sectionGap,
            fontWeight: FontWeight.w800,
            letterSpacing: AppSizes.profileLetterSpacing,
          ),
        ),
        Text(AppStrings.tagline, style: TextStyle(color: Colors.white70)),
      ],
    ),
  );
}
