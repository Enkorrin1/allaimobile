import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'creator@allai.market');
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.authLoginTitle)),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
          ),
          children: [
            Text(l10n.authLoginHeadline, style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.authLoginSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  AppTextField(
                    key: const Key('login-email-field'),
                    controller: _emailController,
                    label: l10n.authEmailLabel,
                    hintText: l10n.authEmailHint,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    errorText: _emailError,
                    prefixIcon: const Icon(Icons.alternate_email),
                    onChanged: (_) => setState(() => _emailError = null),
                    autofillHints: const [AutofillHints.username],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    key: const Key('login-password-field'),
                    controller: _passwordController,
                    label: l10n.authPasswordLabel,
                    hintText: l10n.authPasswordHint,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    errorText: _passwordError,
                    prefixIcon: const Icon(Icons.lock_outline),
                    onChanged: (_) => setState(() => _passwordError = null),
                    autofillHints: const [AutofillHints.password],
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword
                          ? l10n.authShowPassword
                          : l10n.authHidePassword,
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (auth.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppCard(
                color: theme.colorScheme.errorContainer,
                borderColor: Colors.transparent,
                child: Text(
                  auth.errorMessage!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: auth.isSubmitting
                  ? l10n.authLoginSubmitting
                  : l10n.authLoginButton,
              icon: Icons.login,
              fullWidth: true,
              onPressed: auth.isSubmitting ? null : _submit,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: l10n.authForgotPassword,
              icon: Icons.help_outline,
              secondary: true,
              fullWidth: true,
              onPressed: () => context.go(AppRoutes.passwordReset),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => context.go(AppRoutes.register),
              child: Text(l10n.authCreateAccount),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    final success = await ref
        .read(authControllerProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (success && mounted) context.go(AppRoutes.home);
  }

  bool _validate() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    String? emailError;
    String? passwordError;

    if (email.isEmpty) {
      emailError = context.l10n.authEmailRequired;
    } else if (!_looksLikeEmail(email)) {
      emailError = context.l10n.authEmailInvalid;
    }
    if (password.isEmpty) {
      passwordError = context.l10n.authPasswordRequired;
    }

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });
    return emailError == null && passwordError == null;
  }

  bool _looksLikeEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }
}
