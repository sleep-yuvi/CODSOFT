import 'package:flutter/material.dart';
import 'package:todolist_app/main.dart' as main;

class TaskModificationScreen extends StatefulWidget {
  final Map<String, String> task;
  final int index;

  const TaskModificationScreen({super.key, required this.task, required this.index});

  @override
  State<TaskModificationScreen> createState() => _TaskModificationScreenState();
}

class _TaskModificationScreenState extends State<TaskModificationScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dateController;
  late TextEditingController timeController;

  String selectedDate = '';
  String selectedTime = '';

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.task['title']);
    descriptionController = TextEditingController(text: widget.task['description']);
    dateController = TextEditingController(text: widget.task['date']);
    timeController = TextEditingController(text: widget.task['time']);

    selectedDate = widget.task['date'] ?? '';
    selectedTime = widget.task['time'] ?? '';
  }

  void _submitEdits() {
    final updatedTask = {
      'title': titleController.text,
      'description': descriptionController.text,
      'date': selectedDate,
      'time': selectedTime,
    };

    Navigator.pop(context, updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: main.canvasBackground,
      appBar: AppBar(
        backgroundColor: main.canvasBackground,
        elevation: 0,
        title: Text(
          'Edit Task',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
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
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(45.0)),
                    hintText: "Task Title",
                    prefixIcon: Icon(Icons.title_outlined, color: main.secondaryIconTint),
                    contentPadding: main.getFormElementContentPadding(context),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(45.0)),
                    hintText: "Task Description",
                    prefixIcon: Icon(Icons.description_outlined, color: main.secondaryIconTint),
                    contentPadding: main.getFormElementContentPadding(context),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dateController,
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
                      initialDate: selectedDate.isNotEmpty
                          ? DateTime.parse(_parseDateString(selectedDate))
                          : DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      final dateString = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      setState(() {
                        selectedDate = dateString;
                        dateController.text = dateString;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(45.0)),
                    hintText: "Select Specific Time",
                    prefixIcon: Icon(Icons.access_time_outlined, color: main.secondaryIconTint),
                    contentPadding: main.getFormElementContentPadding(context),
                  ),
                  onTap: () async {
                    final initialTime = selectedTime.isNotEmpty
                        ? _parseTimeOfDay(selectedTime)
                        : TimeOfDay.now();
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: initialTime,
                    );
                    if (pickedTime != null) {
                      final timeString = pickedTime.format(context);
                      setState(() {
                        selectedTime = timeString;
                        timeController.text = timeString;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitEdits,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: main.appPrimaryDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 50),
                    ),
                    child: Text(
                      "Save Changes",
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

  String _parseDateString(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return "${parts[2].padLeft(4, '0')}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}";
      }
      return dateStr;
    } catch (_) {
      return dateStr;
    }
  }

  TimeOfDay _parseTimeOfDay(String timeStr) {
    final format = TimeOfDayFormat.h_colon_mm_space_a; 
    try {
      final time = TimeOfDay(
        hour: 0,
        minute: 0,
      );

      final regExp = RegExp(r'(\d+):(\d+) (\w{2})');
      final match = regExp.firstMatch(timeStr);
      if (match != null) {
        int hour = int.parse(match.group(1)!);
        int minute = int.parse(match.group(2)!);
        final ampm = match.group(3)!;

        if (ampm.toLowerCase() == 'pm' && hour != 12) {
          hour += 12;
        } else if (ampm.toLowerCase() == 'am' && hour == 12) {
          hour = 0;
        }

        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (_) {}
    return TimeOfDay.now();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }
}
