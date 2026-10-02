class AppConstants {
  static const String appName = 'Money Manager';
  static const String currentVersion = '1.0.1';
  static const int currentVersionCode = 2;

  // GitHub OTA In-App Update Configuration
  static const String githubOwner = 'iamkamleshmali';
  static const String githubRepo = 'wallet-manager-app';
  static const String githubLatestReleaseUrl =
      'https://api.github.com/repos/$githubOwner/$githubRepo/releases/latest';

  // Database
  static const String databaseName = 'money_manager_km.db';
  static const int databaseVersion = 1;

  // Google Drive AppData
  static const String googleDriveBackupFileName = 'money_manager_backup.sqlite';
  static const String googleDriveBackupFolder = 'appDataFolder';

  // Default Preferences Keys
  static const String prefCurrencySymbol = 'pref_currency_symbol';
  static const String prefPasscodeEnabled = 'pref_passcode_enabled';
  static const String prefBiometricEnabled = 'pref_biometric_enabled';
  static const String prefAutoSyncEnabled = 'pref_auto_sync_enabled';
  static const String prefAutoSyncFrequency = 'pref_auto_sync_frequency'; // 'daily' or 'weekly'
  static const String prefLastSyncTime = 'pref_last_sync_time';
  static const String prefIsDarkMode = 'pref_is_dark_mode';
}
