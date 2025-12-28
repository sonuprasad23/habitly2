import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/core/constants/app_constants.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError('NotificationService must be initialized in main.dart');
});

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _createNotificationChannels();
    _isInitialized = true;
  }

  Future<void> _createNotificationChannels() async {
    const reminderChannel = AndroidNotificationChannel(
      AppConstants.reminderChannelId,
      AppConstants.reminderChannelName,
      description: 'Habit reminder notifications',
      importance: Importance.high,
    );

    const timerChannel = AndroidNotificationChannel(
      AppConstants.timerChannelId,
      AppConstants.timerChannelName,
      description: 'Timer notifications',
      importance: Importance.high,
    );

    const achievementChannel = AndroidNotificationChannel(
      AppConstants.achievementChannelId,
      AppConstants.achievementChannelName,
      description: 'Achievement notifications',
      importance: Importance.defaultImportance,
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(reminderChannel);
    await androidPlugin?.createNotificationChannel(timerChannel);
    await androidPlugin?.createNotificationChannel(achievementChannel);
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap - navigate to relevant screen
    // This will be connected to the router in a real implementation
  }

  // Schedule a habit reminder
  Future<void> scheduleHabitReminder({
    required int habitId,
    required String habitName,
    required int hour,
    required int minute,
    required List<int> daysOfWeek,
  }) async {
    for (final day in daysOfWeek) {
      final notificationId = habitId * 10 + day;
      
      await _plugin.zonedSchedule(
        notificationId,
        'Time for your habit!',
        habitName,
        _nextInstanceOfWeekdayTime(day, hour, minute),
        NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.reminderChannelId,
            AppConstants.reminderChannelName,
            icon: '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'habit:$habitId',
      );
    }
  }

  // Cancel habit reminders
  Future<void> cancelHabitReminders(int habitId) async {
    for (int day = 1; day <= 7; day++) {
      await _plugin.cancel(habitId * 10 + day);
    }
  }

  // Show timer completion notification
  Future<void> showTimerComplete(String timerType, int durationMinutes) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Timer Complete! 🎉',
      'Your $timerType session of $durationMinutes minutes is done.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.timerChannelId,
          AppConstants.timerChannelName,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  // Show achievement notification
  Future<void> showAchievement(String title, String message) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.achievementChannelId,
          AppConstants.achievementChannelName,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  // Show streak milestone
  Future<void> showStreakMilestone(String habitName, int streakDays) async {
    await showAchievement(
      '🔥 Streak Milestone!',
      'Congratulations! You\'ve reached $streakDays days on "$habitName"!',
    );
  }

  tz.TZDateTime _nextInstanceOfWeekdayTime(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  // Request notification permissions (Android 13+)
  Future<bool> requestPermissions() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    return await androidPlugin?.requestNotificationsPermission() ?? false;
  }
}
