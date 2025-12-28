import 'package:drift/drift.dart';
import 'package:habitly/data/database/database.dart';
import 'package:habitly/data/database/tables/tasks_table.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  // Get all incomplete tasks
  Stream<List<Task>> watchIncompleteTasks() {
    return (select(tasks)
          ..where((t) => t.completedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.priority),
            (t) => OrderingTerm.asc(t.dueDate),
          ]))
        .watch();
  }

  // Get tasks for a specific date
  Stream<List<Task>> watchTasksForDate(String date) {
    return (select(tasks)
          ..where((t) => t.dueDate.equals(date) | t.dueDate.isNull())
          ..where((t) => t.completedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.priority)]))
        .watch();
  }

  // Get completed tasks
  Stream<List<Task>> watchCompletedTasks() {
    return (select(tasks)
          ..where((t) => t.completedAt.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .watch();
  }

  // Get overdue tasks
  Stream<List<Task>> watchOverdueTasks(String todayDate) {
    return (select(tasks)
          ..where((t) =>
              t.completedAt.isNull() &
              t.dueDate.isNotNull() &
              t.dueDate.isSmallerThanValue(todayDate))
          ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]))
        .watch();
  }

  // Get a single task
  Future<Task?> getTask(int id) {
    return (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Insert a new task
  Future<int> insertTask(TasksCompanion task) {
    return into(tasks).insert(task);
  }

  // Update a task
  Future<bool> updateTask(Task task) {
    return update(tasks).replace(task);
  }

  // Complete a task
  Future<int> completeTask(int id) {
    return (update(tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(completedAt: Value(DateTime.now())),
    );
  }

  // Uncomplete a task
  Future<int> uncompleteTask(int id) {
    return (update(tasks)..where((t) => t.id.equals(id))).write(
      const TasksCompanion(completedAt: Value(null)),
    );
  }

  // Delete a task
  Future<int> deleteTask(int id) {
    return (delete(tasks)..where((t) => t.id.equals(id))).go();
  }
}
