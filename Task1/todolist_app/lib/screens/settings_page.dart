import 'package:flutter/material.dart';
import 'package:todolist_app/main.dart';

class ApplicationPreferencesScreen extends StatelessWidget {
  const ApplicationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvasBackground,
      appBar: AppBar(
        backgroundColor: canvasBackground,
        elevation: 0,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: secondaryIconTint),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: calculateScreenVerticalPadding(context),
          horizontal: calculateScreenHorizontalPadding(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: true,
              onChanged: (bool value) {
                
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: false,
              onChanged: (bool value) {
                
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
