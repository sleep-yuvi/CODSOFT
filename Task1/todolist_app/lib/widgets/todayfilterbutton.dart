import 'package:flutter/material.dart';
import 'package:todolist_app/main.dart';

class TaskFilterAndDateDisplay extends StatelessWidget {
  const TaskFilterAndDateDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = "${now.day}/${now.month}/${now.year}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Today: $date", style: Theme.of(context).textTheme.bodyMedium),
        IconButton(
          icon: Icon(Icons.filter_list_outlined, color: secondaryIconTint),
          tooltip: 'Filter Tasks',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Filter options coming soon!')),
            );
          },
        ),
      ],
    );
  }
}
