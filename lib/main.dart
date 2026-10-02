import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/app_database.dart';
import 'core/services/auth_service.dart';
import 'core/services/google_drive_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/main_bottom_nav_scaffold.dart';
import 'features/security/screens/passcode_lock_screen.dart';
import 'features/security/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF26282E),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize SQLite database
  await AppDatabase.instance.database;

  // Initialize Google Drive silent sign-in
  await GoogleDriveBackupService.instance.init();

  // Initialize NotificationService & daily reminder
  await NotificationService.instance.init();

  runApp(
    const ProviderScope(
      child: WalletManagerApp(),
    ),
  );
}

class WalletManagerApp extends StatelessWidget {
  const WalletManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to Wallet Manager Dark Theme
      home: const SplashScreen(),
    );
  }
}
