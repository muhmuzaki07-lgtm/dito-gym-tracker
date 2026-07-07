import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/program_data.dart';
import '../../providers/providers.dart';
import '../workout/workout_session_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final today = ProgramData.todayProgram();
    final streak = ref.watch(currentStreakProvider);
    final latestWeight = ref.watch(latestWeightProvider);
    final sessions = ref.watch(allSessionsProvider);

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekSessions = sessions.where((s) =>
        s.finished &&
        s.date.isAfter(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day)));
    final trainingDaysThisWeek =
        ProgramData.week.where((d) => !d.isRest).length;
    final completedThisWeek = weekSessions.length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Halo, ${settings.userName} 👋',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            _formattedToday(),
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // Today's workout card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Today's Workout",
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(
                    today.title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.gold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    today.isRest
                        ? 'Recovery day - jaga konsistensi!'
                        : '${today.exercises.length} exercises',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Stat row: weekly progress / streak / weight
          Row(
            children: [
              _StatCard(
                label: 'Progress Minggu Ini',
                value: '$completedThisWeek/$trainingDaysThisWeek',
                icon: Icons.calendar_month_rounded,
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: 'Workout Streak',
                value: '$streak hari',
                icon: Icons.local_fire_department_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StatCard(
            label: 'Berat Badan Terakhir',
            value: latestWeight == null
                ? 'Belum ada data'
                : '${latestWeight.weightKg.toStringAsFixed(1)} kg',
            icon: Icons.monitor_weight_rounded,
            fullWidth: true,
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: today.isRest
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WorkoutSessionScreen(day: today),
                        ),
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(today.isRest ? 'Rest Day' : 'Start Workout'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formattedToday() {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final now = DateTime.now();
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool fullWidth;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.gold, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(height: 2),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return fullWidth ? content : Expanded(child: content);
  }
}
