import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

enum TransSubTab {
  daily,
  calendar,
  weekly,
  monthly,
  total,
  note;

  String get label {
    switch (this) {
      case TransSubTab.daily:
        return 'Daily';
      case TransSubTab.calendar:
        return 'Calendar';
      case TransSubTab.weekly:
        return 'Weekly';
      case TransSubTab.monthly:
        return 'Monthly';
      case TransSubTab.total:
        return 'Total';
      case TransSubTab.note:
        return 'Note';
    }
  }
}

class TransactionsState {
  final DateTime selectedDate;
  final TransSubTab currentSubTab;
  final List<TransactionModel> transactions;
  final List<CategoryModel> categories;
  final bool isLoading;
  final String? filterAccountId;
  final String? filterCategoryId;
  final String searchQuery;

  const TransactionsState({
    required this.selectedDate,
    this.currentSubTab = TransSubTab.daily,
    this.transactions = const [],
    this.categories = const [],
    this.isLoading = false,
    this.filterAccountId,
    this.filterCategoryId,
    this.searchQuery = '',
  });

  double get totalIncome {
    double sum = 0.0;
    for (final tr in transactions) {
      if (tr.type == TransactionType.income) {
        sum += tr.amount;
      }
    }
    return sum;
  }

  double get totalExpense {
    double sum = 0.0;
    for (final tr in transactions) {
      if (tr.type == TransactionType.expense) {
        sum += tr.amount;
      }
    }
    return sum;
  }

  double get netTotal => totalIncome - totalExpense;

  List<TransactionModel> get filteredTransactions {
    return transactions.where((tr) {
      if (filterAccountId != null && tr.accountId != filterAccountId) {
        return false;
      }
      if (filterCategoryId != null && tr.categoryId != filterCategoryId) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final noteMatch = tr.note?.toLowerCase().contains(query) ?? false;
        final catMatch = tr.categoryName?.toLowerCase().contains(query) ?? false;
        final accMatch = tr.accountName?.toLowerCase().contains(query) ?? false;
        if (!noteMatch && !catMatch && !accMatch) return false;
      }
      return true;
    }).toList();
  }

  TransactionsState copyWith({
    DateTime? selectedDate,
    TransSubTab? currentSubTab,
    List<TransactionModel>? transactions,
    List<CategoryModel>? categories,
    bool? isLoading,
    String? filterAccountId,
    String? filterCategoryId,
    String? searchQuery,
    bool clearFilterAccount = false,
    bool clearFilterCategory = false,
  }) {
    return TransactionsState(
      selectedDate: selectedDate ?? this.selectedDate,
      currentSubTab: currentSubTab ?? this.currentSubTab,
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      filterAccountId: clearFilterAccount ? null : (filterAccountId ?? this.filterAccountId),
      filterCategoryId: clearFilterCategory ? null : (filterCategoryId ?? this.filterCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TransactionsNotifier extends StateNotifier<TransactionsState> {
  final Ref? _ref;

  TransactionsNotifier([this._ref])
      : super(TransactionsState(selectedDate: DateTime.now())) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true);
    final list = await AppDatabase.instance.getTransactionsForMonth(
      state.selectedDate.year,
      state.selectedDate.month,
    );
    final cats = await AppDatabase.instance.getCategories();

    state = state.copyWith(
      transactions: list,
      categories: cats,
      isLoading: false,
    );
  }

  void setSubTab(TransSubTab subTab) {
    state = state.copyWith(currentSubTab: subTab);
  }

  void nextMonth() {
    final next = DateTime(state.selectedDate.year, state.selectedDate.month + 1, 1);
    state = state.copyWith(selectedDate: next);
    loadTransactions();
  }

  void prevMonth() {
    final prev = DateTime(state.selectedDate.year, state.selectedDate.month - 1, 1);
    state = state.copyWith(selectedDate: prev);
    loadTransactions();
  }

  void setMonthYear(int year, int month) {
    state = state.copyWith(selectedDate: DateTime(year, month, 1));
    loadTransactions();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilterAccount(String? accountId) {
    if (accountId == null) {
      state = state.copyWith(clearFilterAccount: true);
    } else {
      state = state.copyWith(filterAccountId: accountId);
    }
  }

  void setFilterCategory(String? categoryId) {
    if (categoryId == null) {
      state = state.copyWith(clearFilterCategory: true);
    } else {
      state = state.copyWith(filterCategoryId: categoryId);
    }
  }

  Future<void> addTransaction(TransactionModel tr) async {
    await AppDatabase.instance.insertTransaction(tr);
    await loadTransactions();
  }

  Future<void> updateTransaction(TransactionModel oldTr, TransactionModel newTr) async {
    await AppDatabase.instance.updateTransaction(oldTr, newTr);
    await loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await AppDatabase.instance.deleteTransaction(id);
    await loadTransactions();
  }

  // Global search across the full SQLite transaction database
  Future<List<TransactionModel>> searchDatabase({
    String query = '',
    String? accountId,
    String? categoryId,
  }) async {
    return await AppDatabase.instance.searchTransactions(
      query: query,
      accountId: accountId,
      categoryId: categoryId,
    );
  }
}

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, TransactionsState>((ref) {
  return TransactionsNotifier(ref);
});
