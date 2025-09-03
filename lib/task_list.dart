import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habbittracker_app/creating_task.dart';
import 'package:habbittracker_app/main.dart';
import 'package:habbittracker_app/reminder_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TaskList extends StatefulWidget {
 const TaskList({super.key,});

  @override
  State<TaskList> createState() => _TaskListState();
}
Future<void> deleteReminder(int index) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> reminders = prefs.getStringList('reminders') ?? [];
  reminders.removeAt(index);
  await prefs.setStringList('reminders', reminders);
}
Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails =
  AndroidNotificationDetails(
    'reminder_channel',
    'Reminders',
    channelDescription: 'Reminder Notifications',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );

  const NotificationDetails details = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    details,
  );
}

Future<void> scheduleNotification(
    String title, String body, TimeOfDay time) async {
  final now = DateTime.now();
  final scheduledDate = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    title,
    body,
    tz.TZDateTime.from(scheduledDate, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Reminder Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    ),
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time, // daily repeat
  );
}

Future<List<Reminder>> getReminders() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> reminders =
      prefs.getStringList('reminders') ?? [];

  return reminders.map((e) => Reminder.fromJson(e)).toList();
}
class _TaskListState extends State<TaskList> {


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Tasks'),
      centerTitle: true,
    ),
    floatingActionButton: IconButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatingTask()));
        },
        icon:  Icon(Icons.add)),
    body:
    Container(
      child: FutureBuilder(
        future: getReminders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final reminders = snapshot.data!;
          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final r = reminders[index];
              return ListTile(
                title: Text(r.act),
                subtitle: Text("${r.day} at ${r.time}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await deleteReminder(index);
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
    )
  );
  }
  }

