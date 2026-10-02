import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/csv_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../accounts/screens/accounts_tab_screen.dart';
import 'about_screen.dart';
import 'backup_sync_screen.dart';
import 'calc_box_screen.dart';
import 'configuration_screen.dart';
import 'security_settings_screen.dart';

class MoreTabScreen extends StatelessWidget {
  const MoreTabScreen({super.key});

  void _handleCsvExportImport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share_rounded, color: AppColors.income),
                title: const Text('Export & Share CSV Ledger', style: TextStyle(color: AppColors.textPrimaryDark)),
                subtitle: const Text('Compatible with Excel and Google Sheets', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                onTap: () async {
                  Navigator.pop(context);
                  await CsvService.instance.shareCsvExport();
                },
              ),
              const Divider(color: AppColors.darkDivider),
              ListTile(
                leading: const Icon(Icons.file_upload_rounded, color: AppColors.expense),
                title: const Text('Import Transactions from CSV', style: TextStyle(color: AppColors.textPrimaryDark)),
                subtitle: const Text('Add transactions from a CSV file', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
                  if (result != null && result.files.single.path != null) {
                    final content = await File(result.files.single.path!).readAsString();
                    final count = await CsvService.instance.importTransactionsFromCsv(content);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Successfully imported $count transactions!')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _MenuItem(
        icon: Icons.tune_rounded,
        title: 'Configuration',
        subtitle: 'Currency & Categories',
        color: AppColors.income,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfigurationScreen())),
      ),
      _MenuItem(
        icon: Icons.account_balance_wallet_rounded,
        title: 'Accounts',
        subtitle: 'Manage & Balance Sheet',
        color: AppColors.expense,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountsTabScreen())),
      ),
      _MenuItem(
        icon: Icons.fingerprint_rounded,
        title: 'Passcode & Lock',
        subtitle: 'Biometric Security',
        color: const Color(0xFF1DD1A1),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecuritySettingsScreen())),
      ),
      _MenuItem(
        icon: Icons.calculate_rounded,
        title: 'CalcBox',
        subtitle: 'Quick Calculator',
        color: const Color(0xFFFECA57),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalcBoxScreen())),
      ),
      _MenuItem(
        icon: Icons.cloud_sync_rounded,
        title: 'Backup & Sync',
        subtitle: 'Google Drive & Local',
        color: const Color(0xFF48DBFB),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BackupSyncScreen())),
      ),
      _MenuItem(
        icon: Icons.table_chart_rounded,
        title: 'Excel / CSV',
        subtitle: 'Export & Import',
        color: const Color(0xFF5F27CD),
        onTap: () => _handleCsvExportImport(context),
      ),
      _MenuItem(
        icon: Icons.info_outline_rounded,
        title: 'About App',
        subtitle: 'v${AppConstants.currentVersion} • Update Check',
        color: const Color(0xFFFF9FF3),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(title: const Text('More & Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 80),
        children: [
          // Grid Menu matching Realbyte Money Manager
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return Material(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item.icon, color: item.color, size: 22),
                        ),
                        const Spacer(),
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            color: AppColors.textSecondaryDark,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'Money Manager • High Performance Ledger\nOffline-First SQLite • Google Drive Sync',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMutedDark,
                fontSize: 11.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
