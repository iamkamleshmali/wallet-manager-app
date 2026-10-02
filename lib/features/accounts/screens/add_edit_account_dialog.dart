import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/account_model.dart';
import '../providers/account_provider.dart';

class AddEditAccountDialog extends ConsumerStatefulWidget {
  final AccountModel? accountToEdit;

  const AddEditAccountDialog({super.key, this.accountToEdit});

  static Future<void> show(BuildContext context, {AccountModel? accountToEdit}) {
    return showDialog(
      context: context,
      builder: (_) => AddEditAccountDialog(accountToEdit: accountToEdit),
    );
  }

  @override
  ConsumerState<AddEditAccountDialog> createState() => _AddEditAccountDialogState();
}

class _AddEditAccountDialogState extends ConsumerState<AddEditAccountDialog> {
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late AccountGroup _selectedGroup;
  late bool _includeInNetWorth;

  @override
  void initState() {
    super.initState();
    final acc = widget.accountToEdit;
    _nameController = TextEditingController(text: acc?.name ?? '');
    _balanceController = TextEditingController(text: acc != null ? acc.balance.toStringAsFixed(0) : '0');
    _selectedGroup = acc?.group ?? AccountGroup.accounts;
    _includeInNetWorth = acc?.includeInNetWorth ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final balance = double.tryParse(_balanceController.text.trim()) ?? 0.0;

    final now = DateTime.now();
    if (widget.accountToEdit != null) {
      final updated = widget.accountToEdit!.copyWith(
        name: name,
        group: _selectedGroup,
        balance: balance,
        includeInNetWorth: _includeInNetWorth,
        updatedAt: now,
      );
      ref.read(accountsProvider.notifier).updateAccount(updated);
    } else {
      final newAcc = AccountModel(
        id: const Uuid().v4(),
        name: name,
        group: _selectedGroup,
        balance: balance,
        includeInNetWorth: _includeInNetWorth,
        iconCodePoint: _selectedGroup.iconData.codePoint,
        colorValue: _selectedGroup.isLiability ? 0xFFFF5E57 : 0xFF2E86DE,
        createdAt: now,
        updatedAt: now,
      );
      ref.read(accountsProvider.notifier).addAccount(newAcc);
    }
    Navigator.pop(context);
  }

  void _delete() {
    if (widget.accountToEdit != null) {
      ref.read(accountsProvider.notifier).deleteAccount(widget.accountToEdit!.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.accountToEdit != null;

    return AlertDialog(
      backgroundColor: AppColors.darkCard,
      title: Text(
        isEditing ? 'Edit Account' : 'Add New Account',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Account Name'),
              style: const TextStyle(color: AppColors.textPrimaryDark),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<AccountGroup>(
              value: _selectedGroup,
              dropdownColor: AppColors.darkCardElevated,
              decoration: const InputDecoration(labelText: 'Group'),
              style: const TextStyle(color: AppColors.textPrimaryDark),
              items: AccountGroup.values.map((g) {
                return DropdownMenuItem(
                  value: g,
                  child: Row(
                    children: [
                      Icon(g.iconData, size: 18, color: AppColors.textSecondaryDark),
                      const SizedBox(width: 8),
                      Text(g.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedGroup = val);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _balanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: const InputDecoration(labelText: 'Starting Balance (₹)'),
              style: const TextStyle(color: AppColors.textPrimaryDark),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Include in Net Worth', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 13)),
              value: _includeInNetWorth,
              activeColor: AppColors.expense,
              onChanged: (val) => setState(() => _includeInNetWorth = val),
            ),
          ],
        ),
      ),
      actions: [
        if (isEditing)
          TextButton(
            onPressed: _delete,
            child: const Text('Delete', style: TextStyle(color: AppColors.expense)),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.expense),
          onPressed: _save,
          child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class AdjustBalanceDialog extends ConsumerStatefulWidget {
  final AccountModel account;

  const AdjustBalanceDialog({super.key, required this.account});

  static Future<void> show(BuildContext context, AccountModel account) {
    return showDialog(
      context: context,
      builder: (_) => AdjustBalanceDialog(account: account),
    );
  }

  @override
  ConsumerState<AdjustBalanceDialog> createState() => _AdjustBalanceDialogState();
}

class _AdjustBalanceDialogState extends ConsumerState<AdjustBalanceDialog> {
  late TextEditingController _balanceController;
  late TextEditingController _noteController;
  double _diff = 0.0;

  @override
  void initState() {
    super.initState();
    _balanceController = TextEditingController(text: widget.account.balance.toStringAsFixed(2));
    _noteController = TextEditingController(text: 'Modified Bal. adjustment');
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _calculateDiff(String val) {
    final newBal = double.tryParse(val) ?? widget.account.balance;
    setState(() {
      _diff = newBal - widget.account.balance;
    });
  }

  void _applyAdjustment() {
    final newBal = double.tryParse(_balanceController.text.trim()) ?? widget.account.balance;
    ref.read(accountsProvider.notifier).adjustBalance(
      accountId: widget.account.id,
      newBalance: newBal,
      note: _noteController.text.trim(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkCard,
      title: Text('Adjust Balance: ${widget.account.name}', style: const TextStyle(fontSize: 16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Current Balance:', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
              Text(
                CurrencyFormatter.format(widget.account.balance),
                style: const TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _balanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: const InputDecoration(labelText: 'New Actual Balance'),
            style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 16, fontWeight: FontWeight.w700),
            onChanged: _calculateDiff,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ledger Adjustment:', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
              Text(
                _diff == 0
                    ? 'No change'
                    : CurrencyFormatter.format(_diff, showSign: true),
                style: TextStyle(
                  color: _diff > 0 ? AppColors.income : (_diff < 0 ? AppColors.expense : AppColors.textSecondaryDark),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(labelText: 'Reason / Note'),
            style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13),
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
          onPressed: _applyAdjustment,
          child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
