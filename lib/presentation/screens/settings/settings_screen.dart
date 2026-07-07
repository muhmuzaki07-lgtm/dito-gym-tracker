import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/workout_models.dart';
import '../../providers/providers.dart';
import '../../../core/services/notification_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final sessions = ref.watch(allSessionsProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),

          _SectionCard(
            title: 'Tampilan',
            children: [
              const ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Dark Mode'),
                subtitle: Text('Selalu aktif secara default'),
                trailing: Icon(Icons.dark_mode_rounded, color: AppColors.gold),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Gunakan lbs'),
                subtitle: const Text('Matikan untuk menggunakan kg'),
                value: settings.useLbs,
                onChanged: (v) async {
                  settings.useLbs = v;
                  await ref.read(workoutRepositoryProvider).saveSettings(settings);
                  notifyDataChanged(ref);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          _SectionCard(
            title: 'Reminder',
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Reminder Latihan'),
                value: settings.reminderWorkout,
                onChanged: (v) async {
                  settings.reminderWorkout = v;
                  await ref.read(workoutRepositoryProvider).saveSettings(settings);
                  if (v) {
                    await NotificationService.instance.scheduleDailyWorkoutReminder();
                  } else {
                    await NotificationService.instance.cancelWorkoutReminder();
                  }
                  notifyDataChanged(ref);
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Reminder Minum Air'),
                value: settings.reminderWater,
                onChanged: (v) async {
                  settings.reminderWater = v;
                  await ref.read(workoutRepositoryProvider).saveSettings(settings);
                  if (v) {
                    await NotificationService.instance.scheduleWaterReminders();
                  } else {
                    await NotificationService.instance.cancelWaterReminders();
                  }
                  notifyDataChanged(ref);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          _SectionCard(
            title: 'Data',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.table_chart_rounded, color: AppColors.gold),
                title: const Text('Export CSV'),
                onTap: () => _exportCsv(context, sessions),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.gold),
                title: const Text('Export PDF'),
                onTap: () => _exportPdf(context, sessions),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.backup_rounded, color: AppColors.gold),
                title: const Text('Backup Data'),
                onTap: () => _backup(context, sessions),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('Dito Gym Tracker v1.0.0',
                style: const TextStyle(color: AppColors.textDisabled, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, List<WorkoutSession> sessions) async {
    final rows = <List<dynamic>>[
      ['Date', 'Day', 'Exercise', 'Set', 'Weight', 'Reps', 'Completed'],
    ];
    for (final s in sessions) {
      for (final ex in s.exercises) {
        for (var i = 0; i < ex.sets.length; i++) {
          final set = ex.sets[i];
          rows.add([
            '${s.date.year}-${s.date.month}-${s.date.day}',
            s.dayName,
            ex.exerciseName,
            i + 1,
            set.weightKg,
            set.reps,
            set.completed,
          ]);
        }
      }
    }
    final csvData = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/dito_gym_export.csv');
    await file.writeAsString(csvData);
    if (context.mounted) {
      await Share.shareXFiles([XFile(file.path)]);
    }
  }

  Future<void> _exportPdf(BuildContext context, List<WorkoutSession> sessions) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(text: 'Dito Gym Tracker - Riwayat Latihan'),
          pw.Table.fromTextArray(
            headers: ['Tanggal', 'Program', 'Set Selesai', 'Volume (kg)', 'Durasi (min)'],
            data: sessions
                .map((s) => [
                      '${s.date.day}/${s.date.month}/${s.date.year}',
                      s.dayName,
                      '${s.totalSetsCompleted}',
                      s.totalVolume.toStringAsFixed(0),
                      '${s.durationMinutes}',
                    ])
                .toList(),
          ),
        ],
      ),
    );
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/dito_gym_report.pdf');
    await file.writeAsBytes(await doc.save());
    if (context.mounted) {
      await Share.shareXFiles([XFile(file.path)]);
    }
  }

  Future<void> _backup(BuildContext context, List<WorkoutSession> sessions) async {
    final backupJson = jsonEncode({
      'sessions': sessions
          .map((s) => {
                'id': s.id,
                'date': s.date.toIso8601String(),
                'dayName': s.dayName,
                'finished': s.finished,
                'durationMinutes': s.durationMinutes,
                'exercises': s.exercises
                    .map((ex) => {
                          'exerciseName': ex.exerciseName,
                          'targetRepRange': ex.targetRepRange,
                          'notes': ex.notes,
                          'sets': ex.sets
                              .map((set) => {
                                    'weightKg': set.weightKg,
                                    'reps': set.reps,
                                    'completed': set.completed,
                                  })
                              .toList(),
                        })
                    .toList(),
              })
          .toList(),
    });
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/dito_gym_backup.json');
    await file.writeAsString(backupJson);
    if (context.mounted) {
      await Share.shareXFiles([XFile(file.path)]);
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
