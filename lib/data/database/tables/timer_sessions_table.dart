import 'package:drift/drift.dart';
import 'package:habitly/data/database/tables/habits_table.dart';

enum TimerType { reading, exercise, focus, custom }

class TimerSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get timerType => textEnum<TimerType>()();
  IntColumn get linkedHabitId => integer().nullable().references(Habits, #id)();
  IntColumn get durationSeconds => integer()();
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get endedAt => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
}
