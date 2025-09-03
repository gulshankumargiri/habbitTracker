import 'package:habbittracker_app/reminder_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveReminder(Reminder reminder) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> reminders =
      prefs.getStringList('reminders') ?? [];
  reminders.add(reminder.toJson());

  await prefs.setStringList('reminders', reminders);
}
