import 'package:flutter/material.dart';

class AppColors {
  // Dark Mode Theme (Wallet Manager Aesthetic)
  static const Color darkBackground = Color(0xFF1E2024);
  static const Color darkBackgroundDeep = Color(0xFF18191C);
  static const Color darkCard = Color(0xFF26282E);
  static const Color darkCardElevated = Color(0xFF2C2F36);
  static const Color darkBorder = Color(0xFF33363F);
  static const Color darkDivider = Color(0xFF2A2D35);

  // Light Mode Theme Alternative
  static const Color lightBackground = Color(0xFFF3F5F9);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E6EF);
  static const Color lightDivider = Color(0xFFE9ECF3);

  // Financial Semantics
  static const Color expense = Color(0xFFFF5E57); // Coral Red / Salmon Pink
  static const Color expenseLight = Color(0xFFFF6B6B);
  static const Color expenseDim = Color(0x26FF5E57);

  static const Color income = Color(0xFF2E86DE); // Vibrant Financial Blue
  static const Color incomeLight = Color(0xFF54A0FF);
  static const Color incomeDim = Color(0x262E86DE);

  static const Color transfer = Color(0xFF8C7AE6); // Purple/Violet
  static const Color transferDim = Color(0x268C7AE6);

  static const Color asset = Color(0xFF2E86DE);
  static const Color liability = Color(0xFFFF5E57);
  static const Color netWorth = Color(0xFF1DD1A1);

  // Text & Icons
  static const Color textPrimaryDark = Color(0xFFF5F6FB);
  static const Color textSecondaryDark = Color(0xFF8E95A5);
  static const Color textMutedDark = Color(0xFF5C6272);

  static const Color textPrimaryLight = Color(0xFF14171F);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textMutedLight = Color(0xFF9CA3AF);

  // Badge indicators
  static const Color sundayBadge = Color(0xFFFF5E57);
  static const Color saturdayBadge = Color(0xFF2E86DE);

  // Category Colors Palette
  static const List<Color> categoryPalette = [
    Color(0xFFFF5E57), // Food / Dining
    Color(0xFFFECA57), // Shopping
    Color(0xFF48DBFB), // Transport
    Color(0xFF1DD1A1), // Salary / Income
    Color(0xFF5f27cd), // Entertainment
    Color(0xFFFF9FF3), // Health / Medical
    Color(0xFF00D2D3), // Bills / Utilities
    Color(0xFF54A0FF), // Education
    Color(0xFFFF6B6B), // Housing / Rent
    Color(0xFFC8D6E5), // Other
  ];
}
