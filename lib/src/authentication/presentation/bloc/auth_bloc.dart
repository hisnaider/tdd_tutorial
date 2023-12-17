import 'package:equatable/equatable.dart';


import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';


import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';


import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';


part 'auth_event.dart';


part 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc({

    required CreateUser createUser,

    required GetUsers getUsers,

  })  : _createUser = createUser,

        _getUsers = getUsers,

        super(const AuthInitialState()) {

    on<CreateUserEvent>(_createUserHandler);


    on<GetUsersEvent>(_getUsersHandler);

  }


  final CreateUser _createUser;


  final GetUsers _getUsers;


  Future<void> _createUserHandler(

    CreateUserEvent event,

    Emitter<AuthState> emit,

  ) async {

    emit(const CreatingUserState());


    final result = await _createUser(

      CreateUserParams(

        createdAt: event.createdAt,

        name: event.name,

        avatar: event.avatar,

      ),

    );


    result.fold(

      (failure) => emit(AuthErrorState(failure.errorMessage)),

      (_) => emit(const UserCreatedState()),

    );

  }


  Future<void> _getUsersHandler(

    GetUsersEvent event,

    Emitter<AuthState> emit,

  ) async {

    emit(const GettingUsersState());


    final result = await _getUsers();


    result.fold(

      (failure) => emit(AuthErrorState(failure.errorMessage)),

      (users) => emit(UsersLoaded(users)),

    );

  }

}

