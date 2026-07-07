import 'package:flutter/material.dart';

/// Centralized color palette for Dito Gym Tracker.
/// Dark, premium aesthetic inspired by Hevy / Strong / Alpha Progression.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceElevated = Color(0xFF262626);
  static const Color card = Color(0xFF1C1C1C);

  static const Color gold = Color(0xFFD4AF37);
  static const Color goldMuted = Color(0xFFB8974A);

  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textDisabled = Color(0xFF5C5C5C);

  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFE05353);
  static const Color info = Color(0xFF4FA9E0);

  static const Color divider = Color(0xFF2A2A2A);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE9C766), Color(0xFFD4AF37), Color(0xFFB8974A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
