import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../utils/date_formatters.dart';
import '../../features/transactions/models/transaction_model.dart';

class CsvService {
  static final CsvService instance = CsvService._internal();
  CsvService._internal();

  Future<String> exportTransactionsToCsv() async {
    final transactions = await AppDatabase.instance.getAllTransactions();

    List<List<dynamic>> rows = [];
    // Header
    rows.add([
      'Transaction ID',
      'Date',
      'Time',
      'Type',
      'Amount',
      'Account',
      'To Account',
      'Category',
      'Note',
      'Adjustment',
    ]);

    for (final tr in transactions) {
      rows.add([
        tr.id,
        DateFormatters.formatDateIso(tr.dateTime),
        DateFormatters.formatTime(tr.dateTime),
        tr.type.displayName,
        tr.amount,
        tr.accountName ?? tr.accountId,
        tr.toAccountName ?? tr.toAccountId ?? '',
        tr.categoryName ?? tr.categoryId ?? '',
        tr.note ?? '',
        tr.isModifiedBalanceAdjustment ? 'Yes' : 'No',
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/wallet_manager_transactions_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csvData);
    return file.path;
  }

  Future<void> shareCsvExport() async {
    final filePath = await exportTransactionsToCsv();
    await Share.shareXFiles(
      [XFile(filePath)],
      subject: 'Wallet Manager Transactions Export',
      text: 'Here is your exported transactions ledger from Wallet Manager.',
    );
  }

  Future<int> importTransactionsFromCsv(String csvContent) async {
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvContent);
    if (rows.length <= 1) return 0;

    int importedCount = 0;
    final accounts = await AppDatabase.instance.getAccounts();
    final defaultAccountId = accounts.isNotEmpty ? accounts.first.id : 'acc_cash';

    // Skip header row
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 5) continue;

      try {
        final dateStr = row[1].toString();
        final typeStr = row[3].toString().toLowerCase();
        final amount = double.tryParse(row[4].toString()) ?? 0.0;
        final note = row.length > 8 ? row[8].toString() : '';

        TransactionType type = TransactionType.expense;
        if (typeStr.contains('income')) {
          type = TransactionType.income;
        } else if (typeStr.contains('transfer')) {
          type = TransactionType.transfer;
        }

        DateTime dateTime = DateTime.tryParse(dateStr) ?? DateTime.now();

        final tr = TransactionModel(
          id: const Uuid().v4(),
          type: type,
          amount: amount,
          dateTime: dateTime,
          accountId: defaultAccountId,
          note: note,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await AppDatabase.instance.insertTransaction(tr);
        importedCount++;
      } catch (_) {
        // Skip malformed row and continue
      }
    }

    return importedCount;
  }
}
