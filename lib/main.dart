import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/app_database.dart';
import 'core/services/auth_service.dart';
import 'core/services/google_drive_service.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/main_bottom_nav_scaffold.dart';
import 'features/security/screens/passcode_lock_screen.dart';

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

  runApp(
    const ProviderScope(
      child: WalletManagerApp(),
    ),
  );
}

class WalletManagerApp extends StatefulWidget {
  const WalletManagerApp({super.key});

  @override
  State<WalletManagerApp> createState() => _WalletManagerAppState();
}

class _WalletManagerAppState extends State<WalletManagerApp> {
  bool _isLocked = false;
  bool _isCheckingLock = true;

  @override
  void initState() {
    super.initState();
    _checkSecurityLock();
  }

  Future<void> _checkSecurityLock() async {
    final passcodeEnabled = await AuthService.instance.isPasscodeEnabled();
    final hasPin = await AuthService.instance.hasPin();
    final biometricEnabled = await AuthService.instance.isBiometricEnabled();
    final hasBio = await AuthService.instance.isBiometricAvailable();

    final requiresLock = (passcodeEnabled && hasPin) || (biometricEnabled && hasBio);

    setState(() {
      _isLocked = requiresLock;
      _isCheckingLock = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to Realbyte Money Manager Dark Theme
      home: _isCheckingLock
          ? const Scaffold(
              backgroundColor: Color(0xFF1E2024),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFFF5E57)),
              ),
            )
          : _isLocked
              ? PasscodeLockScreen(
                  onUnlocked: () {
                    setState(() {
                      _isLocked = false;
                    });
                  },
                )
              : const MainBottomNavScaffold(),
    );
  }
}
