import 'package:todolist_app/main.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TaskReminderToggle extends StatefulWidget { 
  const TaskReminderToggle({super.key});

  @override
  State<TaskReminderToggle> createState() => _TaskReminderToggleState(); 
}

class _TaskReminderToggleState extends State<TaskReminderToggle> { 
  bool _isReminderActive = false;

  @override
  Widget build(BuildContext context) {
    final Color buttonBackgroundColor = _isReminderActive ? accentHighlight : appPrimaryDark;
    final Color buttonTextColor = canvasBackground; 
    final Color iconColor = _isReminderActive ? appPrimaryDark : canvasBackground; 

    return Align(
      alignment: Alignment.centerLeft, 
      child: TextButton(
        onPressed: () {
          setState(() {
            _isReminderActive = !_isReminderActive; 
          });
          
          print('Reminder is now: ${_isReminderActive ? 'Active' : 'Inactive'}');
        },
        style: ButtonStyle( 
          padding: const MaterialStatePropertyAll(EdgeInsets.zero),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return accentHighlight.withOpacity(0.2); 
              }
              return null; 
            },
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.07, 
          width: MediaQuery.of(context).size.width * 0.45, 
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.065, 
          ),
          decoration: BoxDecoration(
            color: buttonBackgroundColor, 
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width), 
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, 
            children: [
              Text(
                _isReminderActive ? "Reminder Active" : "Set Reminder", 
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: buttonTextColor), 
              ),
              SvgPicture.asset(
                "assets/bell_white.svg", 
                height: MediaQuery.of(context).size.height * 0.02, 
                width: MediaQuery.of(context).size.height * 0.02, 
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}