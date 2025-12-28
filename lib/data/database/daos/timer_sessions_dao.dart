import 'package:drift/drift.dart';
import 'package:habitly/data/database/database.dart';
import 'package:habitly/data/database/tables/timer_sessions_table.dart';

part 'timer_sessions_dao.g.dart';

@DriftAccessor(tables: [TimerSessions])
class TimerSessionsDao extends DatabaseAccessor<AppDatabase> with _$TimerSessionsDaoMixin {
  TimerSessionsDao(super.db);

  // Get all completed sessions for today
  Stream<List<TimerSession>> watchTodaySessions(DateTime today) {
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return (select(timerSessions)
          ..where((s) =>
              s.startedAt.isBiggerOrEqualValue(startOfDay) &
              s.startedAt.isSmallerThanValue(endOfDay))
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .watch();
  }

  // Get sessions for a date range
  Future<List<TimerSession>> getSessionsInRange(DateTime start, DateTime end) {
    return (select(timerSessions)
          ..where((s) =>
              s.startedAt.isBiggerOrEqualValue(start) &
              s.startedAt.isSmallerThanValue(end))
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .get();
  }

  // Get total time spent today
  Future<int> getTotalTimeToday(DateTime today) async {
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final sessions = await (select(timerSessions)
          ..where((s) =>
              s.startedAt.isBiggerOrEqualValue(startOfDay) &
              s.startedAt.isSmallerThanValue(endOfDay) &
              s.completed.equals(true)))
        .get();
    
    return sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
  }

  // Get sessions by type
  Stream<List<TimerSession>> watchSessionsByType(TimerType type) {
    return (select(timerSessions)
          ..where((s) => s.timerType.equals(type.name))
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .watch();
  }

  // Start a new session
  Future<int> startSession(TimerSessionsCompanion session) {
    return into(timerSessions).insert(session);
  }

  // Complete a session
  Future<int> completeSession(int id, int actualDuration) {
    return (update(timerSessions)..where((s) => s.id.equals(id))).write(
      TimerSessionsCompanion(
        durationSeconds: Value(actualDuration),
        endedAt: Value(DateTime.now()),
        completed: const Value(true),
      ),
    );
  }

  // Cancel a session
  Future<int> cancelSession(int id) {
    return (update(timerSessions)..where((s) => s.id.equals(id))).write(
      TimerSessionsCompanion(
        endedAt: Value(DateTime.now()),
        completed: const Value(false),
      ),
    );
  }

  // Delete a session
  Future<int> deleteSession(int id) {
    return (delete(timerSessions)..where((s) => s.id.equals(id))).go();
  }
}
