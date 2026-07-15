import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/secure_storage.dart';

class SavedPrompt {
  const SavedPrompt({
    required this.id,
    required this.text,
    required this.category,
    required this.modelId,
    required this.createdAt,
  });

  final String id;
  final String text;
  final String category;
  final String modelId;
  final DateTime createdAt;

  factory SavedPrompt.fromJson(Map<String, dynamic> json) => SavedPrompt(
    id: json['id'] as String,
    text: json['text'] as String,
    category: json['category'] as String,
    modelId: json['modelId'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'category': category,
    'modelId': modelId,
    'createdAt': createdAt.toIso8601String(),
  };
}

final savedPromptsControllerProvider =
    NotifierProvider<SavedPromptsController, List<SavedPrompt>>(
      SavedPromptsController.new,
    );

class SavedPromptsController extends Notifier<List<SavedPrompt>> {
  static const storageKey = 'allai.saved-prompts.v1';
  static const maxItems = 20;
  Future<void>? _restoreFuture;

  @override
  List<SavedPrompt> build() {
    _restoreFuture = Future<void>.microtask(_readStored);
    return const [];
  }

  Future<void> restore() => _restoreFuture ??= _readStored();

  Future<void> save({
    required String text,
    required String category,
    required String modelId,
  }) async {
    await restore();
    final clean = text.trim();
    if (clean.isEmpty) return;
    final normalized = clean.toLowerCase();
    final now = DateTime.now();
    final next = [
      SavedPrompt(
        id: 'prompt-${now.microsecondsSinceEpoch}',
        text: clean,
        category: category,
        modelId: modelId,
        createdAt: now,
      ),
      ...state.where((item) => item.text.trim().toLowerCase() != normalized),
    ].take(maxItems).toList();
    state = next;
    await _persist();
  }

  Future<void> remove(String id) async {
    await restore();
    state = state.where((item) => item.id != id).toList();
    await _persist();
  }

  Future<void> _readStored() async {
    final raw = await ref.read(secureStorageProvider).read(storageKey);
    if (!ref.mounted) return;
    try {
      final decoded = raw == null ? const [] : jsonDecode(raw) as List<dynamic>;
      state = decoded
          .whereType<Map<String, dynamic>>()
          .map(SavedPrompt.fromJson)
          .where((item) => item.text.trim().isNotEmpty)
          .take(maxItems)
          .toList();
    } on Object {
      state = const [];
    }
  }

  Future<void> _persist() => ref
      .read(secureStorageProvider)
      .write(
        storageKey,
        jsonEncode(state.map((item) => item.toJson()).toList()),
      );
}
