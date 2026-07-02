import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class LoginPlaceholderScreen extends StatelessWidget {
  const LoginPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const AppTextField(
              label: 'Email',
              hintText: 'creator@allai.market',
            ),
            const SizedBox(height: 16),
            const AppTextField(label: 'Password', hintText: 'Password'),
            const SizedBox(height: 24),
            AppButton(
              label: 'Enter app shell',
              icon: Icons.arrow_forward,
              onPressed: () => context.go('/'),
            ),
          ],
        ),
      ),
    );
  }
}
