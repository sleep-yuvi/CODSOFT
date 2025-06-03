import 'package:flutter/material.dart';

class AlarmRingingScreen extends StatelessWidget {
  final String alarmId;

  const AlarmRingingScreen({super.key, required this.alarmId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alarm Ringing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Alarm is ringing!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Dismiss'),
            ),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Snooze'),
            ),
          ],
        ),
      ),
    );
  }
}
