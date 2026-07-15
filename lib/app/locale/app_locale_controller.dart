import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/secure_storage.dart';

class AppLanguageOption {
  const AppLanguageOption({
    required this.code,
    required this.nativeName,
    required this.englishName,
  });

  final String code;
  final String nativeName;
  final String englishName;

  Locale get locale => Locale(code);
}

class AppLocaleState {
  const AppLocaleState({this.locale, this.isRestoring = false});

  const AppLocaleState.restoring() : locale = null, isRestoring = true;

  final Locale? locale;
  final bool isRestoring;
}

const supportedAppLanguages = <AppLanguageOption>[
  AppLanguageOption(code: 'en', nativeName: 'English', englishName: 'English'),
  AppLanguageOption(code: 'ru', nativeName: 'Русский', englishName: 'Russian'),
  AppLanguageOption(code: 'es', nativeName: 'Español', englishName: 'Spanish'),
  AppLanguageOption(code: 'fr', nativeName: 'Français', englishName: 'French'),
  AppLanguageOption(code: 'de', nativeName: 'Deutsch', englishName: 'German'),
  AppLanguageOption(
    code: 'pt',
    nativeName: 'Português',
    englishName: 'Portuguese',
  ),
  AppLanguageOption(code: 'it', nativeName: 'Italiano', englishName: 'Italian'),
  AppLanguageOption(code: 'tr', nativeName: 'Türkçe', englishName: 'Turkish'),
  AppLanguageOption(code: 'ar', nativeName: 'العربية', englishName: 'Arabic'),
  AppLanguageOption(code: 'hi', nativeName: 'हिन्दी', englishName: 'Hindi'),
  AppLanguageOption(code: 'zh', nativeName: '中文', englishName: 'Chinese'),
  AppLanguageOption(code: 'ja', nativeName: '日本語', englishName: 'Japanese'),
];

final appLocaleControllerProvider =
    NotifierProvider<AppLocaleController, AppLocaleState>(
      AppLocaleController.new,
    );

class AppLocaleController extends Notifier<AppLocaleState> {
  static const storageKey = 'allai.app.locale.v1';

  @override
  AppLocaleState build() {
    Future.microtask(restoreLocale);
    return const AppLocaleState.restoring();
  }

  Future<void> selectLocale(Locale? locale) async {
    final storage = ref.read(secureStorageProvider);
    if (locale == null) {
      await storage.delete(storageKey);
      state = const AppLocaleState();
      return;
    }

    final option = appLanguageOptionForCode(locale.languageCode);
    if (option == null) return;

    await storage.write(storageKey, option.code);
    state = AppLocaleState(locale: option.locale);
  }

  Future<void> restoreLocale() async {
    final storage = ref.read(secureStorageProvider);
    final storedCode = await storage.read(storageKey);
    if (!ref.mounted) return;

    final option = appLanguageOptionForCode(storedCode);

    if (storedCode != null && option == null) {
      await storage.delete(storageKey);
      if (!ref.mounted) return;
    }

    state = AppLocaleState(locale: option?.locale);
  }
}

AppLanguageOption? appLanguageOptionForCode(String? code) {
  if (code == null || code.isEmpty) return null;
  for (final option in supportedAppLanguages) {
    if (option.code == code) return option;
  }
  return null;
}

String appLanguageLabel(Locale? locale, String systemLabel) {
  final option = appLanguageOptionForCode(locale?.languageCode);
  return option?.nativeName ?? systemLabel;
}
