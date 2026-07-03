import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/auth/auth_session.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _confirmedAge18 = false;
  bool _obscurePassword = true;

  bool get _canSubmit {
    return _emailController.text.contains('@') &&
        _passwordController.text.length >= 8 &&
        _passwordController.text == _repeatPasswordController.text &&
        _acceptedTerms &&
        _acceptedPrivacy &&
        _confirmedAge18;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
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
            Text('Создать аккаунт', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Создайте демо-аккаунт. Локальная сессия сохранится на этом устройстве.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            AppTextField(
              key: const Key('register-email-field'),
              controller: _emailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('register-name-field'),
              controller: _nameController,
              label: 'Имя',
              hintText: 'Как к вам обращаться',
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
            ),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('register-password-field'),
              controller: _passwordController,
              label: 'Пароль',
              hintText: 'Минимум 8 символов',
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              autofillHints: const [AutofillHints.newPassword],
              suffixIcon: IconButton(
                tooltip: _obscurePassword ? 'Показать пароль' : 'Скрыть пароль',
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
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('register-repeat-password-field'),
              controller: _repeatPasswordController,
              label: 'Повторите пароль',
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              autofillHints: const [AutofillHints.newPassword],
            ),
            const SizedBox(height: 18),
            CheckboxListTile(
              key: const Key('register-terms-checkbox'),
              value: _acceptedTerms,
              onChanged: (value) {
                setState(() => _acceptedTerms = value ?? false);
              },
              title: _legalLabel(
                prefix: 'Я принимаю ',
                linkLabel: 'условия использования',
                title: 'Условия использования',
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              key: const Key('register-privacy-checkbox'),
              value: _acceptedPrivacy,
              onChanged: (value) {
                setState(() => _acceptedPrivacy = value ?? false);
              },
              title: _legalLabel(
                prefix: 'Я принимаю ',
                linkLabel: 'политику конфиденциальности',
                title: 'Политика конфиденциальности',
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              key: const Key('register-age-checkbox'),
              value: _confirmedAge18,
              onChanged: (value) {
                setState(() => _confirmedAge18 = value ?? false);
              },
              title: const Text('Подтверждаю, что мне есть 18 лет'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            if (auth.errorMessage != null) ...[
              const SizedBox(height: 12),
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
            const SizedBox(height: 20),
            AppButton(
              label: auth.isSubmitting ? 'Создаем...' : 'Создать аккаунт',
              icon: Icons.person_add_alt_1,
              onPressed: auth.isSubmitting || !_canSubmit ? null : _submit,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('Уже есть аккаунт? Войти'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legalLabel({
    required String prefix,
    required String linkLabel,
    required String title,
  }) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(prefix),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => _showLegalPlaceholder(title),
          child: Text(linkLabel),
        ),
      ],
    );
  }

  void _showLegalPlaceholder(String title) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Юридический текст будет подключен после утверждения ссылок. Сейчас это демо-заглушка.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Понятно'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    final now = DateTime.now().toUtc();
    final success = await ref
        .read(authControllerProvider.notifier)
        .register(
          email: _emailController.text,
          password: _passwordController.text,
          displayName: _nameController.text,
          legalConsent: LegalConsent(
            acceptedTerms: _acceptedTerms,
            acceptedPrivacy: _acceptedPrivacy,
            confirmedAge18: _confirmedAge18,
            consentVersion: '2026-07',
            acceptedAt: now,
          ),
        );
    if (success && mounted) context.go(AppRoutes.home);
  }
}
