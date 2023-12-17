import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

abstract class AuthRepo {
  AuthRepo();

  ResultVoid createUser({
    required String createdAt,
    required String name,
    String? avatar,
  });

  ResultFuture<List<User>> getUsers();
}
