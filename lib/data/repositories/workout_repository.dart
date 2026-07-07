import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/workout_models.dart';

/// Single point of access to all local (Hive) data.
/// Keeps UI/providers decoupled from raw box calls (Clean Architecture).
class WorkoutRepository {
  final Box<WorkoutSession> _sessionsBox;
  final Box<WeightEntry> _weightsBox;
  final Box<NutritionProfile> _nutritionBox;
  final Box<WaterIntake> _waterBox;
  final Box<AppSettings> _settingsBox;
  final _uuid = const Uuid();

  WorkoutRepository({
    required Box<WorkoutSession> sessionsBox,
    required Box<WeightEntry> weightsBox,
    required Box<NutritionProfile> nutritionBox,
    required Box<WaterIntake> waterBox,
    required Box<AppSettings> settingsBox,
  })  : _sessionsBox = sessionsBox,
        _weightsBox = weightsBox,
        _nutritionBox = nutritionBox,
        _waterBox = waterBox,
        _settingsBox = settingsBox;

  // ---------------- Workout Sessions ----------------

  List<WorkoutSession> allSessions() =>
      _sessionsBox.values.toList()..sort((a, b) => b.date.compareTo(a.date));

  List<WorkoutSession> finishedSessions() =>
      allSessions().where((s) => s.finished).toList();

  WorkoutSession createSession(String dayName) {
    final session = WorkoutSession(
      id: _uuid.v4(),
      date: DateTime.now(),
      dayName: dayName,
    );
    _sessionsBox.put(session.id, session);
    return session;
  }

  Future<void> saveSession(WorkoutSession session) async {
    await session.save();
  }

  /// Finds the most recent finished log of a specific exercise, useful for
  /// progressive overload comparisons.
  ExerciseLog? lastExerciseLog(String exerciseName) {
    final sessions = finishedSessions();
    for (final session in sessions) {
      for (final ex in session.exercises) {
        if (ex.exerciseName == exerciseName &&
            ex.sets.any((s) => s.completed)) {
          return ex;
        }
      }
    }
    return null;
  }

  int currentStreak() {
    final sessions = finishedSessions();
    if (sessions.isEmpty) return 0;
    int streak = 0;
    DateTime cursor = DateTime.now();
    final dates = sessions.map((s) => DateTime(s.date.year, s.date.month, s.date.day)).toSet();

    // Walk backwards day by day; a "streak" here counts consecutive
    // calendar days (including rest days) since the last workout, capped
    // by consecutive training days logged.
    for (int i = 0; i < 400; i++) {
      final day = DateTime(cursor.year, cursor.month, cursor.day - i);
      if (dates.contains(day)) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }
    return streak;
  }

  // ---------------- Weight ----------------

  List<WeightEntry> allWeights() =>
      _weightsBox.values.toList()..sort((a, b) => a.date.compareTo(b.date));

  Future<void> addWeight(double kg, {DateTime? date}) async {
    final entry = WeightEntry(date: date ?? DateTime.now(), weightKg: kg);
    await _weightsBox.add(entry);
  }

  WeightEntry? latestWeight() {
    final list = allWeights();
    return list.isEmpty ? null : list.last;
  }

  // ---------------- Nutrition ----------------

  NutritionProfile nutritionProfile() {
    if (_nutritionBox.isEmpty) {
      final profile = NutritionProfile();
      _nutritionBox.put('profile', profile);
      return profile;
    }
    return _nutritionBox.get('profile')!;
  }

  Future<void> saveNutritionProfile(NutritionProfile profile) async {
    await _nutritionBox.put('profile', profile);
  }

  int todayWaterMl() {
    final today = DateTime.now();
    return _waterBox.values
        .where((w) =>
            w.date.year == today.year &&
            w.date.month == today.month &&
            w.date.day == today.day)
        .fold(0, (sum, w) => sum + w.amountMl);
  }

  Future<void> addWater(int ml) async {
    await _waterBox.add(WaterIntake(date: DateTime.now(), amountMl: ml));
  }

  // ---------------- Settings ----------------

  AppSettings settings() {
    if (_settingsBox.isEmpty) {
      final s = AppSettings();
      _settingsBox.put('settings', s);
      return s;
    }
    return _settingsBox.get('settings')!;
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox.put('settings', settings);
  }
}
