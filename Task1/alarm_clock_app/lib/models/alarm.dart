class Alarm {
  final String id;
  final int hour;
  final int minute;
  bool isActive;
  bool repeatDaily;
  List<bool> repeatDays; 

  Alarm({
    required this.id,
    required this.hour,
    required this.minute,
    this.isActive = true,
    this.repeatDaily = false,
    List<bool>? repeatDays,
  }) : repeatDays = repeatDays ?? List.filled(7, false);

  String get timeString {
    final int displayHour = hour == 0 || hour == 12 ? 12 : hour % 12;
    final String minuteStr = minute.toString().padLeft(2, '0');
    final String period = hour < 12 ? 'AM' : 'PM';
    return '$displayHour:$minuteStr $period';
  }
  
  String get repeatDaysString {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<String> selectedDays = [];
    for (int i = 0; i < 7; i++) {
      if (repeatDays.length > i && repeatDays[i]) {
        selectedDays.add(dayNames[i]);
      }
    }
    if (selectedDays.isEmpty) return 'No repeat days';
    return selectedDays.join(', ');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'isActive': isActive,
      'repeatDaily': repeatDaily,
      'repeatDays': repeatDays,
    };
  }

  factory Alarm.fromMap(Map<String, dynamic> map) {
    return Alarm(
      id: map['id'] ?? '',
      hour: map['hour'] ?? 0,
      minute: map['minute'] ?? 0,
      isActive: map['isActive'] ?? true,
      repeatDaily: map['repeatDaily'] ?? false,
      repeatDays: List<bool>.from(map['repeatDays'] ?? List.filled(7, false)),
    );
  }
}
