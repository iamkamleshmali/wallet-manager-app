import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/account_model.dart';

class AccountGroupCard extends StatefulWidget {
  final AccountGroup group;
  final List<AccountModel> accounts;
  final void Function(AccountModel account) onEditAccount;
  final void Function(AccountModel account) onAdjustBalance;

  const AccountGroupCard({
    super.key,
    required this.group,
    required this.accounts,
    required this.onEditAccount,
    required this.onAdjustBalance,
  });

  @override
  State<AccountGroupCard> createState() => _AccountGroupCardState();
}

class _AccountGroupCardState extends State<AccountGroupCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.accounts.isEmpty) return const SizedBox();

    double groupTotal = 0.0;
    for (final acc in widget.accounts) {
      groupTotal += acc.balance;
    }

    final isLiability = widget.group.isLiability;
    final totalColor = isLiability ? AppColors.liability : AppColors.asset;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        children: [
          // Header / Accordion trigger
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(widget.group.iconData, color: AppColors.textSecondaryDark, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    widget.group.displayName,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    CurrencyFormatter.format(groupTotal),
                    style: TextStyle(
                      color: totalColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Sora',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondaryDark,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Collapsible account rows
          if (_isExpanded) ...[
            const Divider(color: AppColors.darkDivider),
            ...widget.accounts.map((acc) {
              return InkWell(
                onTap: () => widget.onAdjustBalance(acc),
                onLongPress: () => widget.onEditAccount(acc),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(acc.colorValue).withOpacity(0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          IconData(acc.iconCodePoint, fontFamily: 'MaterialIcons'),
                          color: Color(acc.colorValue),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              acc.name,
                              style: const TextStyle(
                                color: AppColors.textPrimaryDark,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'Tap to adjust balance',
                              style: TextStyle(color: AppColors.textMutedDark, fontSize: 10.5),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(acc.balance),
                        style: TextStyle(
                          color: acc.balance < 0 ? AppColors.expense : AppColors.textPrimaryDark,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Sora',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
