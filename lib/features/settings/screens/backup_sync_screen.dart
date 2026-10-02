import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/google_drive_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../accounts/providers/account_provider.dart';
import '../../transactions/providers/transaction_provider.dart';

class BackupSyncScreen extends ConsumerStatefulWidget {
  const BackupSyncScreen({super.key});

  @override
  ConsumerState<BackupSyncScreen> createState() => _BackupSyncScreenState();
}

class _BackupSyncScreenState extends ConsumerState<BackupSyncScreen> {
  bool _isLoading = false;
  bool _autoSyncEnabled = false;
  String _syncFrequency = 'daily';
  String? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoSyncEnabled = prefs.getBool(AppConstants.prefAutoSyncEnabled) ?? false;
      _syncFrequency = prefs.getString(AppConstants.prefAutoSyncFrequency) ?? 'daily';
      _lastSyncTime = prefs.getString(AppConstants.prefLastSyncTime);
    });
  }

  Future<void> _toggleAutoSync(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefAutoSyncEnabled, val);
    setState(() => _autoSyncEnabled = val);
  }

  Future<void> _exportLocalBackup() async {
    setState(() => _isLoading = true);
    try {
      final dbPath = await AppDatabase.instance.getDatabasePath();
      final file = File(dbPath);
      if (await file.exists()) {
        await Share.shareXFiles(
          [XFile(dbPath)],
          subject: 'Wallet Manager Database Backup',
          text: 'Backup file generated on ${DateTime.now().toLocal()}',
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _importLocalBackup() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) return;

    setState(() => _isLoading = true);
    try {
      final pickedFile = File(result.files.single.path!);
      final dbPath = await AppDatabase.instance.getDatabasePath();
      await pickedFile.copy(dbPath);

      ref.read(accountsProvider.notifier).loadAccounts();
      ref.read(transactionsProvider.notifier).loadTransactions();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup restored successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to restore backup: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _syncToGoogleDrive() async {
    setState(() => _isLoading = true);
    try {
      final success = await GoogleDriveBackupService.instance.uploadBackupToDrive();
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google Drive backup sync completed!')),
          );
          _loadPreferences();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Drive sync failed. Please check internet & Google account.')),
          );
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _restoreFromGoogleDrive() async {
    setState(() => _isLoading = true);
    try {
      final success = await GoogleDriveBackupService.instance.restoreBackupFromDrive();
      if (mounted) {
        if (success) {
          ref.read(accountsProvider.notifier).loadAccounts();
          ref.read(transactionsProvider.notifier).loadTransactions();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Database restored from Google Drive!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid backup found in Drive AppData folder.')),
          );
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final googleUser = GoogleDriveBackupService.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(title: const Text('Backup & Cloud Sync')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.expense))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Google Drive Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.income.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.cloud_sync_rounded, color: AppColors.income, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Google Drive Cloud Sync',
                                  style: TextStyle(
                                    color: AppColors.textPrimaryDark,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  googleUser != null ? googleUser.email : 'Not signed in',
                                  style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          if (googleUser == null)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.income,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () async {
                                await GoogleDriveBackupService.instance.signIn();
                                setState(() {});
                              },
                              child: const Text('Sign In'),
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.logout_rounded, color: AppColors.expense),
                              onPressed: () async {
                                await GoogleDriveBackupService.instance.signOut();
                                setState(() {});
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.darkDivider),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Auto-Sync Backup', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 13.5)),
                        subtitle: const Text('Automatically sync database to Google Drive', style: TextStyle(color: AppColors.textMutedDark, fontSize: 11)),
                        value: _autoSyncEnabled,
                        activeColor: AppColors.income,
                        onChanged: _toggleAutoSync,
                      ),
                      if (_autoSyncEnabled) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Frequency', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
                            DropdownButton<String>(
                              value: _syncFrequency,
                              dropdownColor: AppColors.darkCardElevated,
                              underline: const SizedBox(),
                              style: const TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w700),
                              items: const [
                                DropdownMenuItem(value: 'daily', child: Text('Daily')),
                                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                              ],
                              onChanged: (val) async {
                                if (val != null) {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.setString(AppConstants.prefAutoSyncFrequency, val);
                                  setState(() => _syncFrequency = val);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                      if (_lastSyncTime != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Last Synced: ${_lastSyncTime!.substring(0, 16).replaceAll("T", " ")}',
                          style: const TextStyle(color: AppColors.textMutedDark, fontSize: 11),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.income),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.cloud_upload_rounded, color: AppColors.income, size: 18),
                              label: const Text('Sync Now', style: TextStyle(color: AppColors.income)),
                              onPressed: _syncToGoogleDrive,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.darkBorder),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.cloud_download_rounded, color: AppColors.textSecondaryDark, size: 18),
                              label: const Text('Restore', style: TextStyle(color: AppColors.textSecondaryDark)),
                              onPressed: _restoreFromGoogleDrive,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Local SQLite Backup Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.folder_zip_rounded, color: AppColors.expense, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'Local SQLite Database Backup',
                            style: TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Export the exact SQLite database file for full offline safety, or import a previously exported database.',
                        style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.expense,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.download_rounded, size: 18),
                              label: const Text('Export DB'),
                              onPressed: _exportLocalBackup,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.darkBorder),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.upload_rounded, color: AppColors.textPrimaryDark, size: 18),
                              label: const Text('Import DB', style: TextStyle(color: AppColors.textPrimaryDark)),
                              onPressed: _importLocalBackup,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
