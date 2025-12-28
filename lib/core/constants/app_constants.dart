class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Habitly';
  static const String appVersion = '1.0.0';

  // Animation Durations
  static const Duration quickAnimation = Duration(milliseconds: 100);
  static const Duration standardAnimation = Duration(milliseconds: 250);
  static const Duration emphasisAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // Streak Milestones
  static const List<int> streakMilestones = [7, 14, 30, 60, 90, 180, 365];

  // Timer Presets (in minutes)
  static const int readingTimerDefault = 30;
  static const int exerciseTimerDefault = 45;
  static const int focusTimerDefault = 25;
  static const int pomodoroBreakShort = 5;
  static const int pomodoroBreakLong = 15;

  // Database
  static const String databaseName = 'habitly.db';
  static const int databaseVersion = 1;

  // Notification Channels
  static const String reminderChannelId = 'habit_reminders';
  static const String reminderChannelName = 'Habit Reminders';
  static const String timerChannelId = 'timer_notifications';
  static const String timerChannelName = 'Timer Notifications';
  static const String achievementChannelId = 'achievements';
  static const String achievementChannelName = 'Achievements';

  // Export/Import
  static const String exportFileName = 'habitly_backup';
  static const String exportFileExtension = 'json';

  // Retroactive Completion Limit (days)
  static const int retroactiveCompletionDays = 7;
}
