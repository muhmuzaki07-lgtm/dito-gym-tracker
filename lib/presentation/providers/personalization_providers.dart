import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/equipment.dart';
import '../../core/theme/theme_presets.dart';
import 'providers.dart';

/// The set of equipment the user has marked as available in their gym.
final availableEquipmentProvider = Provider<Set<Equipment>>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.availableEquipment
      .map((name) => Equipment.values.where((e) => e.name == name))
      .expand((e) => e)
      .toSet();
});

/// The currently selected theme preset.
final currentThemePresetProvider = Provider<ThemePreset>((ref) {
  final settings = ref.watch(appSettingsProvider);
  final id = AppThemeIdName.fromStorageKey(settings.themeId);
  return ThemePresets.all[id]!;
});

/// Whether the app should currently show the lock screen. Starts true if
/// a PIN is configured; set to false once the person unlocks for this
/// app session (re-locks on next cold start).
final isAppLockedProvider = StateProvider<bool>((ref) => false);
