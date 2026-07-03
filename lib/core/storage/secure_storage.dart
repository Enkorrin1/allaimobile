import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class SecureStorageClient {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class SecureStorage implements SecureStorageClient {
  const SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class InMemorySecureStorage implements SecureStorageClient {
  InMemorySecureStorage([Map<String, String>? initialValues])
    : _values = Map.of(initialValues ?? const {});

  final Map<String, String> _values;

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }
}

final secureStorageProvider = Provider<SecureStorageClient>((ref) {
  return const SecureStorage(FlutterSecureStorage());
});
