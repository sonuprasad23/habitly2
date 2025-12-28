import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly/data/database/database.dart';

// All habits stream provider
final allHabitsProvider = StreamProvider<List<Habit>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllHabits();
});

// Habit by ID provider
final habitByIdProvider = FutureProvider.family<Habit?, int>((ref, habitId) async {
  final db = ref.watch(databaseProvider);
  return db.getHabit(habitId);
});

// Habit completions for a date provider
final completionsForDateProvider = StreamProvider.family<List<HabitCompletion>, String>((ref, date) {
  final db = ref.watch(databaseProvider);
  return db.watchCompletionsForDate(date);
});

// Streak for a habit provider
final habitStreakProvider = FutureProvider.family<int, int>((ref, habitId) async {
  final db = ref.watch(databaseProvider);
  return db.calculateStreak(habitId);
});

// Best streak for a habit provider
final habitBestStreakProvider = FutureProvider.family<int, int>((ref, habitId) async {
  final db = ref.watch(databaseProvider);
  return db.calculateBestStreak(habitId);
});

// Categories provider
final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllCategories();
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
    FrequencyType frequencyType = FrequencyType.daily,
    String? frequencyDays,
    int targetCount = 1,
    bool reminderEnabled = false,
    String? reminderTime,
  }) async {
    return _db.insertHabit(
      HabitsCompanion.insert(
        name: name,
        description: Value(description),
        icon: Value(icon),
        color: Value(color),
        categoryId: Value(categoryId),
        frequencyType: Value(frequencyType),
        frequencyDays: Value(frequencyDays),
        targetCount: Value(targetCount),
        reminderEnabled: Value(reminderEnabled),
        reminderTime: Value(reminderTime),
      ),
    );
  }

  Future<void> completeHabit(int habitId, String date, {bool skipped = false}) async {
    await _db.completeHabit(habitId, date, skipped: skipped);
  }

  Future<void> uncompleteHabit(int habitId, String date) async {
    await _db.uncompleteHabit(habitId, date);
  }

  Future<void> archiveHabit(int id) async {
    await _db.archiveHabit(id);
  }

  Future<void> deleteHabit(int id) async {
    await _db.deleteHabit(id);
  }
}
