import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../accounts/providers/account_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_item_tile.dart';

class TransactionSearchScreen extends ConsumerStatefulWidget {
  const TransactionSearchScreen({super.key});

  @override
  ConsumerState<TransactionSearchScreen> createState() => _TransactionSearchScreenState();
}

class _TransactionSearchScreenState extends ConsumerState<TransactionSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transState = ref.watch(transactionsProvider);
    final accounts = ref.watch(accountsProvider).accounts;
    final categories = transState.categories;
    final results = transState.filteredTransactions;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search note, category, account...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
          ),
          style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 16),
          onChanged: (query) {
            ref.read(transactionsProvider.notifier).setSearchQuery(query);
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                _searchController.clear();
                ref.read(transactionsProvider.notifier).setSearchQuery('');
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Account Filter
                FilterChip(
                  label: Text(
                    transState.filterAccountId != null
                        ? accounts.firstWhere((a) => a.id == transState.filterAccountId, orElse: () => accounts.first).name
                        : 'All Accounts',
                    style: TextStyle(
                      color: transState.filterAccountId != null ? Colors.white : AppColors.textSecondaryDark,
                      fontSize: 12,
                    ),
                  ),
                  selected: transState.filterAccountId != null,
                  selectedColor: AppColors.expense,
                  backgroundColor: AppColors.darkCard,
                  onSelected: (selected) {
                    _showAccountFilterDialog(context, accounts);
                  },
                ),
                const SizedBox(width: 8),
                // Category Filter
                FilterChip(
                  label: Text(
                    transState.filterCategoryId != null
                        ? categories.firstWhere((c) => c.id == transState.filterCategoryId).name
                        : 'All Categories',
                    style: TextStyle(
                      color: transState.filterCategoryId != null ? Colors.white : AppColors.textSecondaryDark,
                      fontSize: 12,
                    ),
                  ),
                  selected: transState.filterCategoryId != null,
                  selectedColor: AppColors.income,
                  backgroundColor: AppColors.darkCard,
                  onSelected: (selected) {
                    _showCategoryFilterDialog(context, categories);
                  },
                ),
                if (transState.filterAccountId != null || transState.filterCategoryId != null) ...[
                  const SizedBox(width: 8),
                  ActionChip(
                    label: const Text('Reset Filters', style: TextStyle(color: AppColors.expense, fontSize: 12)),
                    backgroundColor: AppColors.darkCard,
                    onPressed: () {
                      ref.read(transactionsProvider.notifier).setFilterAccount(null);
                      ref.read(transactionsProvider.notifier).setFilterCategory(null);
                    },
                  ),
                ],
              ],
            ),
          ),
          const Divider(color: AppColors.darkBorder),

          // Search Results List
          Expanded(
            child: results.isEmpty
                ? const Center(
                    child: Text(
                      'No matching transactions found.',
                      style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const Divider(color: AppColors.darkDivider),
                    itemBuilder: (context, index) {
                      final tr = results[index];
                      return TransactionItemTile(transaction: tr);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAccountFilterDialog(BuildContext context, List accounts) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Accounts', style: TextStyle(color: AppColors.textPrimaryDark)),
              onTap: () {
                ref.read(transactionsProvider.notifier).setFilterAccount(null);
                Navigator.pop(context);
              },
            ),
            ...accounts.map(
              (a) => ListTile(
                title: Text(a.name, style: const TextStyle(color: AppColors.textPrimaryDark)),
                onTap: () {
                  ref.read(transactionsProvider.notifier).setFilterAccount(a.id);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryFilterDialog(BuildContext context, List categories) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Categories', style: TextStyle(color: AppColors.textPrimaryDark)),
                onTap: () {
                  ref.read(transactionsProvider.notifier).setFilterCategory(null);
                  Navigator.pop(context);
                },
              ),
              ...categories.map(
                (c) => ListTile(
                  leading: Icon(c.iconData, color: c.color, size: 20),
                  title: Text(c.name, style: const TextStyle(color: AppColors.textPrimaryDark)),
                  onTap: () {
                    ref.read(transactionsProvider.notifier).setFilterCategory(c.id);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
