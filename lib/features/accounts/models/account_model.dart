import 'package:flutter/material.dart';

enum AccountGroup {
  cash,
  accounts,
  cards,
  investments;

  String get displayName {
    switch (this) {
      case AccountGroup.cash:
        return 'Cash';
      case AccountGroup.accounts:
        return 'Accounts';
      case AccountGroup.cards:
        return 'Cards';
      case AccountGroup.investments:
        return 'Investments';
    }
  }

  IconData get iconData {
    switch (this) {
      case AccountGroup.cash:
        return Icons.money_rounded;
      case AccountGroup.accounts:
        return Icons.account_balance_rounded;
      case AccountGroup.cards:
        return Icons.credit_card_rounded;
      case AccountGroup.investments:
        return Icons.trending_up_rounded;
    }
  }

  bool get isLiability => this == AccountGroup.cards;
}

class AccountModel {
  final String id;
  final String name;
  final AccountGroup group;
  final double balance;
  final String currency;
  final int iconCodePoint;
  final int colorValue;
  final bool includeInNetWorth;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AccountModel({
    required this.id,
    required this.name,
    required this.group,
    required this.balance,
    this.currency = '₹',
    this.iconCodePoint = 0xe040, // default account balance icon
    this.colorValue = 0xFF2E86DE,
    this.includeInNetWorth = true,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  AccountModel copyWith({
    String? id,
    String? name,
    AccountGroup? group,
    double? balance,
    String? currency,
    int? iconCodePoint,
    int? colorValue,
    bool? includeInNetWorth,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      group: group ?? this.group,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      includeInNetWorth: includeInNetWorth ?? this.includeInNetWorth,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'account_group': group.name,
      'balance': balance,
      'currency': currency,
      'icon_code_point': iconCodePoint,
      'color_value': colorValue,
      'include_in_net_worth': includeInNetWorth ? 1 : 0,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'] as String,
      name: map['name'] as String,
      group: AccountGroup.values.firstWhere(
        (g) => g.name == map['account_group'],
        orElse: () => AccountGroup.accounts,
      ),
      balance: (map['balance'] as num).toDouble(),
      currency: (map['currency'] as String?) ?? '₹',
      iconCodePoint: (map['icon_code_point'] as int?) ?? Icons.account_balance_wallet.codePoint,
      colorValue: (map['color_value'] as int?) ?? 0xFF2E86DE,
      includeInNetWorth: (map['include_in_net_worth'] as int? ?? 1) == 1,
      sortOrder: (map['sort_order'] as int?) ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
