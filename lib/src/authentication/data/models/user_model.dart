import 'dart:convert';

import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    super.avatar,
    required super.createdAt,
  });

  const UserModel.empty() : super.empty();

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? createdAt,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        createdAt: createdAt ?? this.createdAt,
      );

  UserModel.fromMap(Map<String, dynamic> map)
      : this(
          id: map["id"],
          avatar: map["avatar"],
          createdAt: map["createdAt"],
          name: map["name"],
        );

  Map<String, dynamic> toMap() => {
        "id": id,
        "avatar": avatar,
        "createdAt": createdAt,
        "name": name,
      };

  String toJson() => jsonEncode(toMap());
}
