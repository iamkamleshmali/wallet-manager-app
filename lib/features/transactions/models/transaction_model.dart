import 'package:flutter/material.dart';

enum TransactionType {
  expense,
  income,
  transfer;

  String get displayName {
    switch (this) {
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.income:
        return 'Income';
      case TransactionType.transfer:
        return 'Transfer';
    }
  }

  Color get color {
    switch (this) {
      case TransactionType.expense:
        return const Color(0xFFFF5E57);
      case TransactionType.income:
        return const Color(0xFF2E86DE);
      case TransactionType.transfer:
        return const Color(0xFF8C7AE6);
    }
  }
}

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final DateTime dateTime;
  final String accountId;
  final String? toAccountId;
  final String? categoryId;
  final String? subCategory;
  final String? note;
  final String? photoPath;
  final bool isModifiedBalanceAdjustment;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined display attributes (populated during query)
  final String? accountName;
  final String? toAccountName;
  final String? categoryName;
  final int? categoryIconCodePoint;
  final int? categoryColorValue;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.dateTime,
    required this.accountId,
    this.toAccountId,
    this.categoryId,
    this.subCategory,
    this.note,
    this.photoPath,
    this.isModifiedBalanceAdjustment = false,
    required this.createdAt,
    required this.updatedAt,
    this.accountName,
    this.toAccountName,
    this.categoryName,
    this.categoryIconCodePoint,
    this.categoryColorValue,
  });

  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    DateTime? dateTime,
    String? accountId,
    String? toAccountId,
    String? categoryId,
    String? subCategory,
    String? note,
    String? photoPath,
    bool? isModifiedBalanceAdjustment,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? accountName,
    String? toAccountName,
    String? categoryName,
    int? categoryIconCodePoint,
    int? categoryColorValue,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      dateTime: dateTime ?? this.dateTime,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      categoryId: categoryId ?? this.categoryId,
      subCategory: subCategory ?? this.subCategory,
      note: note ?? this.note,
      photoPath: photoPath ?? this.photoPath,
      isModifiedBalanceAdjustment:
          isModifiedBalanceAdjustment ?? this.isModifiedBalanceAdjustment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      accountName: accountName ?? this.accountName,
      toAccountName: toAccountName ?? this.toAccountName,
      categoryName: categoryName ?? this.categoryName,
      categoryIconCodePoint:
          categoryIconCodePoint ?? this.categoryIconCodePoint,
      categoryColorValue: categoryColorValue ?? this.categoryColorValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'date_time': dateTime.toIso8601String(),
      'account_id': accountId,
      'to_account_id': toAccountId,
      'category_id': categoryId,
      'sub_category': subCategory,
      'note': note,
      'photo_path': photoPath,
      'is_modified_adjustment': isModifiedBalanceAdjustment ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      type: TransactionType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      amount: (map['amount'] as num).toDouble(),
      dateTime: DateTime.parse(map['date_time'] as String),
      accountId: map['account_id'] as String,
      toAccountId: map['to_account_id'] as String?,
      categoryId: map['category_id'] as String?,
      subCategory: map['sub_category'] as String?,
      note: map['note'] as String?,
      photoPath: map['photo_path'] as String?,
      isModifiedBalanceAdjustment:
          (map['is_modified_adjustment'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      accountName: map['account_name'] as String?,
      toAccountName: map['to_account_name'] as String?,
      categoryName: map['category_name'] as String?,
      categoryIconCodePoint: map['category_icon_code_point'] as int?,
      categoryColorValue: map['category_color_value'] as int?,
    );
  }
}
