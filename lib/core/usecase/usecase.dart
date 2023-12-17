import 'package:tdd_tutorial/core/utils/typedef.dart';

abstract class UsecaseWithParam<Type, Param> {
  const UsecaseWithParam();
  ResultFuture<Type> call(Param param);
}

abstract class UsecaseWithoutParam<Type> {
  const UsecaseWithoutParam();
  ResultFuture<Type> call();
}
