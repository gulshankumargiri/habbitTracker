import 'dart:convert';

class Reminder{
  final String day;
  final String act;
  final String time;

  Reminder( {
    required this.day ,
    required this.act ,
    required this.time, String? activity,
});

  @override
  String toString() {
    return 'Reminder{day: $day, act: $act, time: $time}';
  }
Map<String,dynamic> toMap(){
    return {
      'day':day,
      'activity':act,
      'time':time,
    };
}

factory Reminder.fromMap(Map<String,dynamic> map){
    return Reminder(
      day:map['day'],
      act:map['activity'],
      time:map['time'],
    );
}
  String toJson() => json.encode(toMap());

  factory Reminder.fromJson(String source) =>
      Reminder.fromMap(json.decode(source));
}