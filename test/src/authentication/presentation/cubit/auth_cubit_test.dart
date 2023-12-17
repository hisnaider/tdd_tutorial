import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/auth_cubit.dart';

class MockCreateUser extends Mock implements CreateUser {}

class MockGetUsers extends Mock implements GetUsers {}

void main() {
  late CreateUser createUser;
  late GetUsers getUsers;
  late AuthCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tApiFailure = ApiFailure(message: "message", statusCode: 400);

  setUp(() {
    createUser = MockCreateUser();
    getUsers = MockGetUsers();
    cubit = AuthCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() {
    cubit.close();
  });

  test("Initial state should be [AuthInitialState]", () async {
    expect(cubit.state, const AuthInitialState());
  });

  group("Create user", () {
    blocTest<AuthCubit, AuthState>(
      'should emit [CreatingUserState, UserCreatedState] when is successful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        avatar: tCreateUserParams.avatar,
        name: tCreateUserParams.name,
        createdAt: tCreateUserParams.createdAt,
      ),
      expect: () => const [
        CreatingUserState(),
        UserCreatedState(),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
    blocTest<AuthCubit, AuthState>(
      'should emit [CreatingUserState, AuthErrorState] when is unsuccessful',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Left(tApiFailure));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        avatar: tCreateUserParams.avatar,
        name: tCreateUserParams.name,
        createdAt: tCreateUserParams.createdAt,
      ),
      expect: () => [
        const CreatingUserState(),
        AuthErrorState(tApiFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group("Get users", () {
    blocTest<AuthCubit, AuthState>(
      'should emit [GettingUsersState, UsersLoaded] when is successful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => const [
        GettingUsersState(),
        UsersLoadedState([]),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
    blocTest<AuthCubit, AuthState>(
      'should emit [GettingUsersState, AuthErrorState] when is unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Left(tApiFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => [
        const GettingUsersState(),
        AuthErrorState(tApiFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
