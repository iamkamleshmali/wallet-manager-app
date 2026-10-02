import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatters.dart';

class DateGroupHeader extends StatelessWidget {
  final DateTime date;
  final double dayIncome;
  final double dayExpense;
  final String currency;

  const DateGroupHeader({
    super.key,
    required this.date,
    required this.dayIncome,
    required this.dayExpense,
    this.currency = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final isSun = DateFormatters.isSunday(date);
    final isSat = DateFormatters.isSaturday(date);

    Color badgeBg = AppColors.darkCardElevated;
    Color badgeText = AppColors.textSecondaryDark;

    if (isSun) {
      badgeBg = AppColors.expense.withOpacity(0.18);
      badgeText = AppColors.expenseLight;
    } else if (isSat) {
      badgeBg = AppColors.income.withOpacity(0.18);
      badgeText = AppColors.incomeLight;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Day number & Weekday badge
          Row(
            children: [
              Text(
                DateFormatters.formatDay(date),
                style: const TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  DateFormatters.formatWeekday(date),
                  style: TextStyle(
                    color: badgeText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          // Right: Day-Total Income (Blue) & Day-Total Expense (Red)
          Row(
            children: [
              if (dayIncome > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    CurrencyFormatter.format(dayIncome, symbol: currency),
                    style: const TextStyle(
                      color: AppColors.income,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (dayExpense > 0)
                Text(
                  CurrencyFormatter.format(dayExpense, symbol: currency),
                  style: const TextStyle(
                    color: AppColors.expense,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
