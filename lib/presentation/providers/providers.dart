import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/workout_models.dart';
import '../../data/repositories/workout_repository.dart';

/// Provided in main() once Hive boxes are opened, via ProviderScope overrides.
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  throw UnimplementedError('workoutRepositoryProvider must be overridden in main()');
});

/// Bumping this notifier's value triggers dependents to refresh after any
/// write to Hive (since Hive boxes themselves aren't reactively watched here).
final dataRevisionProvider = StateProvider<int>((ref) => 0);

final allSessionsProvider = Provider<List<WorkoutSession>>((ref) {
  ref.watch(dataRevisionProvider);
  return ref.watch(workoutRepositoryProvider).allSessions();
});

final currentStreakProvider = Provider<int>((ref) {
  ref.watch(dataRevisionProvider);
  return ref.watch(workoutRepositoryProvider).currentStreak();
});

final latestWeightProvider = Provider<WeightEntry?>((ref) {
  ref.watch(dataRevisionProvider);
  return ref.watch(workoutRepositoryProvider).latestWeight();
});

final allWeightsProvider = Provider<List<WeightEntry>>((ref) {
  ref.watch(dataRevisionProvider);
  return ref.watch(workoutRepositoryProvider).allWeights();
});

final nutritionProfileProvider = Provider<NutritionProfile>((ref) {
  ref.watch(dataRevisionProvider);
  return ref.watch(workoutRepositoryProvider).nutritionProfile();
});

final todayWaterProvider = Provider<int>((ref) {
  ref.watch(dataRevisionProvider);
  return ref.watch(workoutRepositoryProvider).todayWaterMl();
});

final appSettingsProvider = Provider<AppSettings>((ref) {
  ref.watch(dataRevisionProvider);
  return ref.watch(workoutRepositoryProvider).settings();
});

/// Bottom navigation currently-selected tab index.
final navIndexProvider = StateProvider<int>((ref) => 0);

/// Helper for screens (ConsumerWidget/ConsumerState) to call after any Hive
/// write, so dependent providers recompute and the UI refreshes.
void notifyDataChanged(WidgetRef ref) {
  ref.read(dataRevisionProvider.notifier).state++;
}
