import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage.dart';

class LegalConsent {
  const LegalConsent({
    required this.acceptedTerms,
    required this.acceptedPrivacy,
    required this.confirmedAge18,
    required this.consentVersion,
    required this.acceptedAt,
  });

  final bool acceptedTerms;
  final bool acceptedPrivacy;
  final bool confirmedAge18;
  final String consentVersion;
  final DateTime acceptedAt;

  bool get isComplete => acceptedTerms && acceptedPrivacy && confirmedAge18;

  factory LegalConsent.fromJson(Map<String, dynamic> json) {
    return LegalConsent(
      acceptedTerms: json['acceptedTerms'] as bool,
      acceptedPrivacy: json['acceptedPrivacy'] as bool,
      confirmedAge18: json['confirmedAge18'] as bool,
      consentVersion: json['consentVersion'] as String,
      acceptedAt: DateTime.parse(json['acceptedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'acceptedTerms': acceptedTerms,
    'acceptedPrivacy': acceptedPrivacy,
    'confirmedAge18': confirmedAge18,
    'consentVersion': consentVersion,
    'acceptedAt': acceptedAt.toIso8601String(),
  };
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.locale,
    required this.createdAt,
    required this.legalConsent,
    this.displayName,
  });

  final String id;
  final String email;
  final String? displayName;
  final String locale;
  final DateTime createdAt;
  final LegalConsent legalConsent;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      locale: json['locale'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      legalConsent: LegalConsent.fromJson(
        json['legalConsent'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    if (displayName != null) 'displayName': displayName,
    'locale': locale,
    'createdAt': createdAt.toIso8601String(),
    'legalConsent': legalConsent.toJson(),
  };
}

class AuthTokenPair {
  const AuthTokenPair({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.accessExpiresAt,
    required this.refreshExpiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final DateTime accessExpiresAt;
  final DateTime refreshExpiresAt;

  bool get isAccessExpired => !accessExpiresAt.isAfter(DateTime.now().toUtc());
  bool get isRefreshExpired =>
      !refreshExpiresAt.isAfter(DateTime.now().toUtc());

  factory AuthTokenPair.fromJson(Map<String, dynamic> json) {
    return AuthTokenPair(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String,
      accessExpiresAt: DateTime.parse(json['accessExpiresAt'] as String),
      refreshExpiresAt: DateTime.parse(json['refreshExpiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'tokenType': tokenType,
    'accessExpiresAt': accessExpiresAt.toIso8601String(),
    'refreshExpiresAt': refreshExpiresAt.toIso8601String(),
  };
}

class AuthSession {
  const AuthSession({
    required this.user,
    required this.tokens,
    required this.createdAt,
    this.restoredAt,
  });

  final AuthUser user;
  final AuthTokenPair tokens;
  final DateTime createdAt;
  final DateTime? restoredAt;

  AuthSession copyWith({AuthTokenPair? tokens, DateTime? restoredAt}) {
    return AuthSession(
      user: user,
      tokens: tokens ?? this.tokens,
      createdAt: createdAt,
      restoredAt: restoredAt ?? this.restoredAt,
    );
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokenPair.fromJson(json['tokens'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      restoredAt: json['restoredAt'] == null
          ? null
          : DateTime.parse(json['restoredAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'tokens': tokens.toJson(),
    'createdAt': createdAt.toIso8601String(),
    if (restoredAt != null) 'restoredAt': restoredAt!.toIso8601String(),
  };
}

class AuthSessionStore {
  const AuthSessionStore(this._storage);

  static const sessionKey = 'allai.auth.session.v1';

  final SecureStorageClient _storage;

  Future<AuthSession?> read() async {
    final raw = await _storage.read(sessionKey);
    if (raw == null || raw.isEmpty) return null;
    return AuthSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> write(AuthSession session) {
    return _storage.write(sessionKey, jsonEncode(session.toJson()));
  }

  Future<void> clear() => _storage.delete(sessionKey);
}

final authSessionStoreProvider = Provider<AuthSessionStore>((ref) {
  return AuthSessionStore(ref.watch(secureStorageProvider));
});
