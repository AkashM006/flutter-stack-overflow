import 'package:drift/drift.dart';
import 'package:stack_overflow/src/db/database.dart';
import 'package:stack_overflow/src/db/schema/user_scheme.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  final AppDatabase db;

  UsersDao(this.db) : super(db);

  Stream<List<User>> watchTodos() {
    return select(users).watch();
  }
}
