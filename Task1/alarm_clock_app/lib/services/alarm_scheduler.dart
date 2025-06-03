import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/alarm.dart';

class AlarmScheduler {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  AlarmScheduler(this.flutterLocalNotificationsPlugin);

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (response) {
      },
    );
  }

  Future<void> scheduleAlarm(Alarm alarm) async {
    await flutterLocalNotificationsPlugin.cancel(alarm.id.hashCode);

    if (!alarm.isActive) return;

    if (alarm.repeatDaily) {
      await _scheduleDaily(alarm);
    } else if (alarm.repeatDays.contains(true)) {
      await _scheduleWeekly(alarm);
    } else {
      await _scheduleOneTime(alarm);
    }
  }

  Future<void> _scheduleOneTime(Alarm alarm) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, alarm.hour, alarm.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      alarm.id.hashCode,
      'Alarm',
      'It\'s time! ${alarm.timeString}',
      scheduledDate,
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'alarm_channel', 'Alarm Notifications',
              channelDescription: 'Channel for Alarm notifications',
              importance: Importance.max,
              priority: Priority.high,
              fullScreenIntent: true,
              playSound: true,
              sound: RawResourceAndroidNotificationSound('alarm_sound')),
          iOS: DarwinNotificationDetails(sound: 'alarm_sound.aiff')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _scheduleDaily(Alarm alarm) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, alarm.hour, alarm.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      alarm.id.hashCode,
      'Daily Alarm',
      'It\'s time! ${alarm.timeString}',
      scheduledDate,
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily_alarm_channel', 'Daily Alarm Notifications',
              channelDescription: 'Channel for daily alarm notifications',
              importance: Importance.max,
              priority: Priority.high,
              fullScreenIntent: true,
              playSound: true,
              sound: RawResourceAndroidNotificationSound('alarm_sound')),
          iOS: DarwinNotificationDetails(sound: 'alarm_sound.aiff')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleWeekly(Alarm alarm) async {
    final now = tz.TZDateTime.now(tz.local);
    for (int i = 0; i < 7; i++) {
      if (!alarm.repeatDays[i]) continue;

      int currentWeekday = now.weekday % 7; 
      int daysToAdd = (i - currentWeekday + 7) % 7;
      if (daysToAdd == 0) {
        var scheduledDate = tz.TZDateTime(
            tz.local, now.year, now.month, now.day, alarm.hour, alarm.minute);
        if (scheduledDate.isBefore(now)) {
          daysToAdd = 7;
        }
      }
      var scheduledDate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day + daysToAdd,
          alarm.hour,
          alarm.minute);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        (alarm.id + i.toString()).hashCode,
        'Weekly Alarm',
        'It\'s time! ${alarm.timeString} on ${_weekdayName(i)}',
        scheduledDate,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'weekly_alarm_channel', 'Weekly Alarm Notifications',
                channelDescription: 'Channel for weekly alarm notifications',
                importance: Importance.max,
                priority: Priority.high,
                fullScreenIntent: true,
                playSound: true,
                sound: RawResourceAndroidNotificationSound('alarm_sound')),
            iOS: DarwinNotificationDetails(sound: 'alarm_sound.aiff')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  String _weekdayName(int i) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[i];
  }

  Future<void> cancelAlarm(Alarm alarm) async {
    await flutterLocalNotificationsPlugin.cancel(alarm.id.hashCode);
  }
}
