import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/models/transaction_model.dart';
import '../../transactions/providers/transaction_provider.dart';

enum StatsPeriod {
  weekly,
  monthly,
  yearly;

  String get label {
    switch (this) {
      case StatsPeriod.weekly:
        return 'Weekly';
      case StatsPeriod.monthly:
        return 'Monthly';
      case StatsPeriod.yearly:
        return 'Yearly';
    }
  }
}

class CategoryStatItem {
  final String categoryId;
  final String categoryName;
  final double amount;
  final double percentage;
  final Color color;
  final IconData icon;

  const CategoryStatItem({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}

class StatsState {
  final StatsPeriod period;
  final TransactionType statType; // expense or income
  final int touchedSectionIndex;

  const StatsState({
    this.period = StatsPeriod.monthly,
    this.statType = TransactionType.expense,
    this.touchedSectionIndex = -1,
  });

  StatsState copyWith({
    StatsPeriod? period,
    TransactionType? statType,
    int? touchedSectionIndex,
  }) {
    return StatsState(
      period: period ?? this.period,
      statType: statType ?? this.statType,
      touchedSectionIndex: touchedSectionIndex ?? this.touchedSectionIndex,
    );
  }
}

class StatsNotifier extends StateNotifier<StatsState> {
  StatsNotifier() : super(const StatsState());

  void setPeriod(StatsPeriod period) {
    state = state.copyWith(period: period);
  }

  void setStatType(TransactionType type) {
    state = state.copyWith(statType: type, touchedSectionIndex: -1);
  }

  void setTouchedSectionIndex(int index) {
    state = state.copyWith(touchedSectionIndex: index);
  }
}

final statsProvider = StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  return StatsNotifier();
});

// Computed category statistics provider
final categoryStatsProvider = Provider<List<CategoryStatItem>>((ref) {
  final transState = ref.watch(transactionsProvider);
  final statsState = ref.watch(statsProvider);

  final filtered = transState.transactions.where((t) => t.type == statsState.statType).toList();
  final totalAmount = filtered.fold<double>(0.0, (acc, t) => acc + t.amount);

  if (totalAmount <= 0) return [];

  final Map<String, double> categorySums = {};
  final Map<String, String> categoryNames = {};
  final Map<String, int> categoryColors = {};
  final Map<String, int> categoryIcons = {};

  for (final tr in filtered) {
    final catId = tr.categoryId ?? 'other';
    final current = categorySums[catId] ?? 0.0;
    categorySums[catId] = current + tr.amount;

    categoryNames[catId] = tr.categoryName ?? 'Other';
    categoryColors[catId] = tr.categoryColorValue ?? 0xFF8395A7;
    categoryIcons[catId] = tr.categoryIconCodePoint ?? Icons.category_rounded.codePoint;
  }

  final List<CategoryStatItem> items = [];
  categorySums.forEach((id, amount) {
    final percentage = (amount / totalAmount) * 100.0;
    items.add(
      CategoryStatItem(
        categoryId: id,
        categoryName: categoryNames[id] ?? 'Other',
        amount: amount,
        percentage: percentage,
        color: Color(categoryColors[id] ?? 0xFF8395A7),
        icon: IconData(categoryIcons[id] ?? Icons.category_rounded.codePoint, fontFamily: 'MaterialIcons'),
      ),
    );
  });

  items.sort((a, b) => b.amount.compareTo(a.amount));
  return items;
});
