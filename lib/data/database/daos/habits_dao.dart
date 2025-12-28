import 'package:drift/drift.dart';
import 'package:habitly/data/database/database.dart';
import 'package:habitly/data/database/tables/habits_table.dart';
import 'package:habitly/data/database/tables/habit_completions_table.dart';

part 'habits_dao.g.dart';

@DriftAccessor(tables: [Habits, HabitCompletions])
class HabitsDao extends DatabaseAccessor<AppDatabase> with _$HabitsDaoMixin {
  HabitsDao(super.db);

  // Get all active habits (not archived)
  Stream<List<Habit>> watchAllHabits() {
    return (select(habits)
          ..where((h) => h.archivedAt.isNull())
          ..orderBy([(h) => OrderingTerm.asc(h.sortOrder)]))
        .watch();
  }

  // Get habits by category
  Stream<List<Habit>> watchHabitsByCategory(int categoryId) {
    return (select(habits)
          ..where((h) => h.archivedAt.isNull() & h.categoryId.equals(categoryId))
          ..orderBy([(h) => OrderingTerm.asc(h.sortOrder)]))
        .watch();
  }

  // Get a single habit
  Future<Habit?> getHabit(int id) {
    return (select(habits)..where((h) => h.id.equals(id))).getSingleOrNull();
  }

  // Insert a new habit
  Future<int> insertHabit(HabitsCompanion habit) {
    return into(habits).insert(habit);
  }

  // Update a habit
  Future<bool> updateHabit(Habit habit) {
    return update(habits).replace(habit);
  }

  // Archive a habit
  Future<int> archiveHabit(int id) {
    return (update(habits)..where((h) => h.id.equals(id))).write(
      HabitsCompanion(archivedAt: Value(DateTime.now())),
    );
  }

  // Delete a habit permanently
  Future<int> deleteHabit(int id) {
    return (delete(habits)..where((h) => h.id.equals(id))).go();
  }

  // Get completions for a habit on a specific date
  Future<HabitCompletion?> getCompletion(int habitId, String date) {
    return (select(habitCompletions)
          ..where((c) => c.habitId.equals(habitId) & c.completedDate.equals(date)))
        .getSingleOrNull();
  }

  // Complete a habit for a date
  Future<void> completeHabit(int habitId, String date, {bool skipped = false}) async {
    final existing = await getCompletion(habitId, date);
    if (existing != null) {
      await (update(habitCompletions)..where((c) => c.id.equals(existing.id))).write(
        HabitCompletionsCompanion(
          completionCount: Value(existing.completionCount + 1),
          completedAt: Value(DateTime.now()),
          skipped: Value(skipped),
        ),
      );
    } else {
      await into(habitCompletions).insert(
        HabitCompletionsCompanion.insert(
          habitId: habitId,
          completedDate: date,
          completionCount: const Value(1),
          skipped: Value(skipped),
        ),
      );
    }
  }

  // Uncomplete a habit for a date
  Future<int> uncompleteHabit(int habitId, String date) {
    return (delete(habitCompletions)
          ..where((c) => c.habitId.equals(habitId) & c.completedDate.equals(date)))
        .go();
  }

  // Get completions for a habit in a date range
  Stream<List<HabitCompletion>> watchCompletions(int habitId, String startDate, String endDate) {
    return (select(habitCompletions)
          ..where((c) =>
              c.habitId.equals(habitId) &
              c.completedDate.isBiggerOrEqualValue(startDate) &
              c.completedDate.isSmallerOrEqualValue(endDate)))
        .watch();
  }

  // Get all completions for a date
  Stream<List<HabitCompletion>> watchCompletionsForDate(String date) {
    return (select(habitCompletions)..where((c) => c.completedDate.equals(date))).watch();
  }

  // Calculate current streak for a habit
  Future<int> calculateStreak(int habitId) async {
    final completions = await (select(habitCompletions)
          ..where((c) => c.habitId.equals(habitId) & c.skipped.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.completedDate)]))
        .get();

    if (completions.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();
    
    // Start from yesterday if today is not completed
    final todayStr = _formatDate(checkDate);
    final hasCompletedToday = completions.any((c) => c.completedDate == todayStr);
    if (!hasCompletedToday) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    for (int i = 0; i < 365; i++) {
      final dateStr = _formatDate(checkDate);
      final hasCompletion = completions.any((c) => c.completedDate == dateStr);
      
      if (hasCompletion) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  // Get best streak for a habit
  Future<int> calculateBestStreak(int habitId) async {
    final completions = await (select(habitCompletions)
          ..where((c) => c.habitId.equals(habitId) & c.skipped.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.completedDate)]))
        .get();

    if (completions.isEmpty) return 0;

    int bestStreak = 1;
    int currentStreak = 1;
    
    for (int i = 1; i < completions.length; i++) {
      final prevDate = DateTime.parse(completions[i - 1].completedDate);
      final currDate = DateTime.parse(completions[i].completedDate);
      final diff = currDate.difference(prevDate).inDays;
      
      if (diff == 1) {
        currentStreak++;
        if (currentStreak > bestStreak) {
          bestStreak = currentStreak;
        }
      } else if (diff > 1) {
        currentStreak = 1;
      }
    }

    return bestStreak;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
