import 'package:drift/drift.dart';
import 'package:stack_overflow/src/db/database.dart';

part 'todo_dao.g.dart';

@DriftAccessor(tables: [Todos])
class TodosDao extends DatabaseAccessor<AppDatabase> with _$TodosDaoMixin {
  final AppDatabase db;

  TodosDao(this.db) : super(db);

  Stream<List<Todo>> watchTodos() {
    return select(db.todos).watch();
  }
}
