import 'package:allai_mobile/core/storage/secure_storage.dart';
import 'package:allai_mobile/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('favorites persist model and template ids across containers', () async {
    final storage = InMemorySecureStorage();
    final first = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(first.dispose);

    final controller = first.read(favoritesControllerProvider.notifier);
    await controller.restore();
    await controller.toggleModel('model-1');
    await controller.toggleTemplate('template-1');

    final second = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(second.dispose);
    await second.read(favoritesControllerProvider.notifier).restore();
    final restored = second.read(favoritesControllerProvider);

    expect(restored.modelIds, {'model-1'});
    expect(restored.templateIds, {'template-1'});
  });

  test('favorites recover safely from malformed storage', () async {
    final storage = InMemorySecureStorage({
      FavoritesController.storageKey: 'not-json',
    });
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    await container.read(favoritesControllerProvider.notifier).restore();
    final state = container.read(favoritesControllerProvider);

    expect(state.isRestoring, isFalse);
    expect(state.modelIds, isEmpty);
    expect(state.templateIds, isEmpty);
  });
}
