import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../accounts/providers/account_provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_item_tile.dart';
import 'transaction_form_modal.dart';

class TransactionSearchScreen extends ConsumerStatefulWidget {
  const TransactionSearchScreen({super.key});

  @override
  ConsumerState<TransactionSearchScreen> createState() => _TransactionSearchScreenState();
}

class _TransactionSearchScreenState extends ConsumerState<TransactionSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<TransactionModel> _searchResults = [];
  bool _isSearching = false;
  String? _filterAccountId;
  String? _filterCategoryId;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Run initial search with empty query across full database
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSearch();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 250), () {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    setState(() => _isSearching = true);
    try {
      final results = await ref.read(transactionsProvider.notifier).searchDatabase(
        query: _searchController.text,
        accountId: _filterAccountId,
        categoryId: _filterCategoryId,
      );
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider).accounts;
    final categories = ref.watch(transactionsProvider).categories;

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
          onChanged: _onSearchChanged,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                _searchController.clear();
                _performSearch();
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
                    _filterAccountId != null
                        ? accounts.firstWhere((a) => a.id == _filterAccountId, orElse: () => accounts.first).name
                        : 'All Accounts',
                    style: TextStyle(
                      color: _filterAccountId != null ? Colors.white : AppColors.textSecondaryDark,
                      fontSize: 12,
                    ),
                  ),
                  selected: _filterAccountId != null,
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
                    _filterCategoryId != null
                        ? (categories.any((c) => c.id == _filterCategoryId)
                            ? categories.firstWhere((c) => c.id == _filterCategoryId).name
                            : 'Category')
                        : 'All Categories',
                    style: TextStyle(
                      color: _filterCategoryId != null ? Colors.white : AppColors.textSecondaryDark,
                      fontSize: 12,
                    ),
                  ),
                  selected: _filterCategoryId != null,
                  selectedColor: AppColors.income,
                  backgroundColor: AppColors.darkCard,
                  onSelected: (selected) {
                    _showCategoryFilterDialog(context, categories);
                  },
                ),
                if (_filterAccountId != null || _filterCategoryId != null) ...[
                  const SizedBox(width: 8),
                  ActionChip(
                    label: const Text('Reset Filters', style: TextStyle(color: AppColors.expense, fontSize: 12)),
                    backgroundColor: AppColors.darkCard,
                    onPressed: () {
                      setState(() {
                        _filterAccountId = null;
                        _filterCategoryId = null;
                      });
                      _performSearch();
                    },
                  ),
                ],
              ],
            ),
          ),
          const Divider(color: AppColors.darkBorder),

          // Search Results List
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator(color: AppColors.expense))
                : _searchResults.isEmpty
                    ? const Center(
                        child: Text(
                          'No matching transactions found.',
                          style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: _searchResults.length,
                        separatorBuilder: (_, __) => const Divider(color: AppColors.darkDivider),
                        itemBuilder: (context, index) {
                          final tr = _searchResults[index];
                          return TransactionItemTile(
                            transaction: tr,
                            onTap: () async {
                              await TransactionFormModal.show(context, transactionToEdit: tr);
                              _performSearch();
                            },
                          );
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
                setState(() => _filterAccountId = null);
                Navigator.pop(context);
                _performSearch();
              },
            ),
            ...accounts.map(
              (a) => ListTile(
                title: Text(a.name, style: const TextStyle(color: AppColors.textPrimaryDark)),
                onTap: () {
                  setState(() => _filterAccountId = a.id);
                  Navigator.pop(context);
                  _performSearch();
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
                  setState(() => _filterCategoryId = null);
                  Navigator.pop(context);
                  _performSearch();
                },
              ),
              ...categories.map(
                (c) => ListTile(
                  leading: Icon(c.iconData, color: c.color, size: 20),
                  title: Text(c.name, style: const TextStyle(color: AppColors.textPrimaryDark)),
                  onTap: () {
                    setState(() => _filterCategoryId = c.id);
                    Navigator.pop(context);
                    _performSearch();
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
