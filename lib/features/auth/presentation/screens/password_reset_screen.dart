import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Восстановление')),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          children: [
            Text('Сброс пароля', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Укажите email. Мы покажем безопасное демо-подтверждение.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            AppTextField(
              key: const Key('reset-email-field'),
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              errorText: _emailError,
              onChanged: (_) => setState(() => _emailError = null),
              autofillHints: const [AutofillHints.email],
            ),
            if (auth.passwordResetSent) ...[
              const SizedBox(height: 16),
              AppCard(
                color: theme.colorScheme.primaryContainer,
                child: Text(
                  'Если аккаунт существует, мы отправим инструкцию',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
            if (auth.errorMessage != null) ...[
              const SizedBox(height: 16),
              AppCard(
                color: theme.colorScheme.errorContainer,
                child: Text(
                  auth.errorMessage!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            AppButton(
              label: auth.isSubmitting
                  ? 'Отправляем...'
                  : 'Отправить инструкцию',
              icon: Icons.mark_email_read_outlined,
              onPressed: auth.isSubmitting ? null : _submit,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('Вернуться ко входу'),
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
      emailError = 'Введите email';
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      emailError = 'Введите корректный email';
    }

    setState(() => _emailError = emailError);
    return emailError == null;
  }
}
