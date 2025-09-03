import 'dart:convert';

class Reminder {
  final String day;
  final String activity; // ✅ act -> activity (match karne ke liye)

  final String time;

  Reminder({
    required this.day,
    required this.activity,
    required this.time,
  });

  @override
  String toString() {
    return 'Reminder{day: $day, activity: $activity, time: $time}';
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'activity': activity,
      'time': time,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      day: map['day'],
      activity: map['activity'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Reminder.fromJson(String source) =>
      Reminder.fromMap(json.decode(source));
}
