import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/calculations.dart';
import '../../../data/models/workout_models.dart';
import '../../providers/providers.dart';

class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({super.key});

  @override
  ConsumerState<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends ConsumerState<NutritionScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(nutritionProfileProvider);
    final targets = Calculations.computeTargets(profile);
    final waterMl = ref.watch(todayWaterProvider);
    const waterGoalMl = 3000;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Nutrition',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Profil', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  _NumberField(
                    label: 'Berat Badan (kg)',
                    initial: profile.weightKg,
                    onSubmit: (v) => _updateProfile(profile.copyWithField(weightKg: v)),
                  ),
                  const SizedBox(height: 10),
                  _NumberField(
                    label: 'Tinggi Badan (cm)',
                    initial: profile.heightCm,
                    onSubmit: (v) => _updateProfile(profile.copyWithField(heightCm: v)),
                  ),
                  const SizedBox(height: 10),
                  _NumberField(
                    label: 'Umur',
                    initial: profile.age.toDouble(),
                    onSubmit: (v) => _updateProfile(profile.copyWithField(age: v.toInt())),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Jenis Kelamin', style: TextStyle(color: AppColors.textSecondary)),
                      const Spacer(),
                      SegmentedButton<Gender>(
                        segments: const [
                          ButtonSegment(value: Gender.male, label: Text('Pria')),
                          ButtonSegment(value: Gender.female, label: Text('Wanita')),
                        ],
                        selected: {profile.gender},
                        onSelectionChanged: (s) =>
                            _updateProfile(profile.copyWithField(gender: s.first)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<ActivityLevel>(
                    value: profile.activityLevel,
                    decoration: const InputDecoration(labelText: 'Level Aktivitas'),
                    items: const [
                      DropdownMenuItem(value: ActivityLevel.sedentary, child: Text('Sedentary')),
                      DropdownMenuItem(value: ActivityLevel.light, child: Text('Ringan')),
                      DropdownMenuItem(value: ActivityLevel.moderate, child: Text('Sedang')),
                      DropdownMenuItem(value: ActivityLevel.active, child: Text('Aktif')),
                      DropdownMenuItem(value: ActivityLevel.veryActive, child: Text('Sangat Aktif')),
                    ],
                    onChanged: (v) {
                      if (v != null) _updateProfile(profile.copyWithField(activityLevel: v));
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Target Harian', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  _TargetRow(label: 'BMR', value: '${targets.bmr.toStringAsFixed(0)} kkal'),
                  _TargetRow(label: 'TDEE', value: '${targets.tdee.toStringAsFixed(0)} kkal'),
                  _TargetRow(
                      label: 'Target Kalori',
                      value: '${targets.calorieTarget.toStringAsFixed(0)} kkal',
                      highlight: true),
                  _TargetRow(label: 'Protein', value: '${targets.proteinGrams.toStringAsFixed(0)} g'),
                  _TargetRow(label: 'Karbohidrat', value: '${targets.carbsGrams.toStringAsFixed(0)} g'),
                  _TargetRow(label: 'Lemak', value: '${targets.fatGrams.toStringAsFixed(0)} g'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Air Minum Hari Ini', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (waterMl / waterGoalMl).clamp(0, 1),
                    backgroundColor: AppColors.surfaceElevated,
                    color: AppColors.info,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 8),
                  Text('$waterMl / $waterGoalMl ml',
                      style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: [200, 350, 500].map((ml) {
                      return OutlinedButton(
                        onPressed: () async {
                          await ref.read(workoutRepositoryProvider).addWater(ml);
                          notifyDataChanged(ref);
                        },
                        child: Text('+$ml ml'),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateProfile(NutritionProfile updated) async {
    await ref.read(workoutRepositoryProvider).saveNutritionProfile(updated);
    notifyDataChanged(ref);
  }
}

class _TargetRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _TargetRow({required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: highlight ? AppColors.gold : AppColors.textPrimary,
              )),
        ],
      ),
    );
  }
}

class _NumberField extends StatefulWidget {
  final String label;
  final double initial;
  final ValueChanged<double> onSubmit;
  const _NumberField({required this.label, required this.initial, required this.onSubmit});

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial.toStringAsFixed(0));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: widget.label),
      onSubmitted: (v) {
        final parsed = double.tryParse(v);
        if (parsed != null) widget.onSubmit(parsed);
      },
      onTapOutside: (_) {
        final parsed = double.tryParse(_controller.text);
        if (parsed != null) widget.onSubmit(parsed);
      },
    );
  }
}

/// Small helper extension so the nutrition screen can update the immutable
/// profile snapshot without a full builder class.
extension NutritionProfileCopy on NutritionProfile {
  NutritionProfile copyWithField({
    double? weightKg,
    double? heightCm,
    int? age,
    Gender? gender,
    ActivityLevel? activityLevel,
  }) {
    return NutritionProfile(
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}
