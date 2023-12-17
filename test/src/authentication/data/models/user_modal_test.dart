import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  const tModel = UserModel.empty();
  test(
    "Should be a subclass of [User] entity",
    () {
      expect(tModel, isA<User>());
    },
  );

  final tJson = fixture("user.json");
  final tMap = jsonDecode(tJson) as Map<String, dynamic>;

  group("From map", () {
    test("Should return [UserModal] with the right data", () {
      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
    });
  });

  group("From json", () {
    test("Should return [UserModel] with the right data", () {
      final result = UserModel.fromJson(tJson);
      expect(result, equals(tModel));
    });
  });

  group("To map", () {
    test("Should return [map] with the right data", () {
      final result = tModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group("To json", () {
    test("Should return [json] with the right data", () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });
  });

  group("Copy with", () {
    test("Should return [UserModel] with different data", () {
      final result = tModel.copyWith(name: "teste");
      expect(result.name, equals("teste"));
      expect(result, isNot(equals(tModel)));
    });
  });
}
