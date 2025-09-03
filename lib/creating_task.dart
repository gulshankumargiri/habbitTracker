import 'package:flutter/material.dart';
import 'package:habbittracker_app/local_stored.dart';
import 'package:habbittracker_app/reminder_model.dart';
import 'package:habbittracker_app/task_list.dart';

class CreatingTask extends StatefulWidget {
  const CreatingTask({super.key});

  @override
  State<CreatingTask> createState() => _CreatingTaskState();
}

enum DayOfWeek {
  sunday('Sunday'),
  monday('Monday'),
  tuesday('Tuesday'),
  wednesday('Wednesday'),
  thursday('Thursday'),
  friday('Friday'),
  saturday('Saturday');

  const DayOfWeek(this.label);
  final String label;
}

enum Activities {
  wake('Wake Up'),
  gym('Go To Gym'),
  breakfast('Breakfast'),
  meet('Meeting'),
  lunch('Lunch'),
  nap('Quick nap'),
  lib('Go To Library'),
  dinner('Dinner'),
  sleep('Go To Sleep');

  const Activities(this.label);
  final String label;
}

class _CreatingTaskState extends State<CreatingTask> {
  DayOfWeek? selectedDay;
  Activities? selectedActivity;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<DayOfWeek>(
                  value: selectedDay,
                  hint: const Text("Select Day"),
                  onChanged: (day) {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                  items: DayOfWeek.values.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.label),
                    );
                  }).toList(),
                ),
                DropdownButton<Activities>(
                  value: selectedActivity,
                  hint: const Text("Select Activity"),
                  onChanged: (act) {
                    setState(() {
                      selectedActivity = act;
                    });
                  },
                  items: Activities.values.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.label),
                    );
                  }).toList(),
                ),
              ],
            ),
            Text(
              selectedTime == null
                  ? "You haven't picked a time yet."
                  : selectedTime!.format(context),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.watch_later_rounded),
              label: const Text("Select Time"),
              onPressed: () async {
                var picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedDay != null &&
                    selectedActivity != null &&
                    selectedTime != null) {
                  final reminder = Reminder(
                    day: selectedDay!.label,
                    activity: selectedActivity!.label,
                    time:
                    "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                  );

                  // ✅ Save reminder
                  await saveReminder(reminder);

                  // ✅ Schedule notification with proper String args
                  await scheduleNotification(
                    selectedActivity!.label, // title
                    "Reminder for ${selectedDay!.label} at ${selectedTime!.format(context)}", // body
                    selectedTime!, // time
                  );


                  ScaffoldMessenger.of(context).showMaterialBanner(
                    MaterialBanner(
                      content: const Text("Reminder Saved ✅"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .hideCurrentMaterialBanner();
                          },
                          child: const Text("Dismiss"),
                        ),
                      ],
                    ),
                  );

                  // ✅ Close screen after delay
                  Future.delayed(const Duration(seconds: 1), () {
                    ScaffoldMessenger.of(context)
                        .hideCurrentMaterialBanner();
                    Navigator.pop(context);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please select all fields first ⚠️")),
                  );
                }
              },
              child: const Text("Save Reminder"),
            )
          ],
        ),
      ),
    );
  }
}
