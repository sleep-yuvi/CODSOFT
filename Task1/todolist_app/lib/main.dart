import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist_app/screens/new_task_entry_screen.dart';
import 'package:todolist_app/screens/task_dashboard_screen.dart';
import 'package:todolist_app/screens/settings_page.dart';

Color appPrimaryDark = const Color(0xff0c120c);
Color accentHighlight = const Color(0xff4285F4);
Color canvasBackground = const Color(0xffFDFDFF);
Color secondaryIconTint = const Color(0xff565656);
Color inputBorderShade = const Color(0xffD6D6D6);
Color auxiliaryTextTone = const Color(0xff565656);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: canvasBackground,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: canvasBackground,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: canvasBackground,
  ));
  runApp(const MomentumApp());
}

class MomentumApp extends StatelessWidget {
  const MomentumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TaskDashboardScreen(),
      theme: ThemeData(
        fontFamily: 'Inter',
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: appPrimaryDark),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: appPrimaryDark),
          bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: appPrimaryDark),
          labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: auxiliaryTextTone),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: appPrimaryDark),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: auxiliaryTextTone),
          bodySmall: TextStyle(fontSize: 12, color: auxiliaryTextTone),
        ),
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => const TaskDashboardScreen(),
        'add_task': (context) => const NewTaskEntryScreen(),
        'settings': (context) => const ApplicationPreferencesScreen(),
      },
    );
  }
}

double calculateScreenVerticalPadding(BuildContext context) => MediaQuery.of(context).size.height / 20;
double calculateScreenHorizontalPadding(BuildContext context) => MediaQuery.of(context).size.width / 20;

EdgeInsets getFormElementContentPadding(BuildContext context) {
  return EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * 0.1,
    vertical: MediaQuery.of(context).size.height * 0.025,
  );
}
