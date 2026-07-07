import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../screens/home/home_screen.dart';
import '../screens/workout/workout_list_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/nutrition/nutrition_screen.dart';
import '../screens/settings/settings_screen.dart';

class MainNavShell extends ConsumerWidget {
  const MainNavShell({super.key});

  static const _screens = [
    HomeScreen(),
    WorkoutListScreen(),
    ProgressScreen(),
    NutritionScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);

    return Scaffold(
      body: IndexedStack(index: index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) =>
            ref.read(navIndexProvider.notifier).state = i,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.fitness_center_rounded), label: 'Workout'),
          NavigationDestination(
              icon: Icon(Icons.show_chart_rounded), label: 'Progress'),
          NavigationDestination(
              icon: Icon(Icons.restaurant_rounded), label: 'Nutrition'),
          NavigationDestination(
              icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}
