import 'package:drift/drift.dart';
import 'package:habitly/data/database/tables/categories_table.dart';

enum FrequencyType { daily, weekly, specificDays }

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().withDefault(const Constant('check_circle'))();
  IntColumn get color => integer().withDefault(const Constant(0xFF6750A4))();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  TextColumn get frequencyType => textEnum<FrequencyType>().withDefault(Constant(FrequencyType.daily.name))();
  TextColumn get frequencyDays => text().nullable()(); // JSON array: [1,3,5] for Mon,Wed,Fri
  IntColumn get targetCount => integer().withDefault(const Constant(1))();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get reminderTime => text().nullable()(); // HH:mm format
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
