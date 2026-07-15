import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/secure_storage.dart';

class FavoritesState {
  const FavoritesState({
    this.modelIds = const {},
    this.templateIds = const {},
    this.isRestoring = true,
  });

  final Set<String> modelIds;
  final Set<String> templateIds;
  final bool isRestoring;

  bool hasModel(String id) => modelIds.contains(id);
  bool hasTemplate(String id) => templateIds.contains(id);
}

final favoritesControllerProvider =
    NotifierProvider<FavoritesController, FavoritesState>(
      FavoritesController.new,
    );

class FavoritesController extends Notifier<FavoritesState> {
  static const storageKey = 'allai.favorites.v1';
  Future<void>? _restoreFuture;

  @override
  FavoritesState build() {
    _restoreFuture = Future<void>.microtask(_readStored);
    return const FavoritesState();
  }

  Future<void> toggleModel(String id) async {
    await restore();
    final ids = {...state.modelIds};
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    state = FavoritesState(
      modelIds: ids,
      templateIds: state.templateIds,
      isRestoring: false,
    );
    await _persist();
  }

  Future<void> toggleTemplate(String id) async {
    await restore();
    final ids = {...state.templateIds};
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    state = FavoritesState(
      modelIds: state.modelIds,
      templateIds: ids,
      isRestoring: false,
    );
    await _persist();
  }

  Future<void> restore() => _restoreFuture ??= _readStored();

  Future<void> _readStored() async {
    final raw = await ref.read(secureStorageProvider).read(storageKey);
    if (!ref.mounted) return;
    try {
      final json = raw == null
          ? const <String, dynamic>{}
          : jsonDecode(raw) as Map<String, dynamic>;
      state = FavoritesState(
        modelIds: _stringSet(json['models']),
        templateIds: _stringSet(json['templates']),
        isRestoring: false,
      );
    } on Object {
      state = const FavoritesState(isRestoring: false);
    }
  }

  Set<String> _stringSet(Object? value) => value is List
      ? value.whereType<String>().where((id) => id.isNotEmpty).toSet()
      : <String>{};

  Future<void> _persist() {
    return ref
        .read(secureStorageProvider)
        .write(
          storageKey,
          jsonEncode({
            'models': state.modelIds.toList()..sort(),
            'templates': state.templateIds.toList()..sort(),
          }),
        );
  }
}
