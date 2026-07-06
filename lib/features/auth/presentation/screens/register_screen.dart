import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
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
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
          ),
          children: [
            Text('Создать аккаунт', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Демо-аккаунт сохранит сессию на этом устройстве и откроет доступ к генератору.',
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
                    key: const Key('register-email-field'),
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.alternate_email),
                    onChanged: (_) => setState(() {}),
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    key: const Key('register-name-field'),
                    controller: _nameController,
                    label: 'Имя',
                    hintText: 'Как к вам обращаться',
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline),
                    autofillHints: const [AutofillHints.name],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    key: const Key('register-password-field'),
                    controller: _passwordController,
                    label: 'Пароль',
                    hintText: 'Минимум 8 символов',
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.lock_outline),
                    onChanged: (_) => setState(() {}),
                    autofillHints: const [AutofillHints.newPassword],
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword
                          ? 'Показать пароль'
                          : 'Скрыть пароль',
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
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    key: const Key('register-repeat-password-field'),
                    controller: _repeatPasswordController,
                    label: 'Повторите пароль',
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    onChanged: (_) => setState(() {}),
                    autofillHints: const [AutofillHints.newPassword],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Column(
                children: [
                  CheckboxListTile(
                    key: const Key('register-terms-checkbox'),
                    value: _acceptedTerms,
                    onChanged: (value) {
                      setState(() => _acceptedTerms = value ?? false);
                    },
                    title: _legalLabel(
                      prefix: 'Принимаю ',
                      linkLabel: 'условия использования',
                      title: 'Условия использования',
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    key: const Key('register-privacy-checkbox'),
                    value: _acceptedPrivacy,
                    onChanged: (value) {
                      setState(() => _acceptedPrivacy = value ?? false);
                    },
                    title: _legalLabel(
                      prefix: 'Принимаю ',
                      linkLabel: 'политику конфиденциальности',
                      title: 'Политика конфиденциальности',
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    key: const Key('register-age-checkbox'),
                    value: _confirmedAge18,
                    onChanged: (value) {
                      setState(() => _confirmedAge18 = value ?? false);
                    },
                    title: const Text('Подтверждаю, что мне есть 18 лет'),
                    controlAffinity: ListTileControlAffinity.leading,
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
              label: auth.isSubmitting ? 'Создаем...' : 'Создать аккаунт',
              icon: Icons.person_add_alt_1,
              fullWidth: true,
              onPressed: auth.isSubmitting || !_canSubmit ? null : _submit,
            ),
            const SizedBox(height: AppSpacing.sm),
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
            minimumSize: const Size(0, 40),
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
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xs,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Юридический текст будет подключен после утверждения ссылок. Сейчас это демо-заглушка.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
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
