import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(allSessionsProvider).where((s) => s.finished).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final weights = ref.watch(allWeightsProvider);
    final streak = ref.watch(currentStreakProvider);

    final totalSets = sessions.fold<int>(0, (sum, s) => sum + s.totalSetsCompleted);
    final totalVolume = sessions.fold<double>(0, (sum, s) => sum + s.totalVolume);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Progress'),
            floating: true,
            backgroundColor: AppColors.background,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    _MetricTile(label: 'Total Latihan', value: '${sessions.length}'),
                    const SizedBox(width: 12),
                    _MetricTile(label: 'Total Set', value: '$totalSets'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _MetricTile(
                        label: 'Total Volume',
                        value: '${totalVolume.toStringAsFixed(0)} kg'),
                    const SizedBox(width: 12),
                    _MetricTile(label: 'Streak', value: '$streak hari'),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Grafik Berat Badan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: weights.length < 2
                      ? const _EmptyChartHint(text: 'Tambahkan minimal 2 data berat badan')
                      : _LineChart(
                          spots: weights
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value.weightKg))
                              .toList(),
                        ),
                ),
                const SizedBox(height: 24),
                const Text('Grafik Volume Latihan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: sessions.length < 2
                      ? const _EmptyChartHint(text: 'Selesaikan minimal 2 sesi latihan')
                      : _LineChart(
                          spots: sessions
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value.totalVolume))
                              .toList(),
                        ),
                ),
                const SizedBox(height: 24),
                const Text('Riwayat Latihan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ...sessions.reversed.take(10).map((s) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(s.dayName),
                        subtitle: Text(
                            '${s.date.day}/${s.date.month}/${s.date.year} · ${s.totalSetsCompleted} sets · ${s.totalVolume.toStringAsFixed(0)} kg'),
                        trailing: Text('${s.durationMinutes} min',
                            style: const TextStyle(color: AppColors.textSecondary)),
                      ),
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  const _MetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  final List<FlSpot> spots;
  const _LineChart({required this.spots});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.gold,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.gold.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChartHint extends StatelessWidget {
  final String text;
  const _EmptyChartHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: const TextStyle(color: AppColors.textSecondary)),
    );
  }
}
