import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatters.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_item_tile.dart';

class CalendarViewScreen extends ConsumerStatefulWidget {
  const CalendarViewScreen({super.key});

  @override
  ConsumerState<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends ConsumerState<CalendarViewScreen> {
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final transState = ref.watch(transactionsProvider);
    final currentMonth = transState.selectedDate;

    // Days in current month
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstWeekdayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1).weekday;
    // Normalize to Sunday = 0
    final startOffset = firstWeekdayOfMonth % 7;

    // Precalculate day summaries
    final Map<int, double> dayIncomes = {};
    final Map<int, double> dayExpenses = {};

    for (final tr in transState.transactions) {
      final day = tr.dateTime.day;
      if (tr.type == TransactionType.income) {
        dayIncomes[day] = (dayIncomes[day] ?? 0.0) + tr.amount;
      } else if (tr.type == TransactionType.expense) {
        dayExpenses[day] = (dayExpenses[day] ?? 0.0) + tr.amount;
      }
    }

    final selectedDayTransactions = _selectedDay == null
        ? []
        : transState.transactions
            .where((t) => DateFormatters.isSameDay(t.dateTime, _selectedDay!))
            .toList();

    return Column(
      children: [
        // Weekday header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Row(
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((d) {
              final isSun = d == 'Sun';
              final isSat = d == 'Sat';
              return Expanded(
                child: Text(
                  d,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSun
                        ? AppColors.expense
                        : isSat
                            ? AppColors.income
                            : AppColors.textSecondaryDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Calendar Grid
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.85,
            ),
            itemCount: startOffset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startOffset) {
                return const SizedBox();
              }

              final day = index - startOffset + 1;
              final dayDate = DateTime(currentMonth.year, currentMonth.month, day);
              final isSelected = _selectedDay != null && DateFormatters.isSameDay(dayDate, _selectedDay!);
              final inc = dayIncomes[day] ?? 0.0;
              final exp = dayExpenses[day] ?? 0.0;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = dayDate;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.darkCardElevated : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected ? Border.all(color: AppColors.expense, width: 1.5) : null,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          color: isSelected ? AppColors.textPrimaryDark : AppColors.textSecondaryDark,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (inc > 0)
                        Text(
                          CurrencyFormatter.formatCompact(inc, symbol: ''),
                          style: const TextStyle(color: AppColors.income, fontSize: 8, fontWeight: FontWeight.w700),
                        ),
                      if (exp > 0)
                        Text(
                          CurrencyFormatter.formatCompact(exp, symbol: ''),
                          style: const TextStyle(color: AppColors.expense, fontSize: 8, fontWeight: FontWeight.w700),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Selected Day Details
        if (_selectedDay != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormatters.formatDateWithDay(_selectedDay!),
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${selectedDayTransactions.length} transactions',
                  style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: selectedDayTransactions.isEmpty
                ? const Center(
                    child: Text('No transactions on this date', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: selectedDayTransactions.length,
                    separatorBuilder: (_, __) => const Divider(color: AppColors.darkDivider),
                    itemBuilder: (context, index) {
                      return TransactionItemTile(transaction: selectedDayTransactions[index]);
                    },
                  ),
          ),
        ] else ...[
          const Expanded(
            child: Center(
              child: Text(
                'Select a day to view transactions',
                style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
