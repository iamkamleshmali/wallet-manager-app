import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../accounts/providers/account_provider.dart';
import '../../transactions/models/transaction_model.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../providers/stats_provider.dart';
import '../widgets/interactive_pie_chart.dart';
import '../widgets/net_worth_trend_chart.dart';

class StatsTabScreen extends ConsumerWidget {
  const StatsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(statsProvider);
    final statsNotifier = ref.read(statsProvider.notifier);
    final transState = ref.watch(transactionsProvider);
    final accountsState = ref.watch(accountsProvider);
    final categoryStats = ref.watch(categoryStatsProvider);

    final isExpense = statsState.statType == TransactionType.expense;
    final totalAmount = isExpense ? statsState.totalExpense : statsState.totalIncome;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Statistics & Analytics'),
        actions: [
          // Period Selector: Weekly / Monthly / Yearly
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: DropdownButton<StatsPeriod>(
              value: statsState.period,
              dropdownColor: AppColors.darkCard,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textSecondaryDark),
              style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12, fontWeight: FontWeight.w700),
              items: StatsPeriod.values.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(p.label),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) statsNotifier.setPeriod(val);
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 40),
        children: [
          // Toggle between Expenses and Income
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => statsNotifier.setStatType(TransactionType.expense),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isExpense ? AppColors.expense : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        'Expenses',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isExpense ? Colors.white : AppColors.textSecondaryDark,
                          fontSize: 13,
                          fontWeight: isExpense ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => statsNotifier.setStatType(TransactionType.income),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !isExpense ? AppColors.income : Colors.transparent,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        'Income',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !isExpense ? Colors.white : AppColors.textSecondaryDark,
                          fontSize: 13,
                          fontWeight: !isExpense ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Interactive Pie Chart
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              children: [
                InteractivePieChart(
                  items: categoryStats,
                  totalAmount: totalAmount,
                  touchedIndex: statsState.touchedSectionIndex,
                  onTouch: statsNotifier.setTouchedSectionIndex,
                  centerTitle: isExpense ? 'Total Expense' : 'Total Income',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Category Breakdown List
          if (categoryStats.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category Breakdown',
                    style: TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...categoryStats.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          // Color indicator dot
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: item.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Category Name
                          Expanded(
                            child: Text(
                              item.categoryName,
                              style: const TextStyle(
                                color: AppColors.textPrimaryDark,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Percentage %
                          Text(
                            '${item.percentage.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: AppColors.textSecondaryDark,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Total Amount
                          Text(
                            CurrencyFormatter.format(item.amount),
                            style: const TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Sora',
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Asset Trend Graph / Net Worth Trajectory
          NetWorthTrendChart(currentNetWorth: accountsState.netWorth),
        ],
      ),
    );
  }
}
