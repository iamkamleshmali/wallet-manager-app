import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _isPasscodeEnabled = false;
  bool _isBiometricEnabled = false;
  bool _hasBiometrics = false;
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final pass = await AuthService.instance.isPasscodeEnabled();
    final bio = await AuthService.instance.isBiometricEnabled();
    final avail = await AuthService.instance.isBiometricAvailable();

    setState(() {
      _isPasscodeEnabled = pass;
      _isBiometricEnabled = bio;
      _hasBiometrics = avail;
    });
  }

  void _showSetPinDialog() {
    _pinController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text('Set 4-Digit Passcode'),
        content: TextField(
          controller: _pinController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
          style: const TextStyle(letterSpacing: 16, fontSize: 24, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
          decoration: const InputDecoration(counterText: ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.expense),
            onPressed: () async {
              if (_pinController.text.length == 4) {
                await AuthService.instance.savePin(_pinController.text);
                await AuthService.instance.setPasscodeEnabled(true);
                setState(() => _isPasscodeEnabled = true);
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(title: const Text('Security & Lock')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Passcode Protection', style: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Require 4-digit PIN to open app', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                  value: _isPasscodeEnabled,
                  activeColor: AppColors.expense,
                  onChanged: (val) async {
                    if (val) {
                      _showSetPinDialog();
                    } else {
                      await AuthService.instance.setPasscodeEnabled(false);
                      setState(() => _isPasscodeEnabled = false);
                    }
                  },
                ),
                if (_isPasscodeEnabled) ...[
                  const Divider(color: AppColors.darkDivider),
                  ListTile(
                    title: const Text('Change Passcode', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 14)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondaryDark),
                    onTap: _showSetPinDialog,
                  ),
                ],
                const Divider(color: AppColors.darkDivider),
                SwitchListTile(
                  title: const Text('Biometric Authentication', style: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    _hasBiometrics ? 'Use Fingerprint or Face ID' : 'Biometrics not available on this device',
                    style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                  ),
                  value: _isBiometricEnabled && _hasBiometrics,
                  activeColor: AppColors.income,
                  onChanged: _hasBiometrics
                      ? (val) async {
                          if (val) {
                            final success = await AuthService.instance.authenticateWithBiometrics(
                              reason: 'Verify identity to enable biometrics',
                            );
                            if (success) {
                              await AuthService.instance.setBiometricEnabled(true);
                              setState(() => _isBiometricEnabled = true);
                            }
                          } else {
                            await AuthService.instance.setBiometricEnabled(false);
                            setState(() => _isBiometricEnabled = false);
                          }
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
