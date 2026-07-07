import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/workout_models.dart';

/// A single editable row representing one working set: weight input,
/// reps input, and a completion checkbox.
class ExerciseSetRow extends StatefulWidget {
  final int setIndex;
  final SetLog setLog;
  final String unitLabel; // "kg" or "lbs"
  final VoidCallback onChanged;
  final VoidCallback onCompletedToggled;

  const ExerciseSetRow({
    super.key,
    required this.setIndex,
    required this.setLog,
    required this.unitLabel,
    required this.onChanged,
    required this.onCompletedToggled,
  });

  @override
  State<ExerciseSetRow> createState() => _ExerciseSetRowState();
}

class _ExerciseSetRowState extends State<ExerciseSetRow> {
  late final TextEditingController _weightController;
  late final TextEditingController _repsController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.setLog.weightKg == 0 ? '' : widget.setLog.weightKg.toString(),
    );
    _repsController = TextEditingController(
      text: widget.setLog.reps == 0 ? '' : widget.setLog.reps.toString(),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = widget.setLog.completed;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${widget.setIndex + 1}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: widget.unitLabel,
                isDense: true,
              ),
              onChanged: (v) {
                widget.setLog.weightKg = double.tryParse(v) ?? 0;
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'reps', isDense: true),
              onChanged: (v) {
                widget.setLog.reps = int.tryParse(v) ?? 0;
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: widget.onCompletedToggled,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: done ? AppColors.gold : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.check,
                color: done ? Colors.black : AppColors.textDisabled,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
