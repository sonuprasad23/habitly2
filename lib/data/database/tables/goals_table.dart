import 'package:drift/drift.dart';

enum GoalType { shortTerm, longTerm }

class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get goalType => textEnum<GoalType>().withDefault(Constant(GoalType.shortTerm.name))();
  TextColumn get targetDate => text().nullable()(); // YYYY-MM-DD
  RealColumn get progressPercentage => real().withDefault(const Constant(0.0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();
}
