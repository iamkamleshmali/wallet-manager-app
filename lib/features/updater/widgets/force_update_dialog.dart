import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../models/github_release_model.dart';
import '../providers/update_provider.dart';

class ForceUpdateDialog extends ConsumerWidget {
  final GithubReleaseModel release;

  const ForceUpdateDialog({
    super.key,
    required this.release,
  });

  static Future<void> show(BuildContext context, GithubReleaseModel release) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => ForceUpdateDialog(release: release),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 MB';
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }

  Future<void> _launchApkDownload(BuildContext context) async {
    final apkUrl = release.apkDownloadUrl ??
        'https://github.com/${AppConstants.githubOwner}/${AppConstants.githubRepo}/releases/latest';
    final uri = Uri.tryParse(apkUrl);
    if (uri != null) {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open download URL.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateState = ref.watch(updateProvider);

    return PopScope(
      canPop: false, // Prevents Android back button from closing dialog
      child: Dialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon Header
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.expense.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.expense.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(
                    Icons.system_update_rounded,
                    color: AppColors.expense,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Update Required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 8),

              // Version Tags
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.darkCardElevated,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'v${AppConstants.currentVersion}',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.textMutedDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.expense.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      release.tagName,
                      style: const TextStyle(
                        color: AppColors.expense,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Release Notes / Changelog
              const Text(
                "What's New:",
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                constraints: const BoxConstraints(maxHeight: 140),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.darkBackgroundDeep,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    release.body.isNotEmpty ? release.body : 'Minor bug fixes & performance enhancements.',
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Progress Bar if downloading
              if (updateState.status == UpdateStatus.downloading) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Downloading update...',
                      style: TextStyle(color: AppColors.expenseLight, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${(updateState.downloadProgress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: updateState.downloadProgress > 0 ? updateState.downloadProgress : null,
                    minHeight: 8,
                    backgroundColor: AppColors.darkBackgroundDeep,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.expense),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    '${_formatBytes(updateState.bytesReceived)} / ${_formatBytes(updateState.totalBytes)}',
                    style: const TextStyle(color: AppColors.textMutedDark, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Error display
              if (updateState.status == UpdateStatus.error && updateState.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.expense.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    updateState.errorMessage!,
                    style: const TextStyle(color: AppColors.expense, fontSize: 11.5),
                  ),
                ),
              ],

              // Action Button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.expense,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    _launchApkDownload(context);
                  },
                  child: const Text(
                    'Update Now',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                'Please update to continue using Wallet Manager seamlessly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMutedDark,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
