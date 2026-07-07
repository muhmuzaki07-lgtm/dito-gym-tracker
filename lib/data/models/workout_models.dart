import 'package:hive/hive.dart';

/// ---------------------------------------------------------------------
/// Hive models for Dito Gym Tracker.
/// TypeAdapters are hand-written (not generated) so the project compiles
/// immediately without requiring `build_runner` to be run first.
/// Type IDs used: 0=SetLog, 1=ExerciseLog, 2=WorkoutSession,
/// 3=WeightEntry, 4=NutritionProfile, 5=WaterIntake, 6=AppSettings
/// ---------------------------------------------------------------------

class SetLog extends HiveObject {
  double weightKg;
  int reps;
  bool completed;

  SetLog({this.weightKg = 0, this.reps = 0, this.completed = false});
}

class SetLogAdapter extends TypeAdapter<SetLog> {
  @override
  final int typeId = 0;

  @override
  SetLog read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return SetLog(
      weightKg: (fields[0] as num?)?.toDouble() ?? 0,
      reps: fields[1] as int? ?? 0,
      completed: fields[2] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, SetLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.weightKg)
      ..writeByte(1)
      ..write(obj.reps)
      ..writeByte(2)
      ..write(obj.completed);
  }
}

class ExerciseLog extends HiveObject {
  String exerciseName;
  String targetRepRange;
  List<SetLog> sets;
  String notes;

  ExerciseLog({
    required this.exerciseName,
    required this.targetRepRange,
    List<SetLog>? sets,
    this.notes = '',
  }) : sets = sets ?? [];
}

class ExerciseLogAdapter extends TypeAdapter<ExerciseLog> {
  @override
  final int typeId = 1;

  @override
  ExerciseLog read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseLog(
      exerciseName: fields[0] as String? ?? '',
      targetRepRange: fields[1] as String? ?? '',
      sets: (fields[2] as List?)?.cast<SetLog>() ?? [],
      notes: fields[3] as String? ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.exerciseName)
      ..writeByte(1)
      ..write(obj.targetRepRange)
      ..writeByte(2)
      ..write(obj.sets)
      ..writeByte(3)
      ..write(obj.notes);
  }
}

class WorkoutSession extends HiveObject {
  String id;
  DateTime date;
  String dayName; // e.g. "Upper A"
  List<ExerciseLog> exercises;
  int durationMinutes;
  bool finished;

  WorkoutSession({
    required this.id,
    required this.date,
    required this.dayName,
    List<ExerciseLog>? exercises,
    this.durationMinutes = 0,
    this.finished = false,
  }) : exercises = exercises ?? [];

  double get totalVolume {
    double vol = 0;
    for (final ex in exercises) {
      for (final s in ex.sets) {
        if (s.completed) vol += s.weightKg * s.reps;
      }
    }
    return vol;
  }

  int get totalSetsCompleted {
    int count = 0;
    for (final ex in exercises) {
      count += ex.sets.where((s) => s.completed).length;
    }
    return count;
  }
}

class WorkoutSessionAdapter extends TypeAdapter<WorkoutSession> {
  @override
  final int typeId = 2;

  @override
  WorkoutSession read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSession(
      id: fields[0] as String? ?? '',
      date: fields[1] as DateTime? ?? DateTime.now(),
      dayName: fields[2] as String? ?? '',
      exercises: (fields[3] as List?)?.cast<ExerciseLog>() ?? [],
      durationMinutes: fields[4] as int? ?? 0,
      finished: fields[5] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSession obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.dayName)
      ..writeByte(3)
      ..write(obj.exercises)
      ..writeByte(4)
      ..write(obj.durationMinutes)
      ..writeByte(5)
      ..write(obj.finished);
  }
}

class WeightEntry extends HiveObject {
  DateTime date;
  double weightKg;

  WeightEntry({required this.date, required this.weightKg});
}

class WeightEntryAdapter extends TypeAdapter<WeightEntry> {
  @override
  final int typeId = 3;

  @override
  WeightEntry read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return WeightEntry(
      date: fields[0] as DateTime? ?? DateTime.now(),
      weightKg: (fields[1] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, WeightEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.weightKg);
  }
}

enum Gender { male, female }

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

class NutritionProfile extends HiveObject {
  double weightKg;
  double heightCm;
  int age;
  Gender gender;
  ActivityLevel activityLevel;

  NutritionProfile({
    this.weightKg = 70,
    this.heightCm = 175,
    this.age = 25,
    this.gender = Gender.male,
    this.activityLevel = ActivityLevel.moderate,
  });
}

class NutritionProfileAdapter extends TypeAdapter<NutritionProfile> {
  @override
  final int typeId = 4;

  @override
  NutritionProfile read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return NutritionProfile(
      weightKg: (fields[0] as num?)?.toDouble() ?? 70,
      heightCm: (fields[1] as num?)?.toDouble() ?? 175,
      age: fields[2] as int? ?? 25,
      gender: Gender.values[fields[3] as int? ?? 0],
      activityLevel: ActivityLevel.values[fields[4] as int? ?? 2],
    );
  }

  @override
  void write(BinaryWriter writer, NutritionProfile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.weightKg)
      ..writeByte(1)
      ..write(obj.heightCm)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.gender.index)
      ..writeByte(4)
      ..write(obj.activityLevel.index);
  }
}

class WaterIntake extends HiveObject {
  DateTime date;
  int amountMl;

  WaterIntake({required this.date, required this.amountMl});
}

class WaterIntakeAdapter extends TypeAdapter<WaterIntake> {
  @override
  final int typeId = 5;

  @override
  WaterIntake read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return WaterIntake(
      date: fields[0] as DateTime? ?? DateTime.now(),
      amountMl: fields[1] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, WaterIntake obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.amountMl);
  }
}

class AppSettings extends HiveObject {
  bool useLbs;
  bool reminderWorkout;
  bool reminderWater;
  String userName;

  AppSettings({
    this.useLbs = false,
    this.reminderWorkout = true,
    this.reminderWater = true,
    this.userName = 'Dito',
  });
}

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 6;

  @override
  AppSettings read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      useLbs: fields[0] as bool? ?? false,
      reminderWorkout: fields[1] as bool? ?? true,
      reminderWater: fields[2] as bool? ?? true,
      userName: fields[3] as String? ?? 'Dito',
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.useLbs)
      ..writeByte(1)
      ..write(obj.reminderWorkout)
      ..writeByte(2)
      ..write(obj.reminderWater)
      ..writeByte(3)
      ..write(obj.userName);
  }
}

/// Registers every adapter with Hive. Call once in main() before openBox.
void registerHiveAdapters() {
  Hive.registerAdapter(SetLogAdapter());
  Hive.registerAdapter(ExerciseLogAdapter());
  Hive.registerAdapter(WorkoutSessionAdapter());
  Hive.registerAdapter(WeightEntryAdapter());
  Hive.registerAdapter(NutritionProfileAdapter());
  Hive.registerAdapter(WaterIntakeAdapter());
  Hive.registerAdapter(AppSettingsAdapter());
}

/// Hive box names, centralized to avoid typo bugs / string duplication.
class HiveBoxes {
  HiveBoxes._();
  static const sessions = 'workout_sessions';
  static const weights = 'weight_entries';
  static const nutrition = 'nutrition_profile';
  static const water = 'water_intake';
  static const settings = 'app_settings';
}
