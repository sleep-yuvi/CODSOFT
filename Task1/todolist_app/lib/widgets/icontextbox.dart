import 'package:todolist_app/main.dart' as main; 
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIconInputField extends StatefulWidget { 
  final String placeholderText;
  final String iconPath;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const CustomIconInputField({
    super.key,
    required this.placeholderText,
    required this.iconPath,
    required this.controller,
    this.onChanged,
  });

  @override
  State<CustomIconInputField> createState() => _CustomIconInputFieldState(); 
}

class _CustomIconInputFieldState extends State<CustomIconInputField> { 
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: main.appPrimaryDark),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(width: 1.0, color: main.inputBorderShade),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(width: 2.0, color: main.accentHighlight),
        ),
        hintText: widget.placeholderText,
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: main.auxiliaryTextTone),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            widget.iconPath,
            height: 18,
            width: 18,
            colorFilter: ColorFilter.mode(
              _isFocused ? main.accentHighlight : main.secondaryIconTint,
              BlendMode.srcIn,
            ),
          ),
        ),
        contentPadding: main.getFormElementContentPadding(context), 
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}