import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alarm.dart';

class AlarmStorage {
  static const _key = 'alarms';

  Future<void> saveAlarms(List<Alarm> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = alarms.map((a) => jsonEncode(a.toMap())).toList();
    await prefs.setStringList(_key, encoded);
  }

  Future<List<Alarm>> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(_key);
    if (encoded == null) return [];
    return encoded
        .map((e) => Alarm.fromMap(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }
}
