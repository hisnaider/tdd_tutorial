import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.createdAt,
    required this.name,
    this.avatar,
  });
  final String id;
  final String createdAt;
  final String name;
  final String? avatar;

  const User.empty() : this(id: "0", createdAt: "_", name: "_");

  @override
  List<Object> get props => [id, name];
}
