import 'package:drift/drift.dart';
import 'package:habitly/data/database/tables/goals_table.dart';
import 'package:habitly/data/database/tables/habits_table.dart';
import 'package:habitly/data/database/tables/tasks_table.dart';

class GoalLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer().references(Goals, #id, onDelete: KeyAction.cascade)();
  IntColumn get habitId => integer().nullable().references(Habits, #id)();
  IntColumn get taskId => integer().nullable().references(Tasks, #id)();
}
