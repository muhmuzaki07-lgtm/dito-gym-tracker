/// Equipment types a gym may or may not have. Used to filter/swap
/// exercises via the "Available Equipment" feature.
enum Equipment {
  barbell,
  dumbbell,
  cable,
  machine,
  bodyweight,
  smithMachine,
  pullUpBar,
  ezBar,
}

extension EquipmentLabel on Equipment {
  String get label {
    switch (this) {
      case Equipment.barbell:
        return 'Barbell';
      case Equipment.dumbbell:
        return 'Dumbbell';
      case Equipment.cable:
        return 'Cable';
      case Equipment.machine:
        return 'Machine';
      case Equipment.bodyweight:
        return 'Bodyweight';
      case Equipment.smithMachine:
        return 'Smith Machine';
      case Equipment.pullUpBar:
        return 'Pull-up Bar';
      case Equipment.ezBar:
        return 'EZ Bar';
    }
  }
}

enum Difficulty { beginner, intermediate, advanced }

extension DifficultyLabel on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.beginner:
        return 'Pemula';
      case Difficulty.intermediate:
        return 'Menengah';
      case Difficulty.advanced:
        return 'Lanjutan';
    }
  }
}

enum TrainingGoal { hypertrophy, strength, endurance }

extension TrainingGoalLabel on TrainingGoal {
  String get label {
    switch (this) {
      case TrainingGoal.hypertrophy:
        return 'Hypertrophy';
      case TrainingGoal.strength:
        return 'Strength';
      case TrainingGoal.endurance:
        return 'Endurance';
    }
  }
}
