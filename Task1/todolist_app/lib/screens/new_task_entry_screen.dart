import 'package:flutter/material.dart';
import 'package:todolist_app/main.dart' as main;
import 'package:todolist_app/widgets/backarrow.dart';
import 'package:todolist_app/widgets/setreminder.dart';
import 'package:todolist_app/widgets/spacing.dart';

class NewTaskEntryScreen extends StatefulWidget {
  const NewTaskEntryScreen({super.key});

  @override
  State<NewTaskEntryScreen> createState() => _NewTaskEntryScreenState();
}

class _NewTaskEntryScreenState extends State<NewTaskEntryScreen> {
  String _taskTitleInput = '';
  String _taskDescriptionInput = '';
  String _selectedDateInput = '';
  String _selectedTimeInput = '';

  final TextEditingController titleFieldController = TextEditingController();
  final TextEditingController descriptionFieldController = TextEditingController();
  final TextEditingController dateFieldController = TextEditingController();
  final TextEditingController timeFieldController = TextEditingController();

  void _submitTask() {
    final newTask = {
      'title': _taskTitleInput,
      'description': _taskDescriptionInput,
      'date': _selectedDateInput,
      'time': _selectedTimeInput,
    };

    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: main.canvasBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: main.calculateScreenVerticalPadding(context),
              horizontal: main.calculateScreenHorizontalPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CustomBackButton(),
                    const SizedBox(width: 10),
                    Text(
                      "Craft Your New Task",
                      style: Theme.of(context).textTheme.headlineLarge,
                    )
                  ],
                ),
                const VerticalSpacerStandard(),
                const TaskReminderToggle(),
                const VerticalSpacerStandard(),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Details of Your Endeavor", style: Theme.of(context).textTheme.labelMedium),
                ),
                const VerticalSpacerSmall(),
                TextField(
                  controller: titleFieldController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(45.0)),
                    hintText: "Task Title",
                    prefixIcon: Icon(Icons.title_outlined, color: main.secondaryIconTint),
                    contentPadding: main.getFormElementContentPadding(context),
                  ),
                  onChanged: (value) => setState(() => _taskTitleInput = value),
                ),
                const VerticalSpacerSmall(),
                TextField(
                  controller: descriptionFieldController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(45.0)),
                    hintText: "Elaborate on your task (optional)",
                    prefixIcon: Icon(Icons.description_outlined, color: main.secondaryIconTint),
                    contentPadding: main.getFormElementContentPadding(context),
                  ),
                  onChanged: (value) => setState(() => _taskDescriptionInput = value),
                ),
                const VerticalSpacerStandard(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Scheduling Your Commitment", style: Theme.of(context).textTheme.labelMedium),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: dateFieldController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(45.0)),
                    hintText: "Select Completion Date",
                    prefixIcon: Icon(Icons.calendar_month_outlined, color: main.secondaryIconTint),
                    contentPadding: main.getFormElementContentPadding(context),
                  ),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      final dateString = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      setState(() {
                        _selectedDateInput = dateString;
                        dateFieldController.text = dateString;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: timeFieldController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(45.0)),
                    hintText: "Select Specific Time",
                    prefixIcon: Icon(Icons.access_time_outlined, color: main.secondaryIconTint),
                    contentPadding: main.getFormElementContentPadding(context),
                  ),
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      final timeString = pickedTime.format(context);
                      setState(() {
                        _selectedTimeInput = timeString;
                        timeFieldController.text = timeString;
                      });
                    }
                  },
                ),
                const VerticalSpacerStandard(),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: main.appPrimaryDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 50),
                    ),
                    child: Text(
                      "Commit Task",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: main.canvasBackground),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleFieldController.dispose();
    descriptionFieldController.dispose();
    dateFieldController.dispose();
    timeFieldController.dispose();
    super.dispose();
  }
}
