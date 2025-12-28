import 'package:drift/drift.dart';
import 'package:habitly/data/database/tables/categories_table.dart';

enum TaskPriority { low, medium, high }

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 300)();
  TextColumn get description => text().nullable()();
  TextColumn get dueDate => text().nullable()(); // YYYY-MM-DD
  TextColumn get dueTime => text().nullable()(); // HH:mm
  TextColumn get priority => textEnum<TaskPriority>().withDefault(Constant(TaskPriority.low.name))();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurrenceRule => text().nullable()(); // RRULE format
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
}
