import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/equipment.dart';
import '../../data/datasources/exercise_library.dart';
import '../../data/datasources/program_data.dart';

/// Shows a bottom sheet listing alternative exercises for the same muscle
/// group, filtered by available equipment. Returns the chosen
/// [ExercisePrescription], or null if the person dismissed the sheet.
Future<ExercisePrescription?> showExerciseSwapSheet(
  BuildContext context, {
  required ExercisePrescription current,
  required Set<Equipment> availableEquipment,
}) {
  return showModalBottomSheet<ExercisePrescription>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _ExerciseSwapSheet(
      current: current,
      availableEquipment: availableEquipment,
    ),
  );
}

class _ExerciseSwapSheet extends StatelessWidget {
  final ExercisePrescription current;
  final Set<Equipment> availableEquipment;

  const _ExerciseSwapSheet({
    required this.current,
    required this.availableEquipment,
  });

  @override
  Widget build(BuildContext context) {
    final candidates = ExerciseLibrary.recommend(
      current: current,
      availableEquipment: availableEquipment,
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ganti "${current.name}"',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text(
                'Rekomendasi berdasarkan kelompok otot yang sama dan equipment yang tersedia.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: candidates.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada alternatif dengan equipment yang tersedia saat ini.\nCoba tambahkan equipment di menu Available Equipment.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        itemCount: candidates.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final ex = candidates[i];
                          return Card(
                            child: ListTile(
                              title: Text(ex.name,
                                  style: const TextStyle(fontWeight: FontWeight.w700)),
                              subtitle: Text(
                                  '${ex.primaryMuscle} · ${ex.equipment.label} · ${ex.difficulty.label}'),
                              trailing: const Icon(Icons.chevron_right_rounded,
                                  color: AppColors.textSecondary),
                              onTap: () => Navigator.of(context).pop(ex),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
