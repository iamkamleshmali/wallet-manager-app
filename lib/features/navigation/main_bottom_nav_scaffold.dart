import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../accounts/screens/accounts_tab_screen.dart';
import '../settings/screens/more_tab_screen.dart';
import '../stats/screens/stats_tab_screen.dart';
import '../transactions/screens/transactions_tab_screen.dart';
import '../updater/services/github_update_service.dart';
import '../updater/widgets/force_update_dialog.dart';

class MainBottomNavScaffold extends ConsumerStatefulWidget {
  const MainBottomNavScaffold({super.key});

  @override
  ConsumerState<MainBottomNavScaffold> createState() => _MainBottomNavScaffoldState();
}

class _MainBottomNavScaffoldState extends ConsumerState<MainBottomNavScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TransactionsTabScreen(),
    StatsTabScreen(),
    AccountsTabScreen(),
    MoreTabScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // GitHub OTA In-App Force-Update check on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkGithubReleaseUpdate();
    });
  }

  Future<void> _checkGithubReleaseUpdate() async {
    try {
      final release = await GithubUpdateService.instance.fetchLatestRelease();
      if (release != null) {
        final needsUpdate = await GithubUpdateService.instance.isUpdateAvailable(release);
        if (needsUpdate && release.apkDownloadUrl != null && mounted) {
          ForceUpdateDialog.show(context, release);
        }
      }
    } catch (_) {
      // Graceful silent error handling if offline
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.darkCard,
          border: Border(
            top: BorderSide(color: AppColors.darkBorder, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: AppColors.darkCard,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.expense,
          unselectedItemColor: AppColors.textSecondaryDark,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Icon(Icons.receipt_long_rounded, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Icon(Icons.receipt_long_rounded, size: 24),
              ),
              label: 'Trans.',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Icon(Icons.pie_chart_outline_rounded, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Icon(Icons.pie_chart_rounded, size: 24),
              ),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Icon(Icons.account_balance_wallet_outlined, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Icon(Icons.account_balance_wallet_rounded, size: 24),
              ),
              label: 'Accounts',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Icon(Icons.more_horiz_rounded, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Icon(Icons.more_horiz_rounded, size: 24),
              ),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
