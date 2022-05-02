import 'dart:convert';

import 'package:telepay/src/models/models.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  group('CreateTransfer', () {
    final transferJson =
        jsonDecode(fixture('create_transfer.json')) as Map<String, dynamic>;

    test('fromJson', () {
      expect(CreateTransfer.fromJson(transferJson), isA<CreateTransfer>());
    });

    test('toJson', () {
      expect(CreateTransfer.fromJson(transferJson).toJson(), transferJson);
    });

    test('equeality', () {
      expect(
        CreateTransfer.fromJson(transferJson),
        equals(CreateTransfer.fromJson(transferJson)),
      );
    });
  });
}
