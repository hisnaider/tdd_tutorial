import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/auth_remote_data_src.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/auth_repo_impl.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRepoImpl extends Mock implements AuthRemoteDataSrc {}

void main() {
  late AuthRemoteDataSrc remoteDataSource;
  late AuthRepoImpl repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRepoImpl();
    repoImpl = AuthRepoImpl(remoteDataSource);
  });

  const tException =
      ApiException(message: "Unknown error occours", statusCode: 500);

  group("create user", () {
    const createdAt = "createdAt";
    const name = "name";
    const avatar = "avatar";
    test(
        "should call the [RemoteDataSource.createUser] and complete successfully when the call to the remote source is successful",
        () async {
      when(
        () => remoteDataSource.createUser(
          createdAt: any(named: "createdAt"),
          name: any(named: "name"),
          avatar: any(named: "avatar"),
        ),
      ).thenAnswer((_) async => Future.value());

      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      expect(result, equals(const Right(null)));
      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        "should return a [ServerFailure] when call to the remote source is unsuccessful",
        () async {
      when(
        () => remoteDataSource.createUser(
            createdAt: any(named: "createdAt"),
            name: any(named: "name"),
            avatar: any(named: "avatar")),
      ).thenThrow(tException);

      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      expect(
          result,
          equals(Left(
            ApiFailure(
                message: tException.message, statusCode: tException.statusCode),
          )));
      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group("get users", () {
    test(
        "should call the [RemoteDataSource.getUsers] and complete successfully when the call to the remote source is successful",
        () async {
      when(
        () => remoteDataSource.getUsers(),
      ).thenAnswer((_) async => []);
      final result = await repoImpl.getUsers();
      expect(result, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        "should return a [ServerFailure] when call to the remote source is unsuccessful",
        () async {
      when(
        () => remoteDataSource.getUsers(),
      ).thenThrow(tException);

      final result = await repoImpl.getUsers();

      expect(
          result,
          equals(Left(
            ApiFailure(
                message: tException.message, statusCode: tException.statusCode),
          )));
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
