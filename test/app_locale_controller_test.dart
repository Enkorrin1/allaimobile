import 'package:allai_mobile/app/locale/app_locale_controller.dart';
import 'package:allai_mobile/core/storage/secure_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'locale controller persists selected locale and supports system reset',
    () async {
      final storage = InMemorySecureStorage();
      final container = ProviderContainer(
        overrides: [secureStorageProvider.overrideWithValue(storage)],
      );
      addTearDown(container.dispose);

      await container
          .read(appLocaleControllerProvider.notifier)
          .selectLocale(const Locale('ru'));

      expect(
        container.read(appLocaleControllerProvider).locale?.languageCode,
        'ru',
      );
      expect(await storage.read(AppLocaleController.storageKey), 'ru');

      await container
          .read(appLocaleControllerProvider.notifier)
          .selectLocale(null);

      expect(container.read(appLocaleControllerProvider).locale, isNull);
      expect(await storage.read(AppLocaleController.storageKey), isNull);
    },
  );

  test('locale controller restores valid stored locale', () async {
    final storage = InMemorySecureStorage({
      AppLocaleController.storageKey: 'ja',
    });
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    await container.read(appLocaleControllerProvider.notifier).restoreLocale();

    expect(
      container.read(appLocaleControllerProvider).locale?.languageCode,
      'ja',
    );
  });
}
