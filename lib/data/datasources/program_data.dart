import '../../core/constants/equipment.dart';

/// Broad muscle group category used for matching exercise alternatives.
/// (More specific labels like "Upper Chest" or "Rear Delts" still live in
/// [ExercisePrescription.primaryMuscle] for display purposes.)
enum MuscleGroup { chest, back, shoulders, biceps, triceps, quads, hamstrings, glutes, calves, abs }

/// Definition of a single exercise prescription within a training day.
class ExercisePrescription {
  final String name;
  final String primaryMuscle;
  final MuscleGroup muscleGroup;
  final int sets;
  final String repRange;
  final String youtubeQuery;
  final String imageAsset;
  final Equipment equipment;
  final Difficulty difficulty;
  final List<TrainingGoal> goals;

  const ExercisePrescription({
    required this.name,
    required this.primaryMuscle,
    required this.muscleGroup,
    required this.sets,
    required this.repRange,
    required this.youtubeQuery,
    this.imageAsset = '',
    required this.equipment,
    this.difficulty = Difficulty.intermediate,
    this.goals = const [TrainingGoal.hypertrophy],
  });

  /// Returns a copy with sets/repRange preserved but swapped identity
  /// fields, used when auto-substituting an unavailable-equipment
  /// exercise with an alternative from the library.
  ExercisePrescription withReplacement(ExercisePrescription other) {
    return ExercisePrescription(
      name: other.name,
      primaryMuscle: other.primaryMuscle,
      muscleGroup: other.muscleGroup,
      sets: sets,
      repRange: repRange,
      youtubeQuery: other.youtubeQuery,
      imageAsset: other.imageAsset,
      equipment: other.equipment,
      difficulty: other.difficulty,
      goals: other.goals,
    );
  }
}

/// A single day in the weekly split. [isRest] days carry a recovery
/// checklist instead of exercises.
class ProgramDay {
  final String dayOfWeek; // Senin, Selasa, ...
  final String title; // Upper A, Lower A, REST DAY, ...
  final bool isRest;
  final List<ExercisePrescription> exercises;
  final List<String> recoveryChecklist;

  const ProgramDay({
    required this.dayOfWeek,
    required this.title,
    this.isRest = false,
    this.exercises = const [],
    this.recoveryChecklist = const [],
  });
}

/// The full weekly Upper-Lower Split program (Men's Physique, evidence-based).
class ProgramData {
  ProgramData._();

  static const List<ProgramDay> week = [
    ProgramDay(
      dayOfWeek: 'Senin',
      title: 'Upper A',
      exercises: [
        ExercisePrescription(
          name: 'Incline Barbell Bench Press',
          primaryMuscle: 'Upper Chest',
          muscleGroup: MuscleGroup.chest,
          sets: 4,
          repRange: '6-8',
          youtubeQuery: 'incline barbell bench press tutorial',
          equipment: Equipment.barbell,
          difficulty: Difficulty.intermediate,
          goals: [TrainingGoal.hypertrophy, TrainingGoal.strength],
        ),
        ExercisePrescription(
          name: 'Pull Up / Wide Lat Pulldown',
          primaryMuscle: 'Lats',
          muscleGroup: MuscleGroup.back,
          sets: 4,
          repRange: '8-10',
          youtubeQuery: 'wide grip lat pulldown tutorial',
          equipment: Equipment.pullUpBar,
          difficulty: Difficulty.intermediate,
        ),
        ExercisePrescription(
          name: 'Flat Dumbbell Press',
          primaryMuscle: 'Chest',
          muscleGroup: MuscleGroup.chest,
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'flat dumbbell press tutorial',
          equipment: Equipment.dumbbell,
        ),
        ExercisePrescription(
          name: 'Chest Supported Row',
          primaryMuscle: 'Mid Back',
          muscleGroup: MuscleGroup.back,
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'chest supported row tutorial',
          equipment: Equipment.machine,
        ),
        ExercisePrescription(
          name: 'Cable Lateral Raise',
          primaryMuscle: 'Side Delts',
          muscleGroup: MuscleGroup.shoulders,
          sets: 4,
          repRange: '12-15',
          youtubeQuery: 'cable lateral raise tutorial',
          equipment: Equipment.cable,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'Face Pull',
          primaryMuscle: 'Rear Delts',
          muscleGroup: MuscleGroup.shoulders,
          sets: 3,
          repRange: '12-15',
          youtubeQuery: 'face pull tutorial',
          equipment: Equipment.cable,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'Rope Triceps Pushdown',
          primaryMuscle: 'Triceps',
          muscleGroup: MuscleGroup.triceps,
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'rope triceps pushdown tutorial',
          equipment: Equipment.cable,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'EZ Bar Curl',
          primaryMuscle: 'Biceps',
          muscleGroup: MuscleGroup.biceps,
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'ez bar curl tutorial',
          equipment: Equipment.ezBar,
          difficulty: Difficulty.beginner,
        ),
      ],
    ),
    ProgramDay(
      dayOfWeek: 'Selasa',
      title: 'Lower A',
      exercises: [
        ExercisePrescription(
          name: 'Back Squat',
          primaryMuscle: 'Quads',
          muscleGroup: MuscleGroup.quads,
          sets: 4,
          repRange: '6-8',
          youtubeQuery: 'back squat tutorial',
          equipment: Equipment.barbell,
          difficulty: Difficulty.advanced,
          goals: [TrainingGoal.hypertrophy, TrainingGoal.strength],
        ),
        ExercisePrescription(
          name: 'Romanian Deadlift',
          primaryMuscle: 'Hamstrings',
          muscleGroup: MuscleGroup.hamstrings,
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'romanian deadlift tutorial',
          equipment: Equipment.barbell,
          difficulty: Difficulty.intermediate,
          goals: [TrainingGoal.hypertrophy, TrainingGoal.strength],
        ),
        ExercisePrescription(
          name: 'Leg Press',
          primaryMuscle: 'Quads',
          muscleGroup: MuscleGroup.quads,
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'leg press tutorial',
          equipment: Equipment.machine,
        ),
        ExercisePrescription(
          name: 'Leg Extension',
          primaryMuscle: 'Quads',
          muscleGroup: MuscleGroup.quads,
          sets: 3,
          repRange: '12-15',
          youtubeQuery: 'leg extension tutorial',
          equipment: Equipment.machine,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'Standing Calf Raise',
          primaryMuscle: 'Calves',
          muscleGroup: MuscleGroup.calves,
          sets: 4,
          repRange: '10-15',
          youtubeQuery: 'standing calf raise tutorial',
          equipment: Equipment.machine,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'Hanging Leg Raise',
          primaryMuscle: 'Abs',
          muscleGroup: MuscleGroup.abs,
          sets: 3,
          repRange: '12-15',
          youtubeQuery: 'hanging leg raise tutorial',
          equipment: Equipment.pullUpBar,
          difficulty: Difficulty.intermediate,
        ),
      ],
    ),
    ProgramDay(
      dayOfWeek: 'Rabu',
      title: 'REST DAY',
      isRest: true,
      recoveryChecklist: [
        'Jalan kaki',
        'Stretching',
        'Mobility',
        'Tidur cukup',
      ],
    ),
    ProgramDay(
      dayOfWeek: 'Kamis',
      title: 'Upper B',
      exercises: [
        ExercisePrescription(
          name: 'Neutral Grip Lat Pulldown',
          primaryMuscle: 'Lats',
          muscleGroup: MuscleGroup.back,
          sets: 4,
          repRange: '8-10',
          youtubeQuery: 'neutral grip lat pulldown tutorial',
          equipment: Equipment.cable,
        ),
        ExercisePrescription(
          name: 'Seated Cable Row',
          primaryMuscle: 'Mid Back',
          muscleGroup: MuscleGroup.back,
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'seated cable row tutorial',
          equipment: Equipment.cable,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'Incline Dumbbell Press',
          primaryMuscle: 'Upper Chest',
          muscleGroup: MuscleGroup.chest,
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'incline dumbbell press tutorial',
          equipment: Equipment.dumbbell,
        ),
        ExercisePrescription(
          name: 'Machine Shoulder Press',
          primaryMuscle: 'Front Delts',
          muscleGroup: MuscleGroup.shoulders,
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'machine shoulder press tutorial',
          equipment: Equipment.machine,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'Machine Lateral Raise',
          primaryMuscle: 'Side Delts',
          muscleGroup: MuscleGroup.shoulders,
          sets: 4,
          repRange: '12-15',
          youtubeQuery: 'machine lateral raise tutorial',
          equipment: Equipment.machine,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'Rear Delt Fly',
          primaryMuscle: 'Rear Delts',
          muscleGroup: MuscleGroup.shoulders,
          sets: 3,
          repRange: '12-15',
          youtubeQuery: 'rear delt fly tutorial',
          equipment: Equipment.dumbbell,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'Overhead Rope Extension',
          primaryMuscle: 'Triceps',
          muscleGroup: MuscleGroup.triceps,
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'overhead rope triceps extension tutorial',
          equipment: Equipment.cable,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'Incline Dumbbell Curl',
          primaryMuscle: 'Biceps',
          muscleGroup: MuscleGroup.biceps,
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'incline dumbbell curl tutorial',
          equipment: Equipment.dumbbell,
          difficulty: Difficulty.beginner,
        ),
      ],
    ),
    ProgramDay(
      dayOfWeek: 'Jumat',
      title: 'Lower B',
      exercises: [
        ExercisePrescription(
          name: 'Romanian Deadlift',
          primaryMuscle: 'Hamstrings',
          muscleGroup: MuscleGroup.hamstrings,
          sets: 4,
          repRange: '6-8',
          youtubeQuery: 'romanian deadlift tutorial',
          equipment: Equipment.barbell,
          difficulty: Difficulty.intermediate,
          goals: [TrainingGoal.hypertrophy, TrainingGoal.strength],
        ),
        ExercisePrescription(
          name: 'Hack Squat',
          primaryMuscle: 'Quads',
          muscleGroup: MuscleGroup.quads,
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'hack squat tutorial',
          equipment: Equipment.machine,
          difficulty: Difficulty.intermediate,
        ),
        ExercisePrescription(
          name: 'Bulgarian Split Squat',
          primaryMuscle: 'Quads/Glutes',
          muscleGroup: MuscleGroup.glutes,
          sets: 3,
          repRange: '10',
          youtubeQuery: 'bulgarian split squat tutorial',
          equipment: Equipment.dumbbell,
          difficulty: Difficulty.advanced,
        ),
        ExercisePrescription(
          name: 'Leg Curl',
          primaryMuscle: 'Hamstrings',
          muscleGroup: MuscleGroup.hamstrings,
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'lying leg curl tutorial',
          equipment: Equipment.machine,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'Seated Calf Raise',
          primaryMuscle: 'Calves',
          muscleGroup: MuscleGroup.calves,
          sets: 4,
          repRange: '12-15',
          youtubeQuery: 'seated calf raise tutorial',
          equipment: Equipment.machine,
          difficulty: Difficulty.beginner,
        ),
        ExercisePrescription(
          name: 'Cable Crunch',
          primaryMuscle: 'Abs',
          muscleGroup: MuscleGroup.abs,
          sets: 3,
          repRange: '12-15',
          youtubeQuery: 'cable crunch tutorial',
          equipment: Equipment.cable,
          difficulty: Difficulty.beginner,
        ),
      ],
    ),
    ProgramDay(
      dayOfWeek: 'Sabtu',
      title: 'REST DAY',
      isRest: true,
      recoveryChecklist: [
        'Jalan kaki',
        'Stretching',
        'Mobility',
        'Tidur cukup',
      ],
    ),
    ProgramDay(
      dayOfWeek: 'Minggu',
      title: 'RECOVERY DAY',
      isRest: true,
      recoveryChecklist: [
        'Jalan kaki ringan',
        'Stretching penuh',
        'Mobility drill',
        'Tidur cukup (7-9 jam)',
      ],
    ),
  ];

  /// Returns today's program day based on the local weekday.
  static ProgramDay todayProgram() {
    final weekday = DateTime.now().weekday; // 1 = Monday ... 7 = Sunday
    return week[weekday - 1];
  }

  /// Flattened, de-duplicated (by name) list of every exercise appearing
  /// anywhere in the weekly program. Used as part of the recommendation
  /// pool for the "swap exercise" feature.
  static List<ExercisePrescription> allProgramExercises() {
    final seen = <String>{};
    final result = <ExercisePrescription>[];
    for (final day in week) {
      for (final ex in day.exercises) {
        if (seen.add(ex.name)) {
          result.add(ex);
        }
      }
    }
    return result;
  }
}
