import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/neon_media_card.dart';

class AuthWelcomeScreen extends StatelessWidget {
  const AuthWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 700;
            final heroHeight = constraints.maxHeight * (compact ? 0.42 : 0.58);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    SizedBox(
                      height: heroHeight,
                      child: const _OnboardingHero(),
                    ),
                    SizedBox(height: compact ? 24 : 42),
                    Text(
                      l10n.authWelcomeTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        height: 1.02,
                      ),
                    ),
                    SizedBox(height: compact ? 12 : 18),
                    Text(
                      l10n.authWelcomeSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFB8B8BE),
                        fontSize: 21,
                        height: 1.28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: compact ? 22 : 34),
                    NeonPillButton(
                      label: l10n.commonContinue,
                      onPressed: () => context.go(AppRoutes.register),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      child: Text(l10n.authWelcomeLogin),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.authWelcomeLegal,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF7D7D84),
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingHero extends StatelessWidget {
  const _OnboardingHero();

  @override
  Widget build(BuildContext context) {
    return NeonMediaCard(
      title: '',
      imageUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1100&q=82',
      width: double.infinity,
      height: double.infinity,
      borderRadius: 30,
    );
  }
}
