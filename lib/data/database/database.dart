import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:habitly/core/constants/app_constants.dart';

// Include table definitions directly
part 'database.g.dart';

// Enums
enum FrequencyType { daily, weekly, custom }
enum TaskPriority { low, medium, high }
enum GoalType { shortTerm, longTerm }
enum TimerType { reading, exercise, focus, custom }

// ========== TABLES ==========

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get icon => text().withLength(min: 1, max: 50)();
  IntColumn get color => integer().withDefault(const Constant(0xFF6750A4))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@DataClassName('Habit')
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().withDefault(const Constant('check_circle'))();
  IntColumn get color => integer().withDefault(const Constant(0xFF6750A4))();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  IntColumn get frequencyType => intEnum<FrequencyType>().withDefault(const Constant(0))();
  TextColumn get frequencyDays => text().nullable()();
  IntColumn get targetCount => integer().withDefault(const Constant(1))();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get reminderTime => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@DataClassName('HabitCompletion')
class HabitCompletions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();
  TextColumn get completedDate => text()();
  IntColumn get completionCount => integer().withDefault(const Constant(1))();
  DateTimeColumn get completedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().nullable()();
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [{habitId, completedDate}];
}

@DataClassName('Task')
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get dueTime => text().nullable()();
  IntColumn get priority => intEnum<TaskPriority>().withDefault(const Constant(1))();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurrenceRule => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
}

@DataClassName('Goal')
class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  IntColumn get goalType => intEnum<GoalType>().withDefault(const Constant(0))();
  TextColumn get targetDate => text().nullable()();
  RealColumn get progressPercentage => real().withDefault(const Constant(0.0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

@DataClassName('GoalLink')
class GoalLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer().references(Goals, #id)();
  IntColumn get habitId => integer().nullable().references(Habits, #id)();
  IntColumn get taskId => integer().nullable().references(Tasks, #id)();
}

@DataClassName('TimerSession')
class TimerSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get timerType => intEnum<TimerType>()();
  IntColumn get linkedHabitId => integer().nullable().references(Habits, #id)();
  IntColumn get durationSeconds => integer()();
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get endedAt => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
}

// ========== DATABASE PROVIDER ==========

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database must be initialized in main.dart');
});

// ========== DATABASE CLASS ==========

@DriftDatabase(tables: [
  Categories,
  Habits,
  HabitCompletions,
  Tasks,
  Goals,
  GoalLinks,
  TimerSessions,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => AppConstants.databaseVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedDefaultCategories();
      },
    );
  }

  // ========== HABITS DAO METHODS ==========

  Stream<List<Habit>> watchAllHabits() {
    return (select(habits)
          ..where((h) => h.archivedAt.isNull())
          ..orderBy([(h) => OrderingTerm.asc(h.sortOrder)]))
        .watch();
  }

  Future<Habit?> getHabit(int id) {
    return (select(habits)..where((h) => h.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertHabit(HabitsCompanion habit) {
    return into(habits).insert(habit);
  }

  Future<int> archiveHabit(int id) {
    return (update(habits)..where((h) => h.id.equals(id))).write(
      HabitsCompanion(archivedAt: Value(DateTime.now())),
    );
  }

  Future<int> deleteHabit(int id) {
    return (delete(habits)..where((h) => h.id.equals(id))).go();
  }

  Stream<List<HabitCompletion>> watchCompletionsForDate(String date) {
    return (select(habitCompletions)..where((c) => c.completedDate.equals(date))).watch();
  }

  Future<HabitCompletion?> getCompletion(int habitId, String date) {
    return (select(habitCompletions)
          ..where((c) => c.habitId.equals(habitId) & c.completedDate.equals(date)))
        .getSingleOrNull();
  }

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

  Future<int> uncompleteHabit(int habitId, String date) {
    return (delete(habitCompletions)
          ..where((c) => c.habitId.equals(habitId) & c.completedDate.equals(date)))
        .go();
  }

  Future<int> calculateStreak(int habitId) async {
    final completionsList = await (select(habitCompletions)
          ..where((c) => c.habitId.equals(habitId) & c.skipped.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.completedDate)]))
        .get();

    if (completionsList.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();
    
    final todayStr = _formatDate(checkDate);
    final hasCompletedToday = completionsList.any((c) => c.completedDate == todayStr);
    if (!hasCompletedToday) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    for (int i = 0; i < 365; i++) {
      final dateStr = _formatDate(checkDate);
      final hasCompletion = completionsList.any((c) => c.completedDate == dateStr);
      
      if (hasCompletion) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Future<int> calculateBestStreak(int habitId) async {
    final completionsList = await (select(habitCompletions)
          ..where((c) => c.habitId.equals(habitId) & c.skipped.equals(false))
          ..orderBy([(c) => OrderingTerm.asc(c.completedDate)]))
        .get();

    if (completionsList.isEmpty) return 0;

    int bestStreak = 1;
    int currentStreak = 1;
    
    for (int i = 1; i < completionsList.length; i++) {
      final prevDate = DateTime.parse(completionsList[i - 1].completedDate);
      final currDate = DateTime.parse(completionsList[i].completedDate);
      final diff = currDate.difference(prevDate).inDays;
      
      if (diff == 1) {
        currentStreak++;
        if (currentStreak > bestStreak) bestStreak = currentStreak;
      } else if (diff > 1) {
        currentStreak = 1;
      }
    }

    return bestStreak;
  }

  // ========== CATEGORIES DAO METHODS ==========

  Stream<List<Category>> watchAllCategories() {
    return (select(categories)..orderBy([(c) => OrderingTerm.asc(c.sortOrder)])).watch();
  }

  Future<int> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  // ========== TIMER SESSIONS DAO METHODS ==========

  Stream<List<TimerSession>> watchTodaySessions(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(timerSessions)
          ..where((s) => s.startedAt.isBiggerOrEqualValue(startOfDay) & s.startedAt.isSmallerThanValue(endOfDay)))
        .watch();
  }

  Future<int> startSession(TimerSessionsCompanion session) {
    return into(timerSessions).insert(session);
  }

  Future<void> completeSession(int sessionId, int actualDuration) async {
    await (update(timerSessions)..where((s) => s.id.equals(sessionId))).write(
      TimerSessionsCompanion(
        endedAt: Value(DateTime.now()),
        completed: const Value(true),
        durationSeconds: Value(actualDuration),
      ),
    );
  }

  Future<void> cancelSession(int sessionId) async {
    await (delete(timerSessions)..where((s) => s.id.equals(sessionId))).go();
  }

  Future<int> getTotalTimeToday(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final sessions = await (select(timerSessions)
          ..where((s) => s.startedAt.isBiggerOrEqualValue(startOfDay) & 
                         s.startedAt.isSmallerThanValue(endOfDay) & 
                         s.completed.equals(true)))
        .get();
    return sessions.fold(0, (sum, s) => sum + s.durationSeconds);
  }

  // ========== TASKS DAO METHODS ==========

  Stream<List<Task>> watchIncompleteTasks() {
    return (select(tasks)
          ..where((t) => t.completedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]))
        .watch();
  }

  Future<int> insertTask(TasksCompanion task) {
    return into(tasks).insert(task);
  }

  Future<void> completeTask(int taskId) async {
    await (update(tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(completedAt: Value(DateTime.now())),
    );
  }

  // ========== EXPORT / SEED METHODS ==========

  Future<Map<String, dynamic>> exportData() async {
    final allCategories = await select(categories).get();
    final allHabits = await select(habits).get();
    final allCompletions = await select(habitCompletions).get();
    final allTasks = await select(tasks).get();
    final allGoals = await select(goals).get();
    final allGoalLinks = await select(goalLinks).get();
    final allTimerSessions = await select(timerSessions).get();

    return {
      'categories': allCategories.map((c) => c.toJson()).toList(),
      'habits': allHabits.map((h) => h.toJson()).toList(),
      'habitCompletions': allCompletions.map((c) => c.toJson()).toList(),
      'tasks': allTasks.map((t) => t.toJson()).toList(),
      'goals': allGoals.map((g) => g.toJson()).toList(),
      'goalLinks': allGoalLinks.map((l) => l.toJson()).toList(),
      'timerSessions': allTimerSessions.map((s) => s.toJson()).toList(),
    };
  }

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(goalLinks).go();
      await delete(goals).go();
      await delete(timerSessions).go();
      await delete(habitCompletions).go();
      await delete(habits).go();
      await delete(tasks).go();
      await delete(categories).go();
      await _seedDefaultCategories();
    });
  }

  Future<void> _seedDefaultCategories() async {
    final defaultCategories = [
      CategoriesCompanion.insert(name: 'Health & Fitness', icon: 'fitness_center', color: const Value(0xFF4CAF50), isDefault: const Value(true), sortOrder: const Value(0)),
      CategoriesCompanion.insert(name: 'Learning & Growth', icon: 'school', color: const Value(0xFF2196F3), isDefault: const Value(true), sortOrder: const Value(1)),
      CategoriesCompanion.insert(name: 'Work & Productivity', icon: 'work', color: const Value(0xFFFF9800), isDefault: const Value(true), sortOrder: const Value(2)),
      CategoriesCompanion.insert(name: 'Mind & Wellness', icon: 'self_improvement', color: const Value(0xFF9C27B0), isDefault: const Value(true), sortOrder: const Value(3)),
      CategoriesCompanion.insert(name: 'Home & Life', icon: 'home', color: const Value(0xFF795548), isDefault: const Value(true), sortOrder: const Value(4)),
      CategoriesCompanion.insert(name: 'Finance', icon: 'account_balance_wallet', color: const Value(0xFF009688), isDefault: const Value(true), sortOrder: const Value(5)),
    ];

    for (final category in defaultCategories) {
      await into(categories).insert(category);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
