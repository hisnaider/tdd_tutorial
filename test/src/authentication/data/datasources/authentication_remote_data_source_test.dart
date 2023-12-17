import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constant.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/auth_remote_data_src.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';

class MockCliente extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthRemoteDataSrc remoteDataSource;
  setUp(() {
    client = MockCliente();
    remoteDataSource = AuthRemoteDataScrImpl(client);
    registerFallbackValue(Uri());
  });

  group("Create user", () {
    test("should complete successfully when the status code is 200 or 201",
        () async {
      when(() => client.post(any(),
          body: any(named: "body"),
          headers: {'Content-Type': 'application/json'})).thenAnswer(
        (_) async => http.Response("done", 201),
      );
      final methodCall = remoteDataSource.createUser;
      expect(
        methodCall(
          createdAt: "createdAt",
          name: "name",
        ),
        completes,
      );
      verify(
        () => client.post(Uri.https(kbaseUrl, kCreateUserEndpoint),
            body: jsonEncode({
              "createdAt": "createdAt",
              "name": "name",
            }),
            headers: {'Content-Type': 'application/json'}),
      ).called(1);
    });

    test("should failed when the status code is different than 200 or 201",
        () async {
      when(() => client.post(any(),
          body: any(named: "body"),
          headers: {'Content-Type': 'application/json'})).thenAnswer(
        (_) async => http.Response("Invalid email address", 400),
      );
      final methodCall = remoteDataSource.createUser;
      expect(
        () async => methodCall(
          createdAt: "createdAt",
          name: "name",
        ),
        throwsA(const ApiException(
            message: "Invalid email address", statusCode: 400)),
      );
      verify(
        () => client.post(Uri.https(kbaseUrl, kCreateUserEndpoint),
            body: jsonEncode({
              "createdAt": "createdAt",
              "name": "name",
            }),
            headers: {'Content-Type': 'application/json'}),
      ).called(1);
    });
  });

  group(
    "Get users",
    () {
      final tUsers = [const UserModel.empty()];
      test(
        "should return [List<User>] when the status code is 200 or 201",
        () async {
          when(() => client.get(any())).thenAnswer(
            (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
          );
          final result = await remoteDataSource.getUsers();
          expect(
            result,
            equals(tUsers),
          );
          verify(
            () => client.get(
              Uri.https(kbaseUrl, kGetUsersEndpoint),
            ),
          ).called(1);
          verifyNoMoreInteractions(client);
        },
      );

      test(
          "should throw [ApiException] when status code is different than 200 or 201",
          () async {
        when(() => client.get(any())).thenAnswer(
          (_) async => http.Response("Something goes wrong", 400),
        );
        final result = remoteDataSource.getUsers;
        expect(
          () => result(),
          throwsA(const ApiException(
              message: "Something goes wrong", statusCode: 400)),
        );
        verify(
          () => client.get(
            Uri.https(kbaseUrl, kGetUsersEndpoint),
          ),
        ).called(1);
      });
    },
  );
}
