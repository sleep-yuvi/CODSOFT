import 'package:flutter/material.dart';


class AppHeaderSection extends StatelessWidget {
  const AppHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Today's Goals",
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}
