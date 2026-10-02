import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/transaction_model.dart';

class TransactionItemTile extends StatelessWidget {
  final TransactionModel transaction;
  final String currency;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionItemTile({
    super.key,
    required this.transaction,
    this.currency = '₹',
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color amountColor;
    String sign = '';

    switch (transaction.type) {
      case TransactionType.expense:
        amountColor = AppColors.expense;
        sign = '-';
        break;
      case TransactionType.income:
        amountColor = AppColors.income;
        sign = '+';
        break;
      case TransactionType.transfer:
        amountColor = AppColors.transfer;
        sign = '';
        break;
    }

    final categoryColor = Color(transaction.categoryColorValue ?? 0xFF2E86DE);
    final iconData = transaction.categoryIconCodePoint != null
        ? IconData(transaction.categoryIconCodePoint!, fontFamily: 'MaterialIcons')
        : (transaction.type == TransactionType.transfer
            ? Icons.swap_horiz_rounded
            : Icons.receipt_rounded);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Category Icon Badge
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: transaction.type == TransactionType.transfer
                    ? AppColors.transfer.withOpacity(0.18)
                    : categoryColor.withOpacity(0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                iconData,
                color: transaction.type == TransactionType.transfer
                    ? AppColors.transfer
                    : categoryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Category & Account/Note Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          transaction.type == TransactionType.transfer
                              ? 'Transfer'
                              : (transaction.categoryName ?? 'Uncategorized'),
                          style: const TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (transaction.photoPath != null && transaction.photoPath!.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.receipt_long_rounded,
                          size: 14,
                          color: AppColors.textSecondaryDark,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _buildSubtitle(),
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 11.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Amount
            Text(
              '$sign${CurrencyFormatter.format(transaction.amount, symbol: currency)}',
              style: TextStyle(
                color: amountColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final buffer = StringBuffer();
    if (transaction.type == TransactionType.transfer) {
      buffer.write('${transaction.accountName ?? "Account"} → ${transaction.toAccountName ?? "Account"}');
    } else {
      buffer.write(transaction.accountName ?? 'Account');
    }

    if (transaction.note != null && transaction.note!.trim().isNotEmpty) {
      buffer.write(' • ${transaction.note!.trim()}');
    }
    return buffer.toString();
  }
}
