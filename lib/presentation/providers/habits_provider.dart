import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/data/database/database.dart';
import 'package:habitly/data/database/tables/habits_table.dart';

// All habits stream provider
final allHabitsProvider = StreamProvider<List<Habit>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.habitsDao.watchAllHabits();
});

// Habit by ID provider
final habitByIdProvider = FutureProvider.family<Habit?, int>((ref, habitId) async {
  final db = ref.watch(databaseProvider);
  return db.habitsDao.getHabit(habitId);
});

// Habit completions for a date provider
final completionsForDateProvider = StreamProvider.family<List<HabitCompletion>, String>((ref, date) {
  final db = ref.watch(databaseProvider);
  return db.habitsDao.watchCompletionsForDate(date);
});

// Streak for a habit provider
final habitStreakProvider = FutureProvider.family<int, int>((ref, habitId) async {
  final db = ref.watch(databaseProvider);
  return db.habitsDao.calculateStreak(habitId);
});

// Best streak for a habit provider
final habitBestStreakProvider = FutureProvider.family<int, int>((ref, habitId) async {
  final db = ref.watch(databaseProvider);
  return db.habitsDao.calculateBestStreak(habitId);
});

// Categories provider
final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.categoriesDao.watchAllCategories();
});

// Habit notifier for mutations
final habitNotifierProvider = Provider<HabitNotifier>((ref) {
  final db = ref.watch(databaseProvider);
  return HabitNotifier(db);
});

class HabitNotifier {
  final AppDatabase _db;

  HabitNotifier(this._db);

  Future<int> createHabit({
    required String name,
    String? description,
    String icon = 'check_circle',
    int color = 0xFF6750A4,
    int? categoryId,
    String frequencyType = 'daily',
    String? frequencyDays,
    int targetCount = 1,
    bool reminderEnabled = false,
    String? reminderTime,
  }) async {
    return _db.habitsDao.insertHabit(
      HabitsCompanion.insert(
        name: name,
        description: Value(description),
        icon: Value(icon),
        color: Value(color),
        categoryId: Value(categoryId),
        frequencyType: Value(FrequencyType.values.firstWhere((e) => e.name == frequencyType)),
        frequencyDays: Value(frequencyDays),
        targetCount: Value(targetCount),
        reminderEnabled: Value(reminderEnabled),
        reminderTime: Value(reminderTime),
      ),
    );
  }

  Future<void> completeHabit(int habitId, String date, {bool skipped = false}) async {
    await _db.habitsDao.completeHabit(habitId, date, skipped: skipped);
  }

  Future<void> uncompleteHabit(int habitId, String date) async {
    await _db.habitsDao.uncompleteHabit(habitId, date);
  }

  Future<void> archiveHabit(int id) async {
    await _db.habitsDao.archiveHabit(id);
  }

  Future<void> deleteHabit(int id) async {
    await _db.habitsDao.deleteHabit(id);
  }
}
