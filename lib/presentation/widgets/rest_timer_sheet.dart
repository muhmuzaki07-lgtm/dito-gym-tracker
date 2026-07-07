import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../providers/rest_timer_provider.dart';

/// Shows a modal bottom sheet with a circular countdown and preset
/// duration buttons (60/90/120/180s), matching the spec.
void showRestTimerSheet(BuildContext context, {int initialSeconds = 90}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => RestTimerSheet(initialSeconds: initialSeconds),
  );
}

class RestTimerSheet extends ConsumerStatefulWidget {
  final int initialSeconds;
  const RestTimerSheet({super.key, this.initialSeconds = 90});

  @override
  ConsumerState<RestTimerSheet> createState() => _RestTimerSheetState();
}

class _RestTimerSheetState extends ConsumerState<RestTimerSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(restTimerProvider.notifier).start(widget.initialSeconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(restTimerProvider);
    final minutes = timerState.remainingSeconds ~/ 60;
    final seconds = timerState.remainingSeconds % 60;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Rest Timer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: timerState.progress,
                    strokeWidth: 8,
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.gold),
                  ),
                ),
                Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            children: [60, 90, 120, 180].map((preset) {
              return OutlinedButton(
                onPressed: () =>
                    ref.read(restTimerProvider.notifier).start(preset),
                child: Text('${preset}s'),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      ref.read(restTimerProvider.notifier).addTime(15),
                  child: const Text('+15s'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(restTimerProvider.notifier).stop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Skip'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
