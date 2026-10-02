import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';
import '../../features/accounts/models/account_model.dart';
import '../../features/transactions/models/category_model.dart';
import '../../features/transactions/models/transaction_model.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  AppDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
      _db = null;
    }
  }

  Future<Database> reopen() async {
    await close();
    return await database;
  }

  Future<String> getDatabasePath() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return p.join(docsDir.path, AppConstants.databaseName);
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasePath();
    return await openDatabase(
      dbPath,
      version: AppConstants.databaseVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Version 2 ensures all indexes exist and schema integrity
      await db.execute('CREATE INDEX IF NOT EXISTS idx_trans_datetime ON transactions (date_time)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_trans_account ON transactions (account_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_trans_category ON transactions (category_id)');
    }
    // Future migrations (e.g. if (oldVersion < 3) { ... }) can be added incrementally here safely
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE accounts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        account_group TEXT NOT NULL,
        balance REAL NOT NULL DEFAULT 0.0,
        currency TEXT NOT NULL DEFAULT '₹',
        icon_code_point INTEGER NOT NULL,
        color_value INTEGER NOT NULL,
        include_in_net_worth INTEGER NOT NULL DEFAULT 1,
        sort_order INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        icon_code_point INTEGER NOT NULL,
        color_value INTEGER NOT NULL,
        sort_order INTEGER NOT NULL DEFAULT 0,
        is_default INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        date_time TEXT NOT NULL,
        account_id TEXT NOT NULL,
        to_account_id TEXT,
        category_id TEXT,
        sub_category TEXT,
        note TEXT,
        photo_path TEXT,
        is_modified_adjustment INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (account_id) REFERENCES accounts (id) ON DELETE RESTRICT,
        FOREIGN KEY (to_account_id) REFERENCES accounts (id) ON DELETE RESTRICT,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL
      )
    ''');

    // Create indexes for fast date queries
    await db.execute('CREATE INDEX idx_trans_datetime ON transactions (date_time)');
    await db.execute('CREATE INDEX idx_trans_account ON transactions (account_id)');

    // Seed default categories
    for (final cat in CategoryModel.defaultExpenseCategories) {
      await db.insert('categories', cat.toMap());
    }
    for (final cat in CategoryModel.defaultIncomeCategories) {
      await db.insert('categories', cat.toMap());
    }

    // Seed initial realistic accounts
    final now = DateTime.now();
    final defaultAccounts = [
      AccountModel(
        id: 'acc_cash',
        name: 'Cash in Hand',
        group: AccountGroup.cash,
        balance: 3800.0,
        iconCodePoint: Icons.payments_rounded.codePoint,
        colorValue: 0xFF2ECC71,
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
      ),
      AccountModel(
        id: 'acc_bob_upi',
        name: 'Bob Upi Ac',
        group: AccountGroup.accounts,
        balance: 38450.0,
        iconCodePoint: Icons.account_balance_rounded.codePoint,
        colorValue: 0xFF2E86DE,
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
      ),
      AccountModel(
        id: 'acc_savings',
        name: 'HDFC Savings',
        group: AccountGroup.accounts,
        balance: 142500.0,
        iconCodePoint: Icons.account_balance_rounded.codePoint,
        colorValue: 0xFF00D2D3,
        sortOrder: 3,
        createdAt: now,
        updatedAt: now,
      ),
      AccountModel(
        id: 'acc_credit_card',
        name: 'Credit Card',
        group: AccountGroup.cards,
        balance: -5420.0,
        iconCodePoint: Icons.credit_card_rounded.codePoint,
        colorValue: 0xFFFF5E57,
        sortOrder: 4,
        createdAt: now,
        updatedAt: now,
      ),
      AccountModel(
        id: 'acc_mutual_funds',
        name: 'Mutual Funds & SIP',
        group: AccountGroup.investments,
        balance: 215000.0,
        iconCodePoint: Icons.trending_up_rounded.codePoint,
        colorValue: 0xFF5F27CD,
        sortOrder: 5,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final acc in defaultAccounts) {
      await db.insert('accounts', acc.toMap());
    }

    // Seed realistic sample transactions for the current month
    final sampleTrans = [
      TransactionModel(
        id: const Uuid().v4(),
        type: TransactionType.income,
        amount: 85000.0,
        dateTime: DateTime(now.year, now.month, 1, 10, 30),
        accountId: 'acc_bob_upi',
        categoryId: 'cat_salary',
        note: 'Monthly Salary Credit',
        createdAt: now,
        updatedAt: now,
      ),
      TransactionModel(
        id: const Uuid().v4(),
        type: TransactionType.expense,
        amount: 2200.0,
        dateTime: DateTime(now.year, now.month, 2, 13, 15),
        accountId: 'acc_bob_upi',
        categoryId: 'cat_food',
        note: 'Weekend Grocery & Cafe',
        createdAt: now,
        updatedAt: now,
      ),
      TransactionModel(
        id: const Uuid().v4(),
        type: TransactionType.expense,
        amount: 450.0,
        dateTime: DateTime(now.year, now.month, 2, 17, 45),
        accountId: 'acc_cash',
        categoryId: 'cat_transport',
        note: 'Metro & Auto rickshaw',
        createdAt: now,
        updatedAt: now,
      ),
      TransactionModel(
        id: const Uuid().v4(),
        type: TransactionType.expense,
        amount: 3200.0,
        dateTime: DateTime(now.year, now.month, now.day > 3 ? now.day - 1 : 1, 20, 0),
        accountId: 'acc_credit_card',
        categoryId: 'cat_shopping',
        note: 'Electronics store',
        createdAt: now,
        updatedAt: now,
      ),
      TransactionModel(
        id: const Uuid().v4(),
        type: TransactionType.expense,
        amount: 1450.0,
        dateTime: DateTime(now.year, now.month, now.day, 11, 20),
        accountId: 'acc_bob_upi',
        categoryId: 'cat_bills',
        note: 'Broadband Internet Fiber bill',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final tr in sampleTrans) {
      await db.insert('transactions', tr.toMap());
    }
  }

  // Double-Entry Ledger Insert
  Future<void> insertTransaction(TransactionModel tr) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('transactions', tr.toMap());

      if (tr.type == TransactionType.expense) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
          [tr.amount, DateTime.now().toIso8601String(), tr.accountId],
        );
      } else if (tr.type == TransactionType.income) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
          [tr.amount, DateTime.now().toIso8601String(), tr.accountId],
        );
      } else if (tr.type == TransactionType.transfer && tr.toAccountId != null) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
          [tr.amount, DateTime.now().toIso8601String(), tr.accountId],
        );
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
          [tr.amount, DateTime.now().toIso8601String(), tr.toAccountId],
        );
      }
    });
  }

  // Safely delete a photo file if no other transaction references it
  Future<void> _safeDeleteReceiptFile(DatabaseExecutor db, String? photoPath, {String? excludeTransactionId}) async {
    if (photoPath == null || photoPath.trim().isEmpty) return;
    try {
      final whereClause = excludeTransactionId != null
          ? 'photo_path = ? AND id != ?'
          : 'photo_path = ?';
      final whereArgs = excludeTransactionId != null
          ? [photoPath, excludeTransactionId]
          : [photoPath];

      final countResult = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM transactions WHERE $whereClause',
        whereArgs,
      ));

      if ((countResult ?? 0) == 0) {
        final file = File(photoPath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Error safely deleting receipt file: $e');
    }
  }

  // Update existing transaction with atomic account balance recalculation
  Future<void> updateTransaction(TransactionModel oldTr, TransactionModel newTr) async {
    final db = await database;
    await db.transaction((txn) async {
      // 1. Revert previous transaction impacts on accounts
      if (oldTr.type == TransactionType.expense) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
          [oldTr.amount, DateTime.now().toIso8601String(), oldTr.accountId],
        );
      } else if (oldTr.type == TransactionType.income) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
          [oldTr.amount, DateTime.now().toIso8601String(), oldTr.accountId],
        );
      } else if (oldTr.type == TransactionType.transfer && oldTr.toAccountId != null) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
          [oldTr.amount, DateTime.now().toIso8601String(), oldTr.accountId],
        );
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
          [oldTr.amount, DateTime.now().toIso8601String(), oldTr.toAccountId],
        );
      }

      // 2. Apply new transaction impacts on accounts
      final nowStr = DateTime.now().toIso8601String();
      if (newTr.type == TransactionType.expense) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
          [newTr.amount, nowStr, newTr.accountId],
        );
      } else if (newTr.type == TransactionType.income) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
          [newTr.amount, nowStr, newTr.accountId],
        );
      } else if (newTr.type == TransactionType.transfer && newTr.toAccountId != null) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
          [newTr.amount, nowStr, newTr.accountId],
        );
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
          [newTr.amount, nowStr, newTr.toAccountId],
        );
      }

      // 3. Update the transaction row itself
      await txn.update(
        'transactions',
        newTr.toMap(),
        where: 'id = ?',
        whereArgs: [newTr.id],
      );

      // 4. Clean up old receipt if photo changed or was removed
      if (oldTr.photoPath != null && oldTr.photoPath != newTr.photoPath) {
        await _safeDeleteReceiptFile(txn, oldTr.photoPath, excludeTransactionId: newTr.id);
      }
    });
  }

  // Reversible Transaction Delete with receipt file cleanup
  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      final rows = await txn.query('transactions', where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) return;
      final tr = TransactionModel.fromMap(rows.first);

      // Reverse account balances
      if (tr.type == TransactionType.expense) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
          [tr.amount, DateTime.now().toIso8601String(), tr.accountId],
        );
      } else if (tr.type == TransactionType.income) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
          [tr.amount, DateTime.now().toIso8601String(), tr.accountId],
        );
      } else if (tr.type == TransactionType.transfer && tr.toAccountId != null) {
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance + ?, updated_at = ? WHERE id = ?',
          [tr.amount, DateTime.now().toIso8601String(), tr.accountId],
        );
        await txn.rawUpdate(
          'UPDATE accounts SET balance = balance - ?, updated_at = ? WHERE id = ?',
          [tr.amount, DateTime.now().toIso8601String(), tr.toAccountId],
        );
      }

      await txn.delete('transactions', where: 'id = ?', whereArgs: [id]);

      // Safe receipt cleanup
      await _safeDeleteReceiptFile(txn, tr.photoPath, excludeTransactionId: id);
    });
  }

  // Balance Adjustment (Modified Bal. auto-entry)
  Future<void> adjustAccountBalance({
    required String accountId,
    required double newBalance,
    String? note,
  }) async {
    final db = await database;
    await db.transaction((txn) async {
      final accRows = await txn.query('accounts', where: 'id = ?', whereArgs: [accountId]);
      if (accRows.isEmpty) return;
      final currentBalance = (accRows.first['balance'] as num).toDouble();
      final diff = newBalance - currentBalance;
      if (diff.abs() < 0.001) return;

      final now = DateTime.now();
      // Determine if adjustment is positive (income-like) or negative (expense-like)
      final adjType = diff > 0 ? TransactionType.income : TransactionType.expense;
      final adjAmount = diff.abs();

      final adjTrans = TransactionModel(
        id: const Uuid().v4(),
        type: adjType,
        amount: adjAmount,
        dateTime: now,
        accountId: accountId,
        note: note ?? 'Modified Bal. adjustment',
        isModifiedBalanceAdjustment: true,
        createdAt: now,
        updatedAt: now,
      );

      await txn.insert('transactions', adjTrans.toMap());
      await txn.rawUpdate(
        'UPDATE accounts SET balance = ?, updated_at = ? WHERE id = ?',
        [newBalance, now.toIso8601String(), accountId],
      );
    });
  }

  // Query Transactions joined with Accounts and Categories
  Future<List<TransactionModel>> getTransactionsForMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    return getTransactionsBetween(start, end);
  }

  // Query Transactions between dates
  Future<List<TransactionModel>> getTransactionsBetween(DateTime start, DateTime end) async {
    final db = await database;
    final results = await db.rawQuery('''
      SELECT t.*,
             a.name AS account_name,
             ta.name AS to_account_name,
             c.name AS category_name,
             c.icon_code_point AS category_icon_code_point,
             c.color_value AS category_color_value
      FROM transactions t
      LEFT JOIN accounts a ON t.account_id = a.id
      LEFT JOIN accounts ta ON t.to_account_id = ta.id
      LEFT JOIN categories c ON t.category_id = c.id
      WHERE t.date_time >= ? AND t.date_time < ?
      ORDER BY t.date_time DESC, t.created_at DESC
    ''', [start.toIso8601String(), end.toIso8601String()]);

    return results.map((row) => TransactionModel.fromMap(row)).toList();
  }

  // Global Transaction Search across full database history
  Future<List<TransactionModel>> searchTransactions({
    String query = '',
    String? accountId,
    String? categoryId,
  }) async {
    final db = await database;
    final StringBuffer where = StringBuffer('1=1');
    final List<dynamic> args = [];

    if (accountId != null && accountId.isNotEmpty) {
      where.write(' AND (t.account_id = ? OR t.to_account_id = ?)');
      args.add(accountId);
      args.add(accountId);
    }

    if (categoryId != null && categoryId.isNotEmpty) {
      where.write(' AND t.category_id = ?');
      args.add(categoryId);
    }

    if (query.trim().isNotEmpty) {
      where.write(' AND (t.note LIKE ? OR c.name LIKE ? OR a.name LIKE ? OR ta.name LIKE ?)');
      final searchPattern = '%${query.trim()}%';
      args.addAll([searchPattern, searchPattern, searchPattern, searchPattern]);
    }

    final results = await db.rawQuery('''
      SELECT t.*,
             a.name AS account_name,
             ta.name AS to_account_name,
             c.name AS category_name,
             c.icon_code_point AS category_icon_code_point,
             c.color_value AS category_color_value
      FROM transactions t
      LEFT JOIN accounts a ON t.account_id = a.id
      LEFT JOIN accounts ta ON t.to_account_id = ta.id
      LEFT JOIN categories c ON t.category_id = c.id
      WHERE $where
      ORDER BY t.date_time DESC, t.created_at DESC
    ''', args);

    return results.map((row) => TransactionModel.fromMap(row)).toList();
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final results = await db.rawQuery('''
      SELECT t.*,
             a.name AS account_name,
             ta.name AS to_account_name,
             c.name AS category_name,
             c.icon_code_point AS category_icon_code_point,
             c.color_value AS category_color_value
      FROM transactions t
      LEFT JOIN accounts a ON t.account_id = a.id
      LEFT JOIN accounts ta ON t.to_account_id = ta.id
      LEFT JOIN categories c ON t.category_id = c.id
      ORDER BY t.date_time DESC, t.created_at DESC
    ''');
    return results.map((row) => TransactionModel.fromMap(row)).toList();
  }

  Future<List<AccountModel>> getAccounts() async {
    final db = await database;
    final results = await db.query('accounts', orderBy: 'sort_order ASC, name ASC');
    return results.map((row) => AccountModel.fromMap(row)).toList();
  }

  Future<void> insertAccount(AccountModel account) async {
    final db = await database;
    await db.insert('accounts', account.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateAccount(AccountModel account) async {
    final db = await database;
    await db.update('accounts', account.toMap(), where: 'id = ?', whereArgs: [account.id]);
  }

  Future<void> deleteAccount(String accountId) async {
    final db = await database;
    // Check if account has dependent transactions before deleting
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM transactions WHERE account_id = ? OR to_account_id = ?',
      [accountId, accountId],
    ));

    if ((count ?? 0) > 0) {
      throw AccountHasTransactionsException(
        'Cannot delete account because it contains $count transaction(s). Please delete or reassign them first.',
      );
    }

    await db.delete('accounts', where: 'id = ?', whereArgs: [accountId]);
  }

  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final results = await db.query('categories', orderBy: 'sort_order ASC, name ASC');
    return results.map((row) => CategoryModel.fromMap(row)).toList();
  }

  Future<void> insertCategory(CategoryModel category) async {
    final db = await database;
    await db.insert('categories', category.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Safely replaces the SQLite database file from a source file (e.g. from local import or cloud download).
  /// Ensures validation of SQLite format, graceful rollback on failure, connection closing and reopening.
  Future<void> replaceDatabaseFileSafely(File sourceFile) async {
    if (!await sourceFile.exists()) {
      throw const FileSystemException('Source backup file does not exist');
    }

    // Verify it is a valid SQLite file by testing opening it in read-only mode first
    Database? testDb;
    try {
      testDb = await openReadOnlyDatabase(sourceFile.path);
      // Ensure expected tables exist
      final tables = await testDb.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name IN ('accounts', 'transactions')");
      if (tables.length < 2) {
        throw const FormatException('Selected file is not a valid Wallet Manager database backup');
      }
    } finally {
      if (testDb != null && testDb.isOpen) {
        await testDb.close();
      }
    }

    final dbPath = await getDatabasePath();
    final currentDbFile = File(dbPath);
    final backupCopyPath = '$dbPath.bak';
    final backupCopyFile = File(backupCopyPath);

    // Close active DB connection
    await close();

    bool backupCreated = false;
    try {
      if (await currentDbFile.exists()) {
        await currentDbFile.copy(backupCopyPath);
        backupCreated = true;
      }

      // Copy new file over active db path
      await sourceFile.copy(dbPath);

      // Try reopening to verify integrity
      await reopen();

      // If successful, remove the temporary backup file
      if (backupCreated && await backupCopyFile.exists()) {
        await backupCopyFile.delete();
      }
    } catch (e) {
      // Rollback if anything failed
      if (backupCreated && await backupCopyFile.exists()) {
        try {
          await backupCopyFile.copy(dbPath);
          await backupCopyFile.delete();
          await reopen();
        } catch (_) {}
      }
      rethrow;
    }
  }
}

class AccountHasTransactionsException implements Exception {
  final String message;
  const AccountHasTransactionsException(this.message);

  @override
  String toString() => message;
}
