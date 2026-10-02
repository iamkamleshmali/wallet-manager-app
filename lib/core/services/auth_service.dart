import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _keyPinHash = 'user_pin_hash_v2';
  static const String _keyPinSalt = 'user_pin_salt_v2';
  static const String _legacyPinKey = 'user_pin_hash';

  Future<bool> isBiometricAvailable() async {
    try {
      final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics({String reason = 'Authenticate to access Wallet Manager'}) async {
    try {
      final available = await isBiometricAvailable();
      if (!available) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isPasscodeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefPasscodeEnabled) ?? false;
  }

  Future<void> setPasscodeEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefPasscodeEnabled, enabled);
  }

  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefBiometricEnabled) ?? false;
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefBiometricEnabled, enabled);
  }

  String _hashPinWithSalt(String pin, String salt) {
    final bytes = utf8.encode('$salt:$pin:$salt');
    return sha256.convert(bytes).toString();
  }

  String _generateSalt([int length = 16]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  Future<void> savePin(String pin) async {
    final salt = _generateSalt();
    final hash = _hashPinWithSalt(pin, salt);

    // Save in secure storage
    await _secureStorage.write(key: _keyPinSalt, value: salt);
    await _secureStorage.write(key: _keyPinHash, value: hash);

    // Clean up legacy plaintext key from SharedPreferences if present
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_legacyPinKey);
  }

  Future<bool> verifyPin(String enteredPin) async {
    // 1. Try secure salted hash verification
    final salt = await _secureStorage.read(key: _keyPinSalt);
    final hash = await _secureStorage.read(key: _keyPinHash);

    if (salt != null && hash != null) {
      final calculated = _hashPinWithSalt(enteredPin, salt);
      return calculated == hash;
    }

    // 2. Backward compatibility migration path for legacy plaintext PIN
    final prefs = await SharedPreferences.getInstance();
    final legacyPin = prefs.getString(_legacyPinKey);
    if (legacyPin != null && legacyPin.isNotEmpty) {
      if (legacyPin == enteredPin) {
        // Upgrade legacy PIN immediately to salted secure storage
        await savePin(enteredPin);
        return true;
      }
    }

    return false;
  }

  Future<bool> hasPin() async {
    final hash = await _secureStorage.read(key: _keyPinHash);
    if (hash != null && hash.isNotEmpty) return true;

    final prefs = await SharedPreferences.getInstance();
    final legacyPin = prefs.getString(_legacyPinKey);
    return legacyPin != null && legacyPin.isNotEmpty;
  }
}
