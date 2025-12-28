import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:habitly/core/constants/app_constants.dart';
import 'package:habitly/data/database/tables/categories_table.dart';
import 'package:habitly/data/database/tables/habits_table.dart';
import 'package:habitly/data/database/tables/habit_completions_table.dart';
import 'package:habitly/data/database/tables/tasks_table.dart';
import 'package:habitly/data/database/tables/goals_table.dart';
import 'package:habitly/data/database/tables/goal_links_table.dart';
import 'package:habitly/data/database/tables/timer_sessions_table.dart';
import 'package:habitly/data/database/daos/habits_dao.dart';
import 'package:habitly/data/database/daos/categories_dao.dart';
import 'package:habitly/data/database/daos/tasks_dao.dart';
import 'package:habitly/data/database/daos/timer_sessions_dao.dart';

part 'database.g.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database must be initialized in main.dart');
});

@DriftDatabase(
  tables: [
    Categories,
    Habits,
    HabitCompletions,
    Tasks,
    Goals,
    GoalLinks,
    TimerSessions,
  ],
  daos: [
    HabitsDao,
    CategoriesDao,
    TasksDao,
    TimerSessionsDao,
  ],
)
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
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
      },
    );
  }

  Future<void> _seedDefaultCategories() async {
    final defaultCategories = [
      CategoriesCompanion.insert(
        name: 'Health & Fitness',
        icon: 'fitness_center',
        color: const Value(0xFF4CAF50),
        isDefault: const Value(true),
        sortOrder: const Value(0),
      ),
      CategoriesCompanion.insert(
        name: 'Learning & Growth',
        icon: 'school',
        color: const Value(0xFF2196F3),
        isDefault: const Value(true),
        sortOrder: const Value(1),
      ),
      CategoriesCompanion.insert(
        name: 'Work & Productivity',
        icon: 'work',
        color: const Value(0xFFFF9800),
        isDefault: const Value(true),
        sortOrder: const Value(2),
      ),
      CategoriesCompanion.insert(
        name: 'Mind & Wellness',
        icon: 'self_improvement',
        color: const Value(0xFF9C27B0),
        isDefault: const Value(true),
        sortOrder: const Value(3),
      ),
      CategoriesCompanion.insert(
        name: 'Home & Life',
        icon: 'home',
        color: const Value(0xFF795548),
        isDefault: const Value(true),
        sortOrder: const Value(4),
      ),
      CategoriesCompanion.insert(
        name: 'Finance',
        icon: 'account_balance_wallet',
        color: const Value(0xFF009688),
        isDefault: const Value(true),
        sortOrder: const Value(5),
      ),
      CategoriesCompanion.insert(
        name: 'Creativity',
        icon: 'palette',
        color: const Value(0xFFE91E63),
        isDefault: const Value(true),
        sortOrder: const Value(6),
      ),
      CategoriesCompanion.insert(
        name: 'Relationships',
        icon: 'favorite',
        color: const Value(0xFFF44336),
        isDefault: const Value(true),
        sortOrder: const Value(7),
      ),
    ];

    for (final category in defaultCategories) {
      await into(categories).insert(category);
    }
  }

  // Export all data as JSON
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

  // Clear all data
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
