import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_formatters.dart';
import '../../accounts/providers/account_provider.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../widgets/amount_calculator_keypad.dart';

class TransactionFormModal extends ConsumerStatefulWidget {
  final TransactionType initialType;
  final TransactionModel? transactionToEdit;

  const TransactionFormModal({
    super.key,
    this.initialType = TransactionType.expense,
    this.transactionToEdit,
  });

  static Future<void> show(
    BuildContext context, {
    TransactionType initialType = TransactionType.expense,
    TransactionModel? transactionToEdit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransactionFormModal(
        initialType: transactionToEdit?.type ?? initialType,
        transactionToEdit: transactionToEdit,
      ),
    );
  }

  @override
  ConsumerState<TransactionFormModal> createState() => _TransactionFormModalState();
}

class _TransactionFormModalState extends ConsumerState<TransactionFormModal> {
  late TransactionType _selectedType;
  late DateTime _selectedDateTime;
  String? _selectedAccountId;
  String? _selectedToAccountId;
  String? _selectedCategoryId;
  String _amountString = '0';
  late final TextEditingController _noteController;
  String? _attachedPhotoPath;
  bool _showKeypad = true;

  final ImagePicker _picker = ImagePicker();

  bool get _isEditing => widget.transactionToEdit != null;

  @override
  void initState() {
    super.initState();
    final edit = widget.transactionToEdit;
    if (edit != null) {
      _selectedType = edit.type;
      _selectedDateTime = edit.dateTime;
      _selectedAccountId = edit.accountId;
      _selectedToAccountId = edit.toAccountId;
      _selectedCategoryId = edit.categoryId;
      _amountString = edit.amount % 1 == 0 ? edit.amount.toInt().toString() : edit.amount.toString();
      _noteController = TextEditingController(text: edit.note ?? '');
      _attachedPhotoPath = edit.photoPath;
      _showKeypad = false;
    } else {
      _selectedType = widget.initialType;
      _selectedDateTime = DateTime.now();
      _noteController = TextEditingController();
      _showKeypad = true;

      // Default source account
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final accounts = ref.read(accountsProvider).accounts;
        if (accounts.isNotEmpty) {
          setState(() {
            _selectedAccountId = accounts.first.id;
            if (accounts.length > 1) {
              _selectedToAccountId = accounts[1].id;
            }
          });
        }

        // Default category
        final cats = ref.read(transactionsProvider).categories;
        final matchedCats = cats.where((c) => c.type.name == _selectedType.name).toList();
        if (matchedCats.isNotEmpty) {
          setState(() {
            _selectedCategoryId = matchedCats.first.id;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _attachedPhotoPath = picked.path;
        });
      }
    } catch (_) {
      // Handle camera/gallery permission denial gracefully
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppColors.expense),
                title: const Text('Take Photo', style: TextStyle(color: AppColors.textPrimaryDark)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppColors.income),
                title: const Text('Choose from Gallery', style: TextStyle(color: AppColors.textPrimaryDark)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.expense,
              surface: AppColors.darkCard,
              onSurface: AppColors.textPrimaryDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.expense,
                surface: AppColors.darkCard,
                onSurface: AppColors.textPrimaryDark,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveTransaction() async {
    final double amount = double.tryParse(_amountString) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount greater than 0')),
      );
      return;
    }

    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an account')),
      );
      return;
    }

    if (_selectedType == TransactionType.transfer && _selectedToAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a destination account')),
      );
      return;
    }

    if (_selectedType == TransactionType.transfer && _selectedAccountId == _selectedToAccountId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('From and To accounts must be different')),
      );
      return;
    }

    try {
      if (_isEditing) {
        final old = widget.transactionToEdit!;
        final updated = old.copyWith(
          type: _selectedType,
          amount: amount,
          dateTime: _selectedDateTime,
          accountId: _selectedAccountId!,
          toAccountId: _selectedType == TransactionType.transfer ? _selectedToAccountId : null,
          categoryId: _selectedType != TransactionType.transfer ? _selectedCategoryId : null,
          note: _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null,
          photoPath: _attachedPhotoPath,
          updatedAt: DateTime.now(),
        );

        await ref.read(transactionsProvider.notifier).updateTransaction(old, updated);
        await ref.read(accountsProvider.notifier).loadAccounts();
      } else {
        final newTransaction = TransactionModel(
          id: const Uuid().v4(),
          type: _selectedType,
          amount: amount,
          dateTime: _selectedDateTime,
          accountId: _selectedAccountId!,
          toAccountId: _selectedType == TransactionType.transfer ? _selectedToAccountId : null,
          categoryId: _selectedType != TransactionType.transfer ? _selectedCategoryId : null,
          note: _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null,
          photoPath: _attachedPhotoPath,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await ref.read(transactionsProvider.notifier).addTransaction(newTransaction);
        await ref.read(accountsProvider.notifier).loadAccounts();
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save transaction: $e')),
        );
      }
    }
  }

  Future<void> _deleteTransaction() async {
    if (!_isEditing) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text('Delete Transaction', style: TextStyle(color: AppColors.expense)),
        content: const Text(
          'Are you sure you want to delete this transaction? Account balances will be reverted.',
          style: TextStyle(color: AppColors.textPrimaryDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.expense),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(transactionsProvider.notifier).deleteTransaction(widget.transactionToEdit!.id);
        await ref.read(accountsProvider.notifier).loadAccounts();
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete transaction: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider).accounts;
    final allCats = ref.watch(transactionsProvider).categories;
    final filteredCategories = allCats.where((c) => c.type.name == _selectedType.name).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Top Handle & Close & Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondaryDark),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  _isEditing ? 'Edit Transaction' : 'New Transaction',
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isEditing)
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.expense, size: 22),
                        onPressed: _deleteTransaction,
                      ),
                    TextButton(
                      onPressed: _saveTransaction,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: AppColors.expense,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Segmented Tabs: [Income | Expense | Transfer]
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              children: [
                _buildSegmentTab(
                  type: TransactionType.income,
                  label: 'Income',
                  activeColor: AppColors.income,
                ),
                _buildSegmentTab(
                  type: TransactionType.expense,
                  label: 'Expense',
                  activeColor: AppColors.expense,
                ),
                _buildSegmentTab(
                  type: TransactionType.transfer,
                  label: 'Transfer',
                  activeColor: AppColors.transfer,
                ),
              ],
            ),
          ),

          // Main Form Content Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Amount Display Box
                  GestureDetector(
                    onTap: () => setState(() => _showKeypad = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _showKeypad ? AppColors.expense : AppColors.darkBorder,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Amount',
                            style: TextStyle(
                              color: AppColors.textSecondaryDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '₹$_amountString',
                            style: TextStyle(
                              color: _selectedType.color,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Sora',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Date & Time Picker Row
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today_rounded, color: AppColors.textSecondaryDark, size: 20),
                    title: const Text('Date & Time', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
                    trailing: Text(
                      '${DateFormatters.formatDateWithDay(_selectedDateTime)} ${DateFormatters.formatTime(_selectedDateTime)}',
                      style: const TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    onTap: _pickDateTime,
                  ),
                  const Divider(color: AppColors.darkBorder),

                  // Account Selector
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.textSecondaryDark, size: 20),
                    title: Text(
                      _selectedType == TransactionType.transfer ? 'From Account' : 'Account',
                      style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
                    ),
                    trailing: DropdownButton<String>(
                      value: _selectedAccountId,
                      dropdownColor: AppColors.darkCard,
                      underline: const SizedBox(),
                      style: const TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600, fontSize: 13),
                      items: accounts.map((acc) {
                        return DropdownMenuItem(
                          value: acc.id,
                          child: Text(acc.name),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedAccountId = val),
                    ),
                  ),

                  if (_selectedType == TransactionType.transfer) ...[
                    const Divider(color: AppColors.darkBorder),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.swap_horiz_rounded, color: AppColors.transfer, size: 20),
                      title: const Text('To Account', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
                      trailing: DropdownButton<String>(
                        value: _selectedToAccountId,
                        dropdownColor: AppColors.darkCard,
                        underline: const SizedBox(),
                        style: const TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600, fontSize: 13),
                        items: accounts.map((acc) {
                          return DropdownMenuItem(
                            value: acc.id,
                            child: Text(acc.name),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedToAccountId = val),
                      ),
                    ),
                  ],

                  // Category Selector (if not transfer)
                  if (_selectedType != TransactionType.transfer) ...[
                    const Divider(color: AppColors.darkBorder),
                    const SizedBox(height: 8),
                    const Text(
                      'Category',
                      style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 82,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredCategories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final cat = filteredCategories[index];
                          final isSelected = cat.id == _selectedCategoryId;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategoryId = cat.id),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? cat.color.withOpacity(0.35)
                                        : AppColors.darkCard,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected ? cat.color : AppColors.darkBorder,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Icon(cat.iconData, color: cat.color, size: 22),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cat.name,
                                  style: TextStyle(
                                    color: isSelected ? AppColors.textPrimaryDark : AppColors.textSecondaryDark,
                                    fontSize: 10.5,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const Divider(color: AppColors.darkBorder),

                  // Note Field
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      hintText: 'Add a note or description...',
                      prefixIcon: Icon(Icons.edit_note_rounded, color: AppColors.textSecondaryDark),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                    ),
                    style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13.5),
                  ),

                  const Divider(color: AppColors.darkBorder),

                  // Photo Save Attachment
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.photo_camera_rounded, color: AppColors.textSecondaryDark, size: 20),
                    title: const Text('Photo Save (Attach Receipt)', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
                    trailing: _attachedPhotoPath != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  File(_attachedPhotoPath!),
                                  width: 34,
                                  height: 34,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.expense),
                                onPressed: () => setState(() => _attachedPhotoPath = null),
                              ),
                            ],
                          )
                        : TextButton.icon(
                            icon: const Icon(Icons.add_a_photo_rounded, size: 16, color: AppColors.income),
                            label: const Text('Add', style: TextStyle(color: AppColors.income, fontSize: 12)),
                            onPressed: _showImageSourcePicker,
                          ),
                  ),
                ],
              ),
            ),
          ),

          // Interactive Amount Calculator Keypad
          if (_showKeypad)
            AmountCalculatorKeypad(
              initialValue: _amountString,
              onChanged: (val) => setState(() => _amountString = val),
              onDone: () => setState(() => _showKeypad = false),
            ),
        ],
      ),
    );
  }

  Widget _buildSegmentTab({
    required TransactionType type,
    required String label,
    required Color activeColor,
  }) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
            // update default category
            final cats = ref.read(transactionsProvider).categories;
            final matched = cats.where((c) => c.type.name == type.name).toList();
            if (matched.isNotEmpty) {
              _selectedCategoryId = matched.first.id;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondaryDark,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
