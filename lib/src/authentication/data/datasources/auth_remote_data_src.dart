import 'dart:convert';

import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constant.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSrc {
  Future<void> createUser({
    required String createdAt,
    required String name,
    String? avatar,
  });

  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = "teste-api/users";
const kGetUsersEndpoint = "teste-api/users";

class AuthRemoteDataScrImpl implements AuthRemoteDataSrc {
  const AuthRemoteDataScrImpl(this._client);

  final http.Client _client;

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    String? avatar,
  }) async {
    try {
      final response = await _client.post(
        Uri.https(kbaseUrl, kCreateUserEndpoint),
        body: jsonEncode({"createdAt": createdAt, "name": name}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(
        Uri.https(kbaseUrl, kGetUsersEndpoint),
      );
      if (response.statusCode != 200) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
      return List<Map<String, dynamic>>.from(jsonDecode(response.body))
          .map((map) => UserModel.fromMap(map))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }
}
