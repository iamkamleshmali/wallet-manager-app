import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../updater/providers/update_provider.dart';
import '../../updater/services/github_update_service.dart';
import '../../updater/widgets/force_update_dialog.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  bool _isChecking = false;
  String? _statusMessage;

  Future<void> _checkForUpdates() async {
    setState(() {
      _isChecking = true;
      _statusMessage = null;
    });

    try {
      final release = await GithubUpdateService.instance.fetchLatestRelease();
      if (release != null) {
        final needsUpdate = await GithubUpdateService.instance.isUpdateAvailable(release);
        if (needsUpdate && release.apkDownloadUrl != null) {
          if (mounted) {
            ForceUpdateDialog.show(context, release);
          }
          return;
        }
      }
      setState(() {
        _statusMessage = 'You are using the latest version (${AppConstants.currentVersion})!';
      });
    } catch (_) {
      setState(() {
        _statusMessage = 'Could not check for updates. Please check internet connection.';
      });
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(title: const Text('About & Version')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.expense,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.expense.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 44),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Money Manager',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'Version 1.0.1 (Build 2)',
              style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
            ),
          ),
          const SizedBox(height: 32),

          // GitHub OTA In-App Updater Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Icon(Icons.system_update_rounded, color: AppColors.expense, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'GitHub Releases OTA Updates',
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
                  'Checks for official GitHub release APKs directly on GitHub without Google Play Store.',
                  style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                ),
                const SizedBox(height: 16),
                if (_statusMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.darkCardElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Text(
                      _statusMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.netWorth, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.expense,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isChecking ? null : _checkForUpdates,
                  child: _isChecking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                        )
                      : const Text('Check for Updates Now', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Repository & Architecture Information
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Developer & Architecture', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('• Developer: Kamlesh Mali (@iamkamleshmali)', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12.5)),
                SizedBox(height: 4),
                Text('• Architecture: Offline-First SQLite Ledger (Double-Entry)', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12.5)),
                SizedBox(height: 4),
                Text('• State Engine: Flutter Riverpod', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12.5)),
                SizedBox(height: 4),
                Text('• Cloud Sync: Google Drive AppData Integration', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12.5)),
                SizedBox(height: 4),
                Text('• OTA Engine: Direct In-App APK Force-Update', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
