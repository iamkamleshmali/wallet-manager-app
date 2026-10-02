import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../models/account_model.dart';
import '../../transactions/providers/transaction_provider.dart';

class AccountsState {
  final List<AccountModel> accounts;
  final bool isLoading;

  const AccountsState({
    this.accounts = const [],
    this.isLoading = false,
  });

  List<AccountModel> get cashAccounts =>
      accounts.where((a) => a.group == AccountGroup.cash).toList();

  List<AccountModel> get bankAccounts =>
      accounts.where((a) => a.group == AccountGroup.accounts).toList();

  List<AccountModel> get cardAccounts =>
      accounts.where((a) => a.group == AccountGroup.cards).toList();

  List<AccountModel> get investmentAccounts =>
      accounts.where((a) => a.group == AccountGroup.investments).toList();

  double get totalAssets {
    double sum = 0.0;
    for (final a in accounts) {
      if (!a.group.isLiability && a.includeInNetWorth) {
        sum += (a.balance > 0 ? a.balance : 0);
      }
    }
    return sum;
  }

  double get totalLiabilities {
    double sum = 0.0;
    for (final a in accounts) {
      if (a.group.isLiability && a.includeInNetWorth) {
        sum += a.balance.abs();
      } else if (a.balance < 0 && a.includeInNetWorth) {
        sum += a.balance.abs();
      }
    }
    return sum;
  }

  double get netWorth => totalAssets - totalLiabilities;

  AccountsState copyWith({
    List<AccountModel>? accounts,
    bool? isLoading,
  }) {
    return AccountsState(
      accounts: accounts ?? this.accounts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AccountsNotifier extends StateNotifier<AccountsState> {
  final Ref ref;

  AccountsNotifier(this.ref) : super(const AccountsState()) {
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    state = state.copyWith(isLoading: true);
    final list = await AppDatabase.instance.getAccounts();
    state = state.copyWith(accounts: list, isLoading: false);
  }

  Future<void> addAccount(AccountModel account) async {
    await AppDatabase.instance.insertAccount(account);
    await loadAccounts();
    ref.read(transactionsProvider.notifier).loadTransactions();
  }

  Future<void> updateAccount(AccountModel account) async {
    await AppDatabase.instance.updateAccount(account);
    await loadAccounts();
  }

  Future<void> adjustBalance({
    required String accountId,
    required double newBalance,
    String? note,
  }) async {
    await AppDatabase.instance.adjustAccountBalance(
      accountId: accountId,
      newBalance: newBalance,
      note: note,
    );
    await loadAccounts();
    ref.read(transactionsProvider.notifier).loadTransactions();
  }

  Future<void> deleteAccount(String accountId) async {
    await AppDatabase.instance.deleteAccount(accountId);
    await loadAccounts();
    ref.read(transactionsProvider.notifier).loadTransactions();
  }
}

final accountsProvider =
    StateNotifierProvider<AccountsNotifier, AccountsState>((ref) {
  return AccountsNotifier(ref);
});
