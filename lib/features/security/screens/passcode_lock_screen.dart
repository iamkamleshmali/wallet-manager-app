import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';

class PasscodeLockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;

  const PasscodeLockScreen({super.key, required this.onUnlocked});

  @override
  State<PasscodeLockScreen> createState() => _PasscodeLockScreenState();
}

class _PasscodeLockScreenState extends State<PasscodeLockScreen> {
  String _enteredPin = '';
  bool _isError = false;
  bool _canUseBiometrics = false;

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    final bioEnabled = await AuthService.instance.isBiometricEnabled();
    final bioAvail = await AuthService.instance.isBiometricAvailable();
    if (mounted) {
      setState(() {
        _canUseBiometrics = bioEnabled && bioAvail;
      });
    }
    if (bioEnabled && bioAvail) {
      await _tryBiometrics();
    }
  }

  Future<void> _tryBiometrics() async {
    final success = await AuthService.instance.authenticateWithBiometrics(
      reason: 'Authenticate to open Wallet Manager',
    );
    if (success && mounted) {
      widget.onUnlocked();
    }
  }

  void _onKeyPress(String key) async {
    if (_enteredPin.length >= 4) return;

    setState(() {
      _isError = false;
      _enteredPin += key;
    });

    if (_enteredPin.length == 4) {
      final valid = await AuthService.instance.verifyPin(_enteredPin);
      if (valid) {
        widget.onUnlocked();
      } else {
        setState(() {
          _isError = true;
          _enteredPin = '';
        });
      }
    }
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _isError = false;
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: const Icon(Icons.lock_rounded, color: AppColors.expense, size: 32),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter Passcode',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isError ? 'Incorrect passcode. Try again.' : 'Wallet Manager is locked',
              style: TextStyle(
                color: _isError ? AppColors.expense : AppColors.textSecondaryDark,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 28),

            // PIN Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _enteredPin.length;
                return Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? AppColors.expense : Colors.transparent,
                    border: Border.all(
                      color: isFilled ? AppColors.expense : AppColors.darkBorder,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            const Spacer(),

            // Keypad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  _buildKeypadRow(['1', '2', '3']),
                  const SizedBox(height: 16),
                  _buildKeypadRow(['4', '5', '6']),
                  const SizedBox(height: 16),
                  _buildKeypadRow(['7', '8', '9']),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Biometric button
                      _canUseBiometrics
                          ? IconButton(
                              icon: const Icon(Icons.fingerprint_rounded, size: 32, color: AppColors.income),
                              onPressed: _tryBiometrics,
                            )
                          : const SizedBox(width: 48, height: 48),
                      _buildKeyButton('0'),
                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.backspace_rounded, size: 28, color: AppColors.textSecondaryDark),
                        onPressed: _onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((k) => _buildKeyButton(k)).toList(),
    );
  }

  Widget _buildKeyButton(String key) {
    return InkWell(
      onTap: () => _onKeyPress(key),
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.darkBorder),
        ),
        alignment: Alignment.center,
        child: Text(
          key,
          style: const TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            fontFamily: 'Sora',
          ),
        ),
      ),
    );
  }
}
