class BillingBalance {
  const BillingBalance({
    required this.coinBalance,
    required this.reservedCoins,
    required this.availableCoins,
    required this.updatedAt,
    this.userId,
  });

  final String? userId;
  final int coinBalance;
  final int reservedCoins;
  final int availableCoins;
  final DateTime updatedAt;

  factory BillingBalance.fromJson(Map<String, dynamic> json) {
    final coinBalance = json['coinBalance'] as int;
    final reservedCoins = json['reservedCoins'] as int? ?? 0;
    return BillingBalance(
      userId: json['userId'] as String?,
      coinBalance: coinBalance,
      reservedCoins: reservedCoins,
      availableCoins:
          json['availableCoins'] as int? ?? coinBalance - reservedCoins,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    if (userId != null) 'userId': userId,
    'coinBalance': coinBalance,
    'reservedCoins': reservedCoins,
    'availableCoins': availableCoins,
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class CoinPackage {
  const CoinPackage({
    required this.id,
    required this.name,
    required this.coinAmount,
    required this.description,
    required this.isHighlighted,
    required this.isAvailable,
    this.priceLabel,
    this.displayOrder,
  });

  final String id;
  final String name;
  final int coinAmount;
  final String description;
  final bool isHighlighted;
  final bool isAvailable;
  final String? priceLabel;
  final int? displayOrder;

  factory CoinPackage.fromJson(Map<String, dynamic> json) {
    return CoinPackage(
      id: json['id'] as String,
      name: json['name'] as String,
      coinAmount: json['coinAmount'] as int,
      description: json['description'] as String,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      priceLabel: json['priceLabel'] as String?,
      displayOrder: json['displayOrder'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'coinAmount': coinAmount,
    'description': description,
    'isHighlighted': isHighlighted,
    'isAvailable': isAvailable,
    if (priceLabel != null) 'priceLabel': priceLabel,
    if (displayOrder != null) 'displayOrder': displayOrder,
  };
}

class CoinTransaction {
  const CoinTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.createdAt,
  });

  final String id;
  final String title;
  final int amount;
  final DateTime createdAt;

  factory CoinTransaction.fromJson(Map<String, dynamic> json) {
    return CoinTransaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: json['amount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
