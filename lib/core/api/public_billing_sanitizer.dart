class PublicBillingSanitizationException implements Exception {
  const PublicBillingSanitizationException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'PublicBillingSanitizationException($code, $message)';
}

Map<String, dynamic> sanitizePublicBalanceJson(
  Map<String, dynamic> raw, {
  required String defaultUserId,
}) {
  final coinBalance = _int(raw, 'coinBalance');
  final reservedCoins = raw['reservedCoins'] == null
      ? 0
      : _int(raw, 'reservedCoins');
  final availableCoins = raw['availableCoins'] == null
      ? coinBalance - reservedCoins
      : _int(raw, 'availableCoins');

  if (coinBalance < 0 || reservedCoins < 0 || availableCoins < 0) {
    _fail('balance_unavailable', 'Balance values cannot be negative.');
  }
  if (availableCoins != coinBalance - reservedCoins) {
    _fail(
      'backend_contract_violation',
      'Available coins must equal balance minus reserved coins.',
    );
  }

  final updatedAt = _string(raw, 'updatedAt', code: 'balance_unavailable');
  try {
    DateTime.parse(updatedAt);
  } on FormatException {
    _fail('balance_unavailable', 'Balance timestamp is invalid.');
  }

  return <String, dynamic>{
    'userId': raw['userId'] is String ? raw['userId'] : defaultUserId,
    'coinBalance': coinBalance,
    'reservedCoins': reservedCoins,
    'availableCoins': availableCoins,
    'updatedAt': updatedAt,
  };
}

List<Map<String, dynamic>> sanitizePublicPackagesJson(List<dynamic> raw) {
  final packages = raw.map((item) {
    if (item is Map<String, dynamic>) return sanitizePublicPackageJson(item);
    if (item is Map) {
      return sanitizePublicPackageJson(Map<String, dynamic>.from(item));
    }
    _fail('packages_unavailable', 'Package item must be an object.');
  }).toList();

  final ids = <String>{};
  for (final package in packages) {
    final id = package['id'] as String;
    if (!ids.add(id)) {
      _fail('backend_contract_violation', 'Package id is duplicated.');
    }
  }
  return packages;
}

Map<String, dynamic> sanitizePublicPackageJson(Map<String, dynamic> raw) {
  final coinAmount = _int(raw, 'coinAmount');
  if (coinAmount <= 0) {
    _fail('packages_unavailable', 'Coin package amount must be positive.');
  }

  final package = <String, dynamic>{
    'id': _string(raw, 'id'),
    'name': _string(raw, 'name'),
    'coinAmount': coinAmount,
    'description': _string(raw, 'description'),
    'isHighlighted': raw['isHighlighted'] is bool
        ? raw['isHighlighted']
        : false,
  };
  if (raw['isAvailable'] is bool) package['isAvailable'] = raw['isAvailable'];
  if (raw['priceLabel'] is String) package['priceLabel'] = raw['priceLabel'];
  if (raw['displayOrder'] is int) package['displayOrder'] = raw['displayOrder'];
  return package;
}

int _int(Map<String, dynamic> raw, String key) {
  final value = raw[key];
  if (value is int) return value;
  _fail(
    'backend_contract_violation',
    'Billing field "$key" must be an integer.',
  );
}

String _string(
  Map<String, dynamic> raw,
  String key, {
  String code = 'backend_contract_violation',
}) {
  final value = raw[key];
  if (value is String && value.isNotEmpty) return value;
  _fail(code, 'Billing field "$key" must be a string.');
}

Never _fail(String code, String message) {
  throw PublicBillingSanitizationException(code, message);
}
