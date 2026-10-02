import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constants/app_constants.dart';
import '../models/github_release_model.dart';

class GithubUpdateService {
  static final GithubUpdateService instance = GithubUpdateService._internal();
  GithubUpdateService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'WalletManager-Updater',
      },
    ),
  );

  CancelToken? _downloadCancelToken;

  /// Fetches the latest release from GitHub API.
  Future<GithubReleaseModel?> fetchLatestRelease() async {
    try {
      final response = await _dio.get(AppConstants.githubLatestReleaseUrl);
      if (response.statusCode == 200 && response.data != null) {
        return GithubReleaseModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Failed to fetch GitHub release: $e');
      return null;
    }
  }

  /// Compares local version with remote release tag and returns true if an update is required.
  Future<bool> isUpdateAvailable(GithubReleaseModel release) async {
    try {
      String localVersion = AppConstants.currentVersion;
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        localVersion = packageInfo.version;
      } catch (_) {
        // Fallback to constant
      }

      final remoteVersion = release.cleanVersion;
      return _isRemoteVersionHigher(localVersion, remoteVersion);
    } catch (e) {
      debugPrint('Version comparison error: $e');
      return false;
    }
  }

  bool _isRemoteVersionHigher(String local, String remote) {
    try {
      // Remove any trailing build numbers like +1 or -beta
      final cleanLocal = local.split('+').first.split('-').first.trim();
      final cleanRemote = remote.split('+').first.split('-').first.trim();

      final localParts = cleanLocal.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final remoteParts = cleanRemote.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      while (localParts.length < 3) localParts.add(0);
      while (remoteParts.length < 3) remoteParts.add(0);

      for (int i = 0; i < 3; i++) {
        if (remoteParts[i] > localParts[i]) return true;
        if (remoteParts[i] < localParts[i]) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Downloads the release APK with real-time byte progress.
  Future<String?> downloadApk({
    required String downloadUrl,
    required void Function(int received, int total) onProgress,
  }) async {
    try {
      _downloadCancelToken = CancelToken();

      Directory? saveDir;
      if (Platform.isAndroid) {
        // Use external cache or application support for Android Package Installer access
        saveDir = await getExternalStorageDirectory() ?? await getApplicationSupportDirectory();
      } else {
        saveDir = await getTemporaryDirectory();
      }

      final filePath = '${saveDir.path}/wallet_manager_latest.apk';
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }

      final response = await _dio.download(
        downloadUrl,
        filePath,
        cancelToken: _downloadCancelToken,
        onReceiveProgress: onProgress,
      );

      if (response.statusCode == 200) {
        return filePath;
      }
      return null;
    } catch (e) {
      debugPrint('Error downloading APK: $e');
      return null;
    }
  }

  void cancelDownload() {
    _downloadCancelToken?.cancel('Cancelled by user');
  }

  /// Requests package installation permission and launches Android Package Installer.
  Future<bool> installApk(String filePath) async {
    try {
      if (Platform.isAndroid) {
        final installPermission = await Permission.requestInstallPackages.status;
        if (!installPermission.isGranted) {
          final requested = await Permission.requestInstallPackages.request();
          if (!requested.isGranted) {
            // User did not grant install permission
            return false;
          }
        }
      }

      final result = await OpenFilex.open(
        filePath,
        type: 'application/vnd.android.package-archive',
      );

      return result.type == ResultType.done;
    } catch (e) {
      debugPrint('Failed to trigger package installer: $e');
      return false;
    }
  }
}
