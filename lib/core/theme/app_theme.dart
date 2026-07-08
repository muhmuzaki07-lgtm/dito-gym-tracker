import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'theme_presets.dart';

/// Material 3 dark theme used across the whole app.
/// Rounded corners (20dp), gold accent by default, dynamic per preset.
class AppTheme {
  AppTheme._();

  static const double radius = 20;

  /// Default theme (Black Gold), kept for any code path that hasn't been
  /// migrated to the dynamic theme provider.
  static ThemeData get dark => build(ThemePresets.all[AppThemeId.blackGold]!);

  /// Builds a full ThemeData from a given color preset. Scaffold, AppBar,
  /// Card, NavigationBar, and buttons all follow the preset; some custom
  /// widgets that reference [AppColors] directly keep their original
  /// accent for now (a full per-widget re-theme is a larger follow-up).
  static ThemeData build(ThemePreset preset) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: preset.background,
      colorScheme: ColorScheme.dark(
        primary: preset.accent,
        secondary: preset.accent,
        surface: preset.surface,
        error: AppColors.danger,
        onPrimary: Colors.black,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: preset.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: preset.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: preset.surface,
        indicatorColor: preset.accent.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? preset.accent : AppColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? preset.accent : AppColors.textSecondary,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: preset.accent,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: preset.accent,
          side: BorderSide(color: preset.accent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: preset.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? preset.accent
              : AppColors.textSecondary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? preset.accent.withValues(alpha: 0.4)
              : preset.surfaceElevated,
        ),
      ),
    );
  }
}
