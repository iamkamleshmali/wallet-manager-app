import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/account_model.dart';
import '../providers/account_provider.dart';
import '../widgets/account_group_card.dart';
import 'add_edit_account_dialog.dart';

class AccountsTabScreen extends ConsumerWidget {
  const AccountsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Accounts & Balance Sheet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
            tooltip: 'Add Account',
            onPressed: () => AddEditAccountDialog.show(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.expense))
          : ListView(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 80),
              children: [
                // Header Summary Card: Assets (Blue), Liabilities (Red), Net Worth (Green/Total)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Column(
                    children: [
                      // Net Worth Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Net Worth',
                            style: TextStyle(
                              color: AppColors.textSecondaryDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(state.netWorth),
                            style: const TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Sora',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.darkDivider),
                      const SizedBox(height: 10),
                      // Assets & Liabilities Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.arrow_upward_rounded, size: 14, color: AppColors.asset),
                                    SizedBox(width: 4),
                                    Text('Assets', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  CurrencyFormatter.format(state.totalAssets),
                                  style: const TextStyle(
                                    color: AppColors.asset,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Sora',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(height: 36, width: 1, color: AppColors.darkBorder),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.arrow_downward_rounded, size: 14, color: AppColors.liability),
                                      SizedBox(width: 4),
                                      Text('Liabilities', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    CurrencyFormatter.format(state.totalLiabilities),
                                    style: const TextStyle(
                                      color: AppColors.liability,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Sora',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Collapsible Account Groups: Cash, Accounts, Cards, Investments
                AccountGroupCard(
                  group: AccountGroup.cash,
                  accounts: state.cashAccounts,
                  onEditAccount: (acc) => AddEditAccountDialog.show(context, accountToEdit: acc),
                  onAdjustBalance: (acc) => AdjustBalanceDialog.show(context, acc),
                ),
                AccountGroupCard(
                  group: AccountGroup.accounts,
                  accounts: state.bankAccounts,
                  onEditAccount: (acc) => AddEditAccountDialog.show(context, accountToEdit: acc),
                  onAdjustBalance: (acc) => AdjustBalanceDialog.show(context, acc),
                ),
                AccountGroupCard(
                  group: AccountGroup.cards,
                  accounts: state.cardAccounts,
                  onEditAccount: (acc) => AddEditAccountDialog.show(context, accountToEdit: acc),
                  onAdjustBalance: (acc) => AdjustBalanceDialog.show(context, acc),
                ),
                AccountGroupCard(
                  group: AccountGroup.investments,
                  accounts: state.investmentAccounts,
                  onEditAccount: (acc) => AddEditAccountDialog.show(context, accountToEdit: acc),
                  onAdjustBalance: (acc) => AdjustBalanceDialog.show(context, acc),
                ),
              ],
            ),
    );
  }
}
