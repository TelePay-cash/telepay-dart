import 'dart:convert';

import 'package:telepay/src/models/models.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  group('CreateWithdraw', () {
    final withdrawJson =
        jsonDecode(fixture('create_withdraw.json')) as Map<String, dynamic>;

    test('fromJson', () {
      expect(CreateWithdraw.fromJson(withdrawJson), isA<CreateWithdraw>());
    });

    test('toJson', () {
      expect(CreateWithdraw.fromJson(withdrawJson).toJson(), withdrawJson);
    });

    test('equeality', () {
      expect(
        CreateWithdraw.fromJson(withdrawJson),
        equals(CreateWithdraw.fromJson(withdrawJson)),
      );
    });
  });
}
