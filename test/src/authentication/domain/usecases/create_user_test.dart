import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late AuthRepo repo;
  late CreateUser usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = CreateUser(repo);
  });

  const params = CreateUserParams.empty();
  test("should call [AuthenticationRepository.createUser]", () async {
    // arrange
    when(
      () => repo.createUser(
        createdAt: any(named: "createdAt"),
        name: any(named: "name"),
        avatar: any(named: "avatar"),
      ),
    ).thenAnswer((_) async => const Right(null));
    // act
    final result = await usecase(params);
    // assert
    expect(result, equals(const Right<dynamic, void>(null)));

    verify(() => repo.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar)).called(1);

    verifyNoMoreInteractions(repo);
  });
}
