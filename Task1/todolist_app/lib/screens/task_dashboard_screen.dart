import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_app/main.dart' as main;
import 'package:todolist_app/screens/settings_page.dart';
import 'package:todolist_app/screens/task_modification_screen.dart';
import 'package:todolist_app/widgets/header.dart';
import 'package:todolist_app/widgets/spacing.dart';
import 'package:todolist_app/widgets/todayfilterbutton.dart';

class TaskDashboardScreen extends StatefulWidget {
  const TaskDashboardScreen({super.key});

  @override
  State<TaskDashboardScreen> createState() => _TaskDashboardScreenState();
}

class _TaskDashboardScreenState extends State<TaskDashboardScreen> {
  List<Map<String, String>> _currentTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasksFromStorage();
  }

  Future<void> _loadTasksFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListString = prefs.getString('tasks');
    if (taskListString != null) {
      final List decoded = jsonDecode(taskListString);
      setState(() {
        _currentTasks = List<Map<String, String>>.from(decoded.map((e) => Map<String, String>.from(e)));
      });
    }
  }

  Future<void> _saveTasksToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(_currentTasks));
  }

  void _deleteTask(int index) async {
    setState(() {
      _currentTasks.removeAt(index);
    });
    await _saveTasksToStorage();
  }

  void _editTask(int index) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskModificationScreen(
          task: _currentTasks[index],
          index: index,
        ),
      ),
    );

    if (updatedTask != null && updatedTask is Map<String, String>) {
      setState(() {
        _currentTasks[index] = updatedTask;
      });
      await _saveTasksToStorage();
    }
  }

  void _addNewTask() async {
    final newTask = await Navigator.pushNamed(context, 'add_task');
    if (newTask != null && newTask is Map<String, String>) {
      setState(() {
        _currentTasks.add(newTask);
      });
      await _saveTasksToStorage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: main.canvasBackground,
      appBar: AppBar(
        backgroundColor: main.canvasBackground,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: SvgPicture.asset(
            "assets/trans_logo.svg",
            height: 24,
            width: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: main.secondaryIconTint,
              ),
              tooltip: 'Adjust Application Settings',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApplicationPreferencesScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        backgroundColor: main.accentHighlight,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: main.calculateScreenHorizontalPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeaderSection(),
              const TaskFilterAndDateDisplay(),
              const VerticalSpacerStandard(),
              Expanded(
                child: _currentTasks.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks yet! Tap the "+" button to add one.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: main.auxiliaryTextTone),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _currentTasks.length,
                        itemBuilder: (context, index) {
                          final task = _currentTasks[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(task['title'] ?? ''),
                              subtitle: (task['date'] != null &&
                                      task['date']!.isNotEmpty)
                                  ? Text(
                                      '${task['date']} ${task['time'] ?? ''}'
                                          .trim(),
                                    )
                                  : null,
                              trailing: Wrap(
                                spacing: 12,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: main.secondaryIconTint),
                                    onPressed: () => _editTask(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () => _deleteTask(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
