import 'package:equatable/equatable.dart';
import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/auth_repo.dart';

class CreateUser extends UsecaseWithParam<void, CreateUserParams> {
  const CreateUser(this._repository);

  final AuthRepo _repository;

  @override
  ResultVoid call(CreateUserParams param) async => _repository.createUser(
        createdAt: param.createdAt,
        name: param.name,
        avatar: param.avatar,
      );
}

class CreateUserParams extends Equatable {
  const CreateUserParams(
      {required this.createdAt, required this.name, this.avatar});
  final String createdAt;
  final String name;
  final String? avatar;

  const CreateUserParams.empty() : this(createdAt: "_", name: "_");

  @override
  List<Object?> get props => [createdAt, name];
}
