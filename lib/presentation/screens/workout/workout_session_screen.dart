import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/equipment.dart';
import '../../../core/utils/calculations.dart';
import '../../../data/datasources/exercise_library.dart';
import '../../../data/datasources/program_data.dart';
import '../../../data/models/workout_models.dart';
import '../../providers/personalization_providers.dart';
import '../../providers/providers.dart';
import '../../widgets/exercise_set_row.dart';
import '../../widgets/exercise_swap_sheet.dart';
import '../../widgets/rest_timer_sheet.dart';

/// The active workout screen: shows each exercise with sets to log,
/// progressive overload targets, video tutorial link, and a rest timer.
class WorkoutSessionScreen extends ConsumerStatefulWidget {
  final ProgramDay day;
  const WorkoutSessionScreen({super.key, required this.day});

  @override
  ConsumerState<WorkoutSessionScreen> createState() =>
      _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  late WorkoutSession _session;
  late List<ExercisePrescription> _effectiveExercises;
  final Set<int> _autoSubstitutedIndexes = {};
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    final repo = ref.read(workoutRepositoryProvider);
    final availableEquipment = ref.read(availableEquipmentProvider);

    _effectiveExercises = widget.day.exercises.map((ex) {
      final sub = ExerciseLibrary.autoSubstitute(
        exercise: ex,
        availableEquipment: availableEquipment,
      );
      return sub ?? ex;
    }).toList();

    for (var i = 0; i < widget.day.exercises.length; i++) {
      if (_effectiveExercises[i].name != widget.day.exercises[i].name) {
        _autoSubstitutedIndexes.add(i);
      }
    }

    _session = repo.createSession(widget.day.title);
    for (final ex in _effectiveExercises) {
      _session.exercises.add(
        ExerciseLog(
          exerciseName: ex.name,
          targetRepRange: ex.repRange,
          sets: List.generate(ex.sets, (_) => SetLog()),
        ),
      );
    }
    _stopwatch.start();
    repo.saveSession(_session);
  }

  Future<void> _swapExercise(int index) async {
    final availableEquipment = ref.read(availableEquipmentProvider);
    final chosen = await showExerciseSwapSheet(
      context,
      current: _effectiveExercises[index],
      availableEquipment: availableEquipment,
    );
    if (chosen == null) return;
    setState(() {
      _effectiveExercises[index] = _effectiveExercises[index].withReplacement(chosen);
      _session.exercises[index].exerciseName = chosen.name;
      _autoSubstitutedIndexes.remove(index);
    });
    _persist();
  }

  void _persist() {
    ref.read(workoutRepositoryProvider).saveSession(_session);
    notifyDataChanged(ref);
  }

  Future<void> _finishWorkout() async {
    _stopwatch.stop();
    _session.durationMinutes = (_stopwatch.elapsedMilliseconds / 60000).ceil();
    _session.finished = true;
    await ref.read(workoutRepositoryProvider).saveSession(_session);
    notifyDataChanged(ref);
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Workout selesai! Volume: ${_session.totalVolume.toStringAsFixed(0)} kg, '
            '${_session.totalSetsCompleted} set.',
          ),
          backgroundColor: AppColors.surfaceElevated,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final unitLabel = settings.useLbs ? 'lbs' : 'kg';
    final repo = ref.read(workoutRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.day.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer_outlined),
            onPressed: () => showRestTimerSheet(context, initialSeconds: 90),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: _effectiveExercises.length,
        itemBuilder: (context, index) {
          final prescription = _effectiveExercises[index];
          final log = _session.exercises[index];
          final lastLog = repo.lastExerciseLog(prescription.name);
          final suggestion = Calculations.suggestNext(
            lastLog: lastLog,
            targetRepRange: prescription.repRange,
          );
          final wasAutoSubstituted = _autoSubstitutedIndexes.contains(index);

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(prescription.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            Text(prescription.primaryMuscle,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_horiz_rounded,
                            color: AppColors.textSecondary),
                        tooltip: 'Ganti exercise',
                        onPressed: () => _swapExercise(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_circle_outline_rounded,
                            color: AppColors.gold),
                        tooltip: 'Video tutorial',
                        onPressed: () => _openYoutube(prescription.youtubeQuery),
                      ),
                    ],
                  ),
                  if (wasAutoSubstituted) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              size: 14, color: AppColors.info),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Diganti otomatis dari "${widget.day.exercises[index].name}" (equipment tidak tersedia)',
                              style: const TextStyle(fontSize: 11, color: AppColors.info),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  _OverloadBanner(
                    suggestion: suggestion,
                    unitLabel: unitLabel,
                  ),
                  const Divider(height: 20),
                  Row(
                    children: const [
                      SizedBox(width: 28),
                      Expanded(
                          child: Text('Berat',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textSecondary))),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text('Reps',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textSecondary))),
                      SizedBox(width: 10),
                      SizedBox(width: 36),
                    ],
                  ),
                  ...List.generate(log.sets.length, (setIndex) {
                    return ExerciseSetRow(
                      setIndex: setIndex,
                      setLog: log.sets[setIndex],
                      unitLabel: unitLabel,
                      onChanged: _persist,
                      onCompletedToggled: () {
                        setState(() {
                          log.sets[setIndex].completed =
                              !log.sets[setIndex].completed;
                        });
                        _persist();
                        if (log.sets[setIndex].completed) {
                          showRestTimerSheet(context, initialSeconds: 90);
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Catatan latihan...',
                      isDense: true,
                    ),
                    onChanged: (v) {
                      log.notes = v;
                      _persist();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _finishWorkout,
            child: const Text('Finish Workout'),
          ),
        ),
      ),
    );
  }

  Future<void> _openYoutube(String query) async {
    final uri = Uri.parse(
        'https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _OverloadBanner extends StatelessWidget {
  final OverloadSuggestion suggestion;
  final String unitLabel;

  const _OverloadBanner({required this.suggestion, required this.unitLabel});

  @override
  Widget build(BuildContext context) {
    if (suggestion.previousWeight == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Target: ${suggestion.targetRepRange} reps · belum ada data sebelumnya',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: suggestion.suggestIncrease
            ? AppColors.gold.withValues(alpha: 0.12)
            : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            suggestion.suggestIncrease
                ? Icons.trending_up_rounded
                : Icons.repeat_rounded,
            size: 16,
            color: suggestion.suggestIncrease
                ? AppColors.gold
                : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Minggu lalu: ${suggestion.previousWeight} $unitLabel × ${suggestion.previousReps}  →  '
              'Target: ${suggestion.targetWeight.toStringAsFixed(1)} $unitLabel × ${suggestion.targetRepRange}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color:
                    suggestion.suggestIncrease ? AppColors.gold : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
