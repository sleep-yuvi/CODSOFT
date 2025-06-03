import 'package:flutter/material.dart';
import '../models/alarm.dart';
import '../screens/set_alarm_screen.dart';
import '../services/alarm_scheduler.dart';
import '../services/alarm_storage.dart';
import '../main.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Alarm> alarms = [];
  late AlarmScheduler _alarmScheduler;
  final AlarmStorage _alarmStorage = AlarmStorage();

  @override
  void initState() {
    super.initState();
    _alarmScheduler = AlarmScheduler(flutterLocalNotificationsPlugin);
    _alarmScheduler.init();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final loadedAlarms = await _alarmStorage.loadAlarms();
    setState(() {
      alarms = loadedAlarms;
    });

    for (var alarm in alarms) {
      if (alarm.isActive) {
        await _alarmScheduler.scheduleAlarm(alarm);
      }
    }
  }

  Future<void> _saveAlarms() async {
    await _alarmStorage.saveAlarms(alarms);
  }

  Future<void> _addAlarm() async {
    final newAlarm = await Navigator.push<Alarm>(
      context,
      MaterialPageRoute(builder: (_) => const SetAlarmScreen()),
    );
    if (newAlarm != null) {
      setState(() {
        alarms.add(newAlarm);
      });
      await _alarmScheduler.scheduleAlarm(newAlarm);
      await _saveAlarms();
    }
  }

  Future<void> _toggleAlarm(Alarm alarm) async {
    setState(() {
      alarm.isActive = !alarm.isActive;
    });
    if (alarm.isActive) {
      await _alarmScheduler.scheduleAlarm(alarm);
    } else {
      await _alarmScheduler.cancelAlarm(alarm);
    }
    await _saveAlarms();
  }

  Future<void> _deleteAlarm(Alarm alarm) async {
    setState(() {
      alarms.remove(alarm);
    });
    await _alarmScheduler.cancelAlarm(alarm);
    await _saveAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alarm App')),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          final alarm = alarms[index];
          return ListTile(
            title: Text(alarm.timeString),
            subtitle: Text(alarm.repeatDaily
                ? 'Repeats daily'
                : alarm.repeatDaysString),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: alarm.isActive,
                  onChanged: (_) => _toggleAlarm(alarm),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteAlarm(alarm),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
