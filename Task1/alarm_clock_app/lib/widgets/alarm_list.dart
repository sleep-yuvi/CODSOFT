import 'package:flutter/material.dart';
import '../models/alarm.dart';

class AlarmList extends StatelessWidget {
  final List<Alarm> alarms;

  const AlarmList({super.key, required this.alarms});

  @override
  Widget build(BuildContext context) {
    if (alarms.isEmpty) {
      return const Center(child: Text('No alarms set'));
    }

    return ListView.builder(
      itemCount: alarms.length,
      itemBuilder: (context, index) {
        final alarm = alarms[index];
        final repeatText = alarm.repeatDaily
            ? 'Everyday'
            : alarm.repeatDays.asMap().entries.where((e) => e.value).map((e) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return days[e.key];
              }).join(', ');

        return ListTile(
          title: Text(alarm.timeString),
          subtitle: Text('Repeats: $repeatText'),
          trailing: Switch(
            value: alarm.isActive,
            onChanged: (val) {
            },
          ),
        );
      },
    );
  }
}
