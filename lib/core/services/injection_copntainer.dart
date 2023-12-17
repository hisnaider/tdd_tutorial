import 'package:get_it/get_it.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/auth_remote_data_src.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/auth_repo_impl.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/auth_cubit.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // App Logic
    ..registerFactory(() => AuthCubit(createUser: sl(), getUsers: sl()))

    // Use Cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    // Repositories
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))

    // Data Sources
    ..registerLazySingleton<AuthRemoteDataSrc>(
        () => AuthRemoteDataScrImpl(sl()))

    // External Dependencies
    ..registerLazySingleton(http.Client.new);
}
