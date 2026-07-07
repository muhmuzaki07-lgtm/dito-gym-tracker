import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  static const _workoutReminderId = 1001;
  static const _waterReminderIdBase = 2000;

  Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(initSettings);

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleDailyWorkoutReminder({int hour = 17, int minute = 0}) async {
    await _plugin.zonedSchedule(
      _workoutReminderId,
      'Waktunya Latihan!',
      'Jangan lupa cek program hari ini di Dito Gym Tracker.',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'workout_reminder',
          'Workout Reminder',
          channelDescription: 'Pengingat jadwal latihan harian',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelWorkoutReminder() async {
    await _plugin.cancel(_workoutReminderId);
  }

  Future<void> scheduleWaterReminders() async {
    const hours = [9, 12, 15, 18, 21];
    for (var i = 0; i < hours.length; i++) {
      await _plugin.zonedSchedule(
        _waterReminderIdBase + i,
        'Minum Air',
        'Sudah waktunya minum air untuk menjaga performa latihanmu.',
        _nextInstanceOfTime(hours[i], 0),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'water_reminder',
            'Water Reminder',
            channelDescription: 'Pengingat minum air',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelWaterReminders() async {
    for (var i = 0; i < 5; i++) {
      await _plugin.cancel(_waterReminderIdBase + i);
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
