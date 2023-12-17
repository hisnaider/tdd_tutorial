import 'package:equatable/equatable.dart';


import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';


import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';


import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';


part 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {

  AuthCubit({

    required CreateUser createUser,

    required GetUsers getUsers,

  })  : _createUser = createUser,

        _getUsers = getUsers,

        super(const AuthInitialState());


  final CreateUser _createUser;


  final GetUsers _getUsers;


  Future<void> createUser({

    required String createdAt,

    required String name,

    String? avatar,

  }) async {

    emit(const CreatingUserState());


    final result = await _createUser(

      CreateUserParams(createdAt: createdAt, name: name, avatar: avatar),

    );


    result.fold(

      (failure) => emit(AuthErrorState(failure.errorMessage)),

      (_) => emit(const UserCreatedState()),

    );

  }


  Future<void> getUsers() async {

    emit(const GettingUsersState());


    final result = await _getUsers();


    result.fold(

      (failure) => emit(AuthErrorState(failure.errorMessage)),

      (users) => emit(UsersLoadedState(users)),

    );

  }

}

