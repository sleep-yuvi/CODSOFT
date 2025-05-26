import 'package:todolist_app/main.dart' as main; 
import 'package:flutter/material.dart';

class StandardTextInputField extends StatelessWidget { 
  final String placeholderText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const StandardTextInputField({
    super.key,
    required this.placeholderText,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: main.appPrimaryDark),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(width: 1.0, color: main.inputBorderShade)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(width: 2.0, color: main.accentHighlight)),
        hintText: placeholderText,
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: main.auxiliaryTextTone),
        contentPadding: main.getFormElementContentPadding(context), // Corrected call
      ),
    );
  }
}