import 'package:allai_mobile/core/storage/secure_storage.dart';
import 'package:allai_mobile/features/saved_prompts/presentation/providers/saved_prompts_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'saved prompts persist, deduplicate and restore model context',
    () async {
      final storage = InMemorySecureStorage();
      final first = ProviderContainer(
        overrides: [secureStorageProvider.overrideWithValue(storage)],
      );
      addTearDown(first.dispose);
      final controller = first.read(savedPromptsControllerProvider.notifier);
      await controller.restore();
      await controller.save(
        text: '  Cinematic product reveal  ',
        category: 'video',
        modelId: 'kling',
      );
      await controller.save(
        text: 'cinematic product reveal',
        category: 'video',
        modelId: 'seedance',
      );

      expect(first.read(savedPromptsControllerProvider), hasLength(1));

      final second = ProviderContainer(
        overrides: [secureStorageProvider.overrideWithValue(storage)],
      );
      addTearDown(second.dispose);
      await second.read(savedPromptsControllerProvider.notifier).restore();
      final restored = second.read(savedPromptsControllerProvider).single;

      expect(restored.text, 'cinematic product reveal');
      expect(restored.modelId, 'seedance');
      expect(restored.category, 'video');
    },
  );

  test('saved prompts enforce limit and recover from malformed data', () async {
    final storage = InMemorySecureStorage();
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    final controller = container.read(savedPromptsControllerProvider.notifier);
    await controller.restore();
    for (var index = 0; index < 24; index += 1) {
      await controller.save(
        text: 'Prompt $index',
        category: 'image',
        modelId: 'model',
      );
    }
    expect(container.read(savedPromptsControllerProvider), hasLength(20));

    final brokenStorage = InMemorySecureStorage({
      SavedPromptsController.storageKey: 'broken-json',
    });
    final broken = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(brokenStorage)],
    );
    addTearDown(broken.dispose);
    await broken.read(savedPromptsControllerProvider.notifier).restore();
    expect(broken.read(savedPromptsControllerProvider), isEmpty);
  });
}
