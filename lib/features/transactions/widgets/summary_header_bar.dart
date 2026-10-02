import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

class SummaryHeaderBar extends StatelessWidget {
  final double income;
  final double expense;
  final double total;
  final String currency;

  const SummaryHeaderBar({
    super.key,
    required this.income,
    required this.expense,
    required this.total,
    this.currency = '₹',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder, width: 1),
      ),
      child: Row(
        children: [
          // Income
          Expanded(
            child: _buildColumn(
              title: 'Income',
              amount: income,
              color: AppColors.income,
              showPlus: false,
            ),
          ),
          Container(
            height: 32,
            width: 1,
            color: AppColors.darkBorder,
          ),
          // Expenses
          Expanded(
            child: _buildColumn(
              title: 'Expenses',
              amount: expense,
              color: AppColors.expense,
              showPlus: false,
            ),
          ),
          Container(
            height: 32,
            width: 1,
            color: AppColors.darkBorder,
          ),
          // Total
          Expanded(
            child: _buildColumn(
              title: 'Total',
              amount: total,
              color: total >= 0 ? AppColors.textPrimaryDark : AppColors.expense,
              showPlus: total > 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn({
    required String title,
    required double amount,
    required Color color,
    bool showPlus = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            CurrencyFormatter.format(amount, symbol: currency, showSign: showPlus),
            style: TextStyle(
              color: color,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              fontFamily: 'Sora',
            ),
          ),
        ),
      ],
    );
  }
}
