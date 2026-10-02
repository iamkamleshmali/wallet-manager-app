import 'package:flutter/material.dart';

enum CategoryType {
  expense,
  income;

  String get displayName => this == CategoryType.expense ? 'Expense' : 'Income';
}

class CategoryModel {
  final String id;
  final String name;
  final CategoryType type;
  final int iconCodePoint;
  final int colorValue;
  final int sortOrder;
  final bool isDefault;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.iconCodePoint,
    required this.colorValue,
    this.sortOrder = 0,
    this.isDefault = false,
  });

  IconData get iconData => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'icon_code_point': iconCodePoint,
      'color_value': colorValue,
      'sort_order': sortOrder,
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      type: CategoryType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => CategoryType.expense,
      ),
      iconCodePoint: map['icon_code_point'] as int,
      colorValue: map['color_value'] as int,
      sortOrder: (map['sort_order'] as int?) ?? 0,
      isDefault: (map['is_default'] as int? ?? 0) == 1,
    );
  }

  static List<CategoryModel> get defaultExpenseCategories => [
    CategoryModel(
      id: 'cat_food',
      name: 'Food & Dining',
      type: CategoryType.expense,
      iconCodePoint: Icons.restaurant_rounded.codePoint,
      colorValue: 0xFFFF5E57,
      isDefault: true,
      sortOrder: 1,
    ),
    CategoryModel(
      id: 'cat_shopping',
      name: 'Shopping',
      type: CategoryType.expense,
      iconCodePoint: Icons.shopping_bag_rounded.codePoint,
      colorValue: 0xFFFECA57,
      isDefault: true,
      sortOrder: 2,
    ),
    CategoryModel(
      id: 'cat_transport',
      name: 'Transport',
      type: CategoryType.expense,
      iconCodePoint: Icons.directions_car_rounded.codePoint,
      colorValue: 0xFF48DBFB,
      isDefault: true,
      sortOrder: 3,
    ),
    CategoryModel(
      id: 'cat_bills',
      name: 'Bills & Utilities',
      type: CategoryType.expense,
      iconCodePoint: Icons.receipt_long_rounded.codePoint,
      colorValue: 0xFF00D2D3,
      isDefault: true,
      sortOrder: 4,
    ),
    CategoryModel(
      id: 'cat_entertainment',
      name: 'Entertainment',
      type: CategoryType.expense,
      iconCodePoint: Icons.movie_filter_rounded.codePoint,
      colorValue: 0xFF5F27CD,
      isDefault: true,
      sortOrder: 5,
    ),
    CategoryModel(
      id: 'cat_health',
      name: 'Health & Medical',
      type: CategoryType.expense,
      iconCodePoint: Icons.medical_services_rounded.codePoint,
      colorValue: 0xFFFF9FF3,
      isDefault: true,
      sortOrder: 6,
    ),
    CategoryModel(
      id: 'cat_education',
      name: 'Education',
      type: CategoryType.expense,
      iconCodePoint: Icons.school_rounded.codePoint,
      colorValue: 0xFF54A0FF,
      isDefault: true,
      sortOrder: 7,
    ),
    CategoryModel(
      id: 'cat_housing',
      name: 'Housing & Rent',
      type: CategoryType.expense,
      iconCodePoint: Icons.home_rounded.codePoint,
      colorValue: 0xFFFF6B6B,
      isDefault: true,
      sortOrder: 8,
    ),
    CategoryModel(
      id: 'cat_other_exp',
      name: 'Other Expense',
      type: CategoryType.expense,
      iconCodePoint: Icons.more_horiz_rounded.codePoint,
      colorValue: 0xFF8395A7,
      isDefault: true,
      sortOrder: 9,
    ),
  ];

  static List<CategoryModel> get defaultIncomeCategories => [
    CategoryModel(
      id: 'cat_salary',
      name: 'Salary',
      type: CategoryType.income,
      iconCodePoint: Icons.account_balance_wallet_rounded.codePoint,
      colorValue: 0xFF1DD1A1,
      isDefault: true,
      sortOrder: 1,
    ),
    CategoryModel(
      id: 'cat_allowance',
      name: 'Allowance',
      type: CategoryType.income,
      iconCodePoint: Icons.attach_money_rounded.codePoint,
      colorValue: 0xFF2E86DE,
      isDefault: true,
      sortOrder: 2,
    ),
    CategoryModel(
      id: 'cat_bonus',
      name: 'Bonus',
      type: CategoryType.income,
      iconCodePoint: Icons.card_giftcard_rounded.codePoint,
      colorValue: 0xFFFECA57,
      isDefault: true,
      sortOrder: 3,
    ),
    CategoryModel(
      id: 'cat_investment_inc',
      name: 'Investment Returns',
      type: CategoryType.income,
      iconCodePoint: Icons.trending_up_rounded.codePoint,
      colorValue: 0xFF10AC84,
      isDefault: true,
      sortOrder: 4,
    ),
    CategoryModel(
      id: 'cat_other_inc',
      name: 'Other Income',
      type: CategoryType.income,
      iconCodePoint: Icons.savings_rounded.codePoint,
      colorValue: 0xFF54A0FF,
      isDefault: true,
      sortOrder: 5,
    ),
  ];
}
