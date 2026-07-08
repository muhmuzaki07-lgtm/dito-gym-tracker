import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/equipment.dart';
import '../../providers/providers.dart';

/// Lets the person mark which equipment is available at their gym.
/// Exercises requiring unavailable equipment get auto-substituted when a
/// workout session starts.
class EquipmentScreen extends ConsumerWidget {
  const EquipmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final available = settings.availableEquipment.toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Available Equipment')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pilih alat yang tersedia di gym kamu. Latihan yang butuh alat '
            'yang tidak tersedia akan otomatis diganti dengan alternatif '
            'yang setara.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: Equipment.values.map((eq) {
                final isOn = available.contains(eq.name);
                return SwitchListTile(
                  title: Text(eq.label),
                  value: isOn,
                  onChanged: (v) async {
                    final updated = {...available};
                    if (v) {
                      updated.add(eq.name);
                    } else {
                      updated.remove(eq.name);
                    }
                    settings.availableEquipment = updated.toList();
                    await ref.read(workoutRepositoryProvider).saveSettings(settings);
                    notifyDataChanged(ref);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
