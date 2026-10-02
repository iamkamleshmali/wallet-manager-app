import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../database/app_database.dart';

class GoogleDriveBackupService {
  static final GoogleDriveBackupService instance = GoogleDriveBackupService._internal();
  GoogleDriveBackupService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveAppdataScope,
      drive.DriveApi.driveFileScope,
    ],
  );

  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount? get currentUser => _currentUser;

  Future<bool> init() async {
    try {
      _googleSignIn.onCurrentUserChanged.listen((account) {
        _currentUser = account;
      });
      _currentUser = await _googleSignIn.signInSilently();
      return _currentUser != null;
    } catch (e) {
      debugPrint('Google Drive Silent Sign In error: $e');
      return false;
    }
  }

  Future<GoogleSignInAccount?> signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      return _currentUser;
    } catch (e) {
      debugPrint('Google Drive Sign In error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
    } catch (e) {
      debugPrint('Google Drive Sign Out error: $e');
    }
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    if (_currentUser == null) {
      _currentUser = await signIn();
      if (_currentUser == null) return null;
    }
    final client = await _googleSignIn.authenticatedClient();
    if (client == null) return null;
    return drive.DriveApi(client);
  }

  Future<bool> uploadBackupToDrive() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return false;

      final dbPath = await AppDatabase.instance.getDatabasePath();
      final localFile = File(dbPath);
      if (!await localFile.exists()) return false;

      // Check if backup already exists in appDataFolder
      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name = '${AppConstants.googleDriveBackupFileName}' and trashed = false",
      );

      final media = drive.Media(localFile.openRead(), await localFile.length());

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        // Update existing file
        final existingFileId = fileList.files!.first.id!;
        final driveFile = drive.File();
        driveFile.description = 'Wallet Manager Auto-Backup ${DateTime.now().toIso8601String()}';
        await driveApi.files.update(
          driveFile,
          existingFileId,
          uploadMedia: media,
        );
      } else {
        // Create new backup file
        final driveFile = drive.File()
          ..name = AppConstants.googleDriveBackupFileName
          ..parents = ['appDataFolder']
          ..description = 'Wallet Manager Auto-Backup ${DateTime.now().toIso8601String()}';

        await driveApi.files.create(
          driveFile,
          uploadMedia: media,
        );
      }

      // Record last sync time
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.prefLastSyncTime, DateTime.now().toIso8601String());

      return true;
    } catch (e) {
      debugPrint('Google Drive Upload error: $e');
      return false;
    }
  }

  Future<bool> restoreBackupFromDrive() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return false;

      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name = '${AppConstants.googleDriveBackupFileName}' and trashed = false",
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        return false;
      }

      final fileId = fileList.files!.first.id!;
      final drive.Media downloaded = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final dbPath = await AppDatabase.instance.getDatabasePath();
      final destinationFile = File(dbPath);

      final List<int> dataStore = [];
      await downloaded.stream.forEach((data) {
        dataStore.addAll(data);
      });

      await destinationFile.writeAsBytes(dataStore, flush: true);
      return true;
    } catch (e) {
      debugPrint('Google Drive Restore error: $e');
      return false;
    }
  }

  Future<DateTime?> getLastBackupTimestamp() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return null;

      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name = '${AppConstants.googleDriveBackupFileName}' and trashed = false",
        $fields: 'files(id, name, modifiedTime)',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        return fileList.files!.first.modifiedTime;
      }
      return null;
    } catch (e) {
      debugPrint('Get backup timestamp error: $e');
      return null;
    }
  }
}
