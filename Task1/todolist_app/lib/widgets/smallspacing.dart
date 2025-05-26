import 'package:flutter/material.dart';

class VerticalSpacerSmall extends StatelessWidget {
  const VerticalSpacerSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.01);
  }
}
