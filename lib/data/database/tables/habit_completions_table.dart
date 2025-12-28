import 'package:drift/drift.dart';
import 'package:habitly/data/database/tables/habits_table.dart';

class HabitCompletions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id, onDelete: KeyAction.cascade)();
  TextColumn get completedDate => text()(); // YYYY-MM-DD format
  IntColumn get completionCount => integer().withDefault(const Constant(1))();
  DateTimeColumn get completedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().nullable()();
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {habitId, completedDate},
      ];
}
