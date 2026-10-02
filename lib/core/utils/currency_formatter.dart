import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(
    double amount, {
    String symbol = '₹',
    bool showSign = false,
    bool compact = false,
    int decimalDigits = 2,
  }) {
    final absAmount = amount.abs();
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimalDigits,
    );

    String formattedNumber = formatter.format(absAmount);
    
    // Trim trailing .00 if needed for cleaner look when zero cents
    if (formattedNumber.endsWith('.00')) {
      formattedNumber = formattedNumber.substring(0, formattedNumber.length - 3);
    }

    if (showSign) {
      if (amount > 0) {
        return '+$symbol$formattedNumber';
      } else if (amount < 0) {
        return '-$symbol$formattedNumber';
      }
    }

    if (amount < 0) {
      return '-$symbol$formattedNumber';
    }
    return '$symbol$formattedNumber';
  }

  static String formatCompact(double amount, {String symbol = '₹'}) {
    final abs = amount.abs();
    String formatted;
    if (abs >= 10000000) {
      formatted = '${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (abs >= 100000) {
      formatted = '${(amount / 100000).toStringAsFixed(2)} L';
    } else if (abs >= 1000) {
      formatted = '${(amount / 1000).toStringAsFixed(1)} k';
    } else {
      formatted = amount.toStringAsFixed(0);
    }
    return '$symbol$formatted';
  }
}
