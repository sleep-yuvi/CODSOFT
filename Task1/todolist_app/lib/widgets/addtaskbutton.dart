import 'package:flutter/material.dart';
import 'package:todolist_app/main.dart';

class NewTaskInitiatorButton extends StatelessWidget {
  const NewTaskInitiatorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, 'add_task'),
      backgroundColor: accentHighlight,
      child: const Icon(Icons.add, color: Colors.white),
      tooltip: 'Add New Task',
    );
  }
}
