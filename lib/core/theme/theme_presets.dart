import 'package:flutter/material.dart';

enum AppThemeId {
  blackGold,
  amoledBlack,
  titanium,
  midnightBlue,
  emeraldGreen,
  crimsonRed,
  purpleNeon,
}

extension AppThemeIdName on AppThemeId {
  /// Stable string key used for persistence in Hive (enum index isn't
  /// stable across code changes, so we store this instead).
  String get storageKey => toString().split('.').last;

  static AppThemeId fromStorageKey(String key) {
    return AppThemeId.values.firstWhere(
      (e) => e.storageKey == key,
      orElse: () => AppThemeId.blackGold,
    );
  }
}

class ThemePreset {
  final String label;
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color card;
  final Color accent;

  const ThemePreset({
    required this.label,
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.card,
    required this.accent,
  });
}

class ThemePresets {
  ThemePresets._();

  static const Map<AppThemeId, ThemePreset> all = {
    AppThemeId.blackGold: ThemePreset(
      label: 'Black Gold',
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      surfaceElevated: Color(0xFF262626),
      card: Color(0xFF1C1C1C),
      accent: Color(0xFFD4AF37),
    ),
    AppThemeId.amoledBlack: ThemePreset(
      label: 'AMOLED Black',
      background: Color(0xFF000000),
      surface: Color(0xFF0C0C0C),
      surfaceElevated: Color(0xFF181818),
      card: Color(0xFF0A0A0A),
      accent: Color(0xFFE0E0E0),
    ),
    AppThemeId.titanium: ThemePreset(
      label: 'Titanium',
      background: Color(0xFF17181A),
      surface: Color(0xFF212327),
      surfaceElevated: Color(0xFF2B2E33),
      card: Color(0xFF1D1F22),
      accent: Color(0xFF9AA5B1),
    ),
    AppThemeId.midnightBlue: ThemePreset(
      label: 'Midnight Blue',
      background: Color(0xFF0B1220),
      surface: Color(0xFF141C2E),
      surfaceElevated: Color(0xFF1C2740),
      card: Color(0xFF121A2C),
      accent: Color(0xFF4C8DFF),
    ),
    AppThemeId.emeraldGreen: ThemePreset(
      label: 'Emerald Green',
      background: Color(0xFF0E1712),
      surface: Color(0xFF16211A),
      surfaceElevated: Color(0xFF1E2C23),
      card: Color(0xFF141F19),
      accent: Color(0xFF2ECC71),
    ),
    AppThemeId.crimsonRed: ThemePreset(
      label: 'Crimson Red',
      background: Color(0xFF190E10),
      surface: Color(0xFF241417),
      surfaceElevated: Color(0xFF301A1E),
      card: Color(0xFF201113),
      accent: Color(0xFFE0344B),
    ),
    AppThemeId.purpleNeon: ThemePreset(
      label: 'Purple Neon',
      background: Color(0xFF130B1F),
      surface: Color(0xFF1E1230),
      surfaceElevated: Color(0xFF2A1A40),
      card: Color(0xFF190F28),
      accent: Color(0xFFB14EFF),
    ),
  };
}
