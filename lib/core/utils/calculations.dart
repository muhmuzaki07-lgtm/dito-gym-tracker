import '../../data/models/workout_models.dart';

/// Result bundle for a nutrition calculation.
class NutritionTargets {
  final double bmr;
  final double tdee;
  final double calorieTarget;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;

  const NutritionTargets({
    required this.bmr,
    required this.tdee,
    required this.calorieTarget,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
  });
}

/// Recommendation for the next session of a given exercise, based on the
/// previous logged performance.
class OverloadSuggestion {
  final double? previousWeight;
  final int? previousReps;
  final double targetWeight;
  final String targetRepRange;
  final bool suggestIncrease;

  const OverloadSuggestion({
    this.previousWeight,
    this.previousReps,
    required this.targetWeight,
    required this.targetRepRange,
    required this.suggestIncrease,
  });
}

class Calculations {
  Calculations._();

  /// Mifflin-St Jeor equation — the most accurate widely-used BMR formula.
  static double bmr({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
  }) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return gender == Gender.male ? base + 5 : base - 161;
  }

  static double _activityMultiplier(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.light:
        return 1.375;
      case ActivityLevel.moderate:
        return 1.55;
      case ActivityLevel.active:
        return 1.725;
      case ActivityLevel.veryActive:
        return 1.9;
    }
  }

  /// Full nutrition target calculation for hypertrophy-focused Men's
  /// Physique training: moderate surplus/maintenance, high protein.
  static NutritionTargets computeTargets(NutritionProfile profile) {
    final bmrValue = bmr(
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      age: profile.age,
      gender: profile.gender,
    );
    final tdeeValue = bmrValue * _activityMultiplier(profile.activityLevel);

    // Lean bulk target: TDEE + ~10% for hypertrophy-focused training.
    final calorieTarget = tdeeValue * 1.10;

    // Protein: 2.2g/kg bodyweight (evidence-based upper range for
    // physique athletes). Fat: 25% of calories. Carbs: remainder.
    final proteinGrams = profile.weightKg * 2.2;
    final fatGrams = (calorieTarget * 0.25) / 9;
    final proteinCalories = proteinGrams * 4;
    final fatCalories = fatGrams * 9;
    final carbsGrams = (calorieTarget - proteinCalories - fatCalories) / 4;

    return NutritionTargets(
      bmr: bmrValue,
      tdee: tdeeValue,
      calorieTarget: calorieTarget,
      proteinGrams: proteinGrams,
      carbsGrams: carbsGrams < 0 ? 0 : carbsGrams,
      fatGrams: fatGrams,
    );
  }

  /// Determines the recommended weight/target for the next session of an
  /// exercise, comparing against the last logged performance.
  ///
  /// Rule: if every completed set last time hit the TOP of the target rep
  /// range, recommend a 2.5-5% weight increase. Otherwise keep the same
  /// weight and encourage hitting the top of the range first.
  static OverloadSuggestion suggestNext({
    required ExerciseLog? lastLog,
    required String targetRepRange,
  }) {
    if (lastLog == null || lastLog.sets.isEmpty) {
      return OverloadSuggestion(
        targetWeight: 0,
        targetRepRange: targetRepRange,
        suggestIncrease: false,
      );
    }

    final completedSets = lastLog.sets.where((s) => s.completed).toList();
    if (completedSets.isEmpty) {
      return OverloadSuggestion(
        targetWeight: 0,
        targetRepRange: targetRepRange,
        suggestIncrease: false,
      );
    }

    final topRep = _topOfRange(targetRepRange);
    final allHitTop = completedSets.every((s) => s.reps >= topRep);
    final lastWeight = completedSets.last.weightKg;
    final lastReps = completedSets.last.reps;

    if (allHitTop) {
      // 2.5% - 5% increase, rounded to nearest 0.5 kg (typical plate jump).
      final increased = lastWeight * 1.035;
      final rounded = (increased * 2).round() / 2;
      return OverloadSuggestion(
        previousWeight: lastWeight,
        previousReps: lastReps,
        targetWeight: rounded,
        targetRepRange: targetRepRange,
        suggestIncrease: true,
      );
    }

    return OverloadSuggestion(
      previousWeight: lastWeight,
      previousReps: lastReps,
      targetWeight: lastWeight,
      targetRepRange: targetRepRange,
      suggestIncrease: false,
    );
  }

  static int _topOfRange(String range) {
    final parts = range.split('-');
    final last = parts.last.trim();
    return int.tryParse(last) ?? int.tryParse(parts.first.trim()) ?? 10;
  }

  static double kgToLbs(double kg) => kg * 2.20462;
  static double lbsToKg(double lbs) => lbs / 2.20462;
}
