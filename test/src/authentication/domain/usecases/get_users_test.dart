import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late AuthRepo repo;
  late GetUsers usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = GetUsers(repo);
  });

  const tResponse = [User.empty()];

  test(
    "should call [AuthenticationRepository.getUsers]",
    () async {
      when(() => repo.getUsers()).thenAnswer(
        (_) async => const Right(tResponse),
      );
      final result = await usecase();
      expect(result, equals(const Right<dynamic, List<User>>(tResponse)));

      verify(() => repo.getUsers()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
