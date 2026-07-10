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

class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  ConsumerState<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final _emailController = TextEditingController();
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.authResetTitle)),
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
            Text(l10n.authResetTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.authResetSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AppTextField(
                key: const Key('reset-email-field'),
                controller: _emailController,
                label: l10n.authEmailLabel,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                errorText: _emailError,
                prefixIcon: const Icon(Icons.alternate_email),
                onChanged: (_) => setState(() => _emailError = null),
                autofillHints: const [AutofillHints.email],
              ),
            ),
            if (auth.passwordResetSent) ...[
              const SizedBox(height: AppSpacing.md),
              AppCard(
                color: theme.colorScheme.primaryContainer,
                borderColor: Colors.transparent,
                child: Text(
                  l10n.authResetSuccess,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
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
                  ? l10n.authResetSubmitting
                  : l10n.authResetButton,
              icon: Icons.mark_email_read_outlined,
              fullWidth: true,
              onPressed: auth.isSubmitting ? null : _submit,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => context.go(AppRoutes.login),
              child: Text(l10n.authBackToLogin),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_validate()) return;
    ref
        .read(authControllerProvider.notifier)
        .requestPasswordReset(_emailController.text);
  }

  bool _validate() {
    final email = _emailController.text.trim();
    String? emailError;
    if (email.isEmpty) {
      emailError = context.l10n.authEmailRequired;
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      emailError = context.l10n.authEmailInvalid;
    }

    setState(() => _emailError = emailError);
    return emailError == null;
  }
}
