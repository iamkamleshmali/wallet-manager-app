import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatters.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../widgets/date_group_header.dart';
import '../widgets/summary_header_bar.dart';
import '../widgets/transaction_item_tile.dart';
import 'calendar_view_screen.dart';
import 'transaction_form_modal.dart';
import 'transaction_search_screen.dart';

class TransactionsTabScreen extends ConsumerWidget {
  const TransactionsTabScreen({super.key});

  void _showMonthYearPicker(BuildContext context, WidgetRef ref, DateTime current) {
    int selectedYear = current.year;
    int selectedMonth = current.month;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.darkCard,
              title: const Text('Select Month & Year'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded),
                        onPressed: () => setState(() => selectedYear--),
                      ),
                      Text(
                        '$selectedYear',
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right_rounded),
                        onPressed: () => setState(() => selectedYear++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(12, (index) {
                      final monthNum = index + 1;
                      final isSelected = selectedMonth == monthNum;
                      return ChoiceChip(
                        label: Text(
                          DateFormatters.formatMonthYear(DateTime(selectedYear, monthNum, 1)).split(' ').first,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                            fontSize: 12,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.expense,
                        backgroundColor: AppColors.darkCardElevated,
                        onSelected: (selected) {
                          if (selected) setState(() => selectedMonth = monthNum);
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.expense),
                  onPressed: () {
                    ref.read(transactionsProvider.notifier).setMonthYear(selectedYear, selectedMonth);
                    Navigator.pop(context);
                  },
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transState = ref.watch(transactionsProvider);
    final notifier = ref.read(transactionsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, size: 28),
              onPressed: notifier.prevMonth,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => _showMonthYearPicker(context, ref, transState.selectedDate),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormatters.formatMonthYear(transState.selectedDate),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down_rounded, size: 18, color: AppColors.textSecondaryDark),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded, size: 28),
              onPressed: notifier.nextMonth,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmarks feature enabled')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransactionSearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransactionSearchScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Sub-Tabs: Daily, Calendar, Weekly, Monthly, Total, Note
          Container(
            height: 38,
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: TransSubTab.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final tab = TransSubTab.values[index];
                final isSelected = tab == transState.currentSubTab;
                return ChoiceChip(
                  label: Text(
                    tab.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.expense,
                  backgroundColor: AppColors.darkCard,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? AppColors.expense : AppColors.darkBorder,
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) notifier.setSubTab(tab);
                  },
                );
              },
            ),
          ),

          // Income / Expenses / Total summary bar
          SummaryHeaderBar(
            income: transState.totalIncome,
            expense: transState.totalExpense,
            total: transState.netTotal,
          ),

          // Main Sub-Tab View Content
          Expanded(
            child: _buildSubTabContent(context, transState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.expense,
        foregroundColor: Colors.white,
        elevation: 6,
        onPressed: () => TransactionFormModal.show(context),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }

  Widget _buildSubTabContent(BuildContext context, TransactionsState transState) {
    if (transState.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.expense));
    }

    if (transState.currentSubTab == TransSubTab.calendar) {
      return const CalendarViewScreen();
    }

    if (transState.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded, size: 54, color: AppColors.textMutedDark.withOpacity(0.5)),
            const SizedBox(height: 12),
            const Text(
              'No transactions recorded for this period',
              style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap the + button below to log income or expenses',
              style: TextStyle(color: AppColors.textMutedDark, fontSize: 12),
            ),
          ],
        ),
      );
    }

    if (transState.currentSubTab == TransSubTab.daily) {
      return _buildDailyGroupedList(transState.transactions);
    }

    // Weekly / Monthly / Total / Note views
    return _buildOverviewSummaryList(context, transState);
  }

  Widget _buildDailyGroupedList(List<TransactionModel> transactions) {
    // Group transactions by date
    final Map<String, List<TransactionModel>> grouped = {};
    for (final tr in transactions) {
      final key = DateFormatters.formatDateIso(tr.dateTime);
      grouped.putIfAbsent(key, () => []).add(tr);
    }

    final dates = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 2, 14, 80),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final dateKey = dates[index];
        final dayTrans = grouped[dateKey]!;
        final dayDate = dayTrans.first.dateTime;

        double dayIncome = 0.0;
        double dayExpense = 0.0;
        for (final tr in dayTrans) {
          if (tr.type == TransactionType.income) dayIncome += tr.amount;
          if (tr.type == TransactionType.expense) dayExpense += tr.amount;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DateGroupHeader(
                date: dayDate,
                dayIncome: dayIncome,
                dayExpense: dayExpense,
              ),
              const Divider(color: AppColors.darkDivider),
              ...dayTrans.map((tr) => TransactionItemTile(
                    transaction: tr,
                    onTap: () => TransactionFormModal.show(context, transactionToEdit: tr),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewSummaryList(BuildContext context, TransactionsState transState) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 80),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${transState.currentSubTab.label} Financial Breakdown',
                style: const TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _buildMetricRow('Total Records', '${transState.transactions.length} items'),
              const Divider(color: AppColors.darkDivider),
              _buildMetricRow('Income Recorded', CurrencyFormatter.format(transState.totalIncome), color: AppColors.income),
              const Divider(color: AppColors.darkDivider),
              _buildMetricRow('Expenses Recorded', CurrencyFormatter.format(transState.totalExpense), color: AppColors.expense),
              const Divider(color: AppColors.darkDivider),
              _buildMetricRow(
                'Net Cash Flow',
                CurrencyFormatter.format(transState.netTotal, showSign: true),
                color: transState.netTotal >= 0 ? AppColors.netWorth : AppColors.expense,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Recent Entries',
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        ...transState.transactions.take(10).map(
              (t) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: TransactionItemTile(
                  transaction: t,
                  onTap: () => TransactionFormModal.show(context, transactionToEdit: t),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppColors.textPrimaryDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
