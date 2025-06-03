import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/alarm.dart';

class SetAlarmScreen extends StatefulWidget {
  const SetAlarmScreen({super.key});

  @override
  State<SetAlarmScreen> createState() => _SetAlarmScreenState();
}

class _SetAlarmScreenState extends State<SetAlarmScreen> {
  TimeOfDay? _selectedTime;
  bool _repeatDaily = false;
  List<bool> _selectedDays = List.filled(7, false);

  void _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _saveAlarm() {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select time')));
      return;
    }
    final id = const Uuid().v4();
    final alarm = Alarm(
      id: id,
      hour: _selectedTime!.hour,
      minute: _selectedTime!.minute,
      repeatDaily: _repeatDaily,
      repeatDays: _repeatDaily ? List.filled(7, true) : _selectedDays,
    );
    Navigator.pop(context, alarm);
  }

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Scaffold(
      appBar: AppBar(title: const Text('Set Alarm')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(_selectedTime == null
                  ? 'Pick Time'
                  : 'Time: ${_selectedTime!.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: _pickTime,
            ),
            SwitchListTile(
              title: const Text('Repeat Daily'),
              value: _repeatDaily,
              onChanged: (val) {
                setState(() {
                  _repeatDaily = val;
                  if (val) {
                    _selectedDays = List.filled(7, true);
                  }
                });
              },
            ),
            if (!_repeatDaily)
              Wrap(
                spacing: 6,
                children: List.generate(7, (i) {
                  return FilterChip(
                    label: Text(days[i]),
                    selected: _selectedDays[i],
                    onSelected: (val) {
                      setState(() {
                        _selectedDays[i] = val;
                      });
                    },
                  );
                }),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveAlarm,
              child: const Text('Save Alarm'),
            )
          ],
        ),
      ),
    );
  }
}
