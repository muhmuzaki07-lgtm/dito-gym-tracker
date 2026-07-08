import '../../core/constants/equipment.dart';
import 'program_data.dart';

/// A pool of alternative exercises (beyond what's already in the weekly
/// program) tagged by muscle group / equipment / difficulty / goal.
/// Combined with [ProgramData.allProgramExercises] to build the full
/// recommendation pool used by the "swap exercise" feature.
class ExerciseLibrary {
  ExerciseLibrary._();

  static const List<ExercisePrescription> alternativePool = [
    // Chest
    ExercisePrescription(
      name: 'Smith Machine Bench Press',
      primaryMuscle: 'Chest',
      muscleGroup: MuscleGroup.chest,
      sets: 4,
      repRange: '6-8',
      youtubeQuery: 'smith machine bench press tutorial',
      equipment: Equipment.smithMachine,
      difficulty: Difficulty.beginner,
    ),
    ExercisePrescription(
      name: 'Push Up',
      primaryMuscle: 'Chest',
      muscleGroup: MuscleGroup.chest,
      sets: 4,
      repRange: '10-15',
      youtubeQuery: 'push up proper form tutorial',
      equipment: Equipment.bodyweight,
      difficulty: Difficulty.beginner,
    ),
    ExercisePrescription(
      name: 'Cable Fly',
      primaryMuscle: 'Chest',
      muscleGroup: MuscleGroup.chest,
      sets: 3,
      repRange: '12-15',
      youtubeQuery: 'cable fly tutorial',
      equipment: Equipment.cable,
      difficulty: Difficulty.beginner,
    ),
    ExercisePrescription(
      name: 'Hammer Strength Chest Press',
      primaryMuscle: 'Chest',
      muscleGroup: MuscleGroup.chest,
      sets: 3,
      repRange: '8-10',
      youtubeQuery: 'hammer strength chest press tutorial',
      equipment: Equipment.machine,
      difficulty: Difficulty.beginner,
    ),

    // Back
    ExercisePrescription(
      name: 'Single Arm Dumbbell Row',
      primaryMuscle: 'Lats',
      muscleGroup: MuscleGroup.back,
      sets: 3,
      repRange: '8-12',
      youtubeQuery: 'single arm dumbbell row tutorial',
      equipment: Equipment.dumbbell,
      difficulty: Difficulty.beginner,
    ),
    ExercisePrescription(
      name: 'Machine Row',
      primaryMuscle: 'Mid Back',
      muscleGroup: MuscleGroup.back,
      sets: 3,
      repRange: '10-12',
      youtubeQuery: 'machine row tutorial',
      equipment: Equipment.machine,
      difficulty: Difficulty.beginner,
    ),
    ExercisePrescription(
      name: 'Straight Arm Pulldown',
      primaryMuscle: 'Lats',
      muscleGroup: MuscleGroup.back,
      sets: 3,
      repRange: '12-15',
      youtubeQuery: 'straight arm pulldown tutorial',
      equipment: Equipment.cable,
      difficulty: Difficulty.beginner,
    ),

    // Shoulders
    ExercisePrescription(
      name: 'Dumbbell Shoulder Press',
      primaryMuscle: 'Front Delts',
      muscleGroup: MuscleGroup.shoulders,
      sets: 3,
      repRange: '8-10',
      youtubeQuery: 'dumbbell shoulder press tutorial',
      equipment: Equipment.dumbbell,
    ),
    ExercisePrescription(
      name: 'Dumbbell Lateral Raise',
      primaryMuscle: 'Side Delts',
      muscleGroup: MuscleGroup.shoulders,
      sets: 4,
      repRange: '12-15',
      youtubeQuery: 'dumbbell lateral raise tutorial',
      equipment: Equipment.dumbbell,
      difficulty: Difficulty.beginner,
    ),
    ExercisePrescription(
      name: 'Reverse Pec Deck',
      primaryMuscle: 'Rear Delts',
      muscleGroup: MuscleGroup.shoulders,
      sets: 3,
      repRange: '12-15',
      youtubeQuery: 'reverse pec deck tutorial',
      equipment: Equipment.machine,
      difficulty: Difficulty.beginner,
    ),

    // Biceps
    ExercisePrescription(
      name: 'Dumbbell Bicep Curl',
      primaryMuscle: 'Biceps',
      muscleGroup: MuscleGroup.biceps,
      sets: 3,
      repRange: '10-12',
      youtubeQuery: 'dumbbell bicep curl tutorial',
      equipment: Equipment.dumbbell,
      difficulty: Difficulty.beginner,
    ),
    ExercisePrescription(
      name: 'Cable Curl',
      primaryMuscle: 'Biceps',
      muscleGroup: MuscleGroup.biceps,
      sets: 3,
      repRange: '10-12',
      youtubeQuery: 'cable curl tutorial',
      equipment: Equipment.cable,
      difficulty: Difficulty.beginner,
    ),

    // Triceps
    ExercisePrescription(
      name: 'Dumbbell Skull Crusher',
      primaryMuscle: 'Triceps',
      muscleGroup: MuscleGroup.triceps,
      sets: 3,
      repRange: '10-12',
      youtubeQuery: 'dumbbell skull crusher tutorial',
      equipment: Equipment.dumbbell,
    ),
    ExercisePrescription(
      name: 'Close Grip Bench Press',
      primaryMuscle: 'Triceps',
      muscleGroup: MuscleGroup.triceps,
      sets: 3,
      repRange: '8-10',
      youtubeQuery: 'close grip bench press tutorial',
      equipment: Equipment.barbell,
      difficulty: Difficulty.intermediate,
    ),

    // Quads
    ExercisePrescription(
      name: 'Smith Machine Squat',
      primaryMuscle: 'Quads',
      muscleGroup: MuscleGroup.quads,
      sets: 4,
      repRange: '8-10',
      youtubeQuery: 'smith machine squat tutorial',
      equipment: Equipment.smithMachine,
      difficulty: Difficulty.beginner,
    ),
    ExercisePrescription(
      name: 'Goblet Squat',
      primaryMuscle: 'Quads',
      muscleGroup: MuscleGroup.quads,
      sets: 3,
      repRange: '10-12',
      youtubeQuery: 'goblet squat tutorial',
      equipment: Equipment.dumbbell,
      difficulty: Difficulty.beginner,
    ),
    ExercisePrescription(
      name: 'Bodyweight Squat',
      primaryMuscle: 'Quads',
      muscleGroup: MuscleGroup.quads,
      sets: 4,
      repRange: '15-20',
      youtubeQuery: 'bodyweight squat tutorial',
      equipment: Equipment.bodyweight,
      difficulty: Difficulty.beginner,
    ),

    // Hamstrings
    ExercisePrescription(
      name: 'Dumbbell Romanian Deadlift',
      primaryMuscle: 'Hamstrings',
      muscleGroup: MuscleGroup.hamstrings,
      sets: 3,
      repRange: '8-10',
      youtubeQuery: 'dumbbell romanian deadlift tutorial',
      equipment: Equipment.dumbbell,
    ),
    ExercisePrescription(
      name: 'Seated Leg Curl',
      primaryMuscle: 'Hamstrings',
      muscleGroup: MuscleGroup.hamstrings,
      sets: 3,
      repRange: '10-12',
      youtubeQuery: 'seated leg curl tutorial',
      equipment: Equipment.machine,
      difficulty: Difficulty.beginner,
    ),

    // Glutes
    ExercisePrescription(
      name: 'Hip Thrust',
      primaryMuscle: 'Glutes',
      muscleGroup: MuscleGroup.glutes,
      sets: 3,
      repRange: '8-12',
      youtubeQuery: 'barbell hip thrust tutorial',
      equipment: Equipment.barbell,
      difficulty: Difficulty.intermediate,
    ),
    ExercisePrescription(
      name: 'Cable Kickback',
      primaryMuscle: 'Glutes',
      muscleGroup: MuscleGroup.glutes,
      sets: 3,
      repRange: '12-15',
      youtubeQuery: 'cable glute kickback tutorial',
      equipment: Equipment.cable,
      difficulty: Difficulty.beginner,
    ),

    // Calves
    ExercisePrescription(
      name: 'Bodyweight Calf Raise',
      primaryMuscle: 'Calves',
      muscleGroup: MuscleGroup.calves,
      sets: 4,
      repRange: '15-20',
      youtubeQuery: 'bodyweight calf raise tutorial',
      equipment: Equipment.bodyweight,
      difficulty: Difficulty.beginner,
    ),

    // Abs
    ExercisePrescription(
      name: 'Plank',
      primaryMuscle: 'Abs',
      muscleGroup: MuscleGroup.abs,
      sets: 3,
      repRange: '30-60s',
      youtubeQuery: 'plank proper form tutorial',
      equipment: Equipment.bodyweight,
      difficulty: Difficulty.beginner,
    ),
    ExercisePrescription(
      name: 'Sit Up',
      primaryMuscle: 'Abs',
      muscleGroup: MuscleGroup.abs,
      sets: 3,
      repRange: '15-20',
      youtubeQuery: 'sit up proper form tutorial',
      equipment: Equipment.bodyweight,
      difficulty: Difficulty.beginner,
    ),
  ];

  /// Combined pool: everything already in the weekly program plus this
  /// extra alternatives list, de-duplicated by name.
  static List<ExercisePrescription> fullPool() {
    final seen = <String>{};
    final result = <ExercisePrescription>[];
    for (final ex in [...ProgramData.allProgramExercises(), ...alternativePool]) {
      if (seen.add(ex.name)) {
        result.add(ex);
      }
    }
    return result;
  }

  /// Returns exercises matching the same muscle group as [current],
  /// filtered by the equipment the user has marked as available, and
  /// optionally by difficulty/goal. Excludes [current] itself.
  static List<ExercisePrescription> recommend({
    required ExercisePrescription current,
    required Set<Equipment> availableEquipment,
    Difficulty? difficulty,
    TrainingGoal? goal,
  }) {
    return fullPool().where((e) {
      if (e.name == current.name) return false;
      if (e.muscleGroup != current.muscleGroup) return false;
      if (!availableEquipment.contains(e.equipment)) return false;
      if (difficulty != null && e.difficulty != difficulty) return false;
      if (goal != null && !e.goals.contains(goal)) return false;
      return true;
    }).toList();
  }

  /// Finds the best available substitute for [exercise] given the
  /// equipment the user has on hand. Returns null if the exercise's own
  /// equipment is already available (no substitution needed) or if no
  /// substitute exists.
  static ExercisePrescription? autoSubstitute({
    required ExercisePrescription exercise,
    required Set<Equipment> availableEquipment,
  }) {
    if (availableEquipment.contains(exercise.equipment)) return null;
    final candidates = recommend(
      current: exercise,
      availableEquipment: availableEquipment,
    );
    return candidates.isEmpty ? null : candidates.first;
  }
}
