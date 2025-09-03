import 'package:flutter/material.dart';
import 'package:habbittracker_app/reminder_model.dart';

import 'local_stored.dart';

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

  const DayOfWeek(this.label,);
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

  const Activities(this.label,);
  final String label;
}
TextEditingController? get dayController => null;
TextEditingController? get actController => null;
TimeOfDay? selectedTime;

final day = dayController!.text;
final act = actController!.text;
final times = selectedTime != null
    ? "${selectedTime!.hour}:${selectedTime!.minute}"
    : "";


class _CreatingTaskState extends State<CreatingTask> {
  var time = selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('habit tracker'),
        ),
        body: Container(
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownMenu<DayOfWeek>(
                    initialSelection: DayOfWeek.monday,
                    controller: dayController,
                    requestFocusOnTap: true,
                    label: const Text('Day'),
                    onSelected: (DayOfWeek? color) {
                      setState(() {
                        var selectedColor = color;
                      });
                    },
                    dropdownMenuEntries: DayOfWeek.values
                        .map<DropdownMenuEntry<DayOfWeek>>(
                            (DayOfWeek color) {
                          return DropdownMenuEntry<DayOfWeek>(
                            value: color,
                            label: color.label,
                            enabled: color.label != 'Grey',
                            style: MenuItemButton.styleFrom(
                              foregroundColor: Colors.greenAccent,
                            ),
                          );
                        }).toList(),
                  ),
                  DropdownMenu<Activities>(
                    initialSelection: Activities.wake,
                    controller: actController,
                    requestFocusOnTap: false,
                    label: const Text('Action'),
                    onSelected: (Activities? label) {
                      setState(() {
                        var selectedLabel= label;
                        print(selectedLabel?.label);
                      });
                    },
                    dropdownMenuEntries: Activities.values
                        .map<DropdownMenuEntry<Activities>>(
                            (Activities label) {
                          return DropdownMenuEntry<Activities>(
                            value: label,
                            label: label.label,
                            enabled: label.label != 'Wake',
                            style: MenuItemButton.styleFrom(
                              foregroundColor: Colors.greenAccent,
                            ),
                          );
                        }).toList(),
                  ),

                ],
              ),
              Text(
                time == null ? "You haven't picked a time yet." : time!.format(context),
              ),
              ElevatedButton.icon(
                label:Text('Select Time'),
                onPressed: () async {
                    var pickedTime = await showTimePicker(
                      context: context,
                      initialEntryMode: TimePickerEntryMode.dial,
                      initialTime: TimeOfDay.now(),
                    );

                    setState(() {
                      selectedTime = pickedTime;
                    });
                  },
                  icon: Icon(Icons.watch_later_rounded),

              ),

              ElevatedButton(
                onPressed: () async {
                  Reminder reminder = Reminder(
                    day: dayController!.text,
                    activity: actController?.text,
                    time: selectedTime != null
                        ? "${selectedTime!.hour}:${selectedTime!.minute}"
                        : "", act: '',
                  );

                  await saveReminder(reminder);

                  ScaffoldMessenger.of(context).showMaterialBanner(
                    MaterialBanner(
                      content: Text("Reminder Saved in SharedPreferences ✅"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                          },
                          child: Text("Dismiss"),
                        ),
                      ],
                  ));
                  Navigator.pop(context);
                },
                child: Text("Save Reminder"),
              )
            ],
          ),
        ));
  }
}
