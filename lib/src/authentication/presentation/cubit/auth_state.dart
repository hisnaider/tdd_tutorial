part of 'auth_cubit.dart';


sealed class AuthState extends Equatable {

  const AuthState();


  @override

  List<Object> get props => [];

}


final class AuthInitialState extends AuthState {

  const AuthInitialState();

}


final class CreatingUserState extends AuthState {

  const CreatingUserState();

}


final class GettingUsersState extends AuthState {

  const GettingUsersState();

}


final class UserCreatedState extends AuthState {

  const UserCreatedState();

}


final class UsersLoadedState extends AuthState {

  const UsersLoadedState(this.users);


  final List<User> users;


  @override

  List<Object> get props => users.map((e) => e.id).toList();

}


final class AuthErrorState extends AuthState {

  const AuthErrorState(this.message);


  final String message;


  @override

  List<String> get props => [message];

}

