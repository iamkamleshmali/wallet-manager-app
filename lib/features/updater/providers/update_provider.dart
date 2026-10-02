import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/github_release_model.dart';
import '../services/github_update_service.dart';

enum UpdateStatus {
  idle,
  checking,
  updateAvailable,
  upToDate,
  downloading,
  downloaded,
  error,
}

class UpdateState {
  final UpdateStatus status;
  final GithubReleaseModel? release;
  final double downloadProgress; // 0.0 to 1.0
  final int bytesReceived;
  final int totalBytes;
  final String? downloadedFilePath;
  final String? errorMessage;

  const UpdateState({
    this.status = UpdateStatus.idle,
    this.release,
    this.downloadProgress = 0.0,
    this.bytesReceived = 0,
    this.totalBytes = 0,
    this.downloadedFilePath,
    this.errorMessage,
  });

  UpdateState copyWith({
    UpdateStatus? status,
    GithubReleaseModel? release,
    double? downloadProgress,
    int? bytesReceived,
    int? totalBytes,
    String? downloadedFilePath,
    String? errorMessage,
  }) {
    return UpdateState(
      status: status ?? this.status,
      release: release ?? this.release,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      bytesReceived: bytesReceived ?? this.bytesReceived,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class UpdateNotifier extends StateNotifier<UpdateState> {
  UpdateNotifier() : super(const UpdateState());

  Future<void> checkForUpdate() async {
    state = state.copyWith(status: UpdateStatus.checking);
    try {
      final release = await GithubUpdateService.instance.fetchLatestRelease();
      if (release != null) {
        final needsUpdate = await GithubUpdateService.instance.isUpdateAvailable(release);
        if (needsUpdate && release.apkDownloadUrl != null) {
          state = state.copyWith(
            status: UpdateStatus.updateAvailable,
            release: release,
          );
          return;
        }
      }
      state = state.copyWith(status: UpdateStatus.upToDate);
    } catch (e) {
      state = state.copyWith(
        status: UpdateStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> startDownloadAndInstall() async {
    final release = state.release;
    if (release == null || release.apkDownloadUrl == null) return;

    state = state.copyWith(
      status: UpdateStatus.downloading,
      downloadProgress: 0.0,
    );

    final filePath = await GithubUpdateService.instance.downloadApk(
      downloadUrl: release.apkDownloadUrl!,
      onProgress: (received, total) {
        if (total > 0) {
          final progress = received / total;
          state = state.copyWith(
            downloadProgress: progress,
            bytesReceived: received,
            totalBytes: total,
          );
        }
      },
    );

    if (filePath != null) {
      state = state.copyWith(
        status: UpdateStatus.downloaded,
        downloadedFilePath: filePath,
        downloadProgress: 1.0,
      );
      // Trigger package installer immediately
      await GithubUpdateService.instance.installApk(filePath);
    } else {
      state = state.copyWith(
        status: UpdateStatus.error,
        errorMessage: 'Failed to download APK. Check internet connection and retry.',
      );
    }
  }

  Future<void> installExistingDownload() async {
    if (state.downloadedFilePath != null) {
      await GithubUpdateService.instance.installApk(state.downloadedFilePath!);
    }
  }
}

final updateProvider = StateNotifierProvider<UpdateNotifier, UpdateState>((ref) {
  return UpdateNotifier();
});
