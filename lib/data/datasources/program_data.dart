/// Definition of a single exercise prescription within a training day.
class ExercisePrescription {
  final String name;
  final String primaryMuscle;
  final int sets;
  final String repRange;
  final String youtubeQuery;
  final String imageAsset;

  const ExercisePrescription({
    required this.name,
    required this.primaryMuscle,
    required this.sets,
    required this.repRange,
    required this.youtubeQuery,
    this.imageAsset = '',
  });
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
          sets: 4,
          repRange: '6-8',
          youtubeQuery: 'incline barbell bench press tutorial',
        ),
        ExercisePrescription(
          name: 'Pull Up / Wide Lat Pulldown',
          primaryMuscle: 'Lats',
          sets: 4,
          repRange: '8-10',
          youtubeQuery: 'wide grip lat pulldown tutorial',
        ),
        ExercisePrescription(
          name: 'Flat Dumbbell Press',
          primaryMuscle: 'Chest',
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'flat dumbbell press tutorial',
        ),
        ExercisePrescription(
          name: 'Chest Supported Row',
          primaryMuscle: 'Mid Back',
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'chest supported row tutorial',
        ),
        ExercisePrescription(
          name: 'Cable Lateral Raise',
          primaryMuscle: 'Side Delts',
          sets: 4,
          repRange: '12-15',
          youtubeQuery: 'cable lateral raise tutorial',
        ),
        ExercisePrescription(
          name: 'Face Pull',
          primaryMuscle: 'Rear Delts',
          sets: 3,
          repRange: '12-15',
          youtubeQuery: 'face pull tutorial',
        ),
        ExercisePrescription(
          name: 'Rope Triceps Pushdown',
          primaryMuscle: 'Triceps',
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'rope triceps pushdown tutorial',
        ),
        ExercisePrescription(
          name: 'EZ Bar Curl',
          primaryMuscle: 'Biceps',
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'ez bar curl tutorial',
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
          sets: 4,
          repRange: '6-8',
          youtubeQuery: 'back squat tutorial',
        ),
        ExercisePrescription(
          name: 'Romanian Deadlift',
          primaryMuscle: 'Hamstrings',
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'romanian deadlift tutorial',
        ),
        ExercisePrescription(
          name: 'Leg Press',
          primaryMuscle: 'Quads',
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'leg press tutorial',
        ),
        ExercisePrescription(
          name: 'Leg Extension',
          primaryMuscle: 'Quads',
          sets: 3,
          repRange: '12-15',
          youtubeQuery: 'leg extension tutorial',
        ),
        ExercisePrescription(
          name: 'Standing Calf Raise',
          primaryMuscle: 'Calves',
          sets: 4,
          repRange: '10-15',
          youtubeQuery: 'standing calf raise tutorial',
        ),
        ExercisePrescription(
          name: 'Hanging Leg Raise',
          primaryMuscle: 'Abs',
          sets: 3,
          repRange: '12-15',
          youtubeQuery: 'hanging leg raise tutorial',
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
          sets: 4,
          repRange: '8-10',
          youtubeQuery: 'neutral grip lat pulldown tutorial',
        ),
        ExercisePrescription(
          name: 'Seated Cable Row',
          primaryMuscle: 'Mid Back',
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'seated cable row tutorial',
        ),
        ExercisePrescription(
          name: 'Incline Dumbbell Press',
          primaryMuscle: 'Upper Chest',
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'incline dumbbell press tutorial',
        ),
        ExercisePrescription(
          name: 'Machine Shoulder Press',
          primaryMuscle: 'Front Delts',
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'machine shoulder press tutorial',
        ),
        ExercisePrescription(
          name: 'Machine Lateral Raise',
          primaryMuscle: 'Side Delts',
          sets: 4,
          repRange: '12-15',
          youtubeQuery: 'machine lateral raise tutorial',
        ),
        ExercisePrescription(
          name: 'Rear Delt Fly',
          primaryMuscle: 'Rear Delts',
          sets: 3,
          repRange: '12-15',
          youtubeQuery: 'rear delt fly tutorial',
        ),
        ExercisePrescription(
          name: 'Overhead Rope Extension',
          primaryMuscle: 'Triceps',
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'overhead rope triceps extension tutorial',
        ),
        ExercisePrescription(
          name: 'Incline Dumbbell Curl',
          primaryMuscle: 'Biceps',
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'incline dumbbell curl tutorial',
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
          sets: 4,
          repRange: '6-8',
          youtubeQuery: 'romanian deadlift tutorial',
        ),
        ExercisePrescription(
          name: 'Hack Squat',
          primaryMuscle: 'Quads',
          sets: 3,
          repRange: '8-10',
          youtubeQuery: 'hack squat tutorial',
        ),
        ExercisePrescription(
          name: 'Bulgarian Split Squat',
          primaryMuscle: 'Quads/Glutes',
          sets: 3,
          repRange: '10',
          youtubeQuery: 'bulgarian split squat tutorial',
        ),
        ExercisePrescription(
          name: 'Leg Curl',
          primaryMuscle: 'Hamstrings',
          sets: 3,
          repRange: '10-12',
          youtubeQuery: 'lying leg curl tutorial',
        ),
        ExercisePrescription(
          name: 'Seated Calf Raise',
          primaryMuscle: 'Calves',
          sets: 4,
          repRange: '12-15',
          youtubeQuery: 'seated calf raise tutorial',
        ),
        ExercisePrescription(
          name: 'Cable Crunch',
          primaryMuscle: 'Abs',
          sets: 3,
          repRange: '12-15',
          youtubeQuery: 'cable crunch tutorial',
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
}
