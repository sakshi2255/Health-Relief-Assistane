import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 1. Initialize Timezone Database
    tz.initializeTimeZones();

    // 2. Set App Icon for Notifications
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    // 3. Initialize the Plugin
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // This handles what happens when a user taps the notification
        print("Notification tapped: ${details.id}");
      },
    );

    // 4. Create the Notification Channel (Crucial for Android 8.0+)
    // This tells Android "This app has a Workout category that is very important"
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'workout_channel', // id
      'Workout Reminders', // title
      description: 'Notifications for your scheduled exercise sessions',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 5. 🚨 REQUEST PERMISSIONS (Required for Android 13+ / Realme UI)
    final platform = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (platform != null) {
      // Triggers the "Allow Notifications" system popup
      await platform.requestNotificationsPermission();
      // Triggers the "Exact Alarm" system permission
      await platform.requestExactAlarmsPermission();
    }
  }

  static Future<void> scheduleNotification(int id, String timeString) async {
    try {
      // Parse "07:00 AM" or "07:00 PM" to a 24-hour DateTime
      final parts = timeString.split(RegExp(r'[:\s]'));
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      if (timeString.toUpperCase().contains("PM") && hour != 12) hour += 12;
      if (timeString.toUpperCase().contains("AM") && hour == 12) hour = 0;

      final now = DateTime.now();
      var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

      // If the time already passed today, schedule it for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notifications.zonedSchedule(
        id,
        "Time for Relief",
        "Your scheduled exercise session is ready! Let's get moving.",
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'workout_channel', // Matches the channel ID created in init()
            'Workout Reminders',
            channelDescription: 'Scheduled workout alerts',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true, // Helps bypass lockscreen on some devices
            category: AndroidNotificationCategory.alarm,
          ),
        ),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Repeats daily
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      print("Notification scheduled for: $scheduledDate with ID: $id");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
    print("Notification $id cancelled");
  }
}