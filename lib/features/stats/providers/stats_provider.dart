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
  final List<TransactionModel> periodTransactions;
  final bool isLoading;

  const StatsState({
    this.period = StatsPeriod.monthly,
    this.statType = TransactionType.expense,
    this.touchedSectionIndex = -1,
    this.periodTransactions = const [],
    this.isLoading = false,
  });

  double get totalIncome {
    double sum = 0.0;
    for (final tr in periodTransactions) {
      if (tr.type == TransactionType.income) sum += tr.amount;
    }
    return sum;
  }

  double get totalExpense {
    double sum = 0.0;
    for (final tr in periodTransactions) {
      if (tr.type == TransactionType.expense) sum += tr.amount;
    }
    return sum;
  }

  StatsState copyWith({
    StatsPeriod? period,
    TransactionType? statType,
    int? touchedSectionIndex,
    List<TransactionModel>? periodTransactions,
    bool? isLoading,
  }) {
    return StatsState(
      period: period ?? this.period,
      statType: statType ?? this.statType,
      touchedSectionIndex: touchedSectionIndex ?? this.touchedSectionIndex,
      periodTransactions: periodTransactions ?? this.periodTransactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class StatsNotifier extends StateNotifier<StatsState> {
  StatsNotifier() : super(const StatsState()) {
    loadPeriodData();
  }

  Future<void> loadPeriodData() async {
    state = state.copyWith(isLoading: true);
    final now = DateTime.now();
    late DateTime start;
    late DateTime end;

    switch (state.period) {
      case StatsPeriod.weekly:
        // Current week (starting Monday)
        final weekday = now.weekday; // 1 = Monday, 7 = Sunday
        final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
        start = monday;
        end = monday.add(const Duration(days: 7));
        break;
      case StatsPeriod.monthly:
        // Current month
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 1);
        break;
      case StatsPeriod.yearly:
        // Current year
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year + 1, 1, 1);
        break;
    }

    try {
      final list = await AppDatabase.instance.getTransactionsBetween(start, end);
      state = state.copyWith(
        periodTransactions: list,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void setPeriod(StatsPeriod period) {
    state = state.copyWith(period: period);
    loadPeriodData();
  }

  void setStatType(TransactionType type) {
    state = state.copyWith(statType: type, touchedSectionIndex: -1);
  }

  void setTouchedSectionIndex(int index) {
    state = state.copyWith(touchedSectionIndex: index);
  }
}

final statsProvider = StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  // Reload stats whenever transactions change
  ref.watch(transactionsProvider);
  return StatsNotifier();
});

// Computed category statistics provider using periodTransactions
final categoryStatsProvider = Provider<List<CategoryStatItem>>((ref) {
  final statsState = ref.watch(statsProvider);

  // Transfers are excluded from category expense and income
  final filtered = statsState.periodTransactions
      .where((t) => t.type == statsState.statType && t.type != TransactionType.transfer)
      .toList();
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
