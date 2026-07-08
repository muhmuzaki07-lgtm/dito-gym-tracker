import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'data/models/workout_models.dart';
import 'data/repositories/workout_repository.dart';
import 'presentation/providers/providers.dart';
import 'presentation/providers/personalization_providers.dart';
import 'presentation/screens/lock/lock_screen.dart';
import 'presentation/widgets/main_nav_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  registerHiveAdapters();

  final sessionsBox = await Hive.openBox<WorkoutSession>(HiveBoxes.sessions);
  final weightsBox = await Hive.openBox<WeightEntry>(HiveBoxes.weights);
  final nutritionBox = await Hive.openBox<NutritionProfile>(HiveBoxes.nutrition);
  final waterBox = await Hive.openBox<WaterIntake>(HiveBoxes.water);
  final settingsBox = await Hive.openBox<AppSettings>(HiveBoxes.settings);

  final repository = WorkoutRepository(
    sessionsBox: sessionsBox,
    weightsBox: weightsBox,
    nutritionBox: nutritionBox,
    waterBox: waterBox,
    settingsBox: settingsBox,
  );

  // Notifications are best-effort: if the platform channel isn't ready
  // (e.g. first run before permissions), we don't want to block startup.
  try {
    await NotificationService.instance.init();
  } catch (_) {
    // Ignore — reminders can be re-enabled from Settings once permissions
    // are granted.
  }

  runApp(
    ProviderScope(
      overrides: [
        workoutRepositoryProvider.overrideWithValue(repository),
        // App starts locked if a PIN has been configured.
        isAppLockedProvider.overrideWith((ref) => repository.settings().pinEnabled),
      ],
      child: const DitoGymTrackerApp(),
    ),
  );
}

class DitoGymTrackerApp extends ConsumerWidget {
  const DitoGymTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preset = ref.watch(currentThemePresetProvider);
    final isLocked = ref.watch(isAppLockedProvider);
    final themeData = AppTheme.build(preset);

    return MaterialApp(
      title: 'Dito Gym Tracker',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      darkTheme: themeData,
      themeMode: ThemeMode.dark,
      home: isLocked ? const LockScreen() : const MainNavShell(),
    );
  }
}
