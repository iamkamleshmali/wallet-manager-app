import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../transactions/models/category_model.dart';
import '../../transactions/providers/transaction_provider.dart';

class ConfigurationScreen extends ConsumerStatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  ConsumerState<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends ConsumerState<ConfigurationScreen> {
  String _selectedCurrency = '₹';

  final List<Map<String, String>> _currencies = [
    {'symbol': '₹', 'name': 'Indian Rupee (INR)'},
    {'symbol': '\$', 'name': 'US Dollar (USD)'},
    {'symbol': '€', 'name': 'Euro (EUR)'},
    {'symbol': '£', 'name': 'British Pound (GBP)'},
    {'symbol': '¥', 'name': 'Japanese Yen (JPY)'},
    {'symbol': 'AED', 'name': 'UAE Dirham (AED)'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = prefs.getString(AppConstants.prefCurrencySymbol) ?? '₹';
    });
  }

  Future<void> _selectCurrency(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefCurrencySymbol, symbol);
    setState(() => _selectedCurrency = symbol);
  }

  @override
  Widget build(BuildContext context) {
    final transState = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(title: const Text('Configuration')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Currency Symbol', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              children: _currencies.map((c) {
                final isSelected = c['symbol'] == _selectedCurrency;
                return ListTile(
                  leading: Text(
                    c['symbol']!,
                    style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  title: Text(c['name']!, style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14)),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.expense)
                      : null,
                  onTap: () => _selectCurrency(c['symbol']!),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Categories', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: transState.categories.map((cat) {
                return Chip(
                  avatar: Icon(cat.iconData, size: 16, color: cat.color),
                  label: Text(cat.name, style: const TextStyle(fontSize: 12, color: AppColors.textPrimaryDark)),
                  backgroundColor: AppColors.darkCardElevated,
                  side: const BorderSide(color: AppColors.darkBorder),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
