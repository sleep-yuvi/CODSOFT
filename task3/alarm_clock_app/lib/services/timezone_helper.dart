import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneHelper {
  static Future<void> initializeTimeZones() async {
    tz.initializeTimeZones();
    final String localTimeZone = await tz.local.name;
    tz.setLocalLocation(tz.getLocation(localTimeZone));
  }
}
