import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todolist_app/main.dart' as main; 

class CustomBackButton extends StatelessWidget { 
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.045,
        width: MediaQuery.of(context).size.width * 0.12,
        padding: EdgeInsets.symmetric(
          horizontal: main.calculateScreenHorizontalPadding(context) / 2, 
        ),
        decoration: BoxDecoration(
          color: main.appPrimaryDark, 
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: SvgPicture.asset(
          "assets/back.svg", 
          height: MediaQuery.of(context).size.height * 0.015, 
          colorFilter: ColorFilter.mode(main.canvasBackground, BlendMode.srcIn), 
        ),
      ),
    );
  }
}