import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/program_data.dart';
import 'workout_session_screen.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todayIndex = DateTime.now().weekday - 1;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Program Latihan'),
            floating: true,
            backgroundColor: AppColors.background,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.separated(
              itemCount: ProgramData.week.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final day = ProgramData.week[i];
                final isToday = i == todayIndex;
                return _DayCard(day: day, isToday: isToday);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final ProgramDay day;
  final bool isToday;

  const _DayCard({required this.day, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isToday
            ? const BorderSide(color: AppColors.gold, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: day.isRest
            ? () => _showRecoverySheet(context, day)
            : () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorkoutSessionScreen(day: day),
                  ),
                ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(day.dayOfWeek,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 13)),
                        if (isToday) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('HARI INI',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(day.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    if (!day.isRest)
                      Text('${day.exercises.length} exercises',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              Icon(
                day.isRest
                    ? Icons.self_improvement_rounded
                    : Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRecoverySheet(BuildContext context, ProgramDay day) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(day.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            const Text('Recovery Checklist',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            ...day.recoveryChecklist.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        color: AppColors.gold, size: 20),
                    const SizedBox(width: 10),
                    Text(item),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
